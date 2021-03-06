#
# This file is part of Dist-Metadata
#
# This software is copyright (c) 2011 by Randy Stauner.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.005.
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Information about a perl module distribution",
  "AUTHOR" => "Randy Stauner <rwstauner\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Dist-Metadata",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.006",
  "NAME" => "Dist::Metadata",
  "PREREQ_PM" => {
    "Archive::Tar" => 1,
    "Archive::Zip" => "1.30",
    "CPAN::DistnameInfo" => "0.12",
    "CPAN::Meta" => "2.1",
    "Carp" => 0,
    "Digest" => "1.03",
    "Digest::MD5" => 2,
    "Digest::SHA" => 5,
    "File::Basename" => 0,
    "File::Find" => 0,
    "File::Spec::Native" => "1.002",
    "File::Temp" => "0.19",
    "List::Util" => 0,
    "Module::Metadata" => 0,
    "Path::Class" => "0.24",
    "Try::Tiny" => "0.09",
    "parent" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::Spec" => 0,
    "File::Temp" => "0.19",
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::Fatal" => 0,
    "Test::MockObject" => "1.09",
    "Test::More" => "0.96",
    "blib" => "1.01"
  },
  "VERSION" => "0.927",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Archive::Tar" => 1,
  "Archive::Zip" => "1.30",
  "CPAN::DistnameInfo" => "0.12",
  "CPAN::Meta" => "2.1",
  "Carp" => 0,
  "Digest" => "1.03",
  "Digest::MD5" => 2,
  "Digest::SHA" => 5,
  "ExtUtils::MakeMaker" => 0,
  "File::Basename" => 0,
  "File::Find" => 0,
  "File::Spec" => 0,
  "File::Spec::Native" => "1.002",
  "File::Temp" => "0.19",
  "IO::Handle" => 0,
  "IPC::Open3" => 0,
  "List::Util" => 0,
  "Module::Metadata" => 0,
  "Path::Class" => "0.24",
  "Test::Fatal" => 0,
  "Test::MockObject" => "1.09",
  "Test::More" => "0.96",
  "Try::Tiny" => "0.09",
  "blib" => "1.01",
  "parent" => 0,
  "strict" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
