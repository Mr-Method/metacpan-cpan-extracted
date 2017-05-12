# -*- Mode: Python -*-

use strict;
use warnings;

use Test::More 'no_plan';
use Acme::Pythonic debug => 0;

# ----------------------------------------------------------------------

my $x = 1
unless $x:
    $x += 1
    $x *= 3

is($x, 1)

# ----------------------------------------------------------------------

unless $x == 6 ? 1 : 0:
    $x *= 2

is($x, 2)

# ----------------------------------------------------------------------

my $z = 9
unless $z:
    $z = 3
else:
    $z = 1
    $z *= 3

is($z, 3)

# ----------------------------------------------------------------------

do:
    $z *= 2
    $z += 1
unless $z == 3

is $z, 3

# ----------------------------------------------------------------------

package foo
our $bar = 3
$bar = 5 unless not keys %foo::
Test::More::is($bar, 5)
