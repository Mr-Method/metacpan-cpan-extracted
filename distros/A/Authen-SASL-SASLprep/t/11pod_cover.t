# $Id$

use strict;
use Test::More;

eval "use Test::Pod::Coverage;";
plan skip_all => "Test::Pod::Coverage required for testing POD coverage" if $@;

all_pod_coverage_ok( 'all modules are covered by POD' )
