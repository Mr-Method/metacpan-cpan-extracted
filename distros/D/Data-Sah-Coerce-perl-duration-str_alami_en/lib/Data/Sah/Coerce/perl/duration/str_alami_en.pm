package Data::Sah::Coerce::perl::duration::str_alami_en;

our $DATE = '2019-07-26'; # DATE
our $VERSION = '0.005'; # VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 4,
        might_fail => 1,
        prio => 60, # a bit lower than normal
        precludes => [qr/\Astr_alami(_.+)?\z/, 'str_human'],
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};
    my $coerce_to = $args{coerce_to} // 'float(secs)';

    my $res = {};

    $res->{expr_match} = "!ref($dt)";
    $res->{modules}{"DateTime::Format::Alami::EN"} //= 0;
    $res->{expr_coerce} = join(
        "",
        "do { my \$res; eval { \$res = DateTime::Format::Alami::EN->new->parse_datetime_duration($dt, {format=>'combined'}) }; ",
        ($coerce_to eq 'float(secs)' ? "if (\$@) { ['Invalid duration syntax'] } else { [undef, \$res->{seconds}] } " :
             $coerce_to eq 'DateTime::Duration' ? "if (\$@) { ['Invalid duration syntax'] } else { [undef, \$res->{Duration}] } " :
             (die "BUG: Unknown coerce_to '$coerce_to'")),
        "}",
    );
    $res;
}

1;
# ABSTRACT: Coerce duration from string parsed by DateTime::Format::Alami::EN

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Sah::Coerce::perl::duration::str_alami_en - Coerce duration from string parsed by DateTime::Format::Alami::EN

=head1 VERSION

This document describes version 0.005 of Data::Sah::Coerce::perl::duration::str_alami_en (from Perl distribution Data-Sah-Coerce-perl-duration-str_alami_en), released on 2019-07-26.

=head1 DESCRIPTION

The rule is not enabled by default. You can enable it in a schema using e.g.:

 ["duration", "x.perl.coerce_rules"=>["str_alami_en"]]

=for Pod::Coverage ^(meta|coerce)$

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Data-Sah-Coerce-perl-duration-str_alami_en>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-Data-Sah-Coerce-perl-duration-str_alami_en>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Data-Sah-Coerce-perl-duration-str_alami_en>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2019, 2018, 2016 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
