##############################################################################
#
#  Data::Tools perl module
#  2013-2019 (c) Vladi Belperchinov-Shabanski "Cade"
#  http://cade.datamax.bg
#  <cade@bis.bg> <cade@biscom.net> <cade@datamax.bg> <cade@cpan.org>
#
#  GPL
#
##############################################################################
package Data::Tools::Time;
use strict;
use Exporter;
use Carp;
use Data::Tools;
use Date::Calc;
use Time::JulianDay;

our $VERSION = '1.20';

our @ISA    = qw( Exporter );
our @EXPORT = qw(

                unix_time_diff_in_words
                unix_time_diff_in_words_relative
    
                julian_date_diff_in_words
                julian_date_diff_in_words_relative

                julian_date_add_ymd
                julian_date_to_ymd
                julian_date_from_ymd
                julian_date_goto_first_dom
                julian_date_goto_last_dom
                julian_date_get_dow
                julian_date_month_days_ym
                julian_date_month_days

                );

our %EXPORT_TAGS = (
                   
                   'all'  => \@EXPORT,
                   'none' => [],
                   
                   );

##############################################################################

sub unix_time_diff_in_words
{
  my $utd = abs( int( shift() ) ); # absolute difference in seconds

  if( $utd < 1 )
    {
    return "now";
    }
  if( $utd < 60   ) # less than 1 minute
    {
    my $ss = str_countable( $utd, "second", "seconds" );
    return "$utd $ss";
    };
  if( $utd < 60*60 ) # less than 1 hour
    {
    my $m  = int( $utd / 60 );
    my $ms = str_countable( $m, "minute", "minutes" );
    return "$m $ms";
    };
  if( $utd < 2*24*60*60 ) # less than 2 days (48 hours)
    {
    my $h = int( $utd / ( 60 * 60 ) );
    my $m = int( $utd % ( 60 * 60 ) / 60 );
    my $hs = str_countable( $h, "hour",   "hours"   );
    my $ms = str_countable( $m, "minute", "minutes" );
    return "$h $hs, $m $ms";
    };
  if( $utd < 7*24*60*60 ) # less than 1 week (168 hours)
    {
    my $d  = int( $utd / ( 24 * 60 * 60 ) );
    my $h  = int( $utd % ( 24 * 60 * 60 ) / ( 60 * 60 ) );
    my $ds = str_countable( $d, "day",    "days"    );
    my $hs = str_countable( $h, "hour",   "hours"   );
    return "$d $ds, $h $hs";
    };
  if( $utd < 60*24*60*60 ) # less than 2 months
    {
    my $d  = int( $utd / ( 24 * 60 * 60 ) );
    my $ds = str_countable( $d, "day",    "days"    );
    return "$d $ds";
    };
  if( 42 ) # more than 2 months
    {
    my $m  = int( $utd / ( 30*24*60*60 ) ); # "month" is approximated to 30 days
    my $ms = str_countable( $m, "month", "months" );
    return "$m $ms";
    }
}

sub unix_time_diff_in_words_relative
{
  my $utd = int( shift() ); # relative difference in seconds

  my $uts = unix_time_diff_in_words( $utd );

  if( $utd < 0 )
    {
    return "in $uts";
    }
  elsif( $utd > 0 )
    {
    return "before $uts";
    }
  else
    {
    return $uts;
    }
}

##############################################################################

sub julian_date_diff_in_words
{
  my $jdd  = abs( int( shift() ) ); # absolute difference in days

  if( $jdd < 90 )
    {
    my $d  = int( $jdd );
    my $ds = str_countable( $d, "day", "days" );
    return "$d $ds";
    }
  if( 42 )
    {
    my $m  = int( $jdd / 30 );
    my $ms = str_countable( $m, "month", "months" );
    return "$m $ms";
    };
}

sub julian_date_diff_in_words_relative
{
  my $jdd = int( shift() ); # relative difference in days

  if( $jdd == 0 )
    {
    return "today";
    }
  if( $jdd == -1 )
    {
    return "tomorrow";
    }
  if( $jdd == +1 )
    {
    return "yesterday";
    }

  my $jds = julian_date_diff_in_words( $jdd );
  if( $jdd < 0 )
    {
    return "in $jds";
    }
  elsif( $jdd > 0 )
    {
    return "before $jds";
    }
  else
    {
    return $jds;
    }
}

##############################################################################

# return julian date, moved with positive or negative deltas ( y, m, d ) 
sub julian_date_add_ymd
{
  my $wd = shift; # original/work date
  my $dy = shift; # add delta year
  my $dm = shift; # add delta month
  my $dd = shift; # add delta day

  my ( $y, $m, $d ) = inverse_julian_day( $wd );

  ( $y, $m, $d ) = Date::Calc::Add_Delta_YMD( $y, $m, $d, $dy, $dm, $dd );

  $wd = julian_day( $y, $m, $d );

  return $wd;

}

# return ( year, month, day ) from julian date
sub julian_date_to_ymd
{
  my $wd = shift; # original/work date

  my ( $y, $m, $d ) = inverse_julian_day( $wd );
  return ( $y, $m, $d );
}

# return julian date from ( year, month, day )
sub julian_date_from_ymd
{
  my $y = shift; # set year
  my $m = shift; # set month
  my $d = shift; # set day

  my $wd = julian_day( $y, $m, $d );
  return $wd;
}

# return julian date, moved to the first day of its month
sub julian_date_goto_first_dom
{
  my $wd = shift; # original/work date

  my ( $y, $m, $d ) = julian_date_to_ymd( $wd );
  return julian_date_from_ymd( $y, $m, 1 );
}

