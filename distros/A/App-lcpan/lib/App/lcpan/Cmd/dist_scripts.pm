package App::lcpan::Cmd::dist_scripts;

our $DATE = '2017-02-03'; # DATE
our $VERSION = '1.017'; # VERSION

use 5.010;
use strict;
use warnings;

require App::lcpan;

our %SPEC;

$SPEC{'handle_cmd'} = {
    v => 1.1,
    summary => 'List scripts in a distribution',
    args => {
        %App::lcpan::common_args,
        %App::lcpan::dist_args,
        %App::lcpan::detail_args,
    },
};
sub handle_cmd {
    my %args = @_;

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my $dist = $args{dist};
    my $detail = $args{detail};

    my $sth = $dbh->prepare("SELECT
  script.name name,
  script.abstract abstract
FROM script
LEFT JOIN file ON script.file_id=file.id
LEFT JOIN dist ON file.id=dist.file_id
WHERE dist.name=?
ORDER BY name DESC");
    $sth->execute($dist);
    my @res;
    while (my $row = $sth->fetchrow_hashref) {
        push @res, $detail ? $row : $row->{name};
    }
    my $resmeta = {};
    $resmeta->{'table.fields'} = [qw/name abstract/]
        if $detail;
    [200, "OK", \@res, $resmeta];
}

1;
# ABSTRACT: List scripts in a distribution

__END__

=pod

=encoding UTF-8

=head1 NAME

App::lcpan::Cmd::dist_scripts - List scripts in a distribution

=head1 VERSION

This document describes version 1.017 of App::lcpan::Cmd::dist_scripts (from Perl distribution App-lcpan), released on 2017-02-03.

=head1 FUNCTIONS


=head2 handle_cmd(%args) -> [status, msg, result, meta]

List scripts in a distribution.

This function is not exported.

Arguments ('*' denotes required arguments):

=over 4

=item * B<cpan> => I<dirname>

Location of your local CPAN mirror, e.g. /path/to/cpan.

Defaults to C<~/cpan>.

=item * B<detail> => I<bool>

=item * B<dist>* => I<perl::distname>

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

Please visit the project's homepage at L<https://metacpan.org/release/App-lcpan>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-App-lcpan>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-lcpan>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015-2017 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
