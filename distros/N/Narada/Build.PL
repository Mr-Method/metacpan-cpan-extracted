use Devel::AssertOS qw[-MicrosoftWindows];

# This file was automatically generated by Dist::Zilla::Plugin::ModuleBuild v6.011.
use strict;
use warnings;

use Module::Build 0.28;
use lib qw{inc}; use Module::Build::Custom;

my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.28"
  },
  "configure_requires" => {
    "CPAN::Meta" => "2.150005",
    "Devel::AssertOS" => 0,
    "Devel::CheckOS" => "1.63",
    "Module::Build" => "0.28"
  },
  "dist_abstract" => "framework for ease deploy and support microservice projects",
  "dist_author" => [
    "Alex Efros <powerman\@cpan.org>"
  ],
  "dist_name" => "Narada",
  "dist_version" => "v2.3.8",
  "license" => "mit",
  "module_name" => "Narada",
  "recursive_test_files" => 1,
  "requires" => {
    "App::migrate" => "v0.2.0",
    "App::powerdiff" => 0,
    "DBI" => 0,
    "Export::Attrs" => 0,
    "File::Temp" => 0,
    "FindBin" => 0,
    "Getopt::Long" => 0,
    "List::Util" => 0,
    "Log::Fast" => 0,
    "MIME::Base64" => 0,
    "Path::Tiny" => "0.065",
    "Time::HiRes" => 0,
    "Time::Local" => 0,
    "parent" => 0,
    "perl" => "5.010001",
    "version" => "0.77"
  },
  "script_files" => [
    "bin/narada-backup",
    "bin/narada-bg",
    "bin/narada-bg-killall",
    "bin/narada-diff",
    "bin/narada-download",
    "bin/narada-emu",
    "bin/narada-install",
    "bin/narada-lock",
    "bin/narada-lock-exclusive",
    "bin/narada-mysql",
    "bin/narada-mysqldump",
    "bin/narada-new",
    "bin/narada-new-1",
    "bin/narada-patch",
    "bin/narada-patch-pull",
    "bin/narada-patch-remote",
    "bin/narada-patch-send",
    "bin/narada-release",
    "bin/narada-remote",
    "bin/narada-restore",
    "bin/narada-setup-cron",
    "bin/narada-setup-mysql",
    "bin/narada-setup-qmail",
    "bin/narada-shutdown-services",
    "bin/narada-start-services",
    "bin/narada-upload",
    "bin/narada-viewlog"
  ],
  "test_requires" => {
    "File::Copy::Recursive" => 0,
    "Test::Database" => 0,
    "Test::Differences" => 0,
    "Test::Exception" => 0,
    "Test::MockModule" => 0,
    "Test::More" => "0.96",
    "Test::Output" => 0
  }
);


my %fallback_build_requires = (
  "File::Copy::Recursive" => 0,
  "Module::Build" => "0.28",
  "Test::Database" => 0,
  "Test::Differences" => 0,
  "Test::Exception" => 0,
  "Test::MockModule" => 0,
  "Test::More" => "0.96",
  "Test::Output" => 0
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  delete $module_build_args{test_requires};
  $module_build_args{build_requires} = \%fallback_build_requires;
}

my $build = Module::Build::Custom->new(%module_build_args);


$build->create_build_script;
