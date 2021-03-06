package Net::DashCS::Types::urIs;
use strict;
use warnings;


__PACKAGE__->_set_element_form_qualified(0);

sub get_xmlns { 'http://dashcs.com/api/v1/emergency' };

our $XML_ATTRIBUTE_CLASS;
undef $XML_ATTRIBUTE_CLASS;

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}

use Class::Std::Fast::Storable constructor => 'none';
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

Class::Std::initialize();

{ # BLOCK to scope variables

my %uris_of :ATTR(:get<uris>);

__PACKAGE__->_factory(
    [ qw(        uris

    ) ],
    {
        'uris' => \%uris_of,
    },
    {
        'uris' => 'Net::DashCS::Types::uri',
    },
    {

        'uris' => 'uris',
    }
);

} # end BLOCK







1;


=pod

=head1 NAME

Net::DashCS::Types::urIs

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
urIs from the namespace http://dashcs.com/api/v1/emergency.






=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * uris




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():

 { # Net::DashCS::Types::urIs
   uris =>  { # Net::DashCS::Types::uri
     callername =>  $some_value, # string
     uri =>  $some_value, # string
   },
 },




=head1 AUTHOR

Generated by SOAP::WSDL

=cut

