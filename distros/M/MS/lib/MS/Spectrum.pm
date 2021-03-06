package MS::Spectrum;

use strict;
use warnings;

use List::Util qw/min max/;
use List::MoreUtils qw/any/;

#use MS::Mass qw/elem_mass/;

# The following methods should be defined by all subclasses

sub id;
sub mz;
sub int;
sub rt; # in seconds
sub ms_level;

sub _binary_search_g {

    # finds closest value >= input

    my ($sorted, $target, $lower, $upper) = @_;

    $lower //= 0;
    $upper //= $#{$sorted};

    return if ($target < $sorted->[$lower]);
    return if ($target > $sorted->[$upper]);

    while ($lower != $upper) {
        my $mid = CORE::int( ($lower+$upper)/2 );
        ($lower,$upper) = $target <= $sorted->[$mid]
            ? ( $lower , $mid   )
            : ( $mid+1 , $upper );
    }

    return $lower;

}

sub _binary_search_l {

    # finds closest value <= target

    my ($sorted, $target, $lower, $upper) = @_;

    $lower //= 0;
    $upper //= $#{$sorted};

    return if ($target < $sorted->[$lower]);
    return if ($target > $sorted->[$upper]);

    while ($lower != $upper) {
        my $mid = CORE::int( ($lower+$upper)/2  +1 );
        ($lower,$upper) = $target < $sorted->[$mid]
            ? ( $lower , $mid-1   )
            : ( $mid , $upper );
    }

    return $lower;

}

sub mz_int_by_range {

    my ($self, @c) = @_;

    my $p = scalar(@c);
    my $mz  = $self->mz;
    my $l = min(map {$_->[0]} @c);
    my $u = max(map {$_->[1]} @c);

    defined (my $idx_l = _binary_search_g($mz, $l) )
        or return ([],[]);

    defined (my $idx_u = _binary_search_l($mz, $u, $idx_l) )
        or return ([],[]);

    my $int = $self->int;

    my @mz_pass;
    my @int_pass;
    for ($idx_l..$idx_u) {
        my $m = $mz->[$_];
        next if (! any {$m >= $_->[0] && $m <= $_->[1]} @c);
        push @mz_pass, $mz->[$_];
        push @int_pass, $int->[$_];
    }

    return (\@mz_pass, \@int_pass);

}

1;

__END__

=head1 NAME

MS::Spectrum - Base class for spectrum objects

=head1 SYNOPSIS

    use MS::Reader::Foo;

    my $reader = MS::Reader::Foo->new('spectra.file');

    while (my $spectrum = $reader->next_spectrum) {
        
        # $spectrum inherits from MS::Spectrum, so you can always do:
        my $id  = $spectrum->id;
        my $rt  = $spectrum->rt;
        my $mz  = $spectrum->mz;
        my $int = $spectrum->int;
        my $lvl = $spectrum->ms_level;

    }

=head1 DESCRIPTION

C<MS::Spectrum> is a base class for spectrum objects generated by file
parsers. It defines a minimum set of methods that subclasses should provide
(currently required but not enforced). Subclasses can (and should) provide
additional methods depending on the information available - see individual
subclass documentation for details.

=head1 METHODS

These methods are required to be defined by subclasses.

=head2 id

Returns the spectrum ID as a string. The ID format is not defined and depends
on the source of the data file.

=head2 rt

Returns the retention time of the spectrum in seconds. Subclasses should
ensure that any necessary conversions are carried out to return a value with
the proper units.

=head2 mz

Returns an reference to an array containing ordered mass/charge values for the
spectrum (must be equal in length to that returned by int() ).

=head2 int

Returns a reference to an array containing ordered intensity values for the
spectrum (must be equal in length to that returned by mz() ).

=head2 ms_level

Returns the MS level (e.g. MS1, MS2) of the spectrum as a positive integer.
Should return undefined if the level cannot be determined from input.

=head2 mz_int_by_range

    my ($mz, $int) = $spectrum->mz_int_by_range(
        [200, 300],
        [500, 600],
    );

A convenience method that takes an array of array references, each containing
a pair of start and end m/z values. Returns two references to arrays of m/z
and intensity values that occur within the specified windows.

=head1 CAVEATS AND BUGS

Please reports bugs to the author.

=head1 AUTHOR

Jeremy Volkening <jdv@base2bio.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2016-2019 Jeremy Volkening

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>.

=cut

