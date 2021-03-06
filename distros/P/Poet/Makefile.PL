
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.020.
use strict;
use warnings;



use ExtUtils::MakeMaker ;

use File::ShareDir::Install;
$File::ShareDir::Install::INCLUDE_DOTFILES = 1;
$File::ShareDir::Install::INCLUDE_DOTDIRS = 1;
install_share dist => "share";


my %WriteMakefileArgs = (
  "ABSTRACT" => "The Mason web framework",
  "AUTHOR" => "Jonathan Swartz <swartz\@pobox.com>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::ShareDir::Install" => "0.06"
  },
  "DISTNAME" => "Poet",
  "EXE_FILES" => [
    "bin/poet"
  ],
  "LICENSE" => "perl",
  "NAME" => "Poet",
  "PREREQ_PM" => {
    "CHI" => "0.52",
    "Capture::Tiny" => 0,
    "Class::Load" => 0,
    "Data::Rmap" => "0.6",
    "File::ShareDir" => 0,
    "File::ShareDir::Install" => 0,
    "File::Slurp" => 0,
    "File::Spec::Functions" => 0,
    "Guard" => 0,
    "JSON::XS" => 0,
    "Log::Any::Adapter" => 0,
    "Mason" => "2.19",
    "Mason::Plugin::Cache" => "0.04",
    "Mason::Plugin::HTMLFilters" => 0,
    "Mason::Plugin::RouterSimple" => "0.05",
    "MasonX::ProcessDir" => "0.02",
    "Method::Signatures::Simple" => "1.02",
    "Moose" => "1.15",
    "MooseX::App::Cmd" => 0,
    "MooseX::HasDefaults::RO" => 0,
    "MooseX::StrictConstructor" => 0,
    "Plack" => 0,
    "Plack::Middleware::Debug" => 0,
    "Plack::Middleware::Session" => 0,
    "Plack::Session::Store::Cache" => 0,
    "Try::Tiny" => 0,
    "URI" => 0,
    "URI::Escape" => 0,
    "YAML::XS" => 0
  },
  "TEST_REQUIRES" => {
    "Test::Class::Most" => 0,
    "Test::WWW::Mechanize::PSGI" => 0
  },
  "VERSION" => "0.16",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "CHI" => "0.52",
  "Capture::Tiny" => 0,
  "Class::Load" => 0,
  "Data::Rmap" => "0.6",
  "File::ShareDir" => 0,
  "File::ShareDir::Install" => 0,
  "File::Slurp" => 0,
  "File::Spec::Functions" => 0,
  "Guard" => 0,
  "JSON::XS" => 0,
  "Log::Any::Adapter" => 0,
  "Mason" => "2.19",
  "Mason::Plugin::Cache" => "0.04",
  "Mason::Plugin::HTMLFilters" => 0,
  "Mason::Plugin::RouterSimple" => "0.05",
  "MasonX::ProcessDir" => "0.02",
  "Method::Signatures::Simple" => "1.02",
  "Moose" => "1.15",
  "MooseX::App::Cmd" => 0,
  "MooseX::HasDefaults::RO" => 0,
  "MooseX::StrictConstructor" => 0,
  "Plack" => 0,
  "Plack::Middleware::Debug" => 0,
  "Plack::Middleware::Session" => 0,
  "Plack::Session::Store::Cache" => 0,
  "Test::Class::Most" => 0,
  "Test::WWW::Mechanize::PSGI" => 0,
  "Try::Tiny" => 0,
  "URI" => 0,
  "URI::Escape" => 0,
  "YAML::XS" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

{
package
MY;
use File::ShareDir::Install qw(postamble);
}


