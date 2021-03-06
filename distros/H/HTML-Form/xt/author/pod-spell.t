use strict;
use warnings;
use Test::More;

# generated by Dist::Zilla::Plugin::Test::PodSpelling 2.007005
use Test::Spelling 0.12;
use Pod::Wordlist;

set_spell_cmd('aspell list');
add_stopwords(<DATA>);
all_pod_files_spelling_ok( qw( bin lib ) );
__DATA__
Aas
Adam
Alders
Alessandro
Alex
Alexandr
Alexey
Andreas
Bill
Bron
Burke
CGI
Choroba
Chrysostomos
Ciornii
DAVIDRW
Daniel
David
Denaxas
FWILES
Father
Fiegehenn
Finch
Form
Froehlich
Gavin
Ghedini
Gisle
Gondwana
Graeme
Grossmann
HTML
Hanak
Hans
Hay
Hedlund
Hukins
Ian
Jacob
Julien
Kapranoff
Karaban
Kennedy
Kilgore
Koenig
Lance
Lipcon
Lukas
MARKSTOS
Mai
Mann
Mark
Mike
Olaf
Ondrej
Peter
Peters
Rabbitson
Rezic
Robert
Rolf
Schilli
Sean
Sjogren
Skytta
Slaven
Spiros
Steinbrunner
Steve
SteveHay
Stone
Stosberg
Thompson
Todd
Tom
Tony
Toru
Tourbin
Ville
Wheeler
Wicks
Yamaguchi
Yuri
Zefram
aas
adamk
al3xbio
alexchorny
amir
amire80
andreas
asjo
at
autocomplete
brong
checkbox
choroba
david
davidrw
denaxas
dot
dsteinbrunner
gisle
github
gpeters
hfroehlich
iank
jefflee
john9art
ka
lib
lw
mai
mark
mschilli
murphy
olaf
ondrej
phrstbrn
readonly
rg
ribasushi
ruff
sasao
sburke
shaohua
simbabque
slaven
sprout
srezic
talby
tech
todd
tom
uid39246
unsetting
unvisited
ville
waif
wfmann
zefram
zigorou
