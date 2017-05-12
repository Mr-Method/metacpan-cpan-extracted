package AI::Evolve::Befunge::Critter::Result;
use strict;
use warnings;

use base 'Class::Accessor::Fast';
__PACKAGE__->mk_accessors( qw{ choice died fate moves name score stats tokens won } );

sub new {
    my $package = shift;
    my $self = {
        died         => 0,
        fate         => '',
        moves        => 0,
        score        => 0,
        stats        => {},
        tokens       => 0,
        won          => 0,
        @_
    };
    return bless($self, $package);
}

=head1 NAME

    AI::Evolve::Befunge::Critter::Result - results object


=head1 DESCRIPTION

This object stores the fate of a critter.  It stores whether it died
or lived, what the error message was (if it died), whether it won, and
if it was playing a board game, whether it choose a move.  It also
stores some statistical information about how many moves it made, and
stuff like that.


=head1 CONSTRUCTOR

=head2 new

    Result->new();

Create a new Result object.

=head1 METHODS

Automatically generated accessor methods exist for the following
fields:

=over 4

=item choice

Indicates the choice of positions to play (for board game physics
engines).

=item died

Integer value, true if the critter died.

=item fate

String value, indicates the error message returned by eval, to
indicate the reason for a critter's death.

=item name

Name of the critter, according to its blueprint.

=item score

Integer value supplied by the Physics engine, indicates how well it
thought the critter did.

=item stats

Some additional statistics generated by the run_board_game method in
Physics.pm.

=item tokens

Integer value indicating how much "currency" the critter had left
over.  Higher numbers mean the critter consumed fewer resources.

=item won

Integer value, true if the critter won (as determined by the Physics
engine).

=back


These values may be set using the accessors (like: $result->died(1) ),
or they may be initialized by the constructor (like:
Result->new(died => 1) ).

=cut

1;
