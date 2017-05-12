use strict;
use warnings;

use Test::More tests => 1;
use Acme::Alien::DontPanic2 ();

use Text::ParseWords qw/shellwords/;

my @libs = shellwords( Acme::Alien::DontPanic2->libs );

my ($libname) = grep { s/^-l// } @libs;
is( $libname, 'dontpanic', 'idenitified needed library' );

#This test isn't sufficient, see also Acme::Ford::Prefect

