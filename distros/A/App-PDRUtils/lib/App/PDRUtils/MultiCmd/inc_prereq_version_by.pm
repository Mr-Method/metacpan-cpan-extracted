package App::PDRUtils::MultiCmd::inc_prereq_version_by;

our $DATE = '2016-12-28'; # DATE
our $VERSION = '0.09'; # VERSION

use 5.010001;
use strict;
use warnings;

use App::PDRUtils::MultiCmd;

App::PDRUtils::MultiCmd::create_cmd_from_dist_ini_cmd(
    dist_ini_cmd => 'inc_prereq_version_by',
);

1;
# ABSTRACT: Increase prereq version by a certain increment

__END__

=pod

=encoding UTF-8

=head1 NAME

App::PDRUtils::MultiCmd::inc_prereq_version_by - Increase prereq version by a certain increment

=head1 VERSION

This document describes version 0.09 of App::PDRUtils::MultiCmd::inc_prereq_version_by (from Perl distribution App-PDRUtils), released on 2016-12-28.

=head1 FUNCTIONS


=head2 handle_cmd(%args) -> [status, msg, result, meta]

Increase prereq version by a certain increment.

This function is not exported.

This function supports dry-run operation.


Arguments ('*' denotes required arguments):

=over 4

=item * B<by>* => I<str>

=item * B<depends> => I<array[str]>

Only include repos that has prereq to specified module(s).

=item * B<doesnt_depend> => I<array[str]>

Exclude repos that has prereq to specified module(s).

=item * B<exclude_dist_patterns> => I<array[str]>

Exclude repos which match specified pattern(s).

=item * B<exclude_dists> => I<array[str]>

Exclude repos which have specified name(s).

=item * B<has_tags> => I<array[str]>

Only include repos which have specified tag(s).

A repo can be tagged by tag C<X> if it has a top-level file named C<.tag-X>.

=item * B<include_dist_patterns> => I<array[str]>

Only include repos which match specified pattern(s).

=item * B<include_dists> => I<array[str]>

Only include repos which have specified name(s).

=item * B<lacks_tags> => I<array[str]>

Exclude repos which have specified tag(s).

A repo can be tagged by tag C<X> if it has a top-level file named C<.tag-X>.

=item * B<module>* => I<str>

=item * B<repos> => I<array[str]>

=back

Special arguments:

=over 4

=item * B<-dry_run> => I<bool>

Pass -dry_run=>1 to enable simulation mode.

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

Please visit the project's homepage at L<https://metacpan.org/release/App-PDRUtils>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-App-PDRUtils>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-PDRUtils>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
