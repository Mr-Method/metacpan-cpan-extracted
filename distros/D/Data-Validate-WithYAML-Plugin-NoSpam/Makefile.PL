# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.010.
use strict;
use warnings;

use 5.014;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Plugin to check that a given text is no spam.",
  "AUTHOR" => "Renee Baecker <module\@renee-baecker.de>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Data-Validate-WithYAML-Plugin-NoSpam",
  "LICENSE" => "artistic_2",
  "MIN_PERL_VERSION" => "5.014",
  "NAME" => "Data::Validate::WithYAML::Plugin::NoSpam",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Data::Validate::WithYAML" => "0.17"
  },
  "TEST_REQUIRES" => {
    "Perl::Critic" => 0,
    "Test::CheckManifest" => "1.38",
    "Test::More" => 0
  },
  "VERSION" => "0.04",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Data::Validate::WithYAML" => "0.17",
  "Perl::Critic" => 0,
  "Test::CheckManifest" => "1.38",
  "Test::More" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
