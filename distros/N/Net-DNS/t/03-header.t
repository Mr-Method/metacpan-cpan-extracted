#!/usr/bin/perl
# $Id: 03-header.t 1815 2020-10-14 21:55:18Z willem $
#

use strict;
use warnings;
use Test::More;

use Net::DNS::Packet;
use Net::DNS::Parameters;

plan tests => 72;


my $packet = Net::DNS::Packet->new(qw(. NS IN));
my $header = $packet->header;
ok( $header->isa('Net::DNS::Header'), 'packet->header object' );


sub waggle {
	my $object    = shift;
	my $attribute = shift;
	my @sequence  = @_;
	for my $value (@sequence) {
		my $change = $object->$attribute($value);
		my $stored = $object->$attribute();
		is( $stored, $value, "expected value after header->$attribute($value)" );
	}
	return;
}


my $newid = Net::DNS::Packet->new()->header->id;
waggle( $header, 'id', $header->id, $newid, $header->id );

waggle( $header, 'opcode', qw(STATUS UPDATE QUERY) );
waggle( $header, 'rcode',  qw(REFUSED FORMERR NOERROR) );

waggle( $header, 'qr', 1, 0, 1, 0 );
waggle( $header, 'aa', 1, 0, 1, 0 );
waggle( $header, 'tc', 1, 0, 1, 0 );
waggle( $header, 'rd', 0, 1, 0, 1 );
waggle( $header, 'ra', 1, 0, 1, 0 );
waggle( $header, 'ad', 1, 0, 1, 0 );
waggle( $header, 'cd', 1, 0, 1, 0 );


#
#  Is $header->string remotely sane?
#
like( $header->string, '/opcode = QUERY/', 'string() has QUERY opcode' );
like( $header->string, '/qdcount = 1/',	   'string() has qdcount correct' );
like( $header->string, '/ancount = 0/',	   'string() has ancount correct' );
like( $header->string, '/nscount = 0/',	   'string() has nscount correct' );
like( $header->string, '/arcount = 0/',	   'string() has arcount correct' );

$header->opcode('UPDATE');
like( $header->string, '/opcode = UPDATE/', 'string() has UPDATE opcode' );
like( $header->string, '/zocount = 1/',	    'string() has zocount correct' );
like( $header->string, '/prcount = 0/',	    'string() has prcount correct' );
like( $header->string, '/upcount = 0/',	    'string() has upcount correct' );
like( $header->string, '/adcount = 0/',	    'string() has adcount correct' );


#
# Check that the aliases work
#
my $rr = Net::DNS::RR->new('example.com. 10800 A 192.0.2.1');
my @rr = ( $rr, $rr );
$packet->push( prereq	  => $rr );
$packet->push( update	  => $rr, @rr );
$packet->push( additional => @rr, @rr );

is( $header->zocount, $header->qdcount, 'zocount value matches qdcount' );
is( $header->prcount, $header->ancount, 'prcount value matches ancount' );
is( $header->upcount, $header->nscount, 'upcount value matches nscount' );
is( $header->adcount, $header->arcount, 'adcount value matches arcount' );


foreach my $method (qw(qdcount ancount nscount arcount)) {
	local $Net::DNS::Header::warned;
	local $SIG{__WARN__} = sub { die @_ };

	eval { $header->$method(1) };
	my ($warning) = split /\n/, "$@\n";
	ok( $warning, "$method read-only:\t[$warning]" );

	eval { $header->$method(1) };
	my ($repeated) = split /\n/, "$@\n";
	ok( !$repeated, "warning not repeated:\t[$repeated]" );
}


my $data = $packet->data;

my $packet2 = Net::DNS::Packet->new( \$data );

my $string = $packet->header->string;

is( $packet2->header->string, $string, 'encode/decode transparent' );


SKIP: {
	my $size = $header->size;
	my $edns = $header->edns;
	ok( $edns->isa('Net::DNS::RR::OPT'), 'header->edns object' );

	skip( 'EDNS header extensions not supported', 10 ) unless $edns->isa('Net::DNS::RR::OPT');

	waggle( $header, 'do', 0, 1, 0, 1 );
	waggle( $header, 'rcode', qw(BADVERS BADMODE BADNAME FORMERR NOERROR) );

	my $packet = Net::DNS::Packet->new();			# empty EDNS size solicitation
	my $udplim = 1280;
	$packet->edns->size($udplim);
	my $encoded = $packet->data;
	my $decoded = Net::DNS::Packet->new( \$encoded );
	is( $decoded->edns->size, $udplim, 'EDNS size request assembled correctly' );
}


eval {					## exercise printing functions
	require IO::File;
	my $file   = "03-header.tmp";
	my $handle = IO::File->new( $file, '>' ) || die "Could not open $file for writing";
	select( ( select($handle), $header->print )[0] );
	close($handle);
	unlink($file);
};


exit;

