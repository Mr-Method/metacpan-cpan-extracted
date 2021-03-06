package Clip2;
use strict;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
use Tk;

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(&new);
#%EXPORT_TAGS = ( DEFAULT => [qw(&new &setclipboundaries &getxmin &getymin &getxmax &getymax )],
%EXPORT_TAGS = ( DEFAULT => [qw(&new)],
                   Both    => [qw(&new)]);

sub new  {
	my ($pkg,$x1,$y1,$x2,$y2) = @_;
	bless {
		_xmin 	=> $x1,
		_ymin 	=> $y1,
		_xmax 	=> $x2,
		_ymax 	=> $y2
	}, $pkg;
}

sub setclipboundaries {
	my $obj 	= shift;
	my $x1		= shift;	
	my $y1		= shift;	
	my $x2		= shift;	
	my $y2		= shift;
	$obj->{_xmin} = $x1;
	$obj->{_ymin} = $y1;
	$obj->{_xmax} = $x2;
	$obj->{_ymax} = $y2;
}

sub code {
	my $obj = shift;
	my $x	= shift;
	my $y	= shift;

	return 	(($x<$obj->getxmin())<<3) | (($x>$obj->getxmax())<<2) |
		(($y<$obj->getymin())<<1) | ($y>$obj->getymax());
}

sub getxmin { my $obj = shift; return $obj->{_xmin}; }
sub getymin { my $obj = shift; return $obj->{_ymin}; }
sub getxmax { my $obj = shift; return $obj->{_xmax}; }
sub getymax { my $obj = shift; return $obj->{_ymax}; }
sub gettag { my $obj = shift; return $obj->{_tag}; }
sub getclipboundaries { 
	my $obj = shift; 
	my @xy = ( 
		$obj->getxmin(), 
		$obj->getymin(),
		$obj->getxmax(), 
		$obj->getymax()
	);
	return @xy;
}

sub cliped {
	my $obj = shift;
	my $xP 	= shift;
	my $yP 	= shift;
	my $xQ 	= shift;
	my $yQ 	= shift;
	my $cP 	= $obj->code( $xP, $yP );
	my $cQ 	= $obj->code( $xQ, $yQ );
if ( $cP | $cQ ) { return 1; }
return 0;
#	while( $cP | $cQ ) {
#		if( $cP & $cQ ) { return; }
#		my $dx = $xQ - $xP;
#		my $dy = $yQ - $yP;
#		if ( $cP ) {
#			if    ( $cP & 8 ) { $yP += ( $xmin-$xP)*$dy/$dx; $xP=$xmin; }
#			elsif ( $cP & 4 ) { $yP += ( $xmax-$xP)*$dy/$dx; $xP=$xmax; }
#			elsif ( $cP & 2 ) { $xP += ( $ymin-$yP)*$dx/$dy; $yP=$ymin; }
#			elsif ( $cP & 1 ) { $xP += ( $ymax-$yP)*$dx/$dy; $yP=$ymax; }
#			$cP = $obj->code( $xP, $yP );
#		} else {
#			if    ( $cQ & 8 ) { $yQ += ( $xmin-$xQ)*$dy/$dx; $xQ=$xmin; }
#			elsif ( $cQ & 4 ) { $yQ += ( $xmax-$xQ)*$dy/$dx; $xQ=$xmax; }
#			elsif ( $cQ & 2 ) { $xQ += ( $ymin-$yQ)*$dx/$dy; $yQ=$ymin; }
#			elsif ( $cQ & 1 ) { $xQ += ( $ymax-$yQ)*$dx/$dy; $yQ=$ymax; }
#			$cQ = $obj->code( $xQ, $yQ );
#		} # end if
#	} # end while
}

1;
