# -*- Mode: Perl -*-
#
# Copyright (c) 2001, Bryan Jurish.  All rights reserved.
#
# This package is free software.  You may redistribute it
# and/or modify it under the same terms as Perl itself.
#
package Speech::Rsynth;

use 5.006;
use strict;
use warnings;
use Carp;

require Exporter;
require DynaLoader;
use AutoLoader;

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Speech::Rsynth ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS =
  (
   'const_nsynth' => [qw(
			 ALL_PARALLEL
			 CASCADE_PARALLEL
			 IMPULSIVE
			 NATURAL
			 NPAR
			 PI
			)],
   'const_rflags' => [qw(
			RSY_RUNNING
			RSY_USEAUDIO
		       )],
   'const_aufile' => [qw(
			 SUN_HDRSIZE
			 SUN_LIN_16
			 SUN_LIN_8
			 SUN_MAGIC
			 SUN_ULAW
			 SUN_UNSPEC
			)],
		   );

$EXPORT_TAGS{const} =[
		      @{$EXPORT_TAGS{const_nsynth}},
		      @{$EXPORT_TAGS{const_rflags}},
		      @{$EXPORT_TAGS{const_aufile}},
		     ];

$EXPORT_TAGS{all} = [
		     @{$EXPORT_TAGS{const}}
		    ];

our @EXPORT_OK = ( @{$EXPORT_TAGS{'all'}} );

our @EXPORT = qw();

our $VERSION = '0.03';


sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "& not defined" if $constname eq 'constant';
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/ || $!{EINVAL}) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    croak "Your vendor has not defined Speech::Rsynth macro $constname";
	}
    }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
	if ($] >= 5.00561) {
	    *$AUTOLOAD = sub () { $val };
	}
	else {
	    *$AUTOLOAD = sub { $val };
	}
    }
    goto &$AUTOLOAD;
}

bootstrap Speech::Rsynth $VERSION;

# Preloaded methods go here.

#-----------------------------------------------------------------------
# List of field-accessor subs
#   + (here only hand-written accessors (perl only))
#-----------------------------------------------------------------------
our @ACCESSORS = qw(use_audio running);

#-----------------------------------------------------------------------
# Constructor (wrapper)
#-----------------------------------------------------------------------
# $rs = Speech::Rsynth->new(%args);
#  + keyword %args as for 'configure()'
sub new {
  my $proto = shift;
  my ($self);
  if (ref($proto)) {
    $self = ref($proto)->New();
    $self->configure($proto->configure,@_);
  } else {
    $self = $proto->New();
    $self->configure(@_);
  }
  return $self;
}

#-----------------------------------------------------------------------
# Wrappers: start/stop
#-----------------------------------------------------------------------
*start = \&Start;
*stop = \&Stop;
*say_string = \&Say_String;
*say_file = \&Say_File;

#-----------------------------------------------------------------------
# Accessors: Flags
#-----------------------------------------------------------------------
# $bool = $rs->use_audio();
# $rs->use_audio($bool);
sub use_audio {
  my $rs = shift;
  if (exists($_[0])) {
    $rs->set_flags($_[0]
		   ? $rs->get_flags | &RSY_USEAUDIO
		   : $rs->get_flags & ~&RSY_USEAUDIO);
  }
  return $rs->get_flags & &RSY_USEAUDIO != 0;
}

# $bool = $rs->running();
# $rs->running($bool);
sub running {
  my $rs = shift;
  if (exists($_[0])) {
    if ($_[0]) { $rs->Start; }
    else { $rs->Stop; }
  }
  return $rs->get_flags & &RSY_RUNNING != 0;
}


#-----------------------------------------------------------------------
# Configuration
#-----------------------------------------------------------------------

# %hash = $rs->configure(), %hash = $rs->configure($name=>$val,...)
sub configure {
  my ($rs,%args) = @_;
  my ($code);
  if (%args) {
    # set stuff
    my ($k,$v);
    while (($k,$v) = each(%args)) {
      if ( defined($code = $rs->can("set_$k")) || defined($code = $rs->can($k)) ) {
	&$code($rs,$v);
      } else {
	carp( __PACKAGE__ . "::configure() warning: ignoring unknown field '$k'");
      }
    }
  }
  # get stuff
  return
    map {
      ($_ => (defined($code = $rs->can("get_$_"))
	      ? &$code($rs)
	      : $rs->$_()))
    } @ACCESSORS;
}

