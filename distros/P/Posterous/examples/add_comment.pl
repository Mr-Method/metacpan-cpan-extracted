#!/usr/bin/env perl

use 5.010;
use lib qw(lib);

use Posterous;
use Data::Dumper;
use YAML qw(LoadFile);

$config = LoadFile("$ENV{HOME}/.posterous");

$posterous = Posterous->new($config->{core}->{user}, $config->{core}->{pass});

say Dumper $posterous->add_comment(post_id => 2441422, comment => "posterous add_comment() example");
