use 5.008;

use strict;
use warnings;

use Test::More;

eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;

plan tests => 1;
pod_coverage_ok( 'DBD::Mock' ,{
    trustme => [ qr/CLONE|driver/ ],
});
