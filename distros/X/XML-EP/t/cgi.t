# -*- perl -*-

my $numTests = 5;

use strict;
use XML::EP ();
use XML::EP::Request::CGI ();
use XML::EP::Test (qw(Test));
use Data::Dumper ();
use File::Spec ();
use IO::Scalar ();

$^W = $| = 1;


sub MakeFile {
    my $file = shift;  my $xml = shift;
    (open(FILE, ">$file") and (print FILE $xml) and close(FILE))
}

print "1..$numTests\n";
my $file = File::Spec->catdir(File::Spec->tmpdir(), "cgi.t.xml");
$ENV{PATH_TRANSLATED} = $file;


my $ep = XML::EP->new();
Test($ep);

my $request = XML::EP::Request::CGI->new();
Test($request);

my $xml = <<'XML';
<?xml version="1.0" ?>
<html><head><title>Ok</title></head>
<body bgcolor="#ffffff"><h1>Yes, it works!</h1>
<p/>This is a paragraph.</body></html>
XML
Test(MakeFile($file, $xml)) or print STDERR "Failed to create $file: $!\n";

my $output;
tie *OUTPUT, 'IO::Scalar', \$output;
$request->FileHandle(\*OUTPUT);
my $result = $ep->Handle($request);
Test(!$result) ||
    print Data::Dumper->new([$result])->Indent(1)->Terse(1)->Dump(), "\n";
{
  Test($output eq <<'XML') or print "$output\n";
content-type: text/html

<html><head><title>Ok</title></head>
<body bgcolor="#ffffff"><h1>Yes, it works!</h1>
<p></p>This is a paragraph.</body></html>
XML
}
