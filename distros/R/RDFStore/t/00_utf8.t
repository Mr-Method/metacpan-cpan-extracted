BEGIN {print "1..15\n";}
END { print "not ok 1\n" unless $::loaded; RDFStore::debug_malloc_dump(); };

sub ok
{
    my $no = shift ;
    my $result = shift ;
 
    print "not " unless $result ;
    print "ok $no\n" ;
}

use RDFStore::Util::UTF8 qw( cp_to_utf8 utf8_to_cp is_utf8 to_utf8 to_utf8_foldedcase utf8lc );

$loaded = 1;
print "ok 1\n";

my $tt=2;

# utf8 stuff
#ok $tt++, ! is_utf8(" "); # not valid
ok $tt++, is_utf8("A"); # valid
ok $tt++, is_utf8("è"); # valid
ok $tt++, ! is_utf8("�"); # not valid
ok $tt++, ! is_utf8("��"); # not valid
ok $tt++,  is_utf8("€"); # valid

my $cc = 0x0391;
ok $tt++, my $utf8 = cp_to_utf8( $cc );

ok $tt++, my $cc1 = utf8_to_cp( $utf8 );
ok $tt++, ($cc == $cc1);

my $str = "�";
ok $tt++, (! is_utf8( $str ) ); # but shouldn't it be valid ???
ok $tt++, $str = to_utf8( $str );
ok $tt++, is_utf8( $str );

# utf8 case-fold stuff
my $str1 = "AlBerTo"; # to get 'alberto'
ok $tt++, my $str2 = to_utf8_foldedcase( $str1 );
ok $tt++, ($str1 ne $str2);
ok $tt++, (lc($str1) eq $str2);
