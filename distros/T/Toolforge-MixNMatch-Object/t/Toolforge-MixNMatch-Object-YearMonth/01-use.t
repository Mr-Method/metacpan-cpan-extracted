use strict;
use warnings;

use Test::More 'tests' => 3;
use Test::NoWarnings;

BEGIN {

	# Test.
	use_ok('Toolforge::MixNMatch::Object::YearMonth');
}

# Test.
require_ok('Toolforge::MixNMatch::Object::YearMonth');
