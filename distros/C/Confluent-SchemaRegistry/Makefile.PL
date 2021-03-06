#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use ExtUtils::MakeMaker;

if ( $^O eq 'MSWin32' || $^O eq 'solaris' ||  $^O eq 'cygwin' ) {
    print STDERR "OS unsupported: $^O\n";
    exit( 255 );
}

my $package = 'Confluent::SchemaRegistry';
my $path_to_package = 'lib/Confluent/SchemaRegistry.pm';

`perldoc -uT $path_to_package | pod2text - README`;
`perldoc -uT $path_to_package | pod2markdown - README.md`; # useful for GitHub repo home

my %config = (
    NAME                => $package,
    VERSION_FROM        => $path_to_package,  # finds $VERSION
    MIN_PERL_VERSION    => '5.010',
    PREREQ_PM           => {            # more to the list $Module::CoreList::version{5.010}
		'JSON::XS'     => 'v4.30.0',
		'REST::Client' => 'v273.0.0',
        'HTTP::Status' => 'v6.270.0',
		'Try::Tiny'    => 'v0.300.0',
		'Avro::Schema' => 'v1.10.1',
		'Aspect'       => 'v1.40.0'
    },
    TEST_REQUIRES       => {            # more to the list $Module::CoreList::version{5.010}
		'Math::BigInt'				=> '1.89',
		'Test::Exception'			=> '0.43'
    },
    META_MERGE          => {
        no_index                => {
            directory               => [
                't',
                'inc',
            ]
        },
        'meta-spec'             => { version => 2 },
        resources               => {
            bugtracker              => {
               web                      => 'https://github.com/alivraghi/Confluent-SchemaRegistry/issues',
            },
            homepage                => 'https://github.com/alivraghi/Confluent-SchemaRegistry',
            repository              => {
                type                    => 'git',
                url                     => 'git@github.com/Confluent-SchemaRegistry.git',
                web                     => 'https://github.com/alivraghi/Confluent-SchemaRegistry.git',
            },
        },
    },
    ( $] >= 5.005 ?                             ## Add these new keywords supported since 5.005
        (
            ABSTRACT            => 'A simple client for interacting with Confluent Schema Registry.',
            AUTHOR              => 'Alvaro Livraghi',
        ) : ()
    ),
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    realclean           => { FILES => "inc Confluent-SchemaRegistry-*.tar.gz" },
    LICENSE             => 'perl',
#    NO_MYMETA           => 1,
);

ExtUtils::MakeMaker::WriteMakefile( %config );
