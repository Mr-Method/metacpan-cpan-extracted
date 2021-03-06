=head1 NAME

Net::RVP::Session - encapsulation of a session (conversation)

=head1 SYNOPSIS

 my $session = $rvp->session();
 $session->add($user1,$user2);
 $session->say("hello");

=head1 METHODS

=cut
package Net::RVP::Session;

use strict;


=head2 new ( RVP object, session id (GUID) )

=cut
sub new {
  my ($class,$rvp,$id) = @_;
  my $self = bless { rvp => $rvp, id => $id, user => {} }, ref $class || $class;
  return $self;
}


=head2 id

Return the session id.

=cut
sub id {
  shift->{id}
}


# _notify ( RVP::User object, MIME body text )
#
# create a notify request, pass to _send, return result
#
sub _notify {
  my ($self,$user,$body) = @_;
  my $src = $self->{rvp}->url();
  my $dst = $user->url();

  my $xml = <<XML;
<r:notification xmlns:d='DAV:' xmlns:r='http://schemas.microsoft.com/rvp/'><r:message><r:notification-from><r:contact><d:href>$src</d:href></r:contact></r:notification-from><r:notification-to><r:contact><d:href>$dst</d:href></r:contact></r:notification-to><r:msgbody><r:mime-data><![CDATA[MIME-Version: 1.0\r
Session-Id: $self->{id}\r
$body]]></r:mime-data></r:msgbody></r:message></r:notification>
XML

  my $req = $self->{rvp}->_request(NOTIFY => $user->url(),
   RVP_ack_type => 'DeepOr', RVP_hop_count => 1, XML => $xml);
  return $self->{rvp}->_send($req);
}


=head2 add ( RVP::User object, ... )

Sends a message to the users to add them to the conversation.

Returns number of users successfully added.

=cut
sub add {
  my $self = shift;

  my $success = 0;

  for my $user(@_) {
    next if $self->{user}->{$user->url()};     # can't join multiply
    my $res = $self->_notify($user,
     "Content-Type: text/x-msmsgscontrol\r\n\r\n\r\n");
    $self->join_event($user), $success++ if $res->is_success();
  }

  return $success;
}


=head2 leave

Leave the conversation.

=cut
sub leave {
  my $self = shift;

  for my $user(values %{$self->{user}}) {
    my $res = $self->_notify($user,
     "Content-Type: text/x-imleave\x0d\x0a\x0d\x0a\x0d\x0a");
  } 
  delete $self->{rvp}->{sesss}->{$self->{id}};
}


=head2 typing

Send 'typing' message.

=cut
sub typing {
  my $self = shift;

  for my $user(values %{$self->{user}}) {
    my $res = $self->_notify($user,
     "Content-Type: text/x-msmsgscontrol\r\nTypingUser: ".$self->{rvp}->name().
     '@'.$self->{rvp}->server()."\x0d\x0a\x0d\x0a\x0d\x0a");
  }
}


=head2 has ( RVP::User )

Returns true iff the given user is in the session.

=cut
sub has {
  my ($self,$user) = @_;
  return exists $self->{user}->{$user->url()};
}


=head2 users

Returns list of users (RVP::User object) in the session.

=cut
sub users {
  my $self = shift;
  return values %{$self->{user}};
}


=head2 say ( text )

Send message.

=cut
sub say {
  my ($self,$text) = @_;

  # XXX don't send 'X-MMS-IM-Format: FN=MS%20Shell%20Dlg; EF=; CO=0; CS=0; PF=0'
  # XXX do we need to?
  for my $user(values %{$self->{user}}) {
    my $res = $self->_notify($user,
     "Content-Type: text/plain; charset=UTF-8\x0d\x0a\x0d\x0a$text");
  }
}


=head2 join_event ( RVP::User )

A user has been added to the conversation.  Called in response to an
'x-msmsgscontrol' event (non-typing).

=cut
sub join_event {
  my ($self,$user) = @_;
  $self->{user}->{$user->url()} = $user;
}


=head2 part_event ( RVP::User )

A user has left the conversation.  Should be called in response to an
'x-imleave' event (e.g. as generated by the leave method here, but received
on our notification server).

Returns true on success, false if not found.

=cut
sub part_event {
  my ($self,$user) = @_;
  return delete $self->{user}->{$user->url()};
}


=head2 typing_event ( RVP::User )

A user is typing.  Called in response to a notification.

=cut
sub typing_event {
  # do nothing
}


=head2 message_event ( RVP::User, message )

Message was sent to a user.

=cut
sub message_event {
  # do nothing
}


=head1 AUTHOR

David Robins E<lt>dbrobins@davidrobins.netE<gt>.

=cut


1;
