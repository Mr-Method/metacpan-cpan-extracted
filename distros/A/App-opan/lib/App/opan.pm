#!perl

package App::opan;

use strictures 2;

our $VERSION = '0.002001';

use Dist::Metadata;
use File::Open qw(fopen);
use List::UtilsBy qw(sort_by);
use File::Path qw(mkpath);
use IPC::System::Simple qw(capture);
use Mojo::Util qw(monkey_patch);
use Mojo::File qw(path);
use File::Spec;
use File::Copy qw(copy);
use Import::Into;

sub packages_header {
  my ($count) = @_;
  (my $str = <<"  HEADER") =~ s/^    //mg;
    File:         02packages.details.txt
    Description:  Package names found in directory \$CPAN/authors/id/
    Columns:      package name, version, path
    Intended-For: Automated fetch routines, namespace documentation.
    Written-By:   App::opan
    Line-Count:   ${count}
    Last-Updated: ${\scalar gmtime} GMT

  HEADER
  return $str;
}

sub extract_provides_from_tarball {
  my ($tarball) = @_;
  Dist::Metadata->new(file => $tarball)->package_versions;
}

sub provides_to_packages_entries {
  my ($path, $provides) = @_;
  # <@mst> ok, I officially have no idea what order 02packages is actually in
  # <@rjbs>     $list .= join "", sort {lc $a cmp lc $b} @listing02;
  [
    map +[
      $_, defined($provides->{$_}) ? $provides->{$_} : 'undef', $path
    ], sort_by { lc } keys %$provides
  ]
}

sub entries_from_packages_file {
  my ($file) = @_;
  my $fh = fopen $file;
  while (my $header = <$fh>) {
    last if $header =~ /^$/;
  }
  my @entries;
  while (my $line = <$fh>) {
    chomp($line);
    push @entries, [ split /\s+/, $line ];
  }
  return \@entries;
}

sub merge_packages_entries {
  my ($base, $merge_these) = @_;
  return $base unless $merge_these;
  my @merged;
  my @to_merge = @$merge_these;
  foreach my $idx (0..$#$base) {
    while (@to_merge and lc($to_merge[0][0]) lt lc($base->[$idx][0])) {
      push @merged, shift @to_merge;
    }
    push @merged, (
      (@to_merge and $to_merge[0][0] eq $base->[$idx][0])
        ? shift @to_merge
        : $base->[$idx]
    );
  }
  push @merged, @to_merge;
  return \@merged;
}

sub write_packages_file {
  my ($file, $entries) = @_;
  my $fh = fopen $file, 'w';
  print $fh packages_header(scalar @$entries);
  local *_ = sub {
    # mirroring 'sub rewrite02 {' in lib/PAUSE/mldistwatch.pm
    # see http://github.com/andk/pause for the whole thing
    my ($one, $two) = (30, 8);
    if (length($_[0]) > $one) {
      $one += 8 - length($_[1]);
      $two = length($_[1]);
    }
    sprintf "%-${one}s %${two}s  %s\n", @_;
  };
  print $fh _(@$_) for @$entries;
  close $fh;
  path("${file}.gz")->spurt(scalar capture(gzip => -c => $file));
}

sub add_dist_to_index {
  my ($index, $dist) = @_;
  my $existing = entries_from_packages_file($index);
  my ($path) = $dist =~ m{pans/[a-z]+/dists/(.*)};
  write_packages_file(
    $index,
    merge_packages_entries(
      $existing,
      provides_to_packages_entries(
        $path,
        extract_provides_from_tarball($dist)
      ),
    )
  );
}

sub remove_dist_from_index {
  my ($index, $dist) = @_;
  my $existing = entries_from_packages_file($index);
  my $exclude = qr/\Q${dist}\E$/;
  write_packages_file(
    $index,
    [ grep $_->[2] !~ $exclude, @$existing ],
  );
}

my @pan_names = qw(upstream custom pinset combined nopin);

sub do_init {
  my ($app) = @_;
  mkpath('pans');
  mkpath("pans/$_/dists") for @pan_names;
  write_packages_file("pans/$_/index", []) for qw(custom pinset);
  do_pull($app);
}

sub do_fetch {
  my ($app) = @_;
  path('pans/upstream/index.gz')->spurt(
    $app->ua->get($app->cpan_url.'modules/02packages.details.txt.gz')
        ->res->body
  );
  path('pans/upstream/index')->spurt(
    scalar capture zcat => 'pans/upstream/index.gz'
  );
}

