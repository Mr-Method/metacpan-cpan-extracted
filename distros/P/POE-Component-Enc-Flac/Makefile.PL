use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'          => 'POE::Component::Enc::Flac',
    'VERSION_FROM'  => 'Flac.pm', # finds $VERSION
    'PREREQ_PM'     => {POE => 0.27},
    ($] >= 5.005 ?                ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM=> 'Flac.pm', # retrieve abstract from module
       AUTHOR       => 'Steve James <steATcpanDOTorg>',
       clean        => {FILES => 't/*.ogg' },
      ) : ()),
);
