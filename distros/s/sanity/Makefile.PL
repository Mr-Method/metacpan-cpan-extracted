
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.020.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker ;



my %WriteMakefileArgs = (
  "ABSTRACT" => "The ONLY meta pragma you'll ever need!",
  "AUTHOR" => "Brendan Byrd <BBYRD\@CPAN.org>",
  "CONFIGURE_REQUIRES" => {},
  "DISTNAME" => "sanity",
  "EXE_FILES" => [],
  "LICENSE" => "artistic_2",
  "NAME" => "sanity",
  "PREREQ_PM" => {
    "Import::Into" => "1.1.0",
    "List::MoreUtils" => "0.23"
  },
  "TEST_REQUIRES" => {
    "Test::CheckDeps" => "0.010",
    "Test::More" => "0.94"
  },
  "VERSION" => "1.03",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Import::Into" => "1.1.0",
  "List::MoreUtils" => "0.23",
  "Test::CheckDeps" => "0.010",
  "Test::More" => "0.94"
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



