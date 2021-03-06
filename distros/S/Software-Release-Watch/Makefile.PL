# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.009.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Watch latest software releases",
  "AUTHOR" => "perlancar <perlancar\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Software-Release-Watch",
  "EXE_FILES" => [
    "script/list-software-releases",
    "script/list-watchable-software"
  ],
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.010001",
  "NAME" => "Software::Release::Watch",
  "PREREQ_PM" => {
    "Data::Sah::Compiler::perl::TH::array" => 0,
    "Data::Sah::Compiler::perl::TH::bool" => 0,
    "Data::Sah::Compiler::perl::TH::int" => 0,
    "Data::Sah::Compiler::perl::TH::str" => 0,
    "Exporter" => 0,
    "Log::ger" => "0.011",
    "Module::List" => 0,
    "Moo" => 0,
    "Moo::Role" => 0,
    "Perinci::CmdLine::Any" => 0,
    "Perinci::CmdLine::Base" => "1.75",
    "Perinci::Sub::Gen::AccessTable" => "0.55",
    "Perinci::Sub::Property::result::table" => 0,
    "SemVer" => "0.3.0",
    "Software::Catalog" => "0.03",
    "WWW::Mechanize" => 0,
    "experimental" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.05",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Data::Sah::Compiler::perl::TH::array" => 0,
  "Data::Sah::Compiler::perl::TH::bool" => 0,
  "Data::Sah::Compiler::perl::TH::int" => 0,
  "Data::Sah::Compiler::perl::TH::str" => 0,
  "Exporter" => 0,
  "File::Spec" => 0,
  "IO::Handle" => 0,
  "IPC::Open3" => 0,
  "Log::ger" => "0.011",
  "Module::List" => 0,
  "Moo" => 0,
  "Moo::Role" => 0,
  "Perinci::CmdLine::Any" => 0,
  "Perinci::CmdLine::Base" => "1.75",
  "Perinci::Sub::Gen::AccessTable" => "0.55",
  "Perinci::Sub::Property::result::table" => 0,
  "SemVer" => "0.3.0",
  "Software::Catalog" => "0.03",
  "Test::More" => 0,
  "WWW::Mechanize" => 0,
  "experimental" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
