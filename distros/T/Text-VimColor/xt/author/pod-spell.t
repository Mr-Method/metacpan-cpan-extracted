use strict;
use warnings;
use Test::More;

# generated by Dist::Zilla::Plugin::Test::PodSpelling 2.007005
use Test::Spelling 0.12;
use Pod::Wordlist;


add_stopwords(<DATA>);
all_pod_files_spelling_ok( qw( bin lib ) );
__DATA__
Fish
Geoff
Hinrik
Matyukhin
Randy
Richards
Shlomi
Sigurðsson
Stauner
Text
VimColor
Vyacheslav
bin
geoffr
hinrik
lib
mattn
mmcleric
qef
randy
rwstauner
shlomif
text
Örn
