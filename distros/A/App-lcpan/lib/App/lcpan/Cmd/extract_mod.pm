package App::lcpan::Cmd::extract_mod;

our $DATE = '2017-02-03'; # DATE
our $VERSION = '1.017'; # VERSION

use 5.010;
use strict;
use warnings;

require App::lcpan;

our %SPEC;

$SPEC{'handle_cmd'} = {
    v => 1.1,
    summary => "Extract a module's latest release file to current directory",
    args => {
        %App::lcpan::common_args,
        %App::lcpan::mod_args,
    },
    tags => ['write-to-fs'],
};
sub handle_cmd {
    require Archive::Extract;

    my %args = @_;

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my $mod = $args{module};

    my $row = $dbh->selectrow_hashref("SELECT
  file.cpanid cpanid,
  file.name name
FROM module
LEFT JOIN file ON module.file_id=file.id
WHERE module.name=?
ORDER BY version_numified DESC
", {}, $mod);

    return [404, "No release for module '$mod'"] unless $row;

    my $path = App::lcpan::_fullpath(
        $row->{name}, $state->{cpan}, $row->{cpanid});

    (-f $path) or return [404, "File not found: $path"];

    my $ae = Archive::Extract->new(archive => $path);
    $ae->extract or return [500, "Can't extract: " . $ae->error];

    [200, "OK", undef, {'func.release_path'=>$path}];
}

1;
# ABSTRACT: Extract a module's latest release file to current directory

__END__

=pod

=encoding UTF-8

=head1 NAME

App::lcpan::Cmd::extract_mod - Extract a module's latest release file to current directory

=head1 VERSION

This document describes version 1.017 of App::lcpan::Cmd::extract_mod (from Perl distribution App-lcpan), released on 2017-02-03.

=head1 FUNCTIONS


=head2 handle_cmd(%args) -> [status, msg, result, meta]

Extract a module's latest release file to current directory.

This function is not exported.

Arguments ('*' denotes required arguments):

=over 4

=item * B<cpan> => I<dirname>

Location of your local CPAN mirror, e.g. /path/to/cpan.

Defaults to C<~/cpan>.

=item * B<index_name> => I<filename> (default: "index.db")

Filename of index.

=item * B<module>* => I<perl::modname>

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
