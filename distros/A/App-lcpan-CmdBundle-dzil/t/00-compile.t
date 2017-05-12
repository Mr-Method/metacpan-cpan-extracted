use 5.006;
use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.054

use Test::More;

plan tests => 10 + ($ENV{AUTHOR_TESTING} ? 1 : 0);

my @module_files = (
    'App/lcpan/Cmd/dzil_authors_by_bundle_count.pm',
    'App/lcpan/Cmd/dzil_authors_by_plugin_count.pm',
    'App/lcpan/Cmd/dzil_authors_by_role_count.pm',
    'App/lcpan/Cmd/dzil_bundles.pm',
    'App/lcpan/Cmd/dzil_bundles_by_rdep_count.pm',
    'App/lcpan/Cmd/dzil_plugins.pm',
    'App/lcpan/Cmd/dzil_plugins_by_rdep_count.pm',
    'App/lcpan/Cmd/dzil_roles.pm',
    'App/lcpan/Cmd/dzil_roles_by_rdep_count.pm',
    'App/lcpan/CmdBundle/dzil.pm'
);



# no fake home requested

my $inc_switch = -d 'blib' ? '-Mblib' : '-Ilib';

use File::Spec;
use IPC::Open3;
use IO::Handle;

open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, $inc_switch, '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$lib loaded ok");

    shift @_warnings if @_warnings and $_warnings[0] =~ /^Using .*\bblib/
        and not eval { require blib; blib->VERSION('1.01') };

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found')
    or diag 'got warnings: ', ( Test::More->can('explain') ? Test::More::explain(\@warnings) : join("\n", '', @warnings) ) if $ENV{AUTHOR_TESTING};


