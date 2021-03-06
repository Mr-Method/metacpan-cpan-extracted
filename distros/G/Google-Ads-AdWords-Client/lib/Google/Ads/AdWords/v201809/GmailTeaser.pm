package Google::Ads::AdWords::v201809::GmailTeaser;
use strict;
use warnings;


__PACKAGE__->_set_element_form_qualified(1);

sub get_xmlns { 'https://adwords.google.com/api/adwords/cm/v201809' };

our $XML_ATTRIBUTE_CLASS;
undef $XML_ATTRIBUTE_CLASS;

sub __get_attr_class {
    return $XML_ATTRIBUTE_CLASS;
}

use Class::Std::Fast::Storable constructor => 'none';
use base qw(Google::Ads::SOAP::Typelib::ComplexType);

{ # BLOCK to scope variables

my %headline_of :ATTR(:get<headline>);
my %description_of :ATTR(:get<description>);
my %businessName_of :ATTR(:get<businessName>);
my %logoImage_of :ATTR(:get<logoImage>);

__PACKAGE__->_factory(
    [ qw(        headline
        description
        businessName
        logoImage

    ) ],
    {
        'headline' => \%headline_of,
        'description' => \%description_of,
        'businessName' => \%businessName_of,
        'logoImage' => \%logoImage_of,
    },
    {
        'headline' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        'description' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        'businessName' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        'logoImage' => 'Google::Ads::AdWords::v201809::Image',
    },
    {

        'headline' => 'headline',
        'description' => 'description',
        'businessName' => 'businessName',
        'logoImage' => 'logoImage',
    }
);

} # end BLOCK







1;


=pod

=head1 NAME

Google::Ads::AdWords::v201809::GmailTeaser

=head1 DESCRIPTION

Perl data type class for the XML Schema defined complexType
GmailTeaser from the namespace https://adwords.google.com/api/adwords/cm/v201809.

Represents Gmail teaser specific data. 




=head2 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY
methods:

=over

=item * headline


=item * description


=item * businessName


=item * logoImage




=back


=head1 METHODS

=head2 new

Constructor. The following data structure may be passed to new():






=head1 AUTHOR

Generated by SOAP::WSDL

=cut

