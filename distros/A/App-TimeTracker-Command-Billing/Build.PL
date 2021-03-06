
# This file was automatically generated by Dist::Zilla::Plugin::ModuleBuild v6.012.
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
  "dist_abstract" => "Add a billing point as a tag to tasks",
  "dist_author" => [
    "Thomas Klausner <domm\@cpan.org>"
  ],
  "dist_name" => "App-TimeTracker-Command-Billing",
  "dist_version" => "1.000",
  "license" => "perl",
  "module_name" => "App::TimeTracker::Command::Billing",
  "recursive_test_files" => 1,
  "requires" => {
    "DateTime" => 0,
    "Moose::Role" => 0,
    "perl" => "5.010",
    "strict" => 0,
    "warnings" => 0
  }
);


my %fallback_build_requires = (
  "Module::Build" => "0.28"
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  delete $module_build_args{test_requires};
  $module_build_args{build_requires} = \%fallback_build_requires;
}

my $build = Module::Build->new(%module_build_args);


$build->create_build_script;
