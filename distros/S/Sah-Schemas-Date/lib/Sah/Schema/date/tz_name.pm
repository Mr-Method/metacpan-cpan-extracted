package Sah::Schema::date::tz_name;

our $AUTHORITY = 'cpan:PERLANCAR'; # AUTHORITY
our $DATE = '2020-03-08'; # DATE
our $DIST = 'Sah-Schemas-Date'; # DIST
our $VERSION = '0.013'; # VERSION

our $schema = [str => {
    summary => 'Timezone name',
    'x.completion' => sub {
        require Complete::TZ;

        my %args = @_;

        Complete::TZ::complete_tz(word => $args{word});
    },
    examples => [
        {value=>'Asia/Jakarta', valid=>1},
    ],
}, {}];

1;

# ABSTRACT: Timezone name

__END__

=pod

=encoding UTF-8

=head1 NAME

Sah::Schema::date::tz_name - Timezone name

=head1 VERSION

This document describes version 0.013 of Sah::Schema::date::tz_name (from Perl distribution Sah-Schemas-Date), released on 2020-03-08.

=head1 SYNOPSIS

Using with L<Data::Sah>:

 use Data::Sah qw(gen_validator);
 my $vdr = gen_validator("date::tz_name*");
 say $vdr->($data) ? "valid" : "INVALID!";

 # Data::Sah can also create a validator to return error message, coerced value,
 # even validators in other languages like JavaScript, from the same schema.
 # See its documentation for more details.

Using in L<Rinci> function metadata (to be used with L<Perinci::CmdLine>, etc):

 package MyApp;
 our %SPEC;
 $SPEC{myfunc} = {
     v => 1.1,
     summary => 'Routine to do blah ...',
     args => {
         arg1 => {
             summary => 'The blah blah argument',
             schema => ['date::tz_name*'],
         },
         ...
     },
 };
 sub myfunc {
     my %args = @_;
     ...
 }

Sample data:

 "Asia/Jakarta"  # valid

=head1 DESCRIPTION

Currently no validation for valid timezone names. But completion is provided.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Sah-Schemas-Date>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-Sah-Schemas-Date>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Sah-Schemas-Date>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020, 2019 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
