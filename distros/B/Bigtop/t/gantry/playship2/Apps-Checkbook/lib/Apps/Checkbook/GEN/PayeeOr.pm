# NEVER EDIT this file.  It was generated and will be overwritten without
# notice upon regeneration of this application.  You have been warned.
package Apps::Checkbook::GEN::PayeeOr;

use strict;
use warnings;

use base 'Apps::Checkbook';
use JSON;
use Gantry::Utils::TablePerms;

use Apps::Checkbook::Model::payee qw(
    $PAYEE
);

#-----------------------------------------------------------------
# $self->do_main(  )
#-----------------------------------------------------------------
sub do_main {
    my ( $self ) = @_;

    $self->stash->view->template( 'results.tt' );
    $self->stash->view->title( 'Payees' );

    my $real_location = $self->location() || '';
    if ( $real_location ) {
        $real_location =~ s{/+$}{};
        $real_location .= '/';
    }

    my @header_options = (
        {
            text => 'Add',
            link => $real_location . "add",
            type => 'create',
        },
    );

    my $retval = {
        headings       => [
            'Name',
        ],
    };

    my $params = $self->params;

    my $search = {};
    if ( $params->{ search } ) {
        my $form = $self->form();

        my @searches;
        foreach my $field ( @{ $form->{ fields } } ) {
            if ( $field->{ searchable } ) {
                push( @searches,
                    ( $field->{ name } => { 'like', "%$params->{ search }%"  } )
                );
            }
        }

        $search = {
            -or => \@searches
        } if scalar( @searches ) > 0;
    }

    my @row_options = (
        {
            text => 'Edit',
            type => 'update',
        },
        {
            text => 'Delete',
            type => 'delete',
        },
    );

    my $perm_obj = Gantry::Utils::TablePerms->new(
        {
            site           => $self,
            real_location  => $real_location,
            header_options => \@header_options,
            row_options    => \@row_options,
        }
    );

    $retval->{ header_options } = $perm_obj->real_header_options;

    my $limit_to_user_id = $perm_obj->limit_to_user_id;
    $search->{ user_id } = $limit_to_user_id if ( $limit_to_user_id );

    my @rows = $PAYEE->get_listing();

    ROW:
    foreach my $row ( @rows ) {
        last ROW if $perm_obj->hide_all_data;

        my $id = $row->id;

        push(
            @{ $retval->{rows} }, {
                orm_row => $row,
                data => [
                    $row->name,
                ],
                options => $perm_obj->real_row_options( $row ),
            }
        );
    }

    if ( $params->{ json } ) {
        $self->template_disable( 1 );

        my $obj = {
            headings        => $retval->{ headings },
            header_options  => $retval->{ header_options },
            rows            => $retval->{ rows },
        };

        my $json = to_json( $obj, { allow_blessed => 1 } );
        return( $json );
    }

    $self->stash->view->data( $retval );
} # END do_main

#-----------------------------------------------------------------
# $self->form( $row )
#-----------------------------------------------------------------
sub form {
    my ( $self, $row ) = @_;

    my $selections = $PAYEE->get_form_selections();

    return {
        name       => 'payee',
        row        => $row,
        legend => $self->path_info =~ /edit/i ? 'Edit' : 'Add',
        fields     => [
            {
                display_size => 20,
                name => 'name',
                label => 'Name',
                type => 'text',
                is => 'varchar',
            },
        ],
    };
} # END form

1;

=head1 NAME

Apps::Checkbook::GEN::PayeeOr - generated support module for Apps::Checkbook::PayeeOr

=head1 SYNOPSIS

In Apps::Checkbook::PayeeOr:

    use base 'Apps::Checkbook::GEN::PayeeOr';

=head1 DESCRIPTION

This module was generated by bigtop and IS subject to regeneration.
Use it in Apps::Checkbook::PayeeOr to provide the methods below.
Feel free to override them.

=head1 METHODS

=over 4

=item do_main

=item form


=back

=head1 AUTHOR

Generated by bigtop and subject to regeneration.

=cut

