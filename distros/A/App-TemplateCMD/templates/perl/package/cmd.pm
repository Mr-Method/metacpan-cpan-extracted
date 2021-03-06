[% IF not vars %][% vars = [ 'search' ] %][% END -%]
[% IF not module -%]
    [%- IF out.match('^lib') -%]
        [%- out = out.replace('lib/', '') -%]
        [%- out = out.replace('[.]pm', '') -%]
        [%- out = out.replace('/', '::', 1) -%]
        [%- module = out -%]
    [%- END -%]
[% END -%]
[% IF not module %][% module = 'Module::Name' %][% END -%]
[% IF not version %][% version = '0.0.1' %][% END -%]
package [% module %];

# Created on: [% date %] [% time %]
# Create by:  [% contact.fullname or user %]
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

[% IF moose -%]
use Moose;
use namespace::autoclean;
[% ELSE -%]
use strict;
use warnings;
[% END -%]
use version;
use Carp;
use Getopt::Long;
use Pod::Usage ();
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
[%- IF moose %]

extends 'Some::Thing';
[%- ELSE %]
use base qw/Exporter/;
[%- END %]

our $VERSION  = 0.7;
our ($name)   = $PROGRAM_NAME =~ m{^.*/(.*?)$}mxs;
our %option;
our %p2u_extra;

sub run {
    my ($self) = @_;

    Getopt::Long::Configure('bundling');
    GetOptions(
        \%option,
        'extra|e',
        'verbose|v+',
        'man',
        'help',
        'VERSION!',
    ) or Pod::Usage::pod2usage(
        -verbose => 1,
        -input   => __FILE__,
        %p2u_extra,
    ) and return 1;

    if ( $option{'VERSION'} ) {
        print "$name Version = $VERSION\n";
        return 0;
    }
    elsif ( $option{'man'} ) {
        Pod::Usage::pod2usage(
            -verbose => 2,
            -input   => __FILE__,
            %p2u_extra,
        );
        return 2;
    }
    elsif ( $option{'help'} ) {
        Pod::Usage::pod2usage(
            -verbose => 1,
            -input   => __FILE__,
            %p2u_extra,
        );
        return 1;
    }

    # do stuff here

    return 0;
}


1;

 =__END__

=head1 NAME

[% module %] - <One-line description of module's purpose>

[% INCLUDE perl/pod/VERSION.pl %]
[% INCLUDE perl/pod/SYNOPSIS.pl %]
[% INCLUDE perl/pod/DESCRIPTION.pl %]
[% INCLUDE perl/pod/METHODS.pl %]

[% IF !moose -%]
[% INCLUDE perl/pod.pl return => exit, sub => 'run' -%]
[% END %]

[% INCLUDE perl/pod/detailed.pl %]
=head1 AUTHOR

[% contact.fullname %] - ([% contact.email %])

=head1 LICENSE AND COPYRIGHT
[% INCLUDE licence.txt %]
=cut
