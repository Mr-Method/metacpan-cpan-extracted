package Alien::Build::Plugin::Core::Legacy;

use strict;
use warnings;
use Alien::Build::Plugin;

# ABSTRACT: Core Alien::Build plugin to maintain compatibility with legacy Alien::Base
our $VERSION = '0.36'; # VERSION


sub init
{
  my($self, $meta) = @_;
  
  $meta->after_hook(
    $_ => sub {
      my($build) = @_;
      
      $build->log("adding legacy hash to config");
      
      my $runtime = $build->runtime_prop;
      
      if($runtime->{cflags} && ! defined $runtime->{cflags_static})
      {
        $runtime->{cflags_static} = $runtime->{cflags};
      }

      if($runtime->{libs} && ! defined $runtime->{libs_static})
      {
        $runtime->{libs_static} = $runtime->{libs};
      }
      
      $runtime->{legacy}->{finished_installing} = 1;
      $runtime->{legacy}->{install_type}        = $runtime->{install_type};
      $runtime->{legacy}->{version}             = $runtime->{version};
      $runtime->{legacy}->{original_prefix}     = $runtime->{prefix};
    }
  ) for qw( gather_system gather_share );
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Build::Plugin::Core::Legacy - Core Alien::Build plugin to maintain compatibility with legacy Alien::Base

=head1 VERSION

version 0.36

=head1 SYNOPSIS

 use alienfile;
 # already loaded

=head1 DESCRIPTION

This plugin provides some compatibility with the legacy L<Alien::Build::ModuleBuild>
interfaces.

=head1 SEE ALSO

L<Alien::Build>, L<Alien::Base::ModuleBuild>

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
