use strict;
use warnings;
use Math::Decimal128 qw(:all);

print "1..2\n";

my $d128 = Math::Decimal128->new();

assignIVl($d128, 123456789);

if($d128 == MEtoD128('123456789', 0)) {print "ok 1\n"}
else {
  warn "$d128 != ", MEtoD128('123456789', 0), "\n";
  print "not ok 1\n";
}

assignIVl($d128, -123456789);

if($d128 == MEtoD128('-123456789', 0)) {print "ok 2\n"}
else {
  warn "$d128 != ", MEtoD128('123456789', 0), "\n";
  print "not ok 2\n";
}
