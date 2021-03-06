use 5.014;

use strict;
use warnings;

use Test::More;

# POD

=name

Data::Object::Hash::Func::Lookup

=abstract

Data-Object Hash Function (Lookup) Class

=synopsis

  use Data::Object::Hash::Func::Lookup;

  my $func = Data::Object::Hash::Func::Lookup->new(@args);

  $func->execute;

=inherits

Data::Object::Hash::Func

=attributes

arg1(Object, req, ro)
arg2(StringLike, req, ro)

=libraries

Data::Object::Library

=description

Data::Object::Hash::Func::Lookup is a function object for Data::Object::Hash.

=cut

# TESTING

use_ok 'Data::Object::Hash::Func::Lookup';

ok 1 and done_testing;
