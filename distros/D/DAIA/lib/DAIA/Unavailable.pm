use strict;
use warnings;
package DAIA::Unavailable;
#ABSTRACT: Information about a service that is currently unavailable
our $VERSION = '0.43'; #VERSION

use base 'DAIA::Availability';
use DateTime;

our %PROPERTIES = (
    %DAIA::Availability::PROPERTIES,
    queue => { 
        filter => sub { return $_[0] =~ /^[0-9]+$/ ? $_[0] : undef },
    },
    expected => { 
        filter => sub { # TODO: move this to function in DAIA::Availability (?)
            return 'unknown' if lc("$_[0]") eq 'unknown';
            my $exp = $_[0];
            if ($exp =~ /^P/ or UNIVERSAL::isa( $exp, 'DateTime::Duration' )) {
                my $span = DAIA::Availability::parse_duration( $exp );
                my $now = DateTime->from_epoch( epoch => time() );
                $exp = $now->add_duration( $span );
            }
            return DAIA::Availability::date_or_datetime( $exp );
        },
    },
);

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

DAIA::Unavailable - Information about a service that is currently unavailable

=head1 VERSION

version 0.43

=head1 DESCRIPTION

This class models a service that is (currently or in general) not available. 
It is derived from L<DAIA::Availability> so see that class for details and 
examples. In addition an instance of this class can have the properties
C<expected> and C<queue>. Obviously the C<status> property of a
C<DAIA::Unavailable> object is always C<0>.

=head1 PROPERTIES

=over

=item href

An URL to perform, register or reserve the service. As the service is unavailable
you will rarely be able to directly perform the service. However the link could
provide more information or alternatives.

=item limitation

An array reference with limitations (L<DAIA::Limitation> objects) 
of the availability.

=item message

An array reference with L<DAIA::Message> objects about this specific service.

=item queue

The number of waiting requests for this service as non-negative integer value.
Note that the value C<0> is also allowed but in practise there is litte 
difference between no queue and a queue of length zero.

=item expected

An optional time period until the service will be available again. The property
is given as ISO time period string (as XML Schema subset C<xs:date> or C<xs:dateTime>)
or the special value "unknown". If no period (nor "unknown") is given, the service 
probably won't be available in the future.

=back

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
