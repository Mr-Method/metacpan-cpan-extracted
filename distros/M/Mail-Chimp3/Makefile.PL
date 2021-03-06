# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.012.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "An interface to mailchimp.com's RESTful Web API v3 using WEB::API",
  "AUTHOR" => "Josh Lavin <digory\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Mail-Chimp3",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.010001",
  "NAME" => "Mail::Chimp3",
  "PREREQ_PM" => {
    "Moo" => 0,
    "Types::Standard" => 0,
    "Web::API" => 0,
    "namespace::autoclean" => "0.16",
    "strictures" => 2
  },
  "TEST_REQUIRES" => {
    "Digest::MD5" => 0,
    "JSON" => 0,
    "Test::More" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.08",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Digest::MD5" => 0,
  "JSON" => 0,
  "Moo" => 0,
  "Test::More" => 0,
  "Types::Standard" => 0,
  "Web::API" => 0,
  "namespace::autoclean" => "0.16",
  "strict" => 0,
  "strictures" => 2,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
