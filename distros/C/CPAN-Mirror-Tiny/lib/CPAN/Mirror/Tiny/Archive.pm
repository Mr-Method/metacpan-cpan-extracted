package CPAN::Mirror::Tiny::Archive;
use strict;
use warnings;

use CPAN::Mirror::Tiny::Util qw(WIN32 safe_system);

use File::Which 'which';
use constant BAD_TAR => ($^O eq 'solaris' || $^O eq 'hpux');

use File::pushd ();
use File::Basename ();

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->_init;
    $self;
}

sub untar { shift->{_backends}{untar}->(@_) }
sub unzip { shift->{_backends}{unzip}->(@_) }

sub _init {
    my $self = shift;
    my $tar = which('tar');
    my $tar_ver;
    my $maybe_bad_tar = sub {
        return 1 if WIN32 || BAD_TAR;
        ($tar_ver) = safe_system([$tar, "--version"]);
        $tar_ver =~ /GNU.*1\.13/i;
    };

    if ($tar && !$maybe_bad_tar->()) {
        chomp $tar_ver;
        $self->{_backends}{untar} = sub {
            my($self, $tarfile) = @_;

            my $xf = ($self->{verbose} ? 'v' : '')."xf";
            my $ar = $tarfile =~ /bz2$/ ? 'j' : 'z';

            my ($out) = safe_system([$tar, "${ar}tf", $tarfile]);
            my($root, @others) = split /\n/, $out
                or return undef;

            FILE: {
                $root =~ s!^\./!!;
                $root =~ s{^(.+?)/.*$}{$1};

                if (!length($root)) {
                    # archive had ./ as the first entry, so try again
                    $root = shift(@others);
                    redo FILE if $root;
                }
            }

            safe_system([$tar, "$ar$xf", $tarfile]);
            return $root if -d $root;
            return undef;
        };
    } elsif (    $tar
             and my $gzip = which('gzip')
             and my $bzip2 = which('bzip2')) {
        $self->{_backends}{untar} = sub {
            my($self, $tarfile) = @_;

            my $x  = "x" . ($self->{verbose} ? 'v' : '') . "f";
            my $ar = $tarfile =~ /bz2$/ ? $bzip2 : $gzip;

            my ($out) = safe_system([$ar, "-dc", $tarfile], "|", [$tar, "tf", "-"]);
            my($root, @others) = split /\n/, $out
                or return undef;

            FILE: {
                $root =~ s!^\./!!;
                $root =~ s{^(.+?)/.*$}{$1};

                if (!length($root)) {
                    # archive had ./ as the first entry, so try again
                    $root = shift(@others);
                    redo FILE if $root;
                }
            }

            safe_system([$ar, "-dc", $tarfile], "|", [$tar, $x, "-"]);
            return $root if -d $root;
            return undef;
        };
    } elsif (eval { require Archive::Tar }) { # uses too much memory!
        $self->{_backends}{untar} = sub {
            my $self = shift;
            my $t = Archive::Tar->new($_[0]);
            my($root, @others) = $t->list_files;
            FILE: {
                $root =~ s!^\./!!;
                $root =~ s{^(.+?)/.*$}{$1};

                if (!length($root)) {
                    # archive had ./ as the first entry, so try again
                    $root = shift(@others);
                    redo FILE if $root;
                }
            }
            $t->extract;
            return -d $root ? $root : undef;
        };
    } else {
        $self->{_backends}{untar} = sub {
            die "Failed to extract $_[1] - You need to have tar or Archive::Tar installed.\n";
        };
    }

    if (my $unzip = which('unzip')) {
        $self->{_backends}{unzip} = sub {
            my($self, $zipfile) = @_;

            my @opt = $self->{verbose} ? () : qw(-q);
            my $out = safe_system([$unzip, "-t", $zipfile]);
            my(undef, $root, @others) = split /\n/, $out
                or return undef;

            chomp $root;
            $root =~ s{^\s+testing:\s+([^/]+)/.*?\s+OK$}{$1};

            safe_system([$unzip, @opt, $zipfile]);
            return $root if -d $root;

            return undef;
        }
    } else {
        $self->{_backends}{unzip} = sub {
            eval { require Archive::Zip }
                or  die "Failed to extract $_[1] - You need to have unzip or Archive::Zip installed.\n";
            my($self, $file) = @_;
            my $zip = Archive::Zip->new();
            my $status;
            $status = $zip->read($file);
            return if $status != Archive::Zip::AZ_OK();
            my @members = $zip->members();
            for my $member ( @members ) {
                my $af = $member->fileName();
                next if ($af =~ m!^(/|\.\./)!);
                $status = $member->extractToFileNamed( $af );
                return if $status != Archive::Zip::AZ_OK();
            }

            my ($root) = $zip->membersMatching( qr<^[^/]+/$> );
            $root &&= $root->fileName;
            return -d $root ? $root : undef;
        };
    }
}

1;

__END__

=head1 NAME

CPAN::Mirror::Tiny::Archive - untar/unzip archives

=head1 LICENSE

Most of code is copied from L<App::cpanminus>. Its license is:

  Copyright 2010- Tatsuhiko Miyagawa

  This software is licensed under the same terms as Perl.

=cut
