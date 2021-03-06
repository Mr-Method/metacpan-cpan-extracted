# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.039.
use strict;
use warnings;



use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "IOLoop interface to Proc::Background",
  "AUTHOR" => "Brian Medley <bpmedley\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Mojo-IOLoop-ProcBackground",
  "LICENSE" => "perl",
  "NAME" => "Mojo::IOLoop::ProcBackground",
  "PREREQ_PM" => {
    "Mojolicious" => 0,
    "Proc::Background" => 0
  },
  "VERSION" => "0.06",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Mojolicious" => 0,
  "Proc::Background" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
