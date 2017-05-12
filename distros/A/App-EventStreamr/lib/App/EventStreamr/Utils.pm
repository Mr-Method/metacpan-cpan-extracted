package App::EventStreamr::Utils;
use Moo;
use IO::Socket::INET; # System Class
use Proc::ProcessTable; # libproc-processtable-perl
use experimental 'switch';
use Data::Dumper;

# ABSTRACT: Utils

our $VERSION = '0.5'; # VERSION: Generated by DZP::OurPkg:Version


sub test {
  my $self = shift;
  $self->{portstate} = port("localhost","1234");
  $self->{get_pid_command} = get_pid_command("video0","ffmpeg -f video4linux2 -s vga -r 25 -i /dev/video0 -target pal-dv - | dvsource-file /dev/stdin -h localhost -p 1234","v4l");
  return;
}

sub port {
  my $self = shift;
  my ($host,$port) = @_;
  my $state;
  my $sock = new IO::Socket::INET ( PeerAddr => $host,
                                    PeerPort => $port,
                                    Proto    => 'tcp'
                                  );
  if ($sock) {
    $state = 1;
    $sock->close;
  } else {
    $state = 0;
  }
  return $state;
}

sub get_pid_state {
  my $self = shift;
  my ($pid) = @_;
  my $return;
  
  $return->{pid} = $pid; 
  $return->{running} = kill 0, $pid;

  return $return;
}

sub get_pid_command {
  my $self = shift;
  my ($id,$command,$type) = @_;
  my $regex;
  my $return;
  
  given ($type) {
    when ("v4l")      { $regex = "ffmpeg.+\\/dev\\/$id.*"; }
    when ("dv")       { $regex = "dvgrab.+$id.*"; }
    when ("stream")   { $regex = "ffmpeg2theora.+--title.$id.+"; }
    when ("mixer")    { $regex = "dvswitch -h 0.0.0.0 -p.+"; }
    default           { $regex = $command }
  }

  # this is hacky.. but it's late and I'm tired!
  $regex = "\\/usr\\/bin\\/plackup.*" if ($id eq 'api');

  my $pt = Proc::ProcessTable->new;
  my @procs = grep { $_->cmndline =~ /$regex/ } @{ $pt->table };
  if (@procs) {
    $return->{pid} = $procs[0]->pid;
    $return->{running} = 1;
  } else {
    $return->{running} = 0;
  }
  
  return $return;
}
1

__END__

=pod

=encoding UTF-8

=head1 NAME

App::EventStreamr::Utils - Utils

=head1 VERSION

version 0.5

=head1 SYNOPSIS

Make Dist::Zilla Happy

=head1 DESCRIPTION

TODO: Remove once port has been grabbed

=head1 AUTHOR

Leon Wright < techman@cpan.org >

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Leon Wright.

This is free software, licensed under:

  The GNU Affero General Public License, Version 3, November 2007

=cut
