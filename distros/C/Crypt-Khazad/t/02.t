use diagnostics;
use strict;
use warnings;
use Test::More tests => 2;
BEGIN {
    use_ok('Crypt::Khazad')
};

BEGIN {
    my $key = pack "H32", "80000000000000000000000000000000";
    my $cipher = new Crypt::Khazad $key;
    my $plaintext = pack "H16", "0000000000000000";
    my $ciphertext = $cipher->encrypt($plaintext);
    my $answer = unpack "H*", $ciphertext;
    is("49a4ce32ac190e3f", $answer);
};