# return julian date, moved to the last day of its month
sub julian_date_goto_last_dom
{
  my $wd = shift; # original/work date

  my ( $y, $m, $d ) = julian_date_to_ymd( $wd );
  return julian_date_from_ymd( $y, $m, Date::Calc::Days_in_Month( $y, $m ) );
}

# return day of the week, for julian date -- 0 Sun .. 6 Sat
sub julian_date_get_dow
{
  my $d = shift; # original date

  return day_of_week( $d );
}

# return month days count for given ( year, month ) (not strictly julian_ namespace)
sub julian_date_month_days_ym
{
  my $y = shift; # set year
  my $m = shift; # set month

  return Date::Calc::Days_in_Month( $y, $m );
}

# return month days count for given julian date
sub julian_date_month_days
{
  my $d = shift;

  return Date::Calc::Days_in_Month( ( julian_date_to_ymd( $d ) )[0,1] );
}

##############################################################################

=pod


=head1 NAME

  Data::Tools::Time provides set of basic functions for time processing.

=head1 SYNOPSIS

  use Data::Tools::Time qw( :all );  # import all functions
  use Data::Tools::Time;             # the same as :all :) 
  use Data::Tools::Time qw( :none ); # do not import anything

  # --------------------------------------------------------------------------

  my $time_diff_str     = unix_time_diff_in_words( $time1 - $time2 );
  my $time_diff_str_rel = unix_time_diff_in_words_relative( $time1 - $time2 );

  # --------------------------------------------------------------------------
    
  my $date_diff_str     = julian_date_diff_in_words( $date1 - $date2 );
  my $date_diff_str_rel = julian_date_diff_in_words_relative( $date1 - $date2 );

  # --------------------------------------------------------------------------
  
  # gets current julian date, needs Time::JulianDay
  my $jd = local_julian_day( time() );

  # move current julian date to year ago, one month ahead and 2 days ahead
  $jd = julian_date_add_ymd( $jd, -1, 1, 2 );

  # get year, month and day from julian date
  my ( $y, $m, $d ) = julian_date_to_ymd( $jd );

  # get julian date from year, month and day
  $jd = julian_date_from_ymd( $y, $m, $d );

  # move julian date ($jd) to the first day of its current month
  $jd = julian_date_goto_first_dom( $jd );

  # move julian date ($jd) to the last day of its current month
  $jd = julian_date_goto_last_dom( $jd );

  # get day of week for given julian date ( 0 => Mon .. 6 => Sun )
  my $dow = julian_date_get_dow( $jd );
  print( ( qw( Mon Tue Wed Thu Fri Sat Sun ) )[ $dow ] . "\n" );

  # get month days count for the given julian date's month
  my $mdays = julian_date_month_days( $jd );

  # get month days count for the given year and month
  my $mdays = julian_date_month_days_ym( $y, $m );

=head1 FUNCTIONS

=head2 unix_time_diff_in_words( $unix_time_diff )

Returns human-friendly text for the given time difference (in seconds).
This function returns absolute difference text, for relative 
(before/after/ago/in) see unix_time_diff_in_words_relative().

=head2 unix_time_diff_in_words_relative( $unix_time_diff )

Same as unix_time_diff_in_words() but returns relative text
(i.e. with before/after/ago/in)

=head2 julian_date_diff_in_words( $julian_date_diff );

Returns human-friendly text for the given date difference (in days).
This function returns absolute difference text, for relative 
(before/after/ago/in) see julian_day_diff_in_words_relative().

=head2 julian_date_diff_in_words_relative( $julian_date_diff );

Same as julian_date_diff_in_words() but returns relative text
(i.e. with before/after/ago/in)

=head1 TODO

  * support for language-dependent wording (before/ago)
  * support for user-defined thresholds (48 hours, 2 months, etc.)

=head1 REQUIRED MODULES

Data::Tools::Time uses:

  * Data::Tools (from the same package)
  * Date::Calc
  * Time::JulianDay

=head1 TEXT TRANSLATION NOTES

time/date difference wording functions does not have translation functions
and return only english text. This is intentional since the goal is to keep
the translation mess away but still allow simple (yet bit strange) 
way to translate the result strings with regexp and language hash:
  
  my $time_diff_str_rel = unix_time_diff_in_words_relative( $time1 - $time2 );
  
  my %TRANS = (
              'now'       => 'sega',
              'today'     => 'dnes',
              'tomorrow'  => 'utre',
              'yesterday' => 'vchera',
              'in'        => 'sled',
              'before'    => 'predi',
              'year'      => 'godina',
              'years'     => 'godini',
              'month'     => 'mesec',
              'months'    => 'meseca',
              'day'       => 'den',
              'days'      => 'dni',
              'hour'      => 'chas',
              'hours'     => 'chasa',
              'minute'    => 'minuta',
              'minutes'   => 'minuti',
              'second'    => 'sekunda',
              'seconds'   => 'sekundi',
              );
              
  $time_diff_str_rel =~ s/([a-z]+)/$TRANS{ lc $1 } || $1/ge;

I know this is no good for longer sentences but works fine in this case.

=head1 GITHUB REPOSITORY

  git@github.com:cade-vs/perl-data-tools.git
  
  git clone git://github.com/cade-vs/perl-data-tools.git
  
=head1 AUTHOR

  Vladi Belperchinov-Shabanski "Cade"

  <cade@bis.bg> <cade@biscom.net> <cade@datamax.bg> <cade@cpan.org>

  http://cade.datamax.bg


=cut

##############################################################################
1;
