# Note: this file was auto-generated by Module::Build::Compat version 0.4001
require 5.008080;
use ExtUtils::MakeMaker;
WriteMakefile
(
  'NAME' => 'XAS::Service',
  'VERSION_FROM' => 'lib/XAS/Service.pm',
  'PREREQ_PM' => {
                   'Data::FormValidator' => '4.7',
                   'Data::FormValidator::Constraints::MethodsFactory' => '0.02',
                   'JSON::XS' => '2.32',
                   'POE::Filter::HTTP::Parser' => '1.06',
                   'Plack' => '0.9989',
                   'Template' => '2.18',
                   'Test::More' => 0,
                   'Web::Machine' => '0.17',
                   'XAS' => '0.12'
                 },
  'INSTALLDIRS' => 'vendor',
  'EXE_FILES' => [],
  'PL_FILES' => {}
)
;
