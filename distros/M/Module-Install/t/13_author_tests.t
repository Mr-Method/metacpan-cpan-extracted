use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More;
use File::Spec;
use lib 't/lib';
use MyTest;

plan tests => 15;

SCOPE: {
	ok( create_dist('Foo', { 'Makefile.PL' => <<"END_DSL" }), 'create_dist' );
use inc::Module::Install 0.81;
name          'Foo';
version       '0.01';
author        'Someone';
license       'perl';
perl_version  '5.005';
requires_from 'lib/Foo.pm';
WriteAll;
END_DSL

	ok( add_test(qw(xt test.t)), 'added xt' );
	ok( build_dist(), 'build_dist' );
	my $file = makefile();
	ok(-f $file);
	my $content = _read($file);
	ok($content, 'file is not empty');
	diag my ($testline) = $content =~ /^#\s*(test => .+)$/m if $ENV{TEST_VERBOSE};
	ok($content =~ /#\s*test => \{ TESTS=>.+xt\/\*\.t/, 'has xt/*.t');
	ok( kill_dist(), 'kill_dist' );
}

SCOPE: {
	ok( create_dist('Foo', { 'Makefile.PL' => <<"END_DSL" }), 'create_dist' );
use inc::Module::Install 0.81;
name          'Foo';
version       '0.01';
author        'Someone';
license       'perl';
perl_version  '5.005';
requires_from 'lib/Foo.pm';
WriteAll;
END_DSL

	ok( add_test(qw(xt test.t)), 'added xt' );
	ok( build_dist(), 'build_dist' );
	rmdir dir(qw(inc .author)); # non-author-mode
	unlink makefile();
	ok( run_makefile_pl(), 'build_dist again' );
	my $file = makefile();
	ok(-f $file);
	my $content = _read($file);
	ok($content, 'file is not empty');
	diag my ($testline) = $content =~ /^#\s*(test => .+)$/m if $ENV{TEST_VERBOSE};
	if ( $ENV{RELEASE_TESTING} ) {
		ok($content =~ /#\s*test => \{ TESTS=>.+xt\/\*\.t/, 'has xt/*.t');
	} else {
		ok($content !~ /#\s*test => \{ TESTS=>.+xt\/\*\.t/, 'has no xt/*.t');
	}
	ok( kill_dist(), 'kill_dist' );
}
