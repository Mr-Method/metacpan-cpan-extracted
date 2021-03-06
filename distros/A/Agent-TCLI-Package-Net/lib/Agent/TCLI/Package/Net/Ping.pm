package Agent::TCLI::Package::Net::Ping;
#
# $Id: Ping.pm 74 2007-06-08 00:42:53Z hacker $
#
=pod

=head1 NAME

Agent::TCLI::Package::Net::Ping

=head1 SYNOPSIS

ping target=example.com

=head1 DESCRIPTION

This module provides a package of commands for the TCLI environment. Currently
one must use the TCLI environment (or browse the source) to see documentation
for the commands it supports within the TCLI Agent.

Makes a standard ping.

=head1 INTERFACE

This module must be loaded into a Agent::TCLI::Control by an
Agent::TCLI::Transport in order for a user to interface with it.

=cut

use warnings;
use strict;

use Object::InsideOut qw(Agent::TCLI::Package::Base);

use POE;
use POE::Component::Client::Ping;
use NetAddr::IP;
use Getopt::Lucid qw(:all);
use Agent::TCLI::Command;
use Agent::TCLI::Parameter;


our $VERSION = '0.030.'.sprintf "%04d", (qw($Id: Ping.pm 74 2007-06-08 00:42:53Z hacker $))[2];

=head2 ATTRIBUTES

The following attributes are accessible through standard <attribute>
methods unless otherwise noted.

These attrbiutes are generally internal and are probably only useful to
someone trying to enhance the functionality of this Package module.

=over

=item target

The default target for a ping
B<target> will only accept NetAddr::IP type values.

=cut

=item timeout

The default timeout for a ping
B<timeout> will only contain numeric values.

=cut

=item retry_count

The default number of retries before failing
B<retry_count> will only contain numeric values.

=cut

=back

=head2 METHODS

Most of these methods are for internal use within the TCLI system and may
be of interest only to developers trying to enhance TCLI.

=over

=item new ( hash of attributes )

Usually the only attributes that are useful on creation are the
verbose and do_verbose attrbiutes that are inherited from Agent::TCLI::Base.

=cut

sub _start {
	my ($kernel,  $self,  $session) =
      @_[KERNEL, OBJECT,   SESSION];
	$self->Verbose("_start: tcli ping starting");

	# are we up before OIO has finished initializing object?
	if (!defined( $self->name ))
	{
		$kernel->yield('_start');
		return;
	}

	# There is only one command object per TCLI
    $kernel->alias_set($self->name);

	# Keep the pinger session so we can shut it down

	# Create a pinger component.
#	$self->set(\@poco_pinger,
	POE::Component::Client::Ping->spawn(
    	Alias   	=> 'pinger',    # This is the name it'll be known by.
    	Timeout 	=> 10,          # This is how long it waits for echo replies.
    	OneReply	=> 1,			# Only tell us when success or timeout
	);

	return($self->name.":_start complete ");
} #end start

sub _stop {
    my ($kernel,  $self,) =
      @_[KERNEL, OBJECT,];
	$self->Verbose("_stop: ".$self->name." stopping",2);

	return($self->name.":_stop complete ");
}

=item ping

This POE Event handler executes the ping command.

=cut

sub ping {
    my ($kernel,  $self, $session, $request, ) =
      @_[KERNEL, OBJECT,  SESSION,     ARG0, ];

	my $txt = '';
	my $param;
	my $command = $request->command->[0];
	my $cmd = $self->commands->{'ping'};

	return unless ( $param = $cmd->Validate($kernel, $request, $self) );

	$self->Verbose("ping: param dump",1,$param);

	my $target;

	if ( defined( $param->{'target'} ) && ref( $param->{'target'} ) eq 'NetAddr::IP' )
	{
		$target = $param->{'target'}
	}
	else
	{
		$self->Verbose('ping: target not specified ');
		$request->Respond($kernel,  "Target must be defined in command line or in default settings.",412);
		return;
	}
	$self->Verbose("ping: target ",1,$target);

	if ( $target->version() == 6 )
	{
		$request->Respond($kernel,  "IPv6 currently not supported.",400);
		return;
	}
	if ( $target->masklen() != 32 )
	{
		$request->Respond($kernel,  "Address blocks not supported.",400);
		return;
	}

	$self->Verbose("ping: target(".$target.") ",2);

	# only one ping per host at a time
	if (defined($self->requests->{$target->addr}{'request'} ))
	{
		$self->Verbose('ping: ping in progress for target');
		$request->Respond($kernel,"Error: ping already in progress for ".$target,409);
		return;
	}

	# $txt will be populated if there was an error.
	if ($txt)
	{
		$self->Verbose('dos: argument error '.$txt);
		$request->Respond($kernel, $txt,412);
		return;
	}


  	$self->requests->{$target->addr}{'request'} = $request;

	# execution
	$kernel->post( 'pinger' => 'ping' => 'Pong' =>
		$target->addr,
		$param->{'timeout'},
		$param->{'retry_count'},
  	);

	return($self->name.":ping done");
}

