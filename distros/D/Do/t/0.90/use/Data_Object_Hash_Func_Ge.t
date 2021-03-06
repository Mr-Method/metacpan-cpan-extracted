use 5.014;

use strict;
use warnings;

use Test::More;

# POD

=name

Data::Object::Hash::Func::Ge

=abstract

Data-Object Hash Function (Ge) Class

=synopsis

  use Data::Object::Hash::Func::Ge;

  my $func = Data::Object::Hash::Func::Ge->new(@args);

  $func->execute;

=inherits

Data::Object::Hash::Func

=attributes

arg1(Object, req, ro)
arg2(HashLike, req, ro)

=libraries

Data::Object::Library

=description

Data::Object::Hash::Func::Ge is a function object for Data::Object::Hash.

=cut

# TESTING

use_ok 'Data::Object::Hash::Func::Ge';

ok 1 and done_testing;
