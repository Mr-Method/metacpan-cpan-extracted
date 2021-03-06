
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.020.
use strict;
use warnings;



use ExtUtils::MakeMaker ;



my %WriteMakefileArgs = (
  "ABSTRACT" => "A pluggable Perl web service to preprocess web requests. Plugins can add geo, timezone and browser metadata, and throttle request rate.",
  "AUTHOR" => "Clinton Gormley <drtech\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "App-Cerberus",
  "EXE_FILES" => [
    "bin/cerberus.pl"
  ],
  "LICENSE" => "perl",
  "NAME" => "App::Cerberus",
  "PREREQ_PM" => {
    "Cache::Memcached::Fast" => 0,
    "Carp" => 0,
    "DateTime" => 0,
    "DateTime::TimeZone::Tzfile" => 0,
    "File::Spec::Functions" => 0,
    "FindBin" => 0,
    "Geo::IP" => 0,
    "HTTP::BrowserDetect" => 0,
    "JSON" => 0,
    "List::Util" => 0,
    "Net::IP::Match::Regexp" => 0,
    "Plack::Request" => 0,
    "Plack::Runner" => 0,
    "Pod::Usage" => 0,
    "Time::OlsonTZ::Data" => 0,
    "YAML" => 0,
    "lib" => 0,
    "parent" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.11",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Cache::Memcached::Fast" => 0,
  "Carp" => 0,
  "DateTime" => 0,
  "DateTime::TimeZone::Tzfile" => 0,
  "File::Spec::Functions" => 0,
  "FindBin" => 0,
  "Geo::IP" => 0,
  "HTTP::BrowserDetect" => 0,
  "JSON" => 0,
  "List::Util" => 0,
  "Net::IP::Match::Regexp" => 0,
  "Plack::Request" => 0,
  "Plack::Runner" => 0,
  "Pod::Usage" => 0,
  "Time::OlsonTZ::Data" => 0,
  "YAML" => 0,
  "lib" => 0,
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



