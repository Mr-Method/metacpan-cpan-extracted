package Alien::HTSlib;
$Alien::HTSlib::VERSION = '0.03';

use strict;
use warnings;

use parent 'Alien::Base';

1;

__END__

=pod

=encoding UTF-8

=head1 NAME
    Alien::HTSlib - Fetch/build/stash the HTSlib headers and libs from http://htslib.org.

=head1 SYNOPSIS
  Example of finding the headers and library that Alien::HTSlib installed.

       $ENV{HTSLIB_DIR} || (
          can_load(
              modules => { 'Alien::HTSlib' => undef, 'File::ShareDir' => undef }
          ) &&
          File::ShareDir::dist_dir('Alien-HTSlib') );


=head1 DESCRIPTION
    Download, build, and install the HTSlib C headers and libraries into a
    well-known location, "File::ShareDir::dist_dir('Alien-HTSlib')", from
    whence other packages can make use of them.

    The version installed will be the latest release on the master branch from
    the HTSlib GitHub repo.

=head1 AUTHOR

Rishi Nag

=head1 COPYRIGHT AND LICENSE

Copyright [1999-2016] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut
