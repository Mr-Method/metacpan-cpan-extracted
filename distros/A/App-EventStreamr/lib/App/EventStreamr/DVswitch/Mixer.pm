package App::EventStreamr::DVswitch::Mixer;
use Method::Signatures;
use Moo;
use namespace::clean;

# ABSTRACT: A DVswitch Process

our $VERSION = '0.5'; # VERSION: Generated by DZP::OurPkg:Version


extends 'App::EventStreamr::Process';

has 'cmd'         => ( is => 'ro', lazy => 1, builder => 1 );
has 'id'          => ( is => 'ro', default => sub { 'dvswitch' } );
has 'type'        => ( is => 'ro', default => sub { 'mixer' } );

method _build_cmd() {
  my $command = $self->{config}{commands}{dvswitch} ? $self->{config}{commands}{dvswitch} : 'dvswitch -h 0.0.0.0 -p $port';
  
  my %cmd_vars =  (
    port    => $self->{config}{mixer}{port},
  );

  $command =~ s/\$(\w+)/$cmd_vars{$1}/g;
  return $command;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::EventStreamr::DVswitch::Mixer - A DVswitch Process

=head1 VERSION

version 0.5

=head1 SYNOPSIS

This Provides a pre-configured DVswitch process.

=head1 DESCRIPTION

This largely extends L<App::EventStreamr::Process>, provides
default cmds that can be overridden in the configuration.

=head1 AUTHOR

Leon Wright < techman@cpan.org >

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Leon Wright.

This is free software, licensed under:

  The GNU Affero General Public License, Version 3, November 2007

=cut
