#!/usr/bin/perl

# Not all hosts respond to IPv6 fragments
# Examples that do:
#  2001:559:0:4f::6011:4dc3

use strict;
use warnings;

use Net::Frame 1.09;
use Net::Frame::Simple 1.05;
use Net::Frame::Layer qw(:subs);
use Net::Frame::Layer::ETH qw(:consts);
use Net::Frame::Layer::IPv6 qw(:consts);
use Net::Frame::Layer::IPv6::Fragment;
use Net::Frame::Layer::ICMPv6 qw(:consts);
use Net::Frame::Layer::ICMPv6::Echo;

# Get input
print "What destination [ENTER for default]? ";
my $dest = <STDIN>;
chomp $dest;
print "\n";

# Validate
$dest = $dest || 'ipv6.google.com';
if (!($dest = getHostIpv6Addr($dest))) { return }

# Create original packet
my $ether = Net::Frame::Layer::ETH->new(
#    src  => 'aa:bb:cc:dd:ee:ff',
#    dst  => '00:11:22:33:44:55',
    type => NF_ETH_TYPE_IPv6
);
my $ipv6  = Net::Frame::Layer::IPv6->new(
#    src        => '2001::1',
    dst        => $dest,
    nextHeader => NF_IPv6_PROTOCOL_ICMPv6
);
my $icmp  = Net::Frame::Layer::ICMPv6->new;
my $payload;
for (1..8192) {
    $payload .= 'a';
}
my $echo  = Net::Frame::Layer::ICMPv6::Echo->new(
    identifier     => 1,
    sequenceNumber => 1,
    payload        => $payload
);
my $packet = Net::Frame::Simple->new(layers=>
    [ $ether, $ipv6, $icmp, $echo ]
);

# Update IPv6 nextHeader
$ipv6->nextHeader(NF_IPv6_PROTOCOL_IPv6FRAGMENT);
$ipv6->pack;

# Create fragment extension headers
my @f;
$f[0] = Net::Frame::Layer::IPv6::Fragment->new(
    nextHeader => NF_IPv6_PROTOCOL_ICMPv6,
    mFlag      => 1
);
for (1..7) {
    push @f, Net::Frame::Layer::IPv6::Fragment->new(
        nextHeader     => NF_IPv6_PROTOCOL_ICMPv6,
        mFlag          => 1,
        # 8192 total / 8 frags / 8-byte units,
        # plus 1 additional 8-byte ICMPv6 header
        fragmentOffset => (($_*8192/64)+1)
    );
}
# Last frag has mFlag set to 0
$f[$#f]->mFlag(0);
$_->pack for (@f);

# Update ICMPv6 checksum for frag packet from orignal packet
$icmp->checksum($packet->ref->{ICMPv6}->checksum);
$icmp->pack;

# Create ICMPv6 Echo header
my $echofrag = Net::Frame::Layer::ICMPv6::Echo->new(
    identifier     => 1,
    sequenceNumber => 1
);
$echofrag->pack;

# IPv6 payload length for packet frag 1 is:
#  8 byte frag header
#  8 byte ICMPv6 header
#  1024 bytes data
$ipv6->payloadLength(8 + 8 + 1024);
$ipv6->pack;

my @frag;
# Create first frag
$frag[0] = $ether->raw . $ipv6->raw . $f[0]->raw . $icmp->raw . $echofrag->raw . substr $payload, 0, 1024;

# IPv6 payload length for packet frag 2... is:
#  8 byte frag header
#  1024 bytes data
$ipv6->payloadLength(8 + 1024);
$ipv6->pack;

# Create remaining 7 frags
for (1..7) {
    $frag[$_] = $ether->raw . $ipv6->raw . $f[$_]->raw . substr $payload, 1024*$_, 1024;
}

# 8 raw packets are stored in @frag

#if (!$ARGV[0]) { exit }
#use Net::Pcap qw(:functions);
#my %devinfo;
#my $err;
#my $fp= pcap_open($ARGV[0], 100, 0, 1000, \%devinfo, \$err);
#if (!defined($fp)) {
#    printf "Unable to open adapter `%s'\n", $ARGV[0];
#    exit 1
#}
#for my $packet (@frag) {
#    if (pcap_sendpacket($fp, $packet) != 0) {
#        printf "Error sending packet: %s\n", pcap_geterr($fp);
#        exit 1
#    }
#}
