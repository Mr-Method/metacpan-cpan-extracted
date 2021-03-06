# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.014.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Modules that generate text tables",
  "AUTHOR" => "perlancar <perlancar\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Acme-CPANModules-TextTable",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.010001",
  "NAME" => "Acme::CPANModules::TextTable",
  "PREREQ_PM" => {
    "Text::ANSITable" => 0,
    "Text::ASCIITable" => 0,
    "Text::FormatTable" => 0,
    "Text::MarkdownTable" => 0,
    "Text::Table" => 0,
    "Text::Table::CSV" => "0.022",
    "Text::Table::HTML" => 0,
    "Text::Table::HTML::DataTables" => 0,
    "Text::Table::Org" => 0,
    "Text::Table::Sprintf" => 0,
    "Text::Table::Tiny" => 0,
    "Text::Table::TinyColor" => 0,
    "Text::Table::TinyColorWide" => 0,
    "Text::Table::TinyWide" => 0,
    "Text::TabularDisplay" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Bencher::Backend" => "1.050",
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.006",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Bencher::Backend" => "1.050",
  "File::Spec" => 0,
  "IO::Handle" => 0,
  "IPC::Open3" => 0,
  "Test::More" => 0,
  "Text::ANSITable" => 0,
  "Text::ASCIITable" => 0,
  "Text::FormatTable" => 0,
  "Text::MarkdownTable" => 0,
  "Text::Table" => 0,
  "Text::Table::CSV" => "0.022",
  "Text::Table::HTML" => 0,
  "Text::Table::HTML::DataTables" => 0,
  "Text::Table::Org" => 0,
  "Text::Table::Sprintf" => 0,
  "Text::Table::Tiny" => 0,
  "Text::Table::TinyColor" => 0,
  "Text::Table::TinyColorWide" => 0,
  "Text::Table::TinyWide" => 0,
  "Text::TabularDisplay" => 0,
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
