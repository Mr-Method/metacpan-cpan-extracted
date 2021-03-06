
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.019.
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Simple Call LIBSVM ",
  "AUTHOR" => "abbypan <abbypan\@gmail.com>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "SimpleCall-LIBSVM",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "SimpleCall::LIBSVM",
  "PREREQ_PM" => {
    "List::AllUitls" => 0
  },
  "VERSION" => "0.01",
  "test" => {
    "TESTS" => ""
  }
);


my %FallbackPrereqs = (
  "List::AllUitls" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