#-----------------------------------------------------------------------
# @ACCESSORS:
#  + List of object properties (auto-generated)
#-----------------------------------------------------------------------
push(@ACCESSORS,
     # auto-generated-accessors:
     qw(
	flags
	verbose
	help_only
	samp_rate
	dev_filename
	linear_filename
	au_filename
	dev_fd
	linear_fd
	au_fd
	mSec_per_frame
	impulse
	casc
	klatt_f0_flutter
	klatt_tilt_db
	klatt_f0_hz
	speed
	frac
	par_name
	jsru_name
	dict_path
	),
    );

#-----------------------------------------------------------------------
# Accessor wrappers go here!
#-----------------------------------------------------------------------
sub flags { return $#_ > 0 ? $_[0]->set_flags($_[1]) : $_[0]->get_flags(); }
sub verbose { return $#_ > 0 ? $_[0]->set_verbose($_[1]) : $_[0]->get_verbose(); }
sub help_only { return $#_ > 0 ? $_[0]->set_help_only($_[1]) : $_[0]->get_help_only(); }
sub samp_rate { return $#_ > 0 ? $_[0]->set_samp_rate($_[1]) : $_[0]->get_samp_rate(); }
sub dev_filename { return $#_ > 0 ? $_[0]->set_dev_filename($_[1]) : $_[0]->get_dev_filename(); }
sub linear_filename { return $#_ > 0 ? $_[0]->set_linear_filename($_[1]) : $_[0]->get_linear_filename(); }
sub au_filename { return $#_ > 0 ? $_[0]->set_au_filename($_[1]) : $_[0]->get_au_filename(); }
sub dev_fd { return $#_ > 0 ? $_[0]->set_dev_fd($_[1]) : $_[0]->get_dev_fd(); }
sub linear_fd { return $#_ > 0 ? $_[0]->set_linear_fd($_[1]) : $_[0]->get_linear_fd(); }
sub au_fd { return $#_ > 0 ? $_[0]->set_au_fd($_[1]) : $_[0]->get_au_fd(); }
sub mSec_per_frame { return $#_ > 0 ? $_[0]->set_mSec_per_frame($_[1]) : $_[0]->get_mSec_per_frame(); }
sub impulse { return $#_ > 0 ? $_[0]->set_impulse($_[1]) : $_[0]->get_impulse(); }
sub casc { return $#_ > 0 ? $_[0]->set_casc($_[1]) : $_[0]->get_casc(); }
sub klatt_f0_flutter { return $#_ > 0 ? $_[0]->set_klatt_f0_flutter($_[1]) : $_[0]->get_klatt_f0_flutter(); }
sub klatt_tilt_db { return $#_ > 0 ? $_[0]->set_klatt_tilt_db($_[1]) : $_[0]->get_klatt_tilt_db(); }
sub klatt_f0_hz { return $#_ > 0 ? $_[0]->set_klatt_f0_hz($_[1]) : $_[0]->get_klatt_f0_hz(); }
sub speed { return $#_ > 0 ? $_[0]->set_speed($_[1]) : $_[0]->get_speed(); }
sub frac { return $#_ > 0 ? $_[0]->set_frac($_[1]) : $_[0]->get_frac(); }
sub par_name { return $#_ > 0 ? $_[0]->set_par_name($_[1]) : $_[0]->get_par_name(); }
sub jsru_name { return $#_ > 0 ? $_[0]->set_jsru_name($_[1]) : $_[0]->get_jsru_name(); }
sub dict_path { return $#_ > 0 ? $_[0]->set_dict_path($_[1]) : $_[0]->get_dict_path(); }




# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

#-----------------------------------------------------------------------
# PODs: Header
#-----------------------------------------------------------------------
=pod

=head1 NAME

Speech::Rsynth --
Perl interface to 'librsynth' Klatt-style speech synthesis C library.

=head1 SYNOPSIS

  use Speech::Rsynth;
{
  # Constructor
  $rs = Speech::Rsynth->new(%cfg);         # create a new synth object

  # Synthesis
  $rs->start;                              # start synthesis
  $rs->say_string("test 1 2 3");           # synthesize string
  $rs->say_file(STDIN);                    # synthesize a whole file
  $rs->stop;                               # stop synthesis (synchronizes)

  # Configuration
  %cfg = $rs->configure;                   # get all synth configuration data
  $rs->configure(%cfg);                    # set (partial) synth configuration

  # Accessors : Flags
  $bool = $rs->use_audio;  $rs->use_audio($bool);   # do/don't send to audio device
  $bool = $rs->running;    $rs->running($bool);     # get/set active-flag

  # Accessors : General
  $level = $rs->verbose;   $rs->verbose($level);    # get/set verbosity level
  $bool = $rs->help_only;  $rs->help_only($bool);   # get/set help-flag

  # Accessors: Audio Properties
  $hertz = $rs->samp_rate; $rs->samp_rate($hertz);  # get/set sample-rate

  # Accessors: Audio Filenames
  $file = $rs->dev_file;    $rs->dev_file($file);     # get/set audio device filename
  $file = $rs->linear_file; $rs->linear_file($file);  # get/set raw linear filename
  $file = $rs->au_file;     $rs->au_file($file);      # get/set Sun/NeXT filename

  # Accessors: File Descriptors
  $fd = $rs->dev_fd;        $rs->dev_fd($fd);         # get/set audio device fd
  $fd = $rs->linear_fd;     $rs->linear_fd($fd);      # get/set raw linear fd
  $fd = $rs->au_fd;         $rs->au_fd($fd);          # get/set Sun/NeXT fd

  # Accessors: Klatt Guts
  $ms = $rs->mSec_per_Frame;   $rs->mSec_per_Frame($ms);  # milliseconds per frame
  $bool = $rs->impulse;        $rs->impulse($bool);       # impulse glottal source
  $n = $rs->casc;              $rs->casc($n);             # number cascade formants
  $n = $rs->klatt_f0_flutter;  $rs->klatt_f0_flutter($n); # F0 flutter
  $dB = $rs->klatt_tilt_db;    $rs->klatt_tilt_db($dB);   # tilt dB
  $hz = $rs->klatt_f0_hz;      $rs->klatt_f0_hz($hz);     # F0 base frequency

  # Accessors: Holmes
  $n = $rs->speed;             $rs->speed($n);            # speed (1.0 is 'normal')
  $f = $rs->frac;              $rs->frac($f);             # parameter filter 'fraction'
  $file = $rs->par_name;       $rs->par_name($file);      # parameter filename for plot
  $file = $rs->jsru_name;      $rs->jsru_name($file);     # plot file for alternate synth (JSRU)

  # Accessors: Dictionary
  $path = $rs->dict_path;      $rs->dict_path($path);     # full path to GDBM dictionary file

  # Accessors: low-level
  $flags = $rs->flags;         $rs->flags($flags);        # get/set flags mask

=cut

#-----------------------------------------------------------------------
# Description
#-----------------------------------------------------------------------
=pod

=head1 DESCRIPTION

Speech::Rsynth is a Perl OO interface to my adaptation of Nick Ing-Simmons'
"rsynth" speech synthesizer package, itself based on Jon Iles' implementation
of a Klatt formant synthesizer.  It currently provides only basic Text-to-Speech
(TTS) capabilities, with output to file(s) of several formats, as well as
directly to an audio device.

Currently tested only under linux.

=cut

#-----------------------------------------------------------------------
# Exports
#-----------------------------------------------------------------------
=pod

=head2 EXPORTS

A number constants may be exported; they are listed here by tag.

=over 4

=item * :const_nsynth

Constants from 'nsynth.h'.

 ALL_PARALLEL
 CASCADE_PARALLEL
 IMPULSIVE
 NATURAL
 NPAR
 PI

=item * :const_rflags

Constants from 'rstruct.h' -- can be used for the 'flags' accessor/keyword.

 RSY_RUNNING
 RSY_USEAUDIO

=item * :const_aufile

Constants from 'aufile.c'.

 SUN_HDRSIZE
 SUN_LIN_16
 SUN_LIN_8
 SUN_MAGIC
 SUN_ULAW
 SUN_UNSPEC

=item * :const

Exports the contents of all of the above 'const_*' tags.

=back

=cut

#-----------------------------------------------------------------------
# Methods
#-----------------------------------------------------------------------
=pod

=head1 METHODS

=cut

#-----------------------------------------------------------------------
# Constructor
#-----------------------------------------------------------------------
=pod

=head2 Constructor

=over 4

=item * new(%args)

Create and return a new Speech::Rsynth object, initializing it
according to the keyword-argments in '%args'.  See
L</Accessors> for a list of valid keyword arguments for %args.

=back

=cut

#-----------------------------------------------------------------------
# Synthesis
#-----------------------------------------------------------------------
=pod

=head2 Synthesis

=over 4

=item * start()

Start the synthesizer.  This method must be called first
if the 'say_*' methods are to produce any useful result.

=item * say_string($string)

Synthesize speech from the text string $string, which may contain
literal phone-strings enclosed in square brackets.  See the
librsynth documentation for details on recognized phone encodings.

=item * say_file(FILEHANDLE)

Synthesize speech from the text from FILEHANDLE, which should
be a Perl filehandle open for reading.

=item * stop()

Stops the synthesizer and synchronizes all its data files.
Note that these files will be overwritten if the synthesizer
is subsequently re-started.

=back

=cut

#-----------------------------------------------------------------------
# Configuration
#-----------------------------------------------------------------------
=pod

=head2 Configuration

=over 4

=item * configure(%cfg)

With arguments, sets the object fields named by the keyword arguments to
the indicated values.  With or without arguments, returns a hash containing
all accessible field values indexed by field names.

See L</Accessors> for details on accessible fields.

=back

=cut

#-----------------------------------------------------------------------
# Accessors
#-----------------------------------------------------------------------
=pod

=head2 Accessors

The following is a list of accessible fields of Speech::Rsynth objects.
Fields may be read out individually for a Speech::Rsynth object
$rs by calling $rs-E<gt>NAME(), where NAME is the field name, and may be
set individually by calling $rs-E<gt>NAME($new_value).  The field names
also function as keyword arguments to the new() and configure() methods,
described above.

=over 4

=cut

# Keywords: Flags
=pod

=item * use_audio

 Type: boolean

Whether or not to output directly to the audio device.
Default=no.


=item * running

 Type=boolean

Whether or not to start() the synth immediately.
Default=no.

=cut

# Keywords: General
=pod

=item * verbose

 Type: integer

Verbosity level.
Default=0.

=item * help_only

 Type: boolean

Whether or not only help messages should be printed.  Default=0.

=cut

# Audio Properties
=pod

=item * samp_rate

 Type: integer

Sample rate in Hz.  Default=8000.

=cut

# Audio Filenames
=pod

=item * dev_file

 Type: string

Audio device filename.  Default="/dev/dsp".

=item * linear_file

 Type: string

Filename for raw linear output.  Default=undef (none).

=item * au_file

 Type: string

Filename for Sun/NeXT output. Default=undef (none).

=cut

# File Descriptors
=pod

=item * dev_fd

 Type: integer

File descriptor for audio device.
Default=-1 (none).

=item * linear_fd

 Type: integer

File descriptor for raw linear file.
Default=-1 (none).

=item * au_fd

File descriptor for Sun/NeXT file
Default=-1 (none).

=cut


# Klatt Guts
=pod

=item * mSec_per_Frame

 Type: integer

milliseconds per frame.
Default=10.

=item * impulse

 Type: boolean

impulse glottal source.
Default=0.

=item * casc

 Type: integer

number cascade formants.
Default=0.

=item * klatt_f0_flutter

 Type: integer

F0 flutter.
Default=0.

=item * klatt_tilt_db

 Type: integer

tilt dB.
Default=10.

=item * klatt_f0_hz

 Type: integer

F0 base frequency.
Default=1330.

=cut

# Accessors: Holmes
=pod

=item * speed

 Type: integer

speed (1.0 is 'normal').
Default=1.

=item * frac

 Type: float

parameter filter 'fraction'.
Default=1.0.

=item * par_name

 Type: string

parameter filename for plot.
Default=undef (none).

=item * jsru_name

 Type: string

plot file for alternate synth (JSRU).
Default=undef (none).

=cut

# Dictionary
=pod

=item * dict_path

 Type: string

full path to GDBM dictionary file.
Default=undef (none).

=cut

# low-level
=pod

=item * flags

 Type: integer (mask)

mask of synth status flags.
default=0.

=back

=cut

#-----------------------------------------------------------------------
# Bugs
#-----------------------------------------------------------------------
=pod

=head1 BUGS AND LIMITATIONS

There are still some globals left in librsynth which may interfere
with multiple synths running simultaneously.

The filename fields should disappear, and the fd fields should
be replaced by something perl-friendly, like filehandles.

More control over synthesis-time parameters would be real nice.

Probably many, many more.

=cut


#-----------------------------------------------------------------------
# Footer
#-----------------------------------------------------------------------
=head1 ACKNOWLEDGEMENTS

perl by Larry Wall.

"say" program and original rsynth package by Nick Ng-Simmons.

=head1 AUTHOR

Bryan Jurish E<lt>moocow@ling.uni-potsdam.deE<gt>

=head1 SEE ALSO

perl(1).
say(1).

=cut
