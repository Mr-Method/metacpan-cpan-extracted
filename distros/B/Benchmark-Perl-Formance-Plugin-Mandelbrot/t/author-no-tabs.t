
BEGIN {
  unless ($ENV{AUTHOR_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for testing by the author');
  }
}

use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.15

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/Benchmark/Perl/Formance/Plugin/Mandelbrot.pm',
    'lib/Benchmark/Perl/Formance/Plugin/Mandelbrot/withmce.pm',
    'lib/Benchmark/Perl/Formance/Plugin/Mandelbrot/withthreads.pm',
    't/00-compile.t',
    't/author-eol.t',
    't/author-no-tabs.t',
    't/author-pod-syntax.t',
    't/samplerun.t'
);

notabs_ok($_) foreach @files;
done_testing;
