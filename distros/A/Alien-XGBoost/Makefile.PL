# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.008.
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Alien package to find, and build if necessary XGBoost dynamic library",
  "AUTHOR" => "Pablo Rodr\x{ed}guez Gonz\x{e1}lez <pablo.rodriguez.gonzalez\@gmail.com>",
  "BUILD_REQUIRES" => {
    "Alien::Build" => "1.04",
    "Alien::Build::MM" => "0.32",
    "ExtUtils::MakeMaker" => "6.52",
    "FFI::CheckLib" => 0,
    "FFI::Platypus" => 0,
    "Path::Tiny" => 0,
    "Sys::Info" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "Alien::Build" => "0.32",
    "Alien::Build::MM" => "0.32",
    "Alien::Build::Plugin::Build::CMake" => "0.99",
    "Alien::git" => 0,
    "ExtUtils::MakeMaker" => "6.52",
    "FFI::CheckLib" => 0,
    "FFI::Platypus" => 0,
    "Path::Tiny" => 0,
    "Sys::Info" => 0
  },
  "DISTNAME" => "Alien-XGBoost",
  "LICENSE" => "apache",
  "MIN_PERL_VERSION" => "5.008",
  "NAME" => "Alien::XGBoost",
  "PREREQ_PM" => {
    "Alien::Base" => 0,
    "Alien::Build" => "1.04",
    "Alien::cmake3" => 0,
    "Alien::git" => 0,
    "base" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Test2::V0" => 0,
    "Test::Alien" => 0,
    "Test::Most" => 0,
    "utf8" => 0
  },
  "VERSION" => "0.05",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Alien::Base" => 0,
  "Alien::Build" => "1.04",
  "Alien::Build::MM" => "0.32",
  "Alien::cmake3" => 0,
  "Alien::git" => 0,
  "ExtUtils::MakeMaker" => "6.52",
  "FFI::CheckLib" => 0,
  "FFI::Platypus" => 0,
  "Path::Tiny" => 0,
  "Sys::Info" => 0,
  "Test2::V0" => 0,
  "Test::Alien" => 0,
  "Test::Most" => 0,
  "base" => 0,
  "strict" => 0,
  "utf8" => 0,
  "warnings" => 0
);


# BEGIN code inserted by Dist::Zilla::Plugin::AlienBuild
use Alien::Build::MM;
my $abmm = Alien::Build::MM->new;
%WriteMakefileArgs = $abmm->mm_args(%WriteMakefileArgs);
# END code inserted by Dist::Zilla::Plugin::AlienBuild


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);


# BEGIN code inserted by Dist::Zilla::Plugin::AlienBuild
sub MY::postamble {
  $abmm->mm_postamble;
}
# END code inserted by Dist::Zilla::Plugin::AlienBuild

