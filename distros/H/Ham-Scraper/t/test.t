
# This -*-perl-*- file is run as part of "make test".
# See "perldoc Test" (or the appropriate Test::* module) for details.
#
BEGIN { print "# Perl version $] under $^O\n" }
BEGIN { require Ham::Scraper } 
print 	'',
  "# Ham::Scraper version $Ham::Scraper::VERSION\n",
  "# Time now: " . scalar(gmtime), " GMT\n",
  "# I'm ", ((chr(65) eq 'A') ? '' : 'not '), "in an ASCII world.\n",
  "#------------------------\n",
;

use Test;
BEGIN { plan tests => 1 }
require Ham::Scraper;
ok(1);
print "# No real tests to run.
";
# See "perldoc makepmdist_1.03.pl" for info on inserting
#  "=for makepmdist-tests" blocks into your module.



