package Data::Sah::Coerce::perl::To_obj::From_str::perl_version;

# AUTHOR
our $DATE = '2021-01-20'; # DATE
our $DIST = 'Sah-Schemas-Perl'; # DIST
our $VERSION = '0.035'; # VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 4,
        summary => 'Coerce perl::version from str',
        might_fail => 1,
        prio => 50,
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{expr_match} = "!ref($dt)";
    $res->{expr_coerce} = join(
        "",
        "do { my \$v; eval { \$v = version->parse($dt) }; if (\$@) { ['Invalid version format'] } else { [undef, \$v] } }",
    );

    $res;
}

1;
# ABSTRACT:

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Sah::Coerce::perl::To_obj::From_str::perl_version

=head1 VERSION

This document describes version 0.035 of Data::Sah::Coerce::perl::To_obj::From_str::perl_version (from Perl distribution Sah-Schemas-Perl), released on 2021-01-20.

=for Pod::Coverage ^(meta|coerce)$

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Sah-Schemas-Perl>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-Sah-Schemas-Perl>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://github.com/perlancar/perl-Sah-Schemas-Perl/issues>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2021, 2020, 2019, 2018, 2017, 2016 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
