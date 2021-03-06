use Test::More tests => 1;

use Convert::TAP::Archive qw(convert_from_taparchive);
use Cwd 'abs_path';

my $abs_path = abs_path('./t/data/01_test_archive.tar.gz');

my $html = convert_from_taparchive(
               archive   => $abs_path,
               formatter => 'TAP::Formatter::HTML',
           );

if ($html =~ /<li class="pln">1..2&nbsp;<\/li>\n<li id="t0" class="tst k">ok 1 - use Convert::TAP::Archive;&nbsp;<\/li>\n<li id="t1" class="tst k">ok 2 - Convert::TAP::Archive-&gt;can\('convert_from_taparchive'\)&nbsp;<\/li>/ ) {
    pass ('match html output');
}
else {
    fail ('match html output');
}

