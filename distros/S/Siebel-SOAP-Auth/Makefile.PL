# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.043.
use strict;
use warnings;

use 5.008009;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Moo based class to implement transparent Siebel Session Management for XML::Compile::WSDL11 ",
  "AUTHOR" => "Alceu Rodrigues de Freitas Junior <arfreitas\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Siebel-SOAP-Auth",
  "LICENSE" => "gpl",
  "MIN_PERL_VERSION" => "5.008009",
  "NAME" => "Siebel::SOAP::Auth",
  "PREREQ_PM" => {
    "Encode" => 0,
    "Log::Report" => "1.05",
    "Moo" => "2.000001",
    "Types::Standard" => "1.000005",
    "XML::Compile::SOAP11" => "3.12",
    "XML::LibXML" => "2.0115",
    "namespace::clean" => "0.25"
  },
  "TEST_REQUIRES" => {
    "Digest::MD5" => 0,
    "File::Spec" => 0,
    "Moose" => "2.1405",
    "Test::Exception" => "0.40",
    "Test::Moose" => "2.1405",
    "Test::More" => 0,
    "XML::Compile::SOAP11" => "3.12",
    "XML::Compile::Transport::SOAPHTTP" => "3.12",
    "XML::Compile::WSDL11" => "3.04"
  },
  "VERSION" => "0.004",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Digest::MD5" => 0,
  "Encode" => 0,
  "File::Spec" => 0,
  "Log::Report" => "1.05",
  "Moo" => "2.000001",
  "Moose" => "2.1405",
  "Test::Exception" => "0.40",
  "Test::Moose" => "2.1405",
  "Test::More" => 0,
  "Types::Standard" => "1.000005",
  "XML::Compile::SOAP11" => "3.12",
  "XML::Compile::Transport::SOAPHTTP" => "3.12",
  "XML::Compile::WSDL11" => "3.04",
  "XML::LibXML" => "2.0115",
  "namespace::clean" => "0.25"
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
