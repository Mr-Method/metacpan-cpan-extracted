package Alien::LZO;

use strict;
use warnings;
use base qw( Alien::Base );

# ABSTRACT: Build and make available LZO
our $VERSION = '0.02'; # VERSION







1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::LZO - Build and make available LZO

=head1 VERSION

version 0.02

=head1 SYNOPSIS

In your Build.PL:

 use Module::Build;
 use Alien::LZO;
 my $builder = Module::Build->new(
   ...
   configure_requires => {
     'Alien::LZO' => '0',
     ...
   },
   extra_compiler_flags => Alien::LZO->cflags,
   extra_linker_flags   => Alien::LZO->libs,
   ...
 );
 
 $build->create_build_script;

In your Makefile.PL:

 use ExtUtils::MakeMaker;
 use Config;
 use Alien::LZO;
 
 WriteMakefile(
   ...
   CONFIGURE_REQUIRES => {
     'Alien::LZO' => '0',
   },
   CCFLAGS => Alien::LZO->cflags . " $Config{ccflags}",
   LIBS    => [ Alien::LZO->libs ],
   ...
 );

In your L<FFI::Platypus> script or module:

 use FFI::Platypus;
 use Alien::LZO;
 
 my $ffi = FFI::Platypus->new(
   lib => [ Alien::LZO->dynamic_libs ],
 );

=head1 DESCRIPTION

This distribution provides lzo so that it can be used by other 
Perl distributions that are on CPAN.  It does this by first trying to 
detect an existing install of lzo on your system.  If found it 
will use that.  If it cannot be found, the source code will be downloaded
from the internet and it will be installed in a private share location
for the use of other modules.

=head1 SEE ALSO

L<Alien>, L<Alien::Base>, L<Alien::Build::Manual::AlienUser>

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
