use warnings;
use strict;

=head1 NAME

Jifty::Plugin::Authentication::ModShibb::Action::ShibbLogout -  - process ModShibb logout plugin

=cut

package Jifty::Plugin::Authentication::ModShibb::Action::ShibbLogout;
use base qw/Jifty::Action/;

=head2 arguments

Return the email and password form fields

=cut

sub arguments {
    return ( { } );
};

=head2 take_action

Nuke the current user object

=cut

sub take_action {
    my $self = shift;
    Jifty->web->current_user(undef);
    $self->result->message(_('For a full logout, you need to CLOSE your browser.'));
    return 1;
};

1;
