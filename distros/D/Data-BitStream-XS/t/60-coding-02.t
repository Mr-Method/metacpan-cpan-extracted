#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Data::BitStream::XS;
my @encodings = qw|
              Unary Unary1 Gamma Delta Omega
              Fibonacci FibGen(3) EvenRodeh Levenstein
              Golomb(10) Golomb(16) Golomb(14000)
              Rice(2) Rice(9)
              GammaGolomb(3) GammaGolomb(128) ExpGolomb(5)
              BoldiVigna(2) Baer(0) Baer(-2) Baer(2)
              StartStepStop(3-3-99) StartStop(1-0-1-0-2-12-99)
              Comma(2) Comma(3)
              BlockTaboo(11) BlockTaboo(0000)
              ARice(2)
            |;

plan tests => scalar @encodings;

foreach my $encoding (@encodings) {
  my $stream = Data::BitStream::XS->new;
  $stream->code_put($encoding, 1235);
  $stream->rewind_for_read;
  my $v = $stream->code_get($encoding);
  cmp_ok($v, '==', 1235, "encoded constant 1235 using $encoding");
}