sub do_merge {
  my ($app) = @_;
  my $upstream = entries_from_packages_file('pans/upstream/index');
  my $pinset = entries_from_packages_file('pans/pinset/index');
  my $custom = entries_from_packages_file('pans/custom/index');

  my $nopin = merge_packages_entries($upstream, $custom);
  write_packages_file('pans/nopin/index', $nopin);

  my $combined = merge_packages_entries(
                   $upstream, merge_packages_entries($pinset, $custom)
                 );
  write_packages_file('pans/combined/index', $combined);
}

sub do_pull {
  my ($app) = @_;
  do_fetch($app);
  do_merge($app);
}

sub do_add {
  my ($app, $path) = @_;
  my (undef, $dir, $file) = File::Spec->splitpath($path);
  mkpath(my $pan_dir = 'pans/custom/dists/M/MY/MY');
  copy($path, my $pan_path = File::Spec->catdir($pan_dir, $file))
    or die "Failed to copy ${path} into custom pan: $!";
  add_dist_to_index('pans/custom/index', $pan_path);
}

sub do_unadd {
  my ($app, $dist) = @_;
  remove_dist_from_index('pans/custom/index', $dist);
}

sub do_pin {
  my ($app, $path) = @_;
  $path =~ /^(([A-Z])[A-Z])[A-Z]/ and $path = join('/', $2, $1, $path);
  my (undef, $dir, $file) = File::Spec->splitpath($path);
  mkpath("pans/pinset/dists/${dir}");
  path(my $pan_path = "pans/pinset/dists/${path}")->spurt(
    $app->ua->get($app->cpan_url.'authors/id/'.$path)->res->body
  );
  add_dist_to_index('pans/pinset/index', $pan_path);
}

sub do_unpin {
  my ($app, $dist) = @_;
  remove_dist_from_index('pans/pinset/index', $dist);
}

sub generate_purgelist {
  my @list;
  foreach my $pan (qw(pinset custom)) {
    my %indexed = map +("pans/${pan}/dists/".$_->[2] => 1),
                    @{entries_from_packages_file("pans/${pan}/index")};
    foreach my $file (sort glob "pans/${pan}/dists/*/*/*/*") {
      push @list, $file unless $indexed{$file};
    }
  }
  return @list;
}

sub do_purgelist {
  print "$_\n" for &generate_purgelist;
}

sub do_purge {
  unlink($_) for &generate_purgelist;
}

sub run_with_server {
  my ($app, $run, $pan, @args) = @_;
  unless (
    defined($pan) and $pan =~ /^--(combined|nopin|autopin)$/
  ) {
    unshift @args, grep defined, $pan;
    $pan = '--combined';
  }
  $pan =~ s/^--//;
  require Mojo::IOLoop::Server;
  my $port = Mojo::IOLoop::Server->generate_port;
  my $url = "http://localhost:${port}/";
  my $pid = fork();
  die "fork() fork()ed up: $!" unless defined $pid;
  unless ($pid) {
    $ENV{OPAN_AUTOPIN} = 1 if $pan eq 'autopin';
    $app->start(daemon => -l => $url);
    exit(0);
  }
  eval { $run->("${url}${pan}", @args) };
  my $err = $@;
  kill TERM => $pid;
  warn "Run block failed: $err" if $err;
}

sub do_cpanm {
  my ($app, @args) = @_;
  run_with_server($app, sub {
    my ($mirror, @args) = @_;
    system(cpanm => '--mirror', $mirror, '--mirror-only', @args);
  }, @args);
}

sub do_carton {
  my ($app, @args) = @_;
  run_with_server($app, sub {
    my ($mirror, @args) = @_;
    local $ENV{PERL_CARTON_MIRROR} = $mirror;
    system(carton => @args);
  }, @args);
}

foreach my $cmd (
  qw(init fetch add unadd pin unpin merge pull purgelist purge cpanm carton)
) {
  my $pkg = "App::opan::Command::${cmd}";
  my $code = __PACKAGE__->can("do_${cmd}");
  Mojo::Base->import::into($pkg, 'Mojolicious::Command');
  monkey_patch $pkg,
    run => sub { my $self = shift; $code->($self->app, @_) };
}

use Mojolicious::Lite;

push(@{app->commands->namespaces}, 'App::opan::Command');

helper cpan_url => sub { $ENV{OPAN_MIRROR} || 'http://www.cpan.org/' };

my $nopin_static = Mojolicious::Static->new(
  paths => [ 'pans/custom/dists' ]
);

my $pinset_static = Mojolicious::Static->new(
  paths => [ 'pans/pinset/dists' ]
);

