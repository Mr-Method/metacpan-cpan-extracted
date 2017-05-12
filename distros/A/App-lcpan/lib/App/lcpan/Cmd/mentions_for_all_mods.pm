package App::lcpan::Cmd::mentions_for_all_mods;

our $DATE = '2017-02-03'; # DATE
our $VERSION = '1.017'; # VERSION

use 5.010;
use strict;
use warnings;
use Log::Any::IfLOG '$log';

require App::lcpan;
require App::lcpan::Cmd::mentions_for_mod;

our %SPEC;

my $mentions_for_mod_args = $App::lcpan::Cmd::mentions_for_mod::SPEC{handle_cmd}{args};

$SPEC{'handle_cmd'} = {
    v => 1.1,
    summary => 'List PODs which mention all specified module(s)',
    args => $mentions_for_mod_args,
};
sub handle_cmd {
    my %args = @_;

    my $mres = App::lcpan::Cmd::mentions_for_mod::handle_cmd(%args);
    return $mres unless $mres->[0] == 200;

    my $mods = $args{modules};

    my %counts; # key = content_path, value = hash of module name => count
    my %content_data; # key = content_path, value = data
    for my $e (@{ $mres->[2] }) {
        $counts{$e->{content_path}}{$e->{module}}++;
        $content_data{$e->{content_path}} //= {
            release          => $e->{release},
            mentioner_author => $e->{mentioner_author},
            content_path     => $e->{content_path},
        };
    }

    my $resmeta = {'table.fields' => [qw/content_path mentioner_author release/]};

    my @res;
    for my $cp (sort keys %counts) {
        next unless keys(%{ $counts{$cp} }) == @$mods;
        push @res, $content_data{$cp};
    }

    [200, "OK", \@res, $resmeta];
}

1;
# ABSTRACT: List PODs which mention all specified module(s)

__END__

=pod

=encoding UTF-8

=head1 NAME

App::lcpan::Cmd::mentions_for_all_mods - List PODs which mention all specified module(s)

=head1 VERSION

This document describes version 1.017 of App::lcpan::Cmd::mentions_for_all_mods (from Perl distribution App-lcpan), released on 2017-02-03.

=head1 FUNCTIONS


=head2 handle_cmd(%args) -> [status, msg, result, meta]

List PODs which mention all specified module(s).

This function is not exported.

Arguments ('*' denotes required arguments):

=over 4

=item * B<cpan> => I<dirname>

Location of your local CPAN mirror, e.g. /path/to/cpan.

Defaults to C<~/cpan>.

=item * B<index_name> => I<filename> (default: "index.db")

Filename of index.

=item * B<mentioned_authors> => I<array[str]>

Filter by author(s) of module/script being mentioned.

=item * B<mentioner_authors> => I<array[str]>

Filter by author(s) of POD that does the mentioning.

=item * B<mentioner_authors_arent> => I<array[str]>

=item * B<mentioner_modules> => I<array[str]>

Filter by module(s) that do the mentioning.

=item * B<mentioner_scripts> => I<array[str]>

Filter by script(s) that do the mentioning.

=item * B<modules>* => I<array[perl::modname]>

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
