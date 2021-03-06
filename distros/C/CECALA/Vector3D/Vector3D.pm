package Vector3D;
use strict;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
use overload
      "-"    => \&minus,
      "+"    => \&plus,
      "*"    => \&mult;

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(&new);
%EXPORT_TAGS = ( DEFAULT => [qw(&new &getx &gety &getxy)],
                   Both    => [qw(&new &getx &gety)]);

sub new  {
	my ($pkg,$x,$y,$z) = @_;
	bless {
		_x => $x,
		_y => $y,
		_z => $z
	}, $pkg;
}

sub getx { my $obj = shift; return $obj->{_x}; }
sub gety { my $obj = shift; return $obj->{_y}; }
sub getz { my $obj = shift; return $obj->{_z}; }
sub getxyz { 
	my $obj = shift; 
	my @xyz = ( $obj->getx(), $obj->gety(), $obj->getz() );
	return @xyz;
}

sub setx { my $obj = shift; $obj->{_x} = shift; }
sub sety { my $obj = shift; $obj->{_y} = shift; }
sub setz { my $obj = shift; $obj->{_z} = shift; }
sub setxyz { 
	my $obj = shift; 
	$obj->setx(shift);
	$obj->sety(shift);
	$obj->setz(shift);
}


sub plus {
	my $u = shift;
	my $v = shift;
	return new Vector3D ( 
		$u->getx() + $v->getx(),
		$u->gety() + $v->gety(),
		$u->getz() + $v->getz()
	);
}

sub minus {
	my $u = shift;
	my $v = shift;
	return new Vector3D ( 
		$u->getx() - $v->getx(),
		$u->gety() - $v->gety(),
		$u->getz() - $v->getz()
	);
}

sub mult {
	my $v = shift;
	my $c = shift;
	return new Vector3D ( 
		$c * $v->getx(),
		$c * $v->gety(),
		$c * $v->getz()
	);
}

sub incr {
	my $u = shift;
	my $v = shift;
	$u->{_x} += $v->{_x};
	$u->{_y} += $v->{_y};
	$u->{_z} += $v->{_z};
	return $u;
}

sub decr {
	my $u = shift;
	my $v = shift;
	$u->{_x} -= $v->{_x};
	$u->{_y} -= $v->{_y};
	$u->{_z} -= $v->{_z};
	return $u;
}

sub scale {
	my $v = shift;
	my $c = shift;
	$v->{_x} *= $c;
	$v->{_y} *= $c;
	$v->{_z} *= $c;
	return $v;
}

sub translate {
	my $u = shift;
	my $v = shift;
	$u->{_x} += $v->getx();
	$u->{_y} += $v->gety();
	$u->{_z} += $v->getz();
}

sub dotproduct {
	my $obj = shift; #vector
	my $b 	= shift; #vector
	return 	$obj->getx() * $b->getx() 	+ 
		$obj->gety() * $b->gety() 	+ 
		$obj->getz() * $b->getz();
}

sub abs {
	my $obj = shift; #vector
	return 	sqrt (	$obj->getx() * $obj->getx()+ 
			$obj->gety() * $obj->gety()+ 
			$obj->getz() * $obj->getz());
}

sub crossproduct {
	my $obj = shift; #vector
	my $b 	= shift; #vector
	return 	new Vector3D( 
		$obj->gety() * $b->getz() - $obj->getz() * $b->gety(),
		$obj->getz() * $b->getx() - $obj->getx() * $b->getz(),
		$obj->getx() * $b->gety() - $obj->gety() * $b->getx()
	);
}

sub rotateZ {
	my $P = shift; #vector
	my $phi = shift;
	my $cosphi = cos( $phi );
	my $sinphi = sin( $phi );
	my $dx = $P->{_x};
	my $dy = $P->{_y};
	$P->setx( $dx * $cosphi - $dy * $sinphi );
	$P->sety( $dx * $sinphi + $dy * $cosphi );
}

sub rotateX {
	my $P = shift; #vector
	my $phi = shift;
	my $cosphi = cos( $phi );
	my $sinphi = sin( $phi );
	my $dx = $P->{_x};
	my $dz = $P->{_z};
	$P->setx( $dx * $cosphi - $dz * $sinphi );
	$P->setz( $dx * $sinphi + $dz * $cosphi );
}

sub rotateY {
	my $P = shift; #vector
	my $phi = shift;
	my $cosphi = cos( $phi );
	my $sinphi = sin( $phi );
	my $dy = $P->{_y};
	my $dz = $P->{_z};
	$P->sety( $dy * $cosphi - $dz * $sinphi );
	$P->setz( $dy * $sinphi + $dz * $cosphi );
}

sub print {
	my $v = shift; #vector
	print 	"( " . $v->getx() . 
		", " . $v->gety() . 
		", " . $v->getz() . ")\n";
}

1;
 