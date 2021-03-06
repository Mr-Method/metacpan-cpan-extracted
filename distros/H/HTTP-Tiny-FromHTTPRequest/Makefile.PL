# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.010.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Perform a request based on a plain HTTP request or HTTP::Request object",
  "AUTHOR" => "Renee Baecker <reneeb\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "HTTP-Tiny-FromHTTPRequest",
  "LICENSE" => "artistic_2",
  "MIN_PERL_VERSION" => "5.010001",
  "NAME" => "HTTP::Tiny::FromHTTPRequest",
  "PREREQ_PM" => {
    "Carp" => 0,
    "HTTP::Request" => "6.07",
    "HTTP::Tiny" => 0,
    "Scalar::Util" => 0
  },
  "TEST_REQUIRES" => {
    "Path::Tiny" => "0.058",
    "Pod::Coverage::TrustPod" => 0
  },
  "VERSION" => "0.02",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "HTTP::Request" => "6.07",
  "HTTP::Tiny" => 0,
  "Path::Tiny" => "0.058",
  "Pod::Coverage::TrustPod" => 0,
  "Scalar::Util" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
