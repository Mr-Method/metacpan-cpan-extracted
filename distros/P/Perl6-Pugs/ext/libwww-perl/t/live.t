use v6-alpha;
use Test;

my $tempfile = 'temp-ex-output';

# Change the URLs to something better/different
my @urls = <
    %s/
    %s
    %s/index.html
>;

my @live_urls;
if (%*ENV{"PUGS_TESTS_ALLOW_NETWORK"}) {
# Need to get some easily validated stuff here
  @live_urls = <
    http://www.corion.net
    http://datenzoo.de
    http://datenzoo.de/
    http://datenzoo.de/index.html
  >;
};
plan 2+@urls*10+@live_urls*8;

use LWP::Simple; pass "(dummy instead of broken use_ok)";

my $expected = "Hello from Pugs";

# Spawn a local proxy server
sub spawn_server (Int $port) {
  my $port = $port || 8086;

  diag "Spawning proxy on port $port";
  my $sock = listen($port);

  my $url = "http://localhost:$port";
  ok(defined $sock, "Listening on $url");

  async {
    #diag "Spawned server";

    while (1) {
      my $hdl = $sock.accept;

      my $request = =$hdl;
      $request ~~ s:P5/\s+$//;
      #diag $request;
      if ($request ~~ rx:P5"^GET /stop-server/") {
            $hdl.close;
            last();
      };

      while (readline($hdl) ~~ rx:P5/\S/) { 1 };
      $hdl.print( "HTTP/1.0 200 OK\r\n"
                ~ "Content-Type: text/plain; charset=UTF-8\r\n"
                ~ "Server: Fake local Pugs HTTPd\r\n"
                ~ "X-Original-Request: $request\r\n"
                ~ "\r\n"
                ~ $expected );
      $hdl.flush();
      $hdl.close;
    };

  };

  $url;
};

my $base_url = spawn_server( 8086 );

for @urls -> $t_url {
  my $url = $t_url;
  $url ~~ s:P5/%s/$base_url/;

  diag "Getting HEAD of $url";
  my $head = head($url);
  ok($head ~~ m:P5/.../, "Got some headers as scalar");
  my @head = head($url);
  ok(@head > 3, "Got more than 1 line as list");
  my %head = head($url);
  ok(%head.keys() > 3, "Got some headers as hash", );
  is(%head{'Content-Type'}, "text/plain; charset=UTF-8", "Got a content type of text/plain", );

  diag "Retrieving $url";
  my $res = get($url);
  ok(defined $res, "Got some result");
  ok($res.chars, "and it's not empty");

  is( chars($res), chars($expected), "The response has the correct length");
  # TODO: Add a check against Content-Length, once it's implemented

  is( $res, $expected, "Got the correct response");

  diag "Storing $url to $tempfile";
  my $f = getstore($url,$tempfile);
  my $buf = slurp $tempfile;
  is( $buf, $res, "... and contains $url");
  is( $f, $res, "... and getstore() returns $url");
};

get("$base_url/stop-server/");

for @live_urls -> $url {
  diag "Getting HEAD of $url";
  my $head = head($url);
  ok( $head ~~ rx:P5/.../, "Got some headers as scalar");
  my @head = head($url);
  todo_ok( @head > 3, "Got more than 1 line as list");
  my %head = head($url);
  todo_ok( %head.keys() > 3, "Got some headers as hash");
  todo_is( %head{'Content-Type'}, "text/html", "Got a content type of text/html");

  diag "Retrieving $url";
  my $res = get($url);
  ok(defined $res, "Got some result");
  ok( defined ($res ~~ rx:P5/./), "and it's not empty");

  # TODO: Uncomment once length() is implemented
  # is( length($res), length($expected), "The response has the correct length");
  # TODO: Add a check against Content-Length, once it's implemented

  diag "Storing $url to $tempfile";
  my $f = getstore($url,$tempfile);
  my $buf = slurp $tempfile;
  is( $buf, $res, "... and contains $url");
  is( $f, $res, "... and getstore() returns $url");
};

unlink $tempfile;
