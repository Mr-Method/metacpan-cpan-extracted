# encoding: Sjis
# This file is encoded in ShiftJIS.
die "This file is not encoded in ShiftJIS.\n" if q{��} ne "\x82\xa0";

my $__FILE__ = __FILE__;

use 5.005;
use Sjis;
print "1..1\n";

print "ok - 1 $^X $__FILE__\n";

__END__
