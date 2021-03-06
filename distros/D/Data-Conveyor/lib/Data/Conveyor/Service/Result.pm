use 5.008;
use strict;
use warnings;

package Data::Conveyor::Service::Result;
BEGIN {
  $Data::Conveyor::Service::Result::VERSION = '1.103130';
}
# ABSTRACT: Stage-based conveyor-belt-like ticket handling system

use YAML;
use overload
  '""'     => 'stringify',
  fallback => 1;
use parent 'Data::Conveyor::Service';
__PACKAGE__->mk_scalar_accessors(qw(result exception));

sub is_ok {
    my $self = shift;
    my $E    = $self->exception;
    !(defined $E && ref $E);
}

sub stringify {
    my $self = shift;
    return sprintf("%s\n", $self->exception) unless $self->is_ok;
    $self->result_as_string;
}

# dummy; subclasses should override this
sub result_as_string { sprintf "%s" => $_[0]->result }
1;


__END__
=pod

=head1 NAME

Data::Conveyor::Service::Result - Stage-based conveyor-belt-like ticket handling system

=head1 VERSION

version 1.103130

=head1 METHODS

=head2 is_ok

FIXME

=head2 result_as_string

FIXME

=head2 stringify

FIXME

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=Data-Conveyor>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see L<http://search.cpan.org/dist/Data-Conveyor/>.

The development version lives at L<http://github.com/hanekomu/Data-Conveyor>
and may be cloned from L<git://github.com/hanekomu/Data-Conveyor>.
Instead of sending patches, please fork this project using the standard
git and github infrastructure.

=head1 AUTHORS

=over 4

=item *

Marcel Gruenauer <marcel@cpan.org>

=item *

Florian Helmberger <fh@univie.ac.at>

=item *

Achim Adam <ac@univie.ac.at>

=item *

Mark Hofstetter <mh@univie.ac.at>

=item *

Heinz Ekker <ek@univie.ac.at>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2004 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

