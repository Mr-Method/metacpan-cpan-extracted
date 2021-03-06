# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.042.
use strict;
use warnings;



use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "The POD-like markup language written for podcats.in",
  "AUTHOR" => "Alastair McGowan-Douglas <altreus\@perl.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Pod-Cats",
  "LICENSE" => "bsd",
  "NAME" => "Pod::Cats",
  "PREREQ_PM" => {
    "Carp" => "1.11",
    "Data::Dumper" => 0,
    "List::Util" => "1.21",
    "Parser::MGC" => "0.06",
    "String::Util" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.08",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => "1.11",
  "Data::Dumper" => 0,
  "List::Util" => "1.21",
  "Parser::MGC" => "0.06",
  "String::Util" => 0,
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
