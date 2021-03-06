
# Test hist() and related functions

use Test::More tests => 4;

use strict;
use warnings;

use PDLA::LiteF;

kill 'INT',$$ if $ENV{UNDER_DEBUGGER}; # Useful for debugging.

sub tapprox {
	my($pa,$pb) = @_;
	all approx $pa, $pb;
}

{
my $x = pdl [15.4,15.8,16.01,16.9,16.1,15.2,15.4,16.2,15.4,16.2,16.4];
my ($hx,$h) = hist ($x,15,17,0.1);

ok( tapprox($hx, pdl(qw/15.05   15.15 15.25   15.35   15.45   15.55   15.65
   15.75   15.85   15.95   16.05   16.15 16.25   16.35   16.45   16.55   16.65
   16.75   16.85   16.95/)) );

ok( tapprox($h, pdl(qw/0 1 0 0 3 0 0 0 1 0 1 3 0 1 0 0 0 0 1 0/)) );
}


{
my $x  = pdl( qw{ 13 10 13 10 9 13 9 12 11 10 10 13 7 6 8 10 11 7 12 9
	       11 11 12 6 12 7} );

my $wt = pdl( qw{ -7.4733817 -3.0945993 -1.7320649 -0.92823577 -0.34618392
	       -1.3326057 -1.3267382 -0.032047153 0.067103333 -0.11446796 
	       -0.72841944 0.95928255  1.4888114 0.17143622 0.14107419
	       -1.6368404    0.72917 -2.0766962 -0.66708236 -0.52959271 
	       1.1551274   0.079184  1.4068289 0.038689811 0.87947996 
	       -0.88373274  } );

my ( $hx, $h ) = whist ($x, $wt, 0, 20, 1 );

ok( tapprox($hx,
	 pdl(qw{ 0.5 1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5
		 11.5 12.5 13.5 14.5 15.5 16.5 17.5 18.5 19.5 }) ) );

ok( tapprox($h, 
	 pdl(qw{ 0 0 0 0 0 0 0.21012603 -1.4716175 0.14107419 -2.2025149
		 -6.5025629  2.0305847  1.5871794 -9.5787698 0 0 0 0 0 0 }) ));
}

## end of tests

