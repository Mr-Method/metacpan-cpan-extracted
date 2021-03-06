use 5.014;

use strict;
use warnings;

use Test::More;

# POD

=name

sin

=usage

  # given 12345

  $number->sin; # -0.993771636455681

=description

The sin method returns the sine of the number (expressed in radians). This
method returns a data type object to be determined after execution.

=signature

sin() : IntObject

=type

method

=cut

# TESTING

use_ok 'Data::Object::Number';

my $data = Data::Object::Number->new(12345);

like $data->sin(), qr/-0.99377/;

ok 1 and done_testing;
