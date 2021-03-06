
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
    'lib/Tapper/Model.pm',
    't/00-load.t',
    't/author-eol.t',
    't/author-no-tabs.t',
    't/author-pod-syntax.t',
    't/fixtures/hardwaredb/systems.yml',
    't/fixtures/testrundb/scenario_testruns.yml',
    't/fixtures/testrundb/testrun_with_preconditions.yml',
    't/tapper-schema-interdep.t',
    't/tapper_model.t'
);

notabs_ok($_) foreach @files;
done_testing;
