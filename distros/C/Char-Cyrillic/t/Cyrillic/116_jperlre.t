# encoding: Cyrillic
# This file is encoded in Cyrillic.
die "This file is not encoded in Cyrillic.\n" if q{あ} ne "\x82\xa0";

use Cyrillic;
print "1..1\n";

my $__FILE__ = __FILE__;

if ('あいう' =~ /(あい+いう)/) {
    print "not ok - 1 $^X $__FILE__ not ('あいう' =~ /あい+いう/).\n";
}
else {
    print "ok - 1 $^X $__FILE__ not ('あいう' =~ /あい+いう/).\n";
}

__END__
