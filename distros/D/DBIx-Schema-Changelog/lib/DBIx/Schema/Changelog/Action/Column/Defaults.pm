package DBIx::Schema::Changelog::Action::Column::Defaults;

=head1 NAME

DBIx::Schema::Changelog::Action::Column::Defaults - Handle default values for table columns

=head1 VERSION

Version 0.9.0


=cut

our $VERSION = '0.9.0';

use utf8;
use strict;
use warnings;
use Moose;
use MooseX::HasDefaults::RO;

use DBIx::Schema::Changelog::Action::Sequences;

with 'DBIx::Schema::Changelog::Role::Action';

has sequences => (
    lazy    => 1,
    does    => 'DBIx::Schema::Changelog::Role::Action',
    default => sub {
        my $self = shift;
        DBIx::Schema::Changelog::Action::Sequences->new(
            driver => $self->driver(),
            dbh    => $self->dbh()
        );
    },
);

=head1 SUBROUTINES/METHODS

=over 4

=item add 
    
    Generate and define default values for column

=cut

sub add {
    my ( $self, $params ) = @_;

    return '' if ( !defined $params->{default} );
    my $defaults       = $self->driver()->defaults;
    my $default_by_key = $defaults->{ $params->{default} };

    unless ($default_by_key) {
        return 'DEFAULT ' . $params->{default}
          if ( $params->{default} =~ m/^''$/ );
        return 'DEFAULT ' . $self->driver()->convert_defaults($params);
    }

    if ( $params->{default} eq 'inc' ) {
        return $self->sequences->add($params)
          if ( $defaults->{ $params->{default} } eq 'sequence' );
        return $defaults->{ $params->{default} };
    }
    elsif ( defined $defaults->{ $params->{default} } ) {
        return 'DEFAULT ' . $defaults->{ $params->{default} };
    }
    return '';
}

=item alter 
    
Not needed!

=cut

sub alter { }

=item drop 
    
Not needed!

=cut

sub drop { }

=item list_from_schema 
    
Not needed!

=cut

sub list_from_schema { }

no Moose;

__PACKAGE__->meta->make_immutable;

1;

__END__

=back

=head1 AUTHOR

Mario Zieschang, C<< <mziescha at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Mario Zieschang.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, trade name, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANT ABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut
