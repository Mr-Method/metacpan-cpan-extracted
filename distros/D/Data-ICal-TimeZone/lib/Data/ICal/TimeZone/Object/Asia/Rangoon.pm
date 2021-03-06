# this class is autogenerated.  use make_zones to regenerate
package Data::ICal::TimeZone::Object::Asia::Rangoon;
use strict;
use base qw( Data::ICal::TimeZone::Object );

my $data = join '', <DATA>;
close DATA; # avoid leaking many many filehandles
__PACKAGE__->new->_load( $data );

1;
__DATA__
BEGIN:VCALENDAR
PRODID:-//My Organization//NONSGML My Product//EN
VERSION:2.0
BEGIN:VTIMEZONE
TZID:Asia/Rangoon
X-LIC-LOCATION:Asia/Rangoon
BEGIN:STANDARD
TZOFFSETFROM:+0630
TZOFFSETTO:+0630
TZNAME:MMT
DTSTART:19700101T000000
END:STANDARD
END:VTIMEZONE
END:VCALENDAR
