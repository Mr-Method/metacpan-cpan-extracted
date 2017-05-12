use strict;
use Test::More tests => 4;
BEGIN { use_ok('Acme::POE::Acronym::Generator'); };
my @words = qw(pig poke pop pluggable environment eskimo oscar elvis organism echo overhead);
my $poegen = Acme::POE::Acronym::Generator->new( wordlist => \@words );
isa_ok( $poegen, 'Acme::POE::Acronym::Generator' );
my $string = $poegen->generate();
ok( $string, $string );
diag($string);
my @list = $poegen->generate();
ok( scalar @list == 3, join ' ', @list );
