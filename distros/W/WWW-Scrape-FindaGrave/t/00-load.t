#!perl -T

use strict;

use Test::Most tests => 2;

BEGIN {
	if(-e 't/online.enabled') {
		use_ok('WWW::Scrape::FindaGrave') || print 'Bail out!';
	} else {
		SKIP: {
			diag 'You must be on-line to test WWW::Scrape::FindaGrave';
			skip 'You must be on-line to test WWW::Scrape::FindaGrave', 1;
			print 'Bail out!';
		}
	}
}

require_ok('WWW::Scrape::FindaGrave') || print 'Bail out!';

diag( "Testing WWW::Scrape::FindaGrave $WWW::Scrape::FindaGrave::VERSION, Perl $], $^X" );
