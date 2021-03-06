#!/usr/bin/perl

use Dancer2;
use lib '../lib';
use Dancer2::Plugin::HTTP::Auth::Extensible;

get '/' => sub {
    my $content = "<h1>Non-secret home page!</h1>";
    if (my $user = http_authenticated_user()) {
        $content .= "<p>Hi there, $user->{name}!</p>";
    } else {
        $content .= "<p>Why not <a href=\"/login\">log in</a>?</p>";
    }

    $content .= <<LINKS;
<p><a href="/secret">Psst, wanna know a secret?</a></p>
<p><a href="/beer">Or maybe you want a beer</a></p>
<p><a href="/vodka">Or, a vodka?</a></p>
LINKS

    if (user_has_role('BeerDrinker')) {
        $content .= "<p>You can drink beer</p>";
    }
    if (user_has_role('WineDrinker')) {
        $content .= "<p>You can drink wine</p>";
    }

    return $content;
};

get '/secret' => http_require_authentication sub { "Only logged-in users can see this" };

get '/beer' => http_require_any_role [qw(BeerDrinker HardDrinker)], sub {
    "Any drinker can get beer.";
};

get '/vodka' => http_require_role HardDrinker => sub {
    "Only hard drinkers get vodka";
};

get '/realm' => http_require_authentication sub {
    "You are logged in using realm: " . http_realm
};
dance();
