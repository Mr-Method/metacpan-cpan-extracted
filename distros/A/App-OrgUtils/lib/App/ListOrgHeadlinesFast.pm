package App::ListOrgHeadlinesFast;

our $DATE = '2016-12-24'; # DATE
our $VERSION = '0.45'; # VERSION

use 5.010;
use strict;
use warnings;

use App::FilterOrgByHeadlines;
use Function::Fallback::CoreOrPP qw(clone);

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'List & count Org headlines & todos',
};

$SPEC{list_org_headlines} = do {
    my $meta = clone $App::FilterOrgByHeadlines::SPEC{filter_org_by_headlines};
    $meta->{summary} = 'List Org headlines';
    delete $meta->{args}{with_content};
    delete $meta->{args}{with_preamble};
    delete $meta->{args}{return_array};
    $meta->{result}{schema} = ['array*', of=>'str*'];
    $meta;
};
sub list_org_headlines {
    my %args = @_;

    my $headlines = App::FilterOrgByHeadlines::filter_org_by_headlines(
        %args,
        with_content => 0,
        with_preamble => 0,
        return_array => 1,
    );

    chomp for @$headlines;
    $headlines;
}

$SPEC{list_org_todos} = do {
    my $meta = clone $SPEC{list_org_headlines};
    $meta->{summary} = 'List Org todos';
    delete $meta->{args}{is_todo};
    $meta;
};
sub list_org_todos {
    my %args = @_;

    list_org_headlines(
        %args,
        is_todo => 1,
    );
}

$SPEC{count_org_headlines} = do {
    my $meta = clone $SPEC{list_org_headlines};
    $meta->{summary} = 'Count Org headlines';
    $meta->{result}{schema} = ['int*'];
    $meta;
};
sub count_org_headlines {
    my %args = @_;

    my $res = list_org_headlines(%args);
    ~~@$res;
}

$SPEC{count_org_todos} = do {
    my $meta = clone $SPEC{count_org_headlines};
    $meta->{summary} = 'Count Org todos';
    delete $meta->{args}{is_todo};
    $meta;
};
sub count_org_todos {
    my %args = @_;

    count_org_headlines(
        %args,
        is_todo => 1,
    );
}

1;
# ABSTRACT: List & count Org headlines & todos

__END__

=pod

=encoding UTF-8

=head1 NAME

App::ListOrgHeadlinesFast - List & count Org headlines & todos

=head1 VERSION

This document describes version 0.45 of App::ListOrgHeadlinesFast (from Perl distribution App-OrgUtils), released on 2016-12-24.

=head1 FUNCTIONS


=head2 count_org_headlines(%args) -> int

Count Org headlines.

This routine uses simple regex instead of Org::Parser, for faster performance.

This function is not exported.

Arguments ('*' denotes required arguments):

=over 4

=item * B<ascendant_match> => I<str|re>

Only include headline whose ascendant matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=item * B<has_tags> => I<array[str]>

Only include headline which have all these tags.

=item * B<input>* => I<str>

Value is either a string or an array of strings.

=item * B<is_done> => I<bool>

Only include headline which is a done todo item.

=item * B<is_todo> => I<bool>

Only include headline which is a todo item.

=item * B<lacks_tags> => I<array[str]>

Only include headline which lack all these tags.

=item * B<level> => I<int>

=item * B<match> => I<str|re>

Only include headline which matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=item * B<max_level> => I<int>

=item * B<min_level> => I<int>

=item * B<parent_match> => I<str|re>

Only include headline whose parent matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=back

Return value:  (int)


=head2 count_org_todos(%args) -> int

Count Org todos.

This routine uses simple regex instead of Org::Parser, for faster performance.

This function is not exported.

Arguments ('*' denotes required arguments):

=over 4

=item * B<ascendant_match> => I<str|re>

Only include headline whose ascendant matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=item * B<has_tags> => I<array[str]>

Only include headline which have all these tags.

=item * B<input>* => I<str>

Value is either a string or an array of strings.

=item * B<is_done> => I<bool>

Only include headline which is a done todo item.

=item * B<lacks_tags> => I<array[str]>

Only include headline which lack all these tags.

=item * B<level> => I<int>

=item * B<match> => I<str|re>

Only include headline which matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=item * B<max_level> => I<int>

=item * B<min_level> => I<int>

=item * B<parent_match> => I<str|re>

Only include headline whose parent matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=back

Return value:  (int)


=head2 list_org_headlines(%args) -> array[str]

List Org headlines.

This routine uses simple regex instead of Org::Parser, for faster performance.

This function is not exported.

Arguments ('*' denotes required arguments):

=over 4

=item * B<ascendant_match> => I<str|re>

Only include headline whose ascendant matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=item * B<has_tags> => I<array[str]>

Only include headline which have all these tags.

=item * B<input>* => I<str>

Value is either a string or an array of strings.

=item * B<is_done> => I<bool>

Only include headline which is a done todo item.

=item * B<is_todo> => I<bool>

Only include headline which is a todo item.

=item * B<lacks_tags> => I<array[str]>

Only include headline which lack all these tags.

=item * B<level> => I<int>

=item * B<match> => I<str|re>

Only include headline which matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=item * B<max_level> => I<int>

=item * B<min_level> => I<int>

=item * B<parent_match> => I<str|re>

Only include headline whose parent matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=back

Return value:  (array[str])


=head2 list_org_todos(%args) -> array[str]

List Org todos.

This routine uses simple regex instead of Org::Parser, for faster performance.

This function is not exported.

Arguments ('*' denotes required arguments):

=over 4

=item * B<ascendant_match> => I<str|re>

Only include headline whose ascendant matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=item * B<has_tags> => I<array[str]>

Only include headline which have all these tags.

=item * B<input>* => I<str>

Value is either a string or an array of strings.

=item * B<is_done> => I<bool>

Only include headline which is a done todo item.

=item * B<lacks_tags> => I<array[str]>

Only include headline which lack all these tags.

=item * B<level> => I<int>

=item * B<match> => I<str|re>

Only include headline which matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=item * B<max_level> => I<int>

=item * B<min_level> => I<int>

=item * B<parent_match> => I<str|re>

Only include headline whose parent matches this.

Value is either a string or a regex. If string is in the form of C</.../> or
C</.../i> it is assumed to be a regex.

=back

Return value:  (array[str])

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/App-OrgUtils>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-App-OrgUtils>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-OrgUtils>

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
