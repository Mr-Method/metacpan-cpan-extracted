# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.012.
use strict;
use warnings;



use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "A Perl SDK for Auth0",
  "AUTHOR" => "John Napiorkowski <jjnapiork\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "WebService-Auth0",
  "LICENSE" => "perl",
  "NAME" => "WebService::Auth0",
  "PREREQ_PM" => {
    "Future" => "0.34",
    "JSON::MaybeXS" => "1.003005",
    "LWP" => "6.15",
    "Module::Runtime" => "0.014",
    "Moo" => "2.000001",
    "Params::Validate" => "1.26",
    "URI" => "1.71"
  },
  "TEST_REQUIRES" => {
    "IO::Socket::SSL" => "1.56",
    "Net::SSLeay" => "1.49",
    "Test::Most" => "0.34"
  },
  "VERSION" => "0.002",
  "test" => {
    "TESTS" => "t/*.t t/authentication/*.t t/management/*.t"
  }
);


my %FallbackPrereqs = (
  "Future" => "0.34",
  "IO::Socket::SSL" => "1.56",
  "JSON::MaybeXS" => "1.003005",
  "LWP" => "6.15",
  "Module::Runtime" => "0.014",
  "Moo" => "2.000001",
  "Net::SSLeay" => "1.49",
  "Params::Validate" => "1.26",
  "Test::Most" => "0.34",
  "URI" => "1.71"
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
