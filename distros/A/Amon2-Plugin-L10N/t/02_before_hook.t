use strict;
use warnings;
use Test::More;
use Plack::Request;
use Plack::Test;
use Test::WWW::Mechanize::PSGI;
use Plack::Builder;

{
    package MyApp;
    use parent qw/Amon2/;

    sub load_config { +{} }

    __PACKAGE__->load_plugins(
        'L10N' => {
            accept_langs          => [qw/ en ja th /],
            po_dir                => File::Spec->catfile(qw/ t po /),
            before_detection_hook => sub {
                my $c = shift;
                $c->req->param('lang');
            },
        },
    );

    package MyApp::Web;
    use parent -norequire, qw/MyApp/;
    use parent qw/Amon2::Web/;
    use Encode;
    use File::Spec;

    sub dispatch {
        my $c = shift;
        $c->create_response(200, [], [ encode( utf8 => $c->loc('Hello, %1', 'yappo') ) ]);
    }
}

my $app = MyApp::Web->to_app;

subtest 'ja' => sub {
    test_psgi(
        app    => $app,
        client => sub {
            my $cb = shift;
            my $res = $cb->(HTTP::Request->new(
                GET => 'http://localhost/?lang=ja',
                [ 'Accept-Language', 'en' ],
            ));
            is $res->content, 'yappo さん、こんにちは';
        }
    );
};

subtest 'th' => sub {
    test_psgi(
        app    => $app,
        client => sub {
            my $cb = shift;
            my $res = $cb->(HTTP::Request->new(
                GET => 'http://localhost/?lang=th',
                [ 'Accept-Language', 'ja' ],
            ));
            is $res->content, 'สวัสดีนาย yappo';
        }
    );
};

subtest 'default' => sub {
    test_psgi(
        app    => $app,
        client => sub {
            my $cb = shift;
            my $res = $cb->(HTTP::Request->new(
                GET => 'http://localhost/?lang=fr',
                [ 'Accept-Language', 'ja' ],
            ));
            is $res->content, 'Hello, yappo';
        }
    );
};

done_testing;
