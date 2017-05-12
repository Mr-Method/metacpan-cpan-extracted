use strict;
use warnings FATAL => 'all';

use Apache::Test;
use Apache::TestUtil;
use Apache::TestRequest;

my $module = 'TestManip::in_modify';
my $location = "/" . Apache::TestRequest::module2path($module);

Apache::TestRequest::scheme('http'); #force http for t/TEST -ssl
Apache::TestRequest::module($module);

my $config = Apache::Test::config();
my $hostport = Apache::TestRequest::hostport($config);
t_debug("connecting to $hostport");

my $keep_alive_times     = 3;
my $non_keep_alive_times = 3;
my $times = $non_keep_alive_times + $keep_alive_times + 1;

plan tests => 6 * $times;

## try non-keepalive conn
Apache::TestRequest::user_agent(reset => 1, keep_alive => 0);
validate() for 1..$non_keep_alive_times;

# try keepalive conns
Apache::TestRequest::user_agent(reset => 1, keep_alive => 1);
validate() for 1..$keep_alive_times;

## try non-keepalive conn
Apache::TestRequest::user_agent(reset => 1, keep_alive => 0);
validate();

# 6 sub-tests
sub validate {

    my $key = "Sign-Here";
    my $val = "DigSig";

    {
        my $res = HEAD $location, $key  => "";

        ok t_cmp("", $res->content, "there should be no response body / HEAD ");

        ok t_cmp($val, $res->header($key)||'', "modified header / HEAD ");
    }

    {
        my $res = GET $location, $key  => "";

        ok t_cmp("", $res->content, "there should be no content / GET");

        ok t_cmp($val, $res->header($key)||'', "modified header / GET ");
    }

    {
        my $content = "Top Input Security";
        my $res = POST $location,
            content  => $content,
                $key  => "";

        ok t_cmp($content, $res->content, "the content came through");

        ok t_cmp($val, $res->header($key)||'', "modified header / POST ");
    }
}
