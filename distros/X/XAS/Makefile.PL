# Note: this file was auto-generated by Module::Build::Compat version 0.4001
require 5.008080;
use ExtUtils::MakeMaker;
WriteMakefile
(
  'NAME' => 'XAS',
  'VERSION_FROM' => 'lib/XAS.pm',
  'PREREQ_PM' => {
                   'Badger' => '0.09',
                   'Config::IniFiles' => '2.65',
                   'Data::Dumper' => '0',
                   'Data::Hexdumper' => '0',
                   'Data::UUID' => '0',
                   'DateTime' => '0.53',
                   'DateTime::Format::Pg' => '0',
                   'DateTime::Format::Strptime' => '1.1',
                   'DateTime::Span' => '0',
                   'Getopt::Long' => '0',
                   'HTTP::Request' => '0',
                   'HTTP::Response' => '0',
                   'Hash::Merge' => '0.12',
                   'JSON::XS' => '2.27',
                   'KeyedMutex' => '0.06',
                   'MIME::Lite' => '3.027',
                   'Net::SSH2' => '0.44',
                   'POE' => '1.294',
                   'Params::Validate' => '0.92',
                   'Pod::Usage' => '1.35',
                   'Set::Light' => '0.04',
                   'Sys::Syslog' => '0',
                   'Test::More' => 0,
                   'Try::Tiny' => '0.11',
                   'Try::Tiny::Retry' => '0.003',
                   'WWW::Curl' => '0',
                   'XML::LibXML' => '0'
                 },
  'INSTALLDIRS' => 'vendor',
  'EXE_FILES' => [
                   'bin/xas-alert',
                   'bin/xas-init',
                   'bin/xas-rotate'
                 ],
  'PL_FILES' => {}
)
;
