# encoding: Cyrillic
# This file is encoded in Cyrillic.
die "This file is not encoded in Cyrillic.\n" if q{��} ne "\x82\xa0";

my $__FILE__ = __FILE__;

use 5.00503;
use Cyrillic;
print "1..1\n";

print "ok - 1 $^X $__FILE__\n";

__END__
