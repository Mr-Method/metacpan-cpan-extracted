use ExtUtils::MakeMaker;


# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'         => 'Parse::FixedLength',
    'VERSION_FROM' => 'FixedLength.pm',
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'FixedLength.pm',
       AUTHOR     => 'Douglas Wilson <dougw@cpan.org>') : ()),
);
