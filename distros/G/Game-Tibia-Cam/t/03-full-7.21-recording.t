use Test::More;
use MIME::Base64;
use Data::HexDump;

BEGIN {
    use_ok 'Game::Tibia::Cam';
}

# a 7.21 recording of a char cursing in front of the queen
# and getting bashed for it
my $rec = do { local $/; decode_base64(<DATA>) };

my $cam = Game::Tibia::Cam->new(rec => $rec);
ok $cam;
ok $cam->{is_str};
my @version = $cam->version;
ok $version[0] <= 721 && 721 <= $version[1];
is $cam->duration, 50.993; # sec
is $cam->ptotal, 66;
diag('Capture has ' . $cam->ptotal . " packets over " . $cam->duration/1000 . 's');

my $last_ts = 0;
my $num = 0;
is $cam->pnum, undef;
isnt $cam->{eof}, 1;
while (my $p = $cam->pnext) {
    is ++$num, $cam->pnum;
    ok $p->{timestamp} >= $last_ts;
}
is $num, $cam->ptotal;

ok $cam->pcap;

done_testing;

__DATA__
AwFCAAAAtAUAAAAAAABQCAp0lw0AMgAAZFR+CnwHZgDfAwD/ZgAA/2YAAP9mAAD/ZgAA/9ACAP+zAg
D/0QIA/2YAAP9mAAD/ZgAA/2YAAP9mANIHAP9mAN8DvAUA/2YA3wMA/2YAnwcA/2YAAP9mAAD/ZgCc
BAD/0AIA/7MCAP/RAgD/ZgCcBAD/ZgAA/2YAnwcA/2YAAP9mAAD/ZgDfAwD/ZgDfAwD/ZgAA/2YA0g
cA/2YAAP9mAAD/0AIA/7MCAP/RAgD/ZgAA/2YAAP9mAAD/ZgAA/2YAAP9mAN8DAP9mAN8DAP9mAAD/
ZgAA/2YAAP9mAAD/0AIA/7MCAP/RAgD/ZgDSBwD/ZgAA/2YAAP9mAAD/ZgAA/2YA3wMA/2YA4gMA/2
YA3gMA/2YA3gMA/2YAAP9mAAD/0AIA/7MCAP/RAgD/ZgAA/2YAAP9mAAD/ZgCjBwD/ZgDRBwD/ZgDf
AwD/nQEA/50BAP+dAd8DAP9mAAD/ZgAA/9ACAP+zAgD/0QIA/2YAowcA/2YAAP9mANEHAP9mANEHAP
9mAAD/ZgDhAwD/nQFpBAD/nQEA/50B3wMA/2YAAP9mAAD/0AIA/7MCAP/RAgD/ZgAA/2YAAP9mAAD/
ZgAA/2YAmwQA/2YAAP+dAd4DAP+dAQD/nQHiAwD/0gIA/9IC8QYA/9gCAP+zAgD/2wIA/9ICkQQA/9
ICAP/SAgD/0gIA/9ICAP/SAgD/swIA/7MCAP+zAgD/swIA/7MCAP+zAqMBAP+zAmEAAAAAAHSXDQAa
AFRoZWxvc3RhcnRvZmtlZXBpbmdhc2VjcmV0ZAKBclhycgDXAAEAAP+zAgD/swIA/7MCAP+zAgD/sw
IA/7MCAP+zAgD/swIA/7MCAP+zAgD/swJhAAAAAAARAABAEQBCYW1iaSBCb25lY3J1c2hlcmQBi2AT
RF8A11wAAAD/swIA/7MCAP+zAgD/swIA/7MCAP+zAgD/swIA/7MCAP+zAgD/swIA/7MCAP+zAgD/sw
IA/7MCAP+zAgD/2gIA/9MCAP/TAocEAP/TAgD/0wIA/9MCAP/TAgD/0wIA/9MCAP+zAgD/swIA/7MC
4AMA/9MCnAQA/9MCxAQA/9YCwgQA/3AAwgQA/3AAwgQA/3AAAP9wAAD/cADCBAD/cADCBAD/cADCBA
D/dQAA/50BAP+dAQD/nQHfAwD/ZgAA/24AwAQA/2cAnQQA/2cAAP9nAAD/ZwAA/2cAAP9nAAD/ZwCd
BAD/ZwDABAD/bwAA/50B3gMA/50B3gMA/50B4gMA/2YA0QcA/24AwAQA/2cAAP9nAAD/ZwAA/2cAAP
9nAAD/ZwAA/2cAAP9nAMAEAP9vAAD/nQEA/50BAP+dAd8DAP9mAMIEAP9uAMYEAP9nAAD/ZwAA/2cA
AP9nAAD/ZwAA/2cAAP9nAAD/ZwDABAD/bwAA/50BAP+dAQD/nQEA/2cAAP9nAAD/ZwAA/2cAAP9nAA
D/ZwAA/2cAAP9nAAD/ZwAA/2cAwAQA/28AAP+dAQD/nQEA/50BAP9nAAD/ZwAA/2cAAP9nAAD/ZwAA
/2cAAP9nAAD/ZwAA/2cAAP9nAMAEAP9vAAD/nQEA/50BYQAAAAAAZwAAQAYAVHJpc2hhZAKLXkMmXw
DXZAAAAP+dAeADAP9nAOMDAP9nAOMDAP9nAOMDAP9nAAD/ZwAA/2cAAP9nAAD/ZwAA/2cAAP9nAMAE
AP9vAAz/3wMA/5YBFQUM/98DAP+WARYFDP/fAwD/lgEVBQD/3gMA/+MDCv/hAwD/lgHeAwD/lQEA/5
UB3wMK/7gEpwEA/5UBFQUA/5UBAP+VAd8DCv+4BKcBAP+VARMFAP+VAQD/lQHfAwr/sAEA/70EqgEA
/5UBAP+VAd8DDP+VAQD/lQHABAz/lQEA/5UBwAQM/5UBAP+VAd8DDP+VAQD/lQHfAwz/lQHeAwD/lQ
HiAwz/lQEA/5UB354CAAAAAAAAAwz/lQEA/5UB3wMM/5UBAP+VAd8DDP+VAQD/lQHfAwD/wgQA/8IE
AP/CBAn/lQEA/5UBAP+VAQD/lQEA/5UBCP/TAwv/XgMA/10DAP9dAwv/XgMA/10DAP9dAwD/wgSpAQ
r/XgMA/10DAP9dAwD/lQHABA3/lQHABA3/lQHABA3/lQHABA3/lQHABA3/lQHABA3/lQHABA3/lQHA
BA3/lQHGBA3/XQMN/10DDf9dAw3/XQMN/10DC/+vAQD/ugSpAQD/XQML/7gEpwEA/2oA//////////
/s/4NUfgp8Bwp4AdgGeAIzBngDiwV4BN4GeAbXBngHawd4CGgHeAofB2SgJwEnAbgA700BABNTAMgA
CoL/1410lw0AANehFQoLCjopKtKHMhIABwBQZXBpbmFvANLehBEABQBGYXd1dADSOs8NAAcATW9yZm
9sawDSU3wSAAYAV2l6ZWZpANLEAAoACABSYWphdGFsaQDStxcKAAsATWF5IERhcndpbmUA0hhdDgAH
AFZhcmVsbGEA0rQIEQAJAERhcmsgVGVlbQDS1KsUAAoATG9yZCBNYWZyYQDSHbIMABQATWF0aWFzIE
RhbmllbCBQZXRydWYA0h3IGAAFAEN2aWNvANJg0RMAFQBBenRlYyBTZXJwZW50IG9mIEZpcmUA0lah
DgASAE9tZWdhIEdob3N0IEh1bnRlcgDSggANAAgATWFyY2VsdXMA0nukFQAKAERhcmsgTWFmcmEB0r
s5EgAPAE1hbHVraW0gQmVsZXppbQDSaYsLAAcAVnVrdXJlZwC0EzQAWW91ciBsYXN0IHZpc2l0IGlu
IFRpYmlhOiAyMS4gSmFuIDIwMDQgMDU6MTg6MDIgQ0VULm1Vfgd8BwFWfgd8Bx0AAAA2AQAAGwCsAA
AWAFJveWFsIEd1YXJkIE9mIFRyaW1lcmEOAAAAsgQAAAwAbV1+BXwHAV1+BHwHEAAAAPIFAAAOAGtU
fgp8BwFjAHSXDQADDgAAAPEHAAAMAG1Wfgd8BwFVfgd8BzcAAACACwAANQCqGgBUaGVsb3N0YXJ0b2
ZrZWVwaW5nYXNlY3JldAFUfgp8BwIAaGlrVX4HfAcBYwARAABAAgkAAADBDAAABwBsXX4EfAcBMgAA
AHQPAAAwAKoRAEJhbWJpIEJvbmVjcnVzaGVyAVV+B3wHFABMT05HIExJVkUgVEhFIFFVRUVOIWAAAA
C0EAAAXgCqDQBMZWFkZXIga25pZ2h0A1F+J3wHRgBCVVkgMkggU1dPUkQgUEFZIFdISVQgRkYsIEhN
TSBBTkQgU09NRSBNT05FWSEhISEhISFNU0cgTUUgRkFTVDxDQVJMSU4+LAAAAD4VAAAqAG4AiwUIAG
JhY2twYWNrFAAKfQcDkgaSBsYFOwYBBiofB2QfBzbtBZsFAQ8AAAA+HAAADQBqXH4EfAdjAGcAAEAD
DgAAAC8kAAAMAG1cfgR8BwFbfgR8Bw4AAAAqLAAADABtW34EfAcBW34FfAc2AAAAXTMAADQAqgYARm
FsdWdlA05+JHwGIwBJIFNFTEwgQ1JPVyBTSElFTEQgQU5EIEtOSUdIVCBBWEUhIQ4AAACnNAAADABt
W34FfAcBW34GfAcOAAAAAjwAAAwAbVt+BnwHAVt+B3wHVgAAADVDAABUAKoaAFRoZWxvc3RhcnRvZm
tlZXBpbmdhc2VjcmV0AVR+CnwHHwB3ZWxjb21lIHRvIG15IHN0dXBpZCBub29iIHZpZGVvogKDVH4K
fAcOg1V+B3wHBA4AAABhRAAADABtW34HfAcBW34GfAcoAAAAPEcAACYAqhEAQmFtYmkgQm9uZWNydX
NoZXIBVX4HfAcKAFRha2UgdGhpcyFcAAAANkgAAFoAooKgHgEnAbgA700BABNTAMgACox0lw0AYINU
fgp8Bw+EVH4KfAfGAQA5tBQVAFlvdSBsb3NlIDkgaGl0cG9pbnRzLqAeAScBuADvTQEAE1MAyAAKjH
SXDQBgDgAAANpLAAAMAG1bfgZ8BwFcfgZ8B1oAAAD1TwAAWACgFQEnAbgA700BABNTAMgACox0lw0A
XYNUfgp8Bw+EVH4KfAfGAQA5tBQVAFlvdSBsb3NlIDkgaGl0cG9pbnRzLqAVAScBuADvTQEAE1MAyA
AKjHSXDQBdcwAAAEBRAABxAG1Ufgp8BwFTfgp8B2hmAN8DAP9mANEHAP9mAAD/ZgAA/2YAAP/QAgD/
swIA/9ECjAQA/2YAAP9mAAD/ZgAA/2YAAP9mAAD/ZgDfAwz/3wMA/5YBFQUL/14DAP9dAwD/XQNG/2
tVfgd8BwFjABEAAEAClQAAAE5SAACTAG1Tfgp8BwFSfgp8B2hmAOEDAP9mAN4DAP9mAN4DAP9mAN4D
AP9mAN4DAP/QAt4DAP+zAu8DAP/RAt4DAP9mAN4DAP9mAN4DAP9mAN4DAP9mAOIDAP9mAAD/ZgDfAw
z/3wMA/5YBiwWXBYsFiwWLBYsFiwWLBYsFC/9eAwD/XQMA/10DRv9rVX4HfAcBYwARAABAAw8AAADL
UwAADQBqW34GfAdjAGcAAEABswAAAB9VAACxAG1Sfgp8BwFRfgp8B2hmAN8DAP9mAAD/ZgAA/2YAAP
9mAAD/0AIA/7MCAP/RAgD/ZgAA/2YAAP9mAAD/ZgDfAwD/ZgAA/2YA5wMA/5UBwgQA/5UBwgQA/5UB
wgQA/5UBwgQA/5UBwgQA/5UBwgQA/5UBwgQA/5UBwgQA/5UBwgQA/5UBwgQA/5UBxgQB/+cDAP+VAd
4DC/9eAwD/XQMA/10DRv9rVX4HfAcBYwARAABAA6UAAAA4VgAAowBtUX4KfAcBUH4KfAdoZgDfAwD/
ZgC/BwD/ZgAA/2YA0gcA/2YAAP/QAgD/swIA/9ECAP9mAAD/ZgC8BwD/ZgAA/2YA3wMA/2YAAP9mAN
8DAP+VAQD/lQEA/5UBAP+VAQD/lQEA/5UBAP+VAQD/lQEA/5UBAP+VAQD/lQHABAH/3wMA/5UBaQQL
/14DAP9dAwD/XQNG/2tVfgd8BwFjABEAAEADWgAAAPBXAABYAKAMAScBuADvTQEAE1MAyAAKjHSXDQ
Bag1B+CnwHD4RQfgp8B8YBADm0FBUAWW91IGxvc2UgOSBoaXRwb2ludHMuoAwBJwG4AO9NAQATUwDI
AAqMdJcNAFp5AAAACVkAAHcAbVB+CnwHAU9+CnwHaGYA3wMA/2YAAP9mAJ8HAP9mAAD/ZgBZBAD/0A
JbBAD/swIA/9ECAP9mAAD/ZgCfBwD/ZgAA/2YA3wMA/2YAAP9mAN8DAP+VAQj/lQEA/5UBwAQB/+cD
AP+WAd4DC/9eAwD/oAEA/10DRv+KAAAA+VkAAIgAbU9+CnwHAU5+CnwHaGYA3wMA/2YAAP9mAAD/Zg
AA/2YAWAQA/9ACWgQA/7MCAP/RAgD/ZgAA/2YAAP9mAAD/ZgDfAwD/ZgAA/2YA3wO8BQD/lQEI/5UB
AP+VAcAEAf/fAwD/lgGbBhAGEgebBQKEBwmlBivcBdwFPAUL/14DAP9dAwD/XQNG/zAAAAD9WgAALg
CqEQBCYW1iaSBCb25lY3J1c2hlcgFVfgd8BwYASHJtcGYhbVV+B3wHAVZ+B3wHfgAAACpcAAB8AG1O
fgp8BwFNfgp8B2hmAN8DAP9mANIHAP9mAAD/ZgC8BwD/ZgAA/9ACAP+zAgD/0QIA/2YAAP9mAL8HAP
9mAAD/ZgDfAwD/ZgAA/2YA3wMA/5UBCP+VAQD/lQHABAH/3wMA/5YB2AaEBwqLBYoFC/9eAwD/XQMA
/10DRv9+AAAAal0AAHwAbU1+CnwHAUx+CnwHaGYA4QMA/2YAAP9mAAD/ZgAA/2YAAP/QAgD/swIA/9
ECAP9mANIHAP9mAAD/ZgAA/2YA3wMA/2YAAP9mAN8DAP+VAQj/lQEA/5UBwAQB/98DAP+WAf0FAQgH
qgaEBwqDBwEL/14DAP9dAwD/XQNG/4kAAAAFXwAAhwBtTH4KfAcBS34KfAdoZgDfAwD/lgHeAwD/lg
HeAwD/lgHeAwD/lgHeAwD/lgHeA7oFAP+WAe8DAP+WAd4DugUA/5YB3gMA/5YB3gMA/5YB3gMA/5YB
5gMA/2YAAP9mAN8DAP+VAQj/lQEA/5UBwAQB/98DAP+WARUFC/9eAwD/XQMA/10DRv9aAAAAbWAAAF
gAoAMBJwG4AO9NAQATUwDIAAqMdJcNAFeDS34KfAcPhEt+CnwHxgEAObQUFQBZb3UgbG9zZSA5IGhp
dHBvaW50cy6gAwEnAbgA700BABNTAMgACox0lw0AV7QAAACkYQAAsgBtS34KfAcBSn4KfAdoZgDfAw
D/lgGdBAD/lgEA/5YBAP+WAQD/lgEA/5YBAP+WAQD/lgEA/5YBAP+WAZ0EAP+WAd8DAP9mAAD/ZgDf
AwD/lgHeAwD/lgHeAwD/lgHeAwD/lgHkAwD/lgHeAwD/lgHeAwD/lgHeAwD/lgHeAwD/lgHeAwD/lg
HeAwD/lgHiAwH/3wMA/5YBEgfqBgEGDhYGlAUVBQv/XgMA/10DAP9dA0b/DwEAAMZiAAANAW1Kfgp8
BwJJfgp8B2hmAN8DTwUA/5YBAP+WAQD/lgEA/5YBAP+WAQD/lgEA/5YBAP+WAQD/lgEA/5YBAP+WAd
8DAP9mAAD/ZgDgAwD/lgEBBQD/lgHmBAD/lgH/BAD/lgHfAwD/lgEPBQD/lgEBBQD/lgHmBAD/lgEA
/5YBAQUA/5YBzQXmBAD/lgHfAwH/3wMA/5YBmAXcBRYGFgYVBQD/lgHeAwD/lgHeAwD/lgHiAwD/lg
HeAwD/lgHeAwD/lgHeAwD/lgHeAwD/lgHeAwD/lgHeAwD/lgHiAwH/XgMA/10DAP9dAwD/ZQMA/2UD
AP9lAwD/ZQMA/2UDAP9lAwD/ZQMA/2UDAP9lAz3/PAEAAGFkAAA6AW1Jfgp8BwFIfgp8B2hmAN8DAP
+WAQD/lgEA/5YBAP+WAWEAAAAAAFoAAEAHAEJhcmJhcmFkAYtONEBzANdkAAAA/5YBRQUA/5YBSAUA
/5YBYQAAAAAAzAAAQAcARmVuYmFsYWQBi000QHMA12QAAEsFAP+WAQD/lgEA/5YBAP+WAd8DAP9mAA
D/ZgAA/5YBFgUA/5YBAP+WAQD/lgHfAwD/lgEOBQD/lgEA/5YBAP+WAQD/lgEBBQD/lgHmBAD/lgHf
AwH/4AMA/94DAP+WAecENgcA/5YB5wSjBQAA/5YB3wMA/5YBnQQA/5YBAP+WAeMFAP+WAeEFAP+WAQ
D/lgGdBAD/lgHhAwH/XgMA/10DAP9dAwD/ZAMA/2QDAP9kAwD/ZAMA/2QDAP9kAwD/ZAMA/2QDAP9k
Az3/5wAAAOdlAADlAG1Ifgp8BwFHfgp8B2hmAN8DAP+WAeEFAP+WAQD/lgEA/5YBAP+WAUQFAP+WAU
cFAP+WAUoFAP+WAQD/lgEA/5YBAP+WAd8DAP9mAAD/4AAA/5YBAP+WAQD/lgEA/5YB3wMA/5YBDQUA
/5YBAP+WAQD/lgEA/5YBAP+WAQD/lgHfAwP/lgEwBQAA/5YBrAUAAP+WAd8DAP+WAQD/lgEA/5YBAP
+WAQD/lgEA/5YBAP+WAeEDAf9gAwD/XwMA/18DAP9kAwD/ZAMA/2QDAP9kAwD/ZAMA/2QDAP9kAwD/
ZAMA/2QDPf9cAAAAvmcAAFoAooCg+gAnAbgA700BABNTAMgACox0lw0AVINHfgp8Bw+ER34KfAfGAQ
A5tBQVAFlvdSBsb3NlIDkgaGl0cG9pbnRzLqD6ACcBuADvTQEAE1MAyAAKjHSXDQBU5wAAABNpAADl
AG1Hfgp8BwFGfgp8B2hmAN8DAP+WAeIDAP+WAWgEAP+WAQD/lgEA/5YBRAUA/5YBRwUA/5YBSgUA/5
YBAP+WAQD/lgEA/5YB3wMA/2YAAP/bANEHAP+WAQD/lgEA/5YBAP+WAfADAP+WAQD/lgEA/5YBDAUA
/5YBDAUA/5YBDAUA/5YBDAUA/5YB3wMD/5YBAP+WAQD/lgHyAwD/lgEA/5YBAQUA/5YB2gQA/5YB3Q
QA/5YB/wQA/5YBAP+WAeEDBP9kAwD/ZAMA/2QDAP9kAwD/ZAMA/2QDAP9kAwD/ZAMA/2QDPf/zAAAA
F2oAAPEAbUZ+CnwHAUV+CnwHaGYA3wMA/5YB3gMA/5YBAP+WAQD/lgEA/5YBRAUA/5YBRwUA/5YBSg
UA/5YBAP+WAQD/lgEA/5YB3wMA/2YAAP/bAAD/lgEA/6YBAP+WAQD/lgHhAwD/lgHeAwD/lgHeAwD/
lgHeAwD/lgHeA7oFAP+WAd4DAP+WAd4DAP+WAeYDA/+WAQD/lgEvBQD/lgHfAwD/lgEA/5YBAQUA/5
YB2QQA/5YB3AQA/5YB/wQA/5YBAP+WAeEDBP+WAd4DAP+WAeIDAP9mAwD/ZgMA/2YDAP9mAwD/ZgMA
/2YDAP9mAwX/ZQM3/xMBAAAgbAAAEQFtRX4KfAcBRH4KfAdoZgDfAwD/lgHhBQD/lgEA/5YBYQAAAA
AAlAAAQAwAUXVlZW4gRWxvaXNlZACKYF5PcwDXZAAAAP+WAQD/lgFEBQD/lgFHBQD/lgFKBQD/lgEA
/5YBAP+WAQD/lgHfAwD/ZgAA/9sAAP+WAQD/lgEA/5YBAP+WAd8DAP+WATsFAP+WAQD/lgEA/5YBAP
+WAQD/lgHjBQD/lgHfAwP/lgHeAwD/lgHeAwD/lgHiA08FAP+WAQD/lgEBBQD/lgHZBAD/lgHcBM0F
AP+WAf8EAP+WAQD/lgHhAwT/lgHiBQD/lgHfAwD/YwMA/2MDAP9jAwD/YwMA/2MDAP9jAwD/YwMF/2
QDN/8VAQAApm0AABMBbUR+CnwHAUN+CnwHaGYA3wNPBQD/lgEA/5YBAP+WAQD/lgEA/5YBQwUA/5YB
RgUA/5YBSQUA/5YBAP+WAQD/lgEA/5YB3wMA/2YAAP/bAAD/lgEA/5YBAP+WAQD/lgHfAwD/lgGjBQ
DmBAD/lgEA/5YBYQAAAAAAbgAAQBEAQnVubnkgQm9uZWNydXNoZXJkAItgA09zANdcAAAA/5YBAP+W
AQEFAP+WAeYEAP+WAd8DA/+WAWgEAP+WAQD/lgHfAwD/lgEA/5YBAQUA/5YB2QQA/5YB3AQA/5YB/w
QA/5YBAP+WAeEDBP+WAQD/lgHfAwD/YwMA/2MDAP9jAwD/YwMA/2MDAP9jAwD/YwMF/2QDN//xAAAA
fW8AAO8AbUN+CnwHAkJ+CnwHaGYA3wMA/5YBnQQA/5YBAP+WAQD/lgEA/5YB4wUA/5YB/QQA/5YB4w
UA/5YBAP+WAQD/lgGdBAD/lgHfAwD/ZgDRBwD/2wAA/5YBAP+WAQD/lgEA/5YB8AMA/5YBAP+WAQD/
lgEA/5YBAP+WAQD/lgEA/5YB3wMD/5YBAP+WAQD/lgHyAwD/lgEA/5YBAQUA/5YB2QQA/5YB3AQA/5
YB/wQA/5YBAP+WAeEDBP+WAQD/lgHfAwD/YwMA/2MDAP9jAwD/YwMA/2MDAP9jAwD/YwMF/2QDDf+W
AdEDAP+WAdUDKP8aAAAAbXAAABgAbTx+C3wGATt+C3wGbTx+B3wHATx+CHwHHQEAALhxAAAbAW1Cfg
p8BwFBfgp8B2hmAOADAP9mAN4DAP9mAN4DAP9mAN4DAP9mAN4DUAUA/2YA3gO6BQD/ZgDeAwD/ZgDe
A7oFAP9mAN4DUAUA/2YA3gMA/2YA4gMA/2YA4wMA/2YAAP/bAAD/lgHkAwD/lgFoBAD/lgEA/5YB3w
MA/5YB4gUA/5YBAP+WAQwFAP+WARUFAP+WARsFAP+WARwFAP+WAd8DA/+WAQD/lgEA/5YB3wMA/5YB
AP+WAQEFAP+WAdgEAP+WAdsEAP+WAf8EAP+WAQD/lgHhAwT/lgEA/5YB3wMA/2MDAP9jAwD/YwMA/2
MDAP9jAwD/YwMA/2MDBf+WAeIDDf+WAcMF5gQA/5YB0gMM/2oAuAS6BKsBG/8TAQAA7XQAABEBbUF+
CnwHAUB+CnwHaGYA3gMA/2YA3gMA/2YA3gMA/2YA3gMA/2YA3gMA/2YA3gMA/2YA3gMA/2YA3gMA/2
YA3gMA/2YA4gMA/+AA3wMA/94AAP/eAAD/5AC9BwD/lQHeAwD/lQHeAwD/lQHeAwD/lQHeAwD/lQHe
AwD/lQHeAwD/lQHeAwD/lQHeA7oFAP+VAd4DAP+VAd4DAP/jAwP/pgEA/5YBAP+WAd8DAP+WAQD/lg
EA/5YBAAUA/5YBAAUA/5YBAP+WAQD/lgHhAwT/lgEA/5YB3wMA/2MDAP9jAwD/YwMA/2MDAP9jAwD/
YwMA/2MDBf+WAd8DDf+WAeMF5gQA/5YBAwQM/2oAuASnARv/GgAAANx3AAAYAG08fgh8BwE8fgd8B2
07fgt8BgE7fgp8BhoAAADDfwAAGABtPH4HfAcBPX4HfAdtO34KfAYBO34LfAYaAAAA0ocAABgAbT1+
B3wHATx+B3wHbTt+C3wGATt+DHwGGgAAALmPAAAYAG08fgd8BwE9fgd8B207fgx8BgE7fgt8BlwAAA
DFlAAAWgCqGgBUaGVsb3N0YXJ0b2ZrZWVwaW5nYXNlY3JldAFAfgp8BwsASGVsbG8gUXVlZW5rPX4H
fAcBYwCUAABAAWtAfgt8BwFjAMwAAEAAa0B+CHwHAWMAWgAAQAIOAAAAqpcAAAwAbTt+C3wGATt+DH
wGmQEAANaYAAAXAW1Afgp8BwE/fgp8B2hmAN4DAP9mAN4DAP9mAN4DAP9mAN4DAP9mAN4DAP9mAN4D
AP9mAN4DAP9mAN4DAP9mAOIDAP9mAN8DAP/bAN8DAP9qAAD/agAA/+4CAP+VAQD/lQEA/5UBAP+VAQ
D/lQEA/5UBAP+VAQD/lQEA/5UBAP+VAQT/3gMA/94DAP/jAwD/3gMA/94DugUA/94DAP/eAwD/3gO6
BQD/3gMA/94DBP+WAQD/lgHfAwD/YwMA/2MDAP9jAwD/YwMA/2MDAP9jAwD/YwMF/5YB3wMN/5YBAP
+WAdIDDP9qALgEpwEb/2s9fgd8BwFjAJQAAEACa0B+C3wHAWMAzAAAQANrQH4IfAcBYwBaAABAAn4A
qgwAUXVlZW4gRWxvaXNlAT1+B3wHHwBJIGdyZWV0IHRoZWUsIG15IGxveWFsIHN1YmplY3QuqgcAQm
FyYmFyYQFAfgh8BxIASEFJTCBUTyBUSEUgUVVFRU4hqgcARmVuYmFsYQFAfgt8BxIASEFJTCBUTyBU
SEUgUVVFRU4hDgAAAJufAAAMAG07fgx8BgE8fgx8BnUAAAA4pAAAcwCqGgBUaGVsb3N0YXJ0b2ZrZW
VwaW5nYXNlY3JldAE/fgp8BwQAZnVja6ABACcBuADvTQEAE1MAyAAKjHSXDQABg0B+C3wHB4M/fgp8
BwSgAQAnAbgA700BABNTAMgACox0lw0AAYNAfgh8BweDP34KfAcEDgAAAHinAAAMAG08fgx8BgE7fg
x8BjoAAACGqAAAOACqBwBGZW5iYWxhAUB+C3wHCgBUYWtlIHRoaXMhqgcAQmFyYmFyYQFAfgh8BwoA
VGFrZSB0aGlzIQ4AAACGrwAADABtO34MfAYBO34NfAZgAAAAZrMAAF4AoAEAJwG4AO9NAQATAwDIAA
qgGAEnAbgA700BABMDAMgACox0lw0AXoM/fgp8BwyqGgBUaGVsb3N0YXJ0b2ZrZWVwaW5nYXNlY3Jl
dAE/fgp8BwoAZXh1cmEgdml0YQ4AAABttwAADABtO34NfAYBO34MfAYOAAAAmr8AAAwAbTt+DHwGAT
t+DXwGKgAAAPnAAAAoAKoaAFRoZWxvc3RhcnRvZmtlZXBpbmdhc2VjcmV0AT9+CnwHAwBsb2wOAAAA
MccAAAwAbTt+DXwGATt+DHwG