my $combined_static = Mojolicious::Static->new(
  paths => [ 'pans/custom/dists', 'pans/pinset/dists' ]
);

my $base_static = Mojolicious::Static->new(
  paths => [ 'pans' ]
);

foreach my $pan (qw(upstream nopin combined)) {
  get "/${pan}/modules/02packages.details.txt" => sub {
    $base_static->dispatch($_[0]->stash(path => "${pan}/index"));
  };
  get "/${pan}/modules/02packages.details.txt.gz" => sub {
    $base_static->dispatch($_[0]->stash(path => "${pan}/index.gz"));
  };
}

my $serve_upstream = sub {
  my ($c) = @_;
  $c->render_later;
  $c->ua->get(
    $c->cpan_url.'authors/id/'.$c->stash->{path},
      sub {
      my (undef, $tx) = @_;
        $c->tx->res($tx->res);
      $c->rendered;
    }
  );
  return;
};

get '/upstream/authors/id/*path' => $serve_upstream;

get '/combined/authors/id/*path' => sub {
  $combined_static->dispatch($_[0]) or $serve_upstream->($_[0]);
};

get '/nopin/authors/id/*path' => sub {
  $nopin_static->dispatch($_[0]) or $serve_upstream->($_[0]);
};

get "/autopin/modules/02packages.details.txt" => sub {
  return $_[0]->render(text => 'Autopin off', status => 404)
    unless $ENV{OPAN_AUTOPIN};
  $base_static->dispatch($_[0]->stash(path => "nopin/index"));
};

get "/autopin/modules/02packages.details.txt.gz" => sub {
  return $_[0]->render(text => 'Autopin off', status => 404)
    unless $ENV{OPAN_AUTOPIN};
  $base_static->dispatch($_[0]->stash(path => "nopin/index.gz"));
};

get '/autopin/authors/id/*path' => sub {
  return $_[0]->render(text => 'Autopin off', status => 404)
    unless $ENV{OPAN_AUTOPIN};
  return if $nopin_static->dispatch($_[0]);
  return if eval {
    do_pin(app, $_[0]->stash->{path});
    $pinset_static->dispatch($_[0]);
  };
  return $_[0]->render(text => 'Not found', status => 404);
};

caller() ? app : app->tap(sub { shift->log->level('fatal') })->start;

=head1 NAME

App::opan - A CPAN overlay for darkpan and pinning purposes

=head1 SYNOPSIS

Set up an opan (creates a directory tree in C<pans/>):

  $ opan init
  $ opan pin MSTROUT/M-1.tar.gz
  $ opan add ./My-Dist-1.23.tar.gz

Now, you can start the server:

  $ opan daemon -l http://localhost:8030/
  Server available at http://localhost:8030/

Then in another terminal, run one of:

  $ cpanm --mirror http://localhost:8030/combined/ --mirror-only --installdeps .
  $ PERL_CARTON_MIRROR=http://localhost:8030/combined/ carton install

Or, to let opan do that part for you, skip starting the server and run one of:

  $ opan cpanm --installdeps .
  $ opan carton install

=head1 NOTA BENE

This is systems software, in its relatively early days. It may contain
horrible bugs. It may turn out to need redesigning in not entirely compatible
ways. I hope neither, but I can't guarantee that yet.

=head1 DESCRIPTION

Two basic approaches to using this thing. First, if you're using carton, you
can probably completely ignore the pinning system, so just do:

  $ opan init
  $ opan add ./My-DarkPan-Dist-1.23.tar.gz
  $ git add pans/; git commit -m 'fresh opan'
  $ opan carton install

You can reproduce this install with simply:

  $ opan carton install --deployment

When you want to update to a new version of the cpan index (assuming you
already have an additional requirement that's too old in your current
snapshot):

  $ opan pull
  $ git add pans/; git commit -m 'update pans'
  $ opan carton install

Second, if you're not using carton, but you want reproducible installs, you
can still mostly ignore the pinning system by doing:

  $ opan init
  $ opan add ./My-DarkPan-Dist-1.23.tar.gz
  $ opan cpanm --autopin --installdeps .
  $ git add pans/; git commit -m 'opan with current version pinning'

Your reproducible install is now:

  $ opan cpanm --installdeps .

When you want to update to a new version of the cpan index (assuming you
already have an additional requirement that's too old in your current
snapshot):

  $ opan pull
  $ opan cpanm --autopin --installdeps .
  $ git add pans/; git commit -m 'update pans'

