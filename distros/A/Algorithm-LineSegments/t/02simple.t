use Test::More;
use Algorithm::LineSegments;

eval "use Test::Deep";
plan skip_all => "Test::Deep required" if $@;
plan tests => 1;

my @data = (
  9.4639403869223315e-08, 6.2436413372779498e-08,
  6.9879916964055155e-08, 0.0,
  2.5136856152130349e-08, 3.3167488311391935e-08,
  2.4269962040079918e-08, 5.1859753824601285e-08,
  7.3665549216173076e-09, 4.1636617709173152e-08,
  6.3353304824431689e-09, 1.0792120086478008e-08,
  6.1050144495311542e-08, 1.9847604448841594e-08,
  5.1123240751849153e-08, 4.2879687356389695e-08,
  5.327892793616229e-08,  4.7179860018786712e-08,
  9.821508939467094e-08,  5.4932520754391589e-08,
  7.8617865995056491e-08, 1.5798448771420226e-08,
  1.374822744537596e-07,  3.7631373572821758e-09,
  1.545821071147202e-08,  6.5964300688392541e-08,
  1.5693387922510738e-08, 3.3970302126817842e-08,
  5.5952799726810554e-08, 4.8817188513794463e-08,
  2.5147040005890631e-08, 1.6811017644613457e-07,
  7.3077544016086904e-08, 5.5543111443512316e-08,
  5.7241045681166725e-08, 7.8155771632282267e-08,
  9.6828308926433238e-08, 7.0898970250254933e-08,
  1.4138510096017853e-07, 4.8577977196373467e-08,
  7.6742971089061029e-08, 7.4095545699037757e-08,
  4.1207819378996646e-08, 8.7655813274523098e-08,
  3.8827629111892747e-08, 3.5623308747290139e-08,
  1.4367344647325808e-07, 7.1146843083624844e-08,
  1.1287908563417659e-07, 1.4372488976732711e-07,
  1.5935856367832457e-07, 1.3169736234885931e-07,
  1.010499275366783e-07,  1.1482337924917374e-07,
  1.3010155441861571e-07, 1.3407833421297255e-07,
  1.6268586477963254e-07, 1.4625940991663811e-07,
  1.1995291515631834e-07, 9.5844484349072445e-08,
  1.8708396964939311e-07, 1.0926952143108792e-07,
  1.2033575558234588e-07, 2.0083781748780893e-07,
  2.0136947398441407e-07, 1.9949439433730731e-07,
  1.4978063234138972e-07, 2.3015466865672352e-07,
  2.8253586492610339e-07, 1.829165228173224e-07,
  3.2350979495276988e-07, 3.0668863360006071e-07,
  4.3463887777761556e-07, 4.2347434714429255e-07,
  7.8861120300643961e-07, 3.6604041042664903e-07,
  4.8644511707607307e-07, 8.4161979430064093e-07,
  6.999898687354289e-07,  1.0163131491935928e-06,
  5.7554666454961989e-07, 8.4375227515920415e-07,
  5.0084031499864068e-07, 8.1850583910636487e-07,
  6.2858021010470111e-07, 1.1939087016799022e-06,
  7.5851613701161114e-07, 8.0766096743900562e-07,
  7.0346953862099326e-07, 5.4865620313648833e-07,
  6.3965364915929968e-07, 5.6690839755901834e-07,
  9.8975874607276637e-07, 9.8134887593914755e-07,
  8.2598535300348885e-07, 6.5078739908130956e-07,
  8.5101095237405389e-07, 8.3415682183840545e-07,
  8.3896236446889816e-07, 8.2226330277990201e-07,
  9.0457018586675986e-07, 9.3627824071518262e-07,
  9.8573502782528521e-07, 8.3708232523349579e-07,
  9.2862518386027659e-07, 1.227572056450299e-06,
  9.5463144589302829e-07, 8.3282310470167431e-07,
  1.003983243208495e-06,  1.1261082590863225e-06,
  1.2228694004079443e-06, 1.3630516377816093e-06,
  1.2632293646674952e-06, 1.2092349379599909e-06,
  9.7269912657793611e-07, 1.3418200524029089e-06,
  1.3381401231526979e-06, 1.7017911204675329e-06,
  1.5483539073102293e-06, 1.5219344504657784e-06,
  1.7284978639509063e-06, 1.5419442433994845e-06,
  1.4907393506291555e-06, 1.5021543049442698e-06,
  1.9912529296561843e-06, 1.8468153939465992e-06,
  2.0081681668671081e-06, 2.0920172119076597e-06,
  2.0749766918015666e-06, 2.4187461349356454e-06,
  2.3721811430732487e-06, 2.5431006633880315e-06,
  2.1537744032684714e-06, 2.4543357994843973e-06,
  3.2118000490299892e-06, 1.9981478089903248e-06,
  2.6157640604651533e-06, 2.1247597032925114e-06,
  2.4799717266432708e-06, 2.4789690087345662e-06,
  2.3558634438813897e-06, 2.2694771359965671e-06,
  2.5580320652807131e-06, 2.1368480247474508e-06,
  1.6404407006120891e-06, 2.0576526367221959e-06,
  3.1698732527729589e-06, 2.943959088952397e-06,
  2.7075916477770079e-06, 2.6067832550324965e-06,
  3.0095975489530247e-06, 2.7878927539859433e-06,
  2.3435613911715336e-06, 2.7437606604507891e-06,
  2.2960084606893361e-06, 2.2332155822368804e-06,
  2.4816026780172251e-06, 2.6799075385497417e-06,
  2.3331647298618918e-06, 2.7450646484794561e-06,
  2.4158300675480859e-06, 2.3866500669100787e-06,
  2.3779982711857883e-06, 2.2776230252929963e-06,
  2.4146254418155877e-06, 2.5009098862938117e-06,
  2.1368341549532488e-06, 2.0914212655043229e-06,
  2.0780062186531723e-06, 2.0650820715673035e-06,
  2.0493278043431928e-06, 2.0855104594375007e-06,
  1.9044288137592957e-06, 1.8554571852291701e-06,
  1.8465681250745547e-06, 1.8236339656141354e-06,
  1.6577106407567044e-06, 1.8574255591374822e-06,
  1.6127103208418703e-06, 1.6292159443764831e-06,
  1.6736373709136387e-06, 1.5465045635210117e-06,
  1.5384320022349129e-06, 1.432767362530285e-06,
  1.4931300711396034e-06, 1.4662895182482316e-06,
  1.5969678770488827e-06, 1.4199331417330541e-06,
  1.4932268186385045e-06, 1.468710252083838e-06,
  1.4313693554868223e-06, 1.4716221130584017e-06,
  1.4158204066916369e-06, 1.5244659152813256e-06,
  1.5860794064792572e-06, 1.5218972748698434e-06,
  1.4549884781445144e-06, 1.5483418565054308e-06,
  1.5587681900797179e-06, 1.4512795587506844e-06,
  1.5417641634485335e-06
);

my $ref = [
  [ [   0, num(9.46394038692233e-008, 1) ], [  75, num(3.66040410426649e-007, 1) ] ],
  [ [  76, num(4.86445117076073e-007, 1) ], [ 145, num(2.0576526367222e-006, 1) ] ],
  [ [ 146, num(3.16987325277296e-006, 1) ], [ 199, num(1.45127955875068e-006, 1) ] ],
];

my @cmp = line_segment_points(points => \@data);

cmp_deeply(\@cmp, $ref, 'reftest');
