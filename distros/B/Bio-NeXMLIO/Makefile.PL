# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.012.
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "stream handler for NeXML documents",
  "AUTHOR" => "Chase Miller <chmille4\@gmail.com>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Bio-NeXMLIO",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.006",
  "NAME" => "Bio::NeXMLIO",
  "PREREQ_PM" => {
    "Bio::AlignIO" => 0,
    "Bio::Event::EventGeneratorI" => 0,
    "Bio::Phylo::Factory" => 0,
    "Bio::Phylo::Forest::Tree" => 0,
    "Bio::Phylo::IO" => 0,
    "Bio::Phylo::Matrices" => 0,
    "Bio::Phylo::Matrices::Datum" => 0,
    "Bio::Phylo::Matrices::Matrix" => 0,
    "Bio::Root::IO" => 0,
    "Bio::Root::Root" => 0,
    "Bio::Seq" => 0,
    "Bio::Seq::SeqFactory" => 0,
    "Bio::SeqFeature::Generic" => 0,
    "Bio::SeqIO" => 0,
    "Bio::TreeIO" => 0,
    "IO::String" => 0,
    "base" => 0,
    "lib" => 0,
    "strict" => 0
  },
  "TEST_REQUIRES" => {
    "Bio::Root::Test" => 0,
    "Bio::Tree::Tree" => 0,
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::More" => 0,
    "warnings" => 0
  },
  "VERSION" => "1.7.3",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Bio::AlignIO" => 0,
  "Bio::Event::EventGeneratorI" => 0,
  "Bio::Phylo::Factory" => 0,
  "Bio::Phylo::Forest::Tree" => 0,
  "Bio::Phylo::IO" => 0,
  "Bio::Phylo::Matrices" => 0,
  "Bio::Phylo::Matrices::Datum" => 0,
  "Bio::Phylo::Matrices::Matrix" => 0,
  "Bio::Root::IO" => 0,
  "Bio::Root::Root" => 0,
  "Bio::Root::Test" => 0,
  "Bio::Seq" => 0,
  "Bio::Seq::SeqFactory" => 0,
  "Bio::SeqFeature::Generic" => 0,
  "Bio::SeqIO" => 0,
  "Bio::Tree::Tree" => 0,
  "Bio::TreeIO" => 0,
  "File::Spec" => 0,
  "IO::Handle" => 0,
  "IO::String" => 0,
  "IPC::Open3" => 0,
  "Test::More" => 0,
  "base" => 0,
  "lib" => 0,
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
