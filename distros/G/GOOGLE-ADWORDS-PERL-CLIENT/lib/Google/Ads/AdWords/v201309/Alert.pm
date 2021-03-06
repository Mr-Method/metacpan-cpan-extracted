package Google::Ads::AdWords::v201309::Alert;
use strict;
use warnings;


__PACKAGE__->_set_element_form_qualified(1);

sub get_xmlns { 'https://adwords.google.com/api/adwords/mcm/v201309' };

our $XML_ATTRIBUTE_CLASS;
undef $XML_ATTRIBUTE_CLASS;

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}

use Class::Std::Fast::Storable constructor => 'none';
use base qw(Google::Ads::SOAP::Typelib::ComplexType);

Class::Std::initialize();

{ # BLOCK to scope variables

my %alertSeverity_of :ATTR(:get<alertSeverity>);
my %alertType_of :ATTR(:get<alertType>);
my %clientCustomerId_of :ATTR(:get<clientCustomerId>);
my %details_of :ATTR(:get<details>);

__PACKAGE__->_factory(
    [ qw(        alertSeverity
        alertType
        clientCustomerId
        details

    ) ],
    {
        'alertSeverity' => \%alertSeverity_of,
        'alertType' => \%alertType_of,
        'clientCustomerId' => \%clientCustomerId_of,
        'details' => \%details_of,
    },
    {
        'alertSeverity' => 'Google::Ads::AdWords::v201309::AlertSeverity',
        'alertType' => 'Google::Ads::AdWords::v201309::AlertType',
        'clientCustomerId' => 'SOAP::WSDL::XSD::Typelib::Builtin::long',
        'details' => 'Google::Ads::AdWords::v201309::Detail',
    },
    {

        'alertSeverity' => 'alertSeverity',
        'alertType' => 'alertType',
        'clientCustomerId' => 'clientCustomerId',
        'details' => 'details',
    }
);

} # end BLOCK







1;


=pod

=head1 NAME

Google::Ads::AdWords::v201309::Alert

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
Alert from the namespace https://adwords.google.com/api/adwords/mcm/v201309.

Alert for a single client. Triggering events are grouped by {@link AlertType} into the same alert with multiple {@link Details}. 




=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * alertSeverity


=item * alertType


=item * clientCustomerId


=item * details




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():






=head1 AUTHOR

Generated by SOAP::WSDL

=cut

