package Org::Element::RadioTarget;

our $DATE = '2020-12-30'; # DATE
our $VERSION = '0.554'; # VERSION

use 5.010;
use locale;
use Moo;
extends 'Org::Element';
with 'Org::Element::Role';
with 'Org::Element::InlineRole';

has target => (is => 'rw');

sub BUILD {
    my ($self, $args) = @_;
    my $pass = $args->{pass} // 1;
    my $doc  = $self->document;
    if ($pass == 1) {
        push @{ $doc->radio_targets },
            $self->target;
    }
}

sub as_string {
    my ($self) = @_;
    join("",
         "<<<", $self->target, ">>>");
}

sub as_text {
    goto \&as_string;
}

1;
# ABSTRACT: Represent Org radio target

__END__

=pod

=encoding UTF-8

=head1 NAME

Org::Element::RadioTarget - Represent Org radio target

=head1 VERSION

This document describes version 0.554 of Org::Element::RadioTarget (from Perl distribution Org-Parser), released on 2020-12-30.

=head1 DESCRIPTION

Derived from L<Org::Element>.

=for Pod::Coverage ^(BUILD)$

=head1 ATTRIBUTES

=head2 target

=head1 METHODS

=head2 as_string => str

From L<Org::Element>.

=head2 as_text => str

From L<Org::Element::InlineRole>.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Org-Parser>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-Org-Parser>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://github.com/perlancar/perl-Org-Parser/issues>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020, 2019, 2017, 2016, 2015, 2014, 2013, 2012, 2011 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
