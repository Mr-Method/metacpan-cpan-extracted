package App::lcpan::Cmd::metacpan_author;

our $DATE = '2017-01-20'; # DATE
our $VERSION = '0.002'; # VERSION

use 5.010001;
use strict;
use warnings;
use Log::Any::IfLOG '$log';

require App::lcpan;

our %SPEC;

$SPEC{handle_cmd} = {
    v => 1.1,
    summary => 'Open author page on MetaCPAN',
    description => <<'_',

Given author with CPAN ID `CPANID`, this will open
`https://metacpan.org/author/CPANID`. `CPANID` will first be checked for
existence in local index database.

_
    args => {
        %App::lcpan::common_args,
        %App::lcpan::author_args,
    },
};
sub handle_cmd {
    my %args = @_;
    my $author = $args{author};

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my ($cpanid) = $dbh->selectrow_array(
        "SELECT cpanid FROM author WHERE cpanid=?", {}, uc $author);
    defined $cpanid or return [404, "No such author '$author'"];

    require Browser::Open;
    my $err = Browser::Open::open_browser("https://metacpan.org/author/$cpanid");
    return [500, "Can't open browser"] if $err;
    [200];
}

1;
# ABSTRACT: Open author page on MetaCPAN

__END__

=pod

=encoding UTF-8

=head1 NAME

App::lcpan::Cmd::metacpan_author - Open author page on MetaCPAN

=head1 VERSION

This document describes version 0.002 of App::lcpan::Cmd::metacpan_author (from Perl distribution App-lcpan-CmdBundle-metacpan), released on 2017-01-20.

=head1 DESCRIPTION

This module handles the L<lcpan> subcommand C<metacpan-author>.

=head1 FUNCTIONS


=head2 handle_cmd(%args) -> [status, msg, result, meta]

Open author page on MetaCPAN.

Given author with CPAN ID C<CPANID>, this will open
CL<https://metacpan.org/author/CPANID>. C<CPANID> will first be checked for
existence in local index database.

This function is not exported.

Arguments ('*' denotes required arguments):

=over 4

=item * B<author>* => I<str>

=item * B<cpan> => I<dirname>

Location of your local CPAN mirror, e.g. /path/to/cpan.

Defaults to C<~/cpan>.

=item * B<index_name> => I<filename> (default: "index.db")

Filename of index.

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

Please visit the project's homepage at L<https://metacpan.org/release/App-lcpan-CmdBundle-metacpan>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-App-lcpan-CmdBundle-metacpan>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-lcpan-CmdBundle-metacpan>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
