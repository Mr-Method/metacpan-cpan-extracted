package Audio::Daemon::MPG123;

use strict;
use IO::Socket;
use IO::Select;
use Audio::Daemon;

use vars qw(@ISA $VERSION $HAVEPLAY $MIXER);

BEGIN { 
  eval "use Audio::Play::MPG123";
  $HAVEPLAY = $@?0:1;
  eval "use Audio::Mixer";
  $MIXER = $@?0:1;
}

@ISA = qw(Audio::Daemon);
$VERSION='0.99Beta';

sub new {
  my $class = shift;
  die "Cannot find Audio::Play::MPG123" if (! $HAVEPLAY);
  my $self = $class->SUPER::new(@_);
  bless $self, $class;
  # initilize current playlist
  $self->{playlist} = [];
  # initialize random index.
  $self->{random} = [];
  $self->{revrandom} = [];
  # initilize my current states of various things
  $self->{state} = {random => 0, repeat => 0, state => 0};
  return $self;
}

sub player {
  my $self = shift;
  $self->{player} = shift if (scalar @_);
  return $self->{player};
}

sub stop {
  my $self = shift;
  my $player = $self->player;
  $self->{state}{state} = 0;
  $player->stop;
}
  
sub play {
  my $self = shift;
  my $remote = shift;
  my $player = $self->player;
  if (defined $remote && ref $remote && scalar @{$remote->{args}}) {
    if ($self->{state}{random}) {
      $self->{state}{renid} = $self->{revrandom}[$remote->{args}[0]];
      $self->{state}{regid} = $remote->{args}[0];
    }
  } elsif ($player->state == 1) {
    $player->pause; # toggles pause flag (starts playing)
    return;
  }
  $self->debug("Random is ".($self->{state}{random})?'true':'false');
  my $id = $self->{state}{regid};
  $self->info("Setting current playlist id to $id and song to ".$self->{playlist}[$id]);
  if (! -r $self->{playlist}[$id] && ($self->{playlist}[$id]!~/^http/)) {
    $self->crit("File Not Found or Not Readable: ".$self->{playlist}[$id]);
    return;
  }
  my $retval = eval { $player->load($self->{playlist}[$id]); };
  $self->crit($@) if ($@);
  $self->info("load returned $retval");
}

sub pause {
  my $self = shift;
  my $player = $self->player;
  $player->pause;
}

