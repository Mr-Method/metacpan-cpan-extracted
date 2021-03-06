
# This file was automatically generated by Dist::Zilla::Plugin::ModuleBuild v5.027.
use strict;
use warnings;

use Module::Build 0.28;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.28"
  },
  "configure_requires" => {
    "Module::Build" => "0.28"
  },
  "dist_abstract" => "A simple wrapper around the python Gemini library for annotating VCF files.",
  "dist_author" => [
    "Jillian Rowe <jillian.e.rowe\@gmail.com>"
  ],
  "dist_name" => "BioX-Wrapper-Gemini",
  "dist_version" => "0.05",
  "license" => "perl",
  "module_name" => "BioX::Wrapper::Gemini",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "BioX::Wrapper" => 0,
    "Cwd" => 0,
    "Data::Dumper" => 0,
    "DateTime" => 0,
    "File::Basename" => 0,
    "File::Find::Rule" => 0,
    "File::FindLib" => 0,
    "File::Path" => 0,
    "List::Compare" => 0,
    "Moose" => 0,
    "MooseX::Getopt" => 0,
    "MooseX::Getopt::Meta::Attribute::NoGetopt" => 0,
    "MooseX::Getopt::Usage" => 0,
    "MooseX::Getopt::Usage::Role::Man" => 0
  },
  "script_files" => [
    "script/gemini-wrapper.pl"
  ],
  "test_requires" => {
    "Test::More" => "0.96"
  }
);


my %fallback_build_requires = (
  "Module::Build" => "0.28",
  "Test::More" => "0.96"
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  delete $module_build_args{test_requires};
  $module_build_args{build_requires} = \%fallback_build_requires;
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
