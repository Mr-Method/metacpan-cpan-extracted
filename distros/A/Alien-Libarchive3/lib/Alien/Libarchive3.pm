package Alien::Libarchive3;

use strict;
use warnings;
use base qw( Alien::Base );

# ABSTRACT: Find or install libarchive version 3.x or better
our $VERSION = '0.28'; # VERSION









1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Libarchive3 - Find or install libarchive version 3.x or better

=head1 VERSION

version 0.28

=head1 SYNOPSIS

In your Build.PL:

 use Module::Build;
 use Alien::Libarchive3;
 my $builder = Module::Build->new(
   ...
   configure_requires => {
     'Alien::Libarchive3' => '0',
     ...
   },
   extra_compiler_flags => Alien::Libarchive3->cflags,
   extra_linker_flags   => Alien::Libarchive3->libs,
   ...
 );
 
 $build->create_build_script;

In your Makefile.PL:

 use ExtUtils::MakeMaker;
 use Config;
 use Alien::Libarchive3;
 
 WriteMakefile(
   ...
   CONFIGURE_REQUIRES => {
     'Alien::Libarchive3' => '0',
   },
   CCFLAGS => Alien::Libarchive3->cflags . " $Config{ccflags}",
   LIBS    => [ Alien::Libarchive3->libs ],
   ...
 );

In your script or module:

 use Alien::Libarchive3;
 use Env qw( @PATH );
 
 unshift @ENV, Alien::Libarchive3->bin_dir;

In your L<FFI::Platypus> script or module:

 use FFI::Platypus;
 use Alien::Libarchive3;
 
 my $ffi = FFI::Platypus->new(
   lib => [ Alien::Libarchive3->dynamic_libs ],
 );

=head1 DESCRIPTION

This distribution provides libarchive so that it can be used by other 
Perl distributions that are on CPAN.  It does this by first trying to 
detect an existing install of libarchive on your system.  If found it 
will use that.  If it cannot be found, the source code will be downloaded
from the internet and it will be installed in a private share location
for the use of other modules.

The intention is for this to eventually replace L<Alien::Libarchive>

=head1 SEE ALSO

L<Alien>, L<Alien::Base>, L<Alien::Build::Manual::AlienUser>

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
