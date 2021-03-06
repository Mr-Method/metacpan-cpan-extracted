use 5.008000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Acme::MUDLike',
    VERSION_FROM      => 'lib/Acme/MUDLike.pm', # finds $VERSION
    PREREQ_PM         => { 
        'Devel::Pointer' => 0, 
        'Continuity' => 1.5,
     }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Acme/MUDLike.pm', # retrieve abstract from module
       AUTHOR         => 'Scott Walters <scott@slowass.net>') : ()),
);
