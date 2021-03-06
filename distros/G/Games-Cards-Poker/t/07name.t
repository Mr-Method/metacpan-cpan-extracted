#!/usr/bin/perl
use warnings;use Test::More;
BEGIN { plan tests => 31 }
use     Games::Cards::Poker qw(:all);
use_ok('Games::Cards::Poker');
my $name = CardName('As');
ok($name eq 'Ace of Spades'    , "CardName( As   ) to $name");
my $card = NameCard($name);
ok($card eq 'As'               , "NameCard($name ) to $card");
   $name = CardName('Kd');
ok($name eq 'King of Diamonds' , "CardName( Kd   ) to $name");
   $card = NameCard($name);
ok($card eq 'Kd'               , "NameCard($name ) to $card");
   $name = CardName('Qh');
ok($name eq 'Queen of Hearts'  , "CardName( Qh   ) to $name");
   $card = NameCard($name);
ok($card eq 'Qh'               , "NameCard($name ) to $card");
   $name = CardName('7d');
ok($name eq 'Seven of Diamonds', "CardName( 7d   ) to $name");
   $card = NameCard($name);
ok($card eq '7d'               , "NameCard($name ) to $card");
   $name = CardName('3c');
ok($name eq 'Three of Clubs'   , "CardName( 3c   ) to $name");
   $card = NameCard($name);
ok($card eq '3c'               , "NameCard($name ) to $card");
   $name = CardName('2d');
ok($name eq 'Two of Diamonds'  , "CardName( 2d   ) to $name");
   $card = NameCard($name);
ok($card eq '2d'               , "NameCard($name ) to $card");
   $name = CardName('2c');
ok($name eq 'Two of Clubs'     , "CardName( 2c   ) to $name");
   $card = NameCard($name);
ok($card eq '2c'               , "NameCard($name ) to $card");
   $name = HandName(0);
ok($name eq 'Royal Flush'      , "HandName(    0 ) to $name");
   $name = HandName('AKQJTs');
ok($name eq 'Royal Flush'      , "HandName(AKQJTs) to $name");
   $name = HandName(qw( Jh Kh Th Ah Qh ));
ok($name eq 'Royal Flush'      , "HandName(Jh Kh Th Ah Qh) to $name");
   @hand = qw( Jh Kh Th Ah Qh );
   $name = HandName(\@hand);
ok($name eq 'Royal Flush'      , "HandName( aref ) to $name");
   $name = HandName(1);
ok($name eq 'Straight Flush'   , "HandName(    1 ) to $name");
   $name = HandName('KQJT9s');
ok($name eq 'Straight Flush'   , "HandName(KQJT9s) to $name");
   $name = HandName(qw( Jh Kh Th 9h Qh ));
ok($name eq 'Straight Flush'   , "HandName(Jh Kh Th 9h Qh) to $name");
   @hand = qw( Jh Kh Th 9h Qh );
   $name = HandName(\@hand);
ok($name eq 'Straight Flush'   , "HandName( aref ) to $name");
   $name = HandName(2000);
ok($name eq 'Three-of-a-Kind'  , "HandName( 2000 ) to $name");
   $name = HandName(7000);
ok($name eq 'High Card'        , "HandName( 7000 ) to $name");
   $name = HandName(ScoreHand(7000));
ok($name eq 'High Card'        , "HandName(ScoreHand( 7000 )) to $name");
   $name = CardName('A');
ok($name eq 'Ace'              , "CardName( A    ) to $name");
   $card = NameCard($name);
ok($card eq 'A'                , "NameCard( Ace  ) to $card");
   $name = CardName('s');
ok($name eq 'Spades'           , "CardName(    s ) to $name");
   $card = NameCard($name);
ok($card eq 's'                , "NameCard(Spades) to $card");
   $name = CardName('2');
ok($name eq 'Two'              , "CardName( 2    ) to $name");