To update a single dist in this system, the easy route is:

  $ opan unpin Thingy-1.23.tar.gz
  $ opan cpanm Thingy
  Fetching http://www.cpan.org/authors/id/S/SO/SOMEONE/Thingy-1.25.tar.gz
  ...
  $ opan pin SOMEONE/Thing-1.25.tar.gz

This will probably make more sense if you read the L</Commands> and L</PANs>
documentation following before trying to set things up.

=head2 Commands

=head3 init

  opan init

Creates a C<pans/> directory with empty indexes for L</custom> and L</pinset>
and a fresh index for L</upstream> (i.e. runs L</fetch> for you at the end
of initialisation).

=head3 fetch

  opan fetch

Fetches 02packages from www.cpan.org into the L</upstream> PAN.

=head3 add

  opan add Dist-Name-1.23.tar.gz

Imports a distribution file into the L</custom> PAN under author C<MY>. Any
path parts provided before the filename will be stripped.

Support for other authors is pending somebody explaining why that would have
a point. See L</pin> for the command you probably wanted instead.

=head3 unadd

  opan unadd Dist-Name-1.23.tar.gz

Looks for a C<Dist-Name-1.23.tar.gz> path in the L</custom> PAN index
and removes the entries.

Does not remove the dist file, see L</purge>.

=head3 pin

  opan pin AUTHOR/Dist-Name-1.23.tar.gz

Fetches the file from the L</upstream> PAN and adds it to L</pinset>.

=head3 unpin

  opan unpin Dist-Name-1.23.tar.gz

Looks for a C<Dist-Name-1.23.tar.gz> path in the L</pinset> PAN index
and removes the entries.

Does not remove the dist file, see L</purge>.

=head3 merge

  opan merge

Rebuilds the L</combined> and L</nopin> PANs' index files.

=head3 pull

  opan pull

Does an L</fetch> then an L</merge>. There's no equivalent for others,
on the assumption what you'll do is roughly L</pin>, L</add>, L</unpin>,
L</unadd>, ... repeat ..., L</pull>.

=head3 purgelist

  opan purgelist

Outputs a list of all non-indexed dists in L</pinset> and L</custom>.

=head3 purge

  opan purge

Deletes all files that would have been listed by L</purgelist>.

=head3 daemon

  opan daemon

Starts a single process server using L<Mojolicious::Command::daemon>.

=head3 prefork

  opan prefork

Starts a multi-process preforking server using
L<Mojolicious::Command::prefork>.

=head3 get

  opan get /upstream/modules/02packages.details.txt.gz

Runs a request against the opan URL space using L<Mojolicious::Command::get>.

=head3 cpanm

  opan cpanm --installdeps .

Starts a temporary server process and runs

  cpanm --mirror http://localhost:<port>/combined/ --mirror-only <your args here>

Can also be run with one of:

  opan cpanm --nopin <your args here>
  opan cpanm --autopin <your args here>
  opan cpanm --combined <your args here>

to request a specific PAN.

=head3 carton

  opan carton install

Starts a temporary server process and runs

  PERL_CARTON_MIRROR=http://localhost:<port>/combined/ carton <your args here>

Can also be run with one of:

  opan carton --nopin <your args here>
  opan carton --autopin <your args here>
  opan carton --combined <your args here>

to request a specific PAN.

=head2 PANs

=head3 upstream

02packages: Fetched from www.cpan.org by the L</fetch> command.

Dist files: Fetched from www.cpan.org on-demand.

=head3 pinset

02packages: Managed by L</pin> and L</unpin> commands.

Dist files: Fetched from www.cpan.org by L</pin> command.

=head3 custom

02packages: Managed by L</add> and L</unadd> commands.

Dist files: Imported from local disk by L</add> command.

=head3 combined

02packages: Merged from upstream, pinset and custom PANs by L</merge> command.

Dist files: Fetched from custom, pinset and upstream in that order.

=head3 nopin

02packages: Merged from upstream and custom PANs by L</merge> command.

Dist files: Fetched from custom, pinset and upstream in that order.

=head3 autopin

Virtual PAN with no presence on disk.

Identical to nopin, but fetching a dist from upstream does an implict L</pin>.

Since this can modify your opan config, it's only enabled if the environment
variable C<OPAN_AUTOPIN> is set to a true value (calling the L</cpanm> or
L</carton> commands with C<--autopin> sets this for you, because you already
specified you wanted that).

=head1 AUTHOR

Matt S. Trout (mst) <mst@shadowcat.co.uk>

=head1 CONTRIBUTORS

None yet, but I'm sure there'll be enough bugs for that to change shortly.

=head1 COPYRIGHT

Copyright (c) 2016 the L<App::opan> L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
