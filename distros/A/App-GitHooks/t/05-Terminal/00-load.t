#!/usr/bin/env perl

use strict;
use warnings;

use Test::FailWarnings -allow_deps => 1;
use Test::More tests => 1;

BEGIN
{
    use_ok( 'App::GitHooks::Terminal' );
}

diag( "Testing App::GitHooks::Terminal $App::GitHooks::Terminal::VERSION, Perl $], $^X" );
