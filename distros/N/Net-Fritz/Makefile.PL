# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.008.
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "AVM Fritz!Box interaction via TR-064",
  "AUTHOR" => "Christian Garbs <mitch\@cgarbs.de>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Net-Fritz",
  "LICENSE" => "gpl",
  "MIN_PERL_VERSION" => "5.006",
  "NAME" => "Net::Fritz",
  "PREREQ_PM" => {
    "AppConfig" => 0,
    "Digest::MD5" => 0,
    "File::Spec" => 0,
    "LWP::UserAgent" => "6.00",
    "Moo" => 0,
    "Moo::Role" => 0,
    "SOAP::Lite" => 0,
    "Scalar::Util" => 0,
    "XML::Parser" => 0,
    "XML::Simple" => 0,
    "constant" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "App::PodLinkCheck" => 0,
    "Capture::Tiny" => 0,
    "File::Basename" => 0,
    "File::Path" => 0,
    "HTTP::Response" => 0,
    "Test::DescribeMe" => 0,
    "Test::Exception" => 0,
    "Test::Mock::LWP::Dispatch" => 0,
    "Test::Mock::Simple" => 0,
    "Test::More" => 0,
    "Test::TempDir::Tiny" => 0
  },
  "VERSION" => "v0.0.9",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "App::PodLinkCheck" => 0,
  "AppConfig" => 0,
  "Capture::Tiny" => 0,
  "Digest::MD5" => 0,
  "File::Basename" => 0,
  "File::Path" => 0,
  "File::Spec" => 0,
  "HTTP::Response" => 0,
  "LWP::UserAgent" => "6.00",
  "Moo" => 0,
  "Moo::Role" => 0,
  "SOAP::Lite" => 0,
  "Scalar::Util" => 0,
  "Test::DescribeMe" => 0,
  "Test::Exception" => 0,
  "Test::Mock::LWP::Dispatch" => 0,
  "Test::Mock::Simple" => 0,
  "Test::More" => 0,
  "Test::TempDir::Tiny" => 0,
  "XML::Parser" => 0,
  "XML::Simple" => 0,
  "constant" => 0,
  "strict" => 0,
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