=item Pong

This POE Event handler receives and processes the events generated by
PoCo::Client::PIng and turns them in to appropriate Responses.

=back

=cut

sub Pong {
	my ($kernel,  $self, $ping, $pong) =
	  @_[KERNEL, OBJECT,  ARG0,  ARG1];

    my ($req_address, $req_timeout, $req_time)      = @$ping;
    my ($resp_address, $roundtrip_time, $resp_time, $resp_ttl) = @$pong;

	$self->Verbose("Pong: req_address(".$req_address.")");
	my ($txt,$code);
	my $request = delete($self->requests->{$req_address}{'request'});

    # The response address is defined if ping successful
    if (defined $resp_address)
    {
    	$txt = sprintf(
        	"ping to %-15.15s at %10d. pong from %-15.15s in %6.3f s\n",
        	$req_address, $req_time,
        	$resp_address, $roundtrip_time,
    	);
    	$code = 200;
    }
    # Otherwise the timeout period has ended and we failed
    else
    {
		$txt = "No response from ".$req_address." in ".$req_timeout;
		$code = 408;  # request_timeout
    }

	$request->Respond($kernel, $txt, $code );


	return($self->name.":Pong done");
}

sub _preinit :PreInit {
	my ($self,$args) = @_;

	$args->{'name'} = 'tcli_ping';


	$args->{'session'} = POE::Session->create(
      object_states => [
          $self => [qw(
          	_start
          	_stop
          	_shutdown
          	_default
          	_child
			establish_context
			ping
			Pong
			settings
			show
			)],
      ],
	);
}

sub _init :Init {
	my $self = shift;

#  constraints:
#    - ASCII


	$self->LoadYaml(<<'...');
---
Agent::TCLI::Parameter:
  name: target
  class: NetAddr::IP
  constraints:
    - ASCII
  help: the target ip address
  manual: >
    The target IP address for the attack. The target may
    be specified as a domain name or as a dotted quad.
  type: Param
  show_method: addr
---
Agent::TCLI::Parameter:
  name: timeout
  constraints:
    - UINT
  default: 10
  class: numeric
  help: the timeout in seconds
  manual: >
    Changes the wait before giving up on getting a response. The default
    is 10 seconds.
  type: Param
---
Agent::TCLI::Parameter:
  name: retry_count
  constraints:
    - UINT
  default: 1
  class: numeric
  help: The number of times to retry when no response is received
  manual: >
    This parameter will cause the specified number or retry attampts
    This will only happen if there is no response from prior requests.
  type: Param
---
Agent::TCLI::Command:
  name: ping
  call_style: session
  command: tcli_ping
  contexts:
    ROOT: ping
  handler: ping
  help: check to see if a host is alive
  manual: >
    Ping will send an ICMP echo to a target, hoping to get an ICMP
    response before a timeout. One can ping multiple hosts concurrently.
  parameters:
    target:
    timeout:
    retry_count:
  required:
    target:
  topic: network
  usage: ping target example.com
---
Agent::TCLI::Command:
  name: set
  call_style: session
  command: tcli_ping
  contexts:
    ping: set
  handler: settings
  help: set defaults for pings attacks
  parameters:
    target:
    timeout:
    retry_count:
  topic: network
  usage: ping set target=target.example.com
---
Agent::TCLI::Command:
  name: show
  call_style: session
  command: tcli_ping
  contexts:
    ping: show
  handler: show
  help: show current settings
  parameters:
    target:
    timeout:
    retry_count:
  topic: network
  usage: ping show timeout
...

}

1;
#__END__

=head3 INHERITED METHODS

This module is an Object::InsideOut object that inherits from Agent::TCLI::Package::Base. It
inherits methods from both. Please refer to their documentation for more
details.

=head1 AUTHOR

Eric Hacker	 E<lt>hacker at cpan.orgE<gt>

=head1 BUGS

SHOULDS and MUSTS are currently not always enforced.

Test scripts not thorough enough.

Probably many others.

=head1 LICENSE

Copyright (c) 2007, Alcatel Lucent, All rights resevred.

This package is free software; you may redistribute it
and/or modify it under the same terms as Perl itself.

=cut
