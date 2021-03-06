# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.009.
use strict;
use warnings;

use 5.008000;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "generate a test database for App::CPANIDX",
  "AUTHOR" => "Chris Williams <chris\@bingosnet.co.uk>",
  "BUILD_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.42",
    "File::Temp" => "0.22",
    "Test::More" => "0.47"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.42"
  },
  "DISTNAME" => "Test-App-CPANIDX-Database",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.008000",
  "NAME" => "Test::App::CPANIDX::Database",
  "PREREQ_PM" => {
    "App::CPANIDX::Tables" => "0.18",
    "DBD::SQLite" => "1.29",
    "DBI" => "1.609"
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::More" => "0.47"
  },
  "VERSION" => "0.06",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "App::CPANIDX::Tables" => "0.18",
  "DBD::SQLite" => "1.29",
  "DBI" => "1.609",
  "ExtUtils::MakeMaker" => "6.42",
  "File::Spec" => 0,
  "File::Temp" => "0.22",
  "IO::Handle" => 0,
  "IPC::Open3" => 0,
  "Test::More" => "0.47"
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
