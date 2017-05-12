package App::DumpFirefoxHistory;

our $DATE = '2017-03-20'; # DATE
our $VERSION = '0.001'; # VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{dump_firefox_history} = {
    v => 1.1,
    summary => 'Dump Firefox history',
    args => {
        detail => {
            schema => 'bool*',
            cmdline_aliases => {l=>{}},
        },
        profile => {
            summary => 'Select profile to use',
            schema => 'str*',
            default => 'default',
            description => <<'_',

You can either provide a name, e.g. `default`, the profile directory of which
will be then be searched in `~/.mozilla/firefox/*.<name>`. Or you can also
provide a directory name.

_
        },
    },
};
sub dump_firefox_history {
    require DBI;

    my %args = @_;

    my ($profile, $profile_dir);
    $profile = $args{profile} // 'default';

    # XXX read list of profiles from ~/.mozilla/firefox/profiles.ini
  GET_PROFILE_DIR:
    {
        if ($profile =~ /\A\w+\z/) {
            # search profile name in profiles directory
            my @dirs = glob "$ENV{HOME}/.mozilla/firefox/*.*";
            return [412, "Can't find any profile directory under ~/.mozilla/firefox"]
                unless @dirs;
            for my $dir (@dirs) {
                if ($dir =~ /\.\Q$profile\E\z/) {
                    $profile_dir = $dir;
                    last GET_PROFILE_DIR;
                }
            }
        }
        if (-d $profile) {
            $profile_dir = $profile;
        } else {
            return [412, "No such profile/profile directory '$profile'"];
        }
    }

    my $path = "$profile_dir/places.sqlite";
    return [412, "Can't find $path"] unless -f $path;

    my $dbh = DBI->connect("dbi:SQLite:dbname=$path", "", "", {RaiseError=>1});
    my $sth = $dbh->prepare("SELECT url,title,last_visit_date,visit_count,frecency FROM moz_places ORDER BY last_visit_date");
    $sth->execute;
    my @rows;
    my $resmeta = {};
    while (my $row = $sth->fetchrow_hashref) {
        if ($args{detail}) {
            push @rows, $row;
        } else {
            push @rows, $row->{url};
        }
    }

    $resmeta->{'table.fields'} = [qw/url title last_visit_date visit_count frecency/]
        if $args{detail};
    [200, "OK", \@rows, $resmeta];
}

1;
# ABSTRACT: Dump Firefox history

__END__

=pod

=encoding UTF-8

=head1 NAME

App::DumpFirefoxHistory - Dump Firefox history

=head1 VERSION

This document describes version 0.001 of App::DumpFirefoxHistory (from Perl distribution App-DumpFirefoxHistory), released on 2017-03-20.

=head1 SYNOPSIS

See the included script L<dump-firefox-history>.

=head1 FUNCTIONS


=head2 dump_firefox_history

Usage:

 dump_firefox_history(%args) -> [status, msg, result, meta]

Dump Firefox history.

This function is not exported.

Arguments ('*' denotes required arguments):

=over 4

=item * B<detail> => I<bool>

=item * B<profile> => I<str> (default: "default")

Select profile to use.

You can either provide a name, e.g. C<default>, the profile directory of which
will be then be searched in C<< ~/.mozilla/firefox/*.E<lt>nameE<gt> >>. Or you can also
provide a directory name.

=back

Returns an enveloped result (an array).

First element (status) is an integer containing HTTP status code
(200 means OK, 4xx caller error, 5xx function error). Second element
(msg) is a string containing error message, or 'OK' if status is
200. Third element (result) is optional, the actual result. Fourth
element (meta) is called result metadata and is optional, a hash
that contains extra information.

Return value:  (any)

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/App-DumpFirefoxHistory>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-App-DumpFirefoxHistory>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-DumpFirefoxHistory>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 SEE ALSO

L<App::DumpChromeHistory>

L<App::DumpOperaHistory>

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
