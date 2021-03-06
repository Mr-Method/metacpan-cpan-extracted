# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.042.
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Extensive, yet simple, logging role using Log::Dispatchouli",
  "AUTHOR" => "Sawyer X <xsawyerx\@cpan.org>, Michael G Schwern <schwern\@pobox.com>",
  "BUILD_REQUIRES" => {
    "Module::Build" => "0.28"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "Module::Build" => "0.28"
  },
  "DISTNAME" => "MouseX-Role-Loggable",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.006",
  "NAME" => "MouseX::Role::Loggable",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Log::Dispatchouli" => 0,
    "Mouse" => "1.04",
    "Mouse::Role" => 0,
    "Mouse::Util::TypeConstraints" => 0,
    "MouseX::Types" => "0.06",
    "MouseX::Types::Mouse" => 0,
    "Safe::Isa" => 0,
    "namespace::autoclean" => "0.16",
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Mouse" => "1.04",
    "Test::Fatal" => 0,
    "Test::More" => 0,
    "blib" => "1.01"
  },
  "VERSION" => "0.113",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "File::Spec" => 0,
  "IO::Handle" => 0,
  "IPC::Open3" => 0,
  "Log::Dispatchouli" => 0,
  "Module::Build" => "0.28",
  "Mouse" => "1.04",
  "Mouse::Role" => 0,
  "Mouse::Util::TypeConstraints" => 0,
  "MouseX::Types" => "0.06",
  "MouseX::Types::Mouse" => 0,
  "Safe::Isa" => 0,
  "Test::Fatal" => 0,
  "Test::More" => 0,
  "blib" => "1.01",
  "namespace::autoclean" => "0.16",
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
