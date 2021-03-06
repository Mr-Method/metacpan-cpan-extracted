# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.008.
use strict;
use warnings;



use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Encodes and Decodes short urls by using Bijection",
  "AUTHOR" => "Adam Hopkins <srchulo\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Short-Url",
  "LICENSE" => "perl",
  "NAME" => "Short::Url",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Mouse" => 0,
    "strict" => 0
  },
  "VERSION" => "0.013",
  "test" => {
    "TESTS" => ""
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Mouse" => 0,
  "strict" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
