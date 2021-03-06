#!/usr/bin/perl -w

use ExtUtils::MakeMaker;

$PACKAGE = 'Class::Virtual';
($PACKAGE_FILE = $PACKAGE) =~ s|::|/|g;
$LAST_API_CHANGE = 0;
$LAST_MAJOR_BUG  = 0;

eval "require $PACKAGE";

unless ($@) { # Make sure we did find the module.
    print <<"CHANGE_WARN" if ${$PACKAGE.'::VERSION'} < $LAST_API_CHANGE;

NOTE: There have been API changes between this version and any older
than version $LAST_API_CHANGE!  Please read the Changes file if you
are upgrading from a version older than $LAST_API_CHANGE.

CHANGE_WARN

    print <<"BUG_WARN" if ${$PACKAGE.'::VERSION'} < $LAST_MAJOR_BUG;
Version $LAST_MAJOR_BUG contained a MAJOR BUG which has now been fixed.  
See the Changes file for details.
BUG_WARN
}

WriteMakefile(
    NAME            => $PACKAGE,

    VERSION_FROM    => "lib/$PACKAGE_FILE.pm",
    ABSTRACT_FROM   => "lib/$PACKAGE_FILE.pm",
    AUTHOR          => 'Michael G Schwern <schwern@pobox.com>',
    LICENSE         => 'perl_5',
    
    PREREQ_PM       => { 
        Class::Data::Inheritable => 0.02,
        Class::ISA               => 0.31,
        Carp::Assert             => 0.10,
        Test::More               => 0.50,
    },

    META_MERGE          => {
        resources => {
            homepage   => 'https://metacpan.org/release/Class-Virtual',
            bugtracker => 'https://github.com/schwern/Class-Virtual/issues',
            repository => 'https://github.com/schwern/Class-Virtual',
        }
    },
);
