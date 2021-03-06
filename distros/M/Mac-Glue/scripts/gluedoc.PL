#!perl
use Config;
use File::Basename qw(basename dirname);
use Cwd;

$origdir = cwd;
chdir dirname($0);
$file = basename($0, '.PL');
$file .= '.com' if $^O eq 'VMS';

open OUT,">$file" or die "Can't create $file: $!";

print "Extracting $file (with variable substitutions)\n";

print OUT <<"!GROK!THIS!";
$Config{startperl}
!GROK!THIS!

# In the following, perl variables are not expanded during extraction.

print OUT <<'!NO!SUBS!';
use strict;
use warnings;

BEGIN {
	($Mac::Glue::Common::PROGVERSION) =
		' $Revision: 1.4 $ ' =~ /\$Revision:\s+([^\s]+)/;
	$Mac::Glue::Common::PROGDESC = <<'EOT';
Usage: $PROGNAME [OPTIONS] GLUE

This is a frontend to perldoc.  It searches for the docs of glues used
by Mac::Glue, and feeds them directly to perldoc.

	# same thing
	perldoc Mac::Glue::glues::Finder
	gluedoc Finder

	# open result in BBEdit
	gluedoc -t Finder | bbedit

Main options:
	-h	Help (this message)
	-v	Version
	-d	GLUE is a dialect (usually "AppleScript")
	-a	GLUE is a scripting addition (like "StandardAdditions")
	-L	List available glues

Options for perldoc (see man perldoc for more information):
	-t	text output
	-u	unformatted
	-m	module
	-l	file name only
	-U	run insecurely

EOT
	$Mac::Glue::Common::PROGOPTS = 'hvadLUtuml';
}

use File::Basename;
use File::Spec::Functions;
use Mac::Glue::Common;

my $opts = opts();
usage() if !@ARGV && !$opts->{'L'};

my $switches = [ '-F', map { '-' . $_ } grep { $opts->{$_} } qw(U t u m l) ];

my $glue = lc(shift @ARGV) || '';
(my $glue1 = $glue) =~ tr/ /_/;
(my $glue2 = $glue) =~ tr/_/ /;

my @dirs;
push @dirs, '' if ( (!$opts->{'a'} && !$opts->{'d'}) || $opts->{'L'});
push @dirs, 'additions' if $opts->{'a'} || $opts->{'L'};
push @dirs, 'dialects'  if $opts->{'d'} || $opts->{'L'};

my %list;
OUTER: for my $dir (@dirs) {
	my $d = catfile($MACGLUEDIR, $dir);
	opendir my $dh, $d or die $!;
	for my $f (readdir $dh) {
		if ($opts->{'L'} && $f =~ /\.pod$/) {
			push @{$list{$dir}}, $f;
			next;
		}

		my $file = catfile($d, $f);
		next unless -f $file;		

		for (lc $f) {
			if (/^(?:\Q$glue\E|\Q$glue1\E|\Q$glue2\E)\.pod$/) {
				system('perldoc', @$switches, $file);
				last OUTER;
			}
		}
	}
}

if ($opts->{'L'}) {
	for my $dir (sort keys %list) {
		printf "%s:\n", (ucfirst($dir) || "Glues");
		printf "  %s\n", join "\n  ", map { s/\.pod//; $_ } sort @{$list{$dir}};
		print "\n";
	}
}


__END__
!NO!SUBS!

close OUT or die "Can't close $file: $!";
chmod 0755, $file or die "Can't reset permissions for $file: $!\n";
exec("$Config{'eunicefix'} $file") if $Config{'eunicefix'} ne ':';
chdir $origdir;
