#!/usr/bin/perl -w

# Copyright 2009, 2010, 2011 Kevin Ryde

# This file is part of Chart.
#
# Chart is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3, or (at your option) any later version.
#
# Chart is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along
# with Chart.  If not, see <http://www.gnu.org/licenses/>.


# Usage: perl -I lib devel/generate-indicator-model.pl
#
# Generate and print to stdout the data for IndicatorModelGenerated.pm which
# is a catalogue of available indicator and average names, keys, etc.

use strict;
use warnings;
use ExtUtils::Manifest;
use FindBin;
use Module::Load;
use Module::Util;
use Data::Dumper;
use POSIX ();

my $option_verbose = 0;
if (($ARGV[0]||'') eq '--verbose') {
  $option_verbose = 1;
  shift @ARGV;
}

POSIX::setlocale(POSIX::LC_MESSAGES(), 'C');

my $toplevel_dir = File::Spec->catdir ($FindBin::Bin, File::Spec->updir);
my $manifest_file = File::Spec->catfile ($toplevel_dir, 'MANIFEST');
my $manifest = ExtUtils::Manifest::maniread ($manifest_file);

my @files = keys %$manifest;
@files = grep {m{^lib/App/Chart/Series/Derived/}} @files;
my @modules = map {Module::Util::path_to_module(substr($_,4))} @files;

my @data;
foreach my $module (@modules) {
  if ($option_verbose) { print "# $module\n"; }
  Module::Load::load ($module);

  $module->can('type') || die "$module doesn't have type()";
  my $type = $module->type;

  my $key = $module; $key =~ s/.*:://;

  $module->can('longname') || die "$module doesn't have longname()";
  my $name = $module->longname;

  my $priority = ($module->can('priority') ? $module->priority : 0);

  push @data, [ $key, $name, $priority, $type, $module ];
}

@data = sort {$b->[2] <=> $a->[2]         # decreasing priority
                || $a->[1] cmp $b->[1] }  # increasing name
  @data;

print '# Generated by generate-indicator-model.pl -- DO NOT EDIT

# Copyright 2006, 2007, 2008, 2009, 2010, 2011 Kevin Ryde

# This file is part of Chart.
#
# Chart is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3, or (at your option) any later version.
#
# Chart is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along
# with Chart.  If not, see <http://www.gnu.org/licenses/>.

## no critic
 [
';
foreach my $elem (@data) {
  my ($key, $name, $priority, $type, $module) = @$elem;

  # overloads stay untranslated, leave out "special"s too for now
  $name = dump_str($name);
  if ($type ne 'overload' && $type ne 'special') { $name = "__($name)"; }

  $key = dump_str($key);
  $type = dump_str($type);
  $priority = dump_str($priority);

  print "  { key      => $key,  # $module\n";
  print "    name     => $name,\n";
  print "    type     => $type,\n";
  print "    priority => $priority,\n";
  print "  },\n";
}
print " ]\n";

sub dump_str {
  my ($str) = @_;
  return Data::Dumper->new([$str],[''])->Indent(0)->Terse(1)->Dump;
}

exit 0;
