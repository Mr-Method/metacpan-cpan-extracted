# $Id: test-common.pl,v 1.2 2001/07/11 08:06:40 btrott Exp $

use vars qw( $BASE $SAMPLES );

use Cwd;
use File::Spec;
my $pwd = cwd();
my @pieces = split /\//, $pwd;
if (-f 'test-common.pl') {
    pop @pieces;
}
elsif (-f 't/test-common.pl') {
}
$BASE = File::Spec->catdir(@pieces);
$SAMPLES = File::Spec->catdir($BASE, 't', 'samples');

1;