sub add {
  my $self = shift;
  my $remote = shift;
  push @{$self->{playlist}}, @{$remote->{args}};
  # create array of indexes: 
  my @trandom = map { $_ } (0..$#{$self->{playlist}});
  $self->randomize(\@trandom);
  # if we have a "new" list, start playing otherwise continue on
  if (scalar @{$self->{playlist}} == scalar @{$remote->{args}}) {
    if ($self->{state}{random}) {
      $self->{state}{ranid} = 0;
      $self->{state}{regid} = $self->{random}[0];
    } else {
      $self->{state}{regid} = 0;
      $self->{state}{ranid} = $self->{revrandom}[0];
    }
    # $self->debug("Setting regid to ".$self->{state}{regid}." and ranid to ".$self->{state}{ranid});
    $self->play;
  }
}
sub del {
  my $self = shift;
  my $remote = shift;
  my $player = $self->player;
  if ($remote->{args}[0] eq 'all') {
    $self->{playlist} = [];
    $player->stop;
  } elsif (scalar @{$remote->{args}}) {
    my @args = sort { $b <=> $a } @{$remote->{args}};
    foreach my $index (@args) {
      splice(@{$self->{playlist}}, $index, 1);
    }
    my @trandom = map { $_ } (0..$#{$self->{playlist}});
    $self->randomize(\@trandom);
    if (scalar grep {/^$self->{state}{regid}$/} @args) {
      $self->next;
    }
  }
}

sub next {
  my $self = shift;
  my $remote = shift;
  # $self->debug("Random and repeat: ".$self->{state}{random}."/".$self->{state}{repeat});

  my $callplay = 0;
  my $id;
  if ($self->{state}{random}) {
    # $self->debug("Taking random ID ".$self->{state}{ranid}." to move forward on");
    $id = $self->{state}{ranid};
  } else {
    # $self->debug("Taking straight ID ".$self->{state}{regid}." to move forward on");
    $id = $self->{state}{regid};
  }
  $id++;
  if ($id > $#{$self->{playlist}}) {
    # $self->debug("end of playlist found");
    $id = 0;
    if ((ref $remote && $remote->{cmd} eq 'next') || $self->{state}{repeat}) {
      $callplay = 1 if ($self->{state}{state} != 0);
    }
  } else {
    $callplay = 1 if ($self->{state}{state} != 0);
  }
  if ($self->{state}{random}) {
    # $self->debug("assigning $id back to random ID");
    $self->{state}{ranid} = $id;
    $self->{state}{regid} = $self->{random}[$id];
  } else {
    # $self->debug("assigning $id back to regular ID");
    $self->{state}{regid} = $id;
    $self->{state}{ranid} = $self->{revrandom}[$id];
  }
  $self->play if ($callplay);
}

sub prev {
  my $self = shift;
  my $remote = shift;
  # $self->debug("Random and repeat: ".$self->{state}{random}."/".$self->{state}{repeat});

  my $id;
  if ($self->{state}{random}) {
    # $self->debug("Taking random ID ".$self->{state}{ranid}." to move back on");
    $id = $self->{state}{ranid};
  } else {
    # $self->debug("Taking straight ID ".$self->{state}{regid}." to move back on");
    $id = $self->{state}{regid};
  }
  $id--;
  if ($id < 0) {
    # $self->debug("beyond beginning of playlist found");
    $id = $#{$self->{playlist}};
  }
  if ($self->{state}{random}) {
    # $self->debug("assigning $id back to random ID");
    $self->{state}{ranid} = $id;
    $self->{state}{regid} = $self->{random}[$id];
  } else {
    # $self->debug("assigning $id back to regular ID");
    $self->{state}{regid} = $id;
    $self->{state}{ranid} = $self->{revrandom}[$id];
  }
  $self->play if ($self->{state}{state} != 0);
}

sub random {
  my $self = shift;
  my $remote = shift;
  my $oldstate = $self->{state}{random};
  # $self->debug("Trying to set ".($remote->{args}[0]));
  if (scalar @{$remote->{args}}) {
    $self->{state}{random} = ($remote->{args}[0]?1:0);
  }
  if ($oldstate != $self->{state}{random}) {
    if ($self->{state}{random}) {
      $self->info("Turning on Random");
    } else {
      $self->info("Turning off Random");
    }
  }
}

sub repeat {
  my $self = shift;
  my $remote = shift;
  my $oldstate = $self->{state}{repeat};
  if (scalar @{$remote->{args}}) {
    $self->{state}{repeat} = ($remote->{args}[0]?1:0);
  }
  if ($oldstate != $self->{state}{repeat}) {
    if ($self->{state}{repeat}) {
      $self->info("Turning on Repeat");
    } else {
      $self->info("Turning off Repeat");
    }
  }
}

sub list {
  my $self = shift;
  my $remote = shift;
  # $self->debug(join "\n", @{$self->{playlist}});
  $self->{state}{showlist} = 1;
}

sub jump {
  my $self = shift;
  my $remote = shift;
  my $player = $self->player;
  my $move = $remote->{args}[0];
  (my $dval = $move) =~ s/\D//g;
  my $change;
  if ($move =~/^([\+\-]{1})/) {
    $change = $1;
  }
  if ($move =~/s$/i) {
    $dval = ($dval/$player->tpf);
  }
  $change .= $dval;
  $self->info("Jumping: rcvd \"".$remote->{args}[0]."\", sending jump(".$change.")");
  $player->jump($change);
}
    
sub vol {
  my $self = shift;
  my $remote = shift;
  if (scalar @{$remote->{args}} && $MIXER && Audio::Mixer::set_cval('vol', @{$remote->{args}})) {
    $self->error("Cannot set volume: $!");
  }
}

sub get_info {
  my $self = shift;
  my $player = $self->player;
  my @out;
  push @out, "state:".$player->state;
  # 0: stopped   1: Paused  2: Playing
  push @out, "random:".$self->{state}{random};
  push @out, "repeat:".$self->{state}{repeat};
  # push @out, "randomlist:".(join ',', @{$self->{random}});
  # push @out, "revrandomlist:".(join ',', @{$self->{revrandom}});
  # push @out, "randomid:".$self->{state}{ranid};
  push @out, "id:".$self->{state}{regid};
  push @out, "frame:".(join ',', @{$player->{frame}}) if (ref $player->{frame} && scalar @{$player->{frame}});
  push @out, "title:".$player->title;
  push @out, "artist:".$player->artist;
  push @out, "album:".$player->album;
  push @out, "genre:".$player->genre;
  push @out, "url:".$player->url;
  my ($lvol, $rvol) = ($MIXER)?Audio::Mixer::get_cval('vol'):(undef, undef);
  push @out, "vol:$lvol $rvol\n";
  if ($self->{state}{showlist}) {
    push @out, "list:".(join $self->{subsep}, @{$self->{playlist}});
    $self->{state}{showlist} = 0;
  }
  map { $self->debug($_); } @out;
  return \@out;
}

sub mainloop {
  my $self = shift;
  my $socket = $self->socket;
  my $player = $self->player(new Audio::Play::MPG123);
  my $s = IO::Select->new($socket);
  # $self->debug("Starting Main Loop, waiting for instructions");
  while(1) {
    if ($s->can_read(0)) {
      # $self->debug("-------------------------------------");
      my $remote = eval { $self->read_client; };
      if ($@) {
        $self->crit($@);
        next;
      }
      if (! defined $remote) {
        $self->crit("big issue, reading from client came back null");
        next;
      }
      # $self->debug("Rcvd \"".$remote->{cmd}."\" from ".$remote->{ip}.':'.$remote->{port});
      # nextlist
      # prevlist
      my @cmds = qw/add del play next nextlist prev prevlist pause
                    jump stop info list random repeat vol/;
      if (scalar grep {/^$remote->{cmd}$/} @cmds) {
        my $method = '$self->'.$remote->{cmd}.'($remote)';
        eval "$method";
      }
      $self->send_status;
    }
    
    $player->poll(0);
    if ($player->state == 0 && $self->{state}{state} == 2) {
      print "Restarting next song...\n";
      $self->next unless ($self->{state}{regid} == $#{$self->{playlist}} && (! $self->{state}{repeat}));
    } elsif ($player->state == 0) {
      # print "Stopped\n";
    } elsif ($player->state == 1) {
      # print "Paused\n";
    } elsif ($player->state == 2) {
      my ($lvol, $rvol) = Audio::Mixer::get_cval('vol') if ($MIXER);
      my $out = $player->url." $lvol $rvol\n";
      # print "Playing $out";
    }
    if ($self->{state}{state} != $player->state) {
      # $self->debug("State changed from ".$self->{state}{state}." to ".$player->state);
    }
    $self->{state}{state} = $player->state;
  }
}

sub send_status {
  my $self = shift;
  my $socket = $self->socket;
  my $player = $self->{player};
  my $out = $self->get_info;
  my $out = join $self->{sep}, @$out;
  $socket->send($out);
}

__END__

=head1 NAME 

Audio::Daemon::MPG123::Server - The Server portion of Audio::Daemon::MPG123

=head1 SYNOPSIS

  use Audio::Daemon::MPG123::Server;

  # set things up
  my $daemon = new Audio::Daemon::MPG123::Server(Port => 9101);

  # this should never return... it is a daemon after all.
  $server->mainloop;
  
=head1 DESCRIPTION

The Server portion of Audio::Daemon::MPG123, a frontend to a frontend for MPG123.  It is 
kept very seperate to give the user full control over how to daemonize, keep running, 
monitor it, log messages, maintain access control, etc.

=head1 CONSTRUCTORS

There is but one method to contruct a new C<Audio::Daemon::MPG123::Server> object:

=over 4

=item Audio::Daemon::MPG123::Server->new(Port => $port, [Log => \&logsub], [Allow => <allowips>], [Deny => <denyips>]);

The new method can take the following arguments:

=over 4

=item Port

The local port to start listening and accepting commands on.

=item Log

This takes a reference to a function that's called for logging purposes, the format passed in is:

=over 4

<type>, <msg>, [caller(1)]

where <type> is one of debug, info, error, crit, warn.  <msg> is the text message, and [caller] is
the array returned by the second form of the perlfunc caller().  This will give you the method,
line number, etc. of where the messagee is coming from.  With this logging feature, I don't have to worry
about syslog, stdout, or how to report errors or debug info... you do!

=back 4

=item Allow, Deny

Access Control.  If you specify something for the Allow variable, it assumes everything not allowed will
be denied.  If you specify something to denied it assumes everything else is allowed.  Wither neither
set, everything is allowed.  It accepts multple formats all seperated by a comma for multiple entries:

=over 4

=item <ip>/mask

Either set to full 255.255.255.0 format or bitmask format: /24

=item <ip>

just an IP specified

=item <low ip>-<high ip>

For example: 192.168.10.15-192.168.10.44 so anythine between those two addresses would match the rule.

=back 4

=head1 METHODS

=over 4

=item mainloop

Never returns, and in theory, should never exit.

=back

=head1 AUTHOR

Jay Jacobs jayj@cpan.org

=head1 SEE ALSO

Audio::Daemon::MPG123

Audio::Play::MPG123

perl(1).

=cut






