package Alien::m4;

use strict;
use warnings;
use base qw( Alien::Base );

# ABSTRACT: Find or build m4
our $VERSION = '0.09'; # VERSION


sub alien_helper
{
  return {
    m4 => sub { 'm4' },
  };
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::m4 - Find or build m4

=head1 VERSION

version 0.09

=head1 SYNOPSIS

From a Perl script

 use Alien::m4;
 use Env qw( @PATH );
 unshift @PATH, Alien::m4->bin_dir;  # m4 is now in your path

From Alien::Base Build.PL

 use Alien:Base::ModuleBuild;
 my $builder = Module::Build->new(
   ...
   alien_bin_requires => {
     'Alien::m4' => '0.07',
   },
   ...
 );
 $builder->create_build_script;

=head1 DESCRIPTION

This package can be used by other CPAN modules that require m4.

=head1 HELPERS

=head2 m4

 %{m4}

Returns the name of the m4 command.  Usually just C<m4>.

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
