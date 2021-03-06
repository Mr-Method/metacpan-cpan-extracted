
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.013.
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Perl JSON Web Encryption (JWE) implementation",
  "AUTHOR" => "Companies House <chgovuk\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "JSON-WebEncryption",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "JSON::WebEncryption",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Crypt::CBC" => 0,
    "Crypt::OpenSSL::RSA" => 0,
    "Digest::SHA" => 0,
    "Exporter" => 0,
    "JSON" => 0,
    "MIME::Base64" => 0,
    "parent" => 0,
    "strict" => 0
  },
  "TEST_REQUIRES" => {
    "Crypt::Rijndael" => 0,
    "Test::More" => 0,
    "Test::Requires" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.03",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Crypt::CBC" => 0,
  "Crypt::OpenSSL::RSA" => 0,
  "Crypt::Rijndael" => 0,
  "Digest::SHA" => 0,
  "Exporter" => 0,
  "JSON" => 0,
  "MIME::Base64" => 0,
  "Test::More" => 0,
  "Test::Requires" => 0,
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



