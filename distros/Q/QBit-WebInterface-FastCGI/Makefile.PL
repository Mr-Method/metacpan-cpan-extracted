# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.010.
use strict;
use warnings;



use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Package for connect WebInterface with FastCGI",
  "AUTHOR" => "Sergei Svistunov <sergei-svistunov\@yandex.ru>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "QBit-WebInterface-FastCGI",
  "EXE_FILES" => [
    "bin/qbit_fcgi_starter"
  ],
  "LICENSE" => "gpl",
  "NAME" => "QBit::WebInterface::FastCGI",
  "PREREQ_PM" => {
    "FCGI" => 0,
    "FCGI::ProcManager" => 0,
    "Getopt::Long" => 0,
    "Pod::Usage" => 0,
    "Proc::Daemon" => 0,
    "QBit::WebInterface" => 0,
    "QBit::WebInterface::Request" => 0,
    "base" => 0,
    "lib" => 0,
    "qbit" => 0
  },
  "VERSION" => "0.006",
  "test" => {
    "TESTS" => ""
  }
);


my %FallbackPrereqs = (
  "FCGI" => 0,
  "FCGI::ProcManager" => 0,
  "Getopt::Long" => 0,
  "Pod::Usage" => 0,
  "Proc::Daemon" => 0,
  "QBit::WebInterface" => 0,
  "QBit::WebInterface::Request" => 0,
  "base" => 0,
  "lib" => 0,
  "qbit" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
