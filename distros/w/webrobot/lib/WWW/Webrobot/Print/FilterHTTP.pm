package WWW::Webrobot::Print::FilterHTTP;
use strict;
use warnings;
# use base "WWW::Webrobot::Print::Util::Base";

# Author: Stefan Trcek
# Copyright(c) 2004 ABAS Software AG

use HTTP::Headers;
use WWW::Webrobot::Print::Html;



=head1 DEPRECATED

This package is deprecated.

=head1 NAME

WWW::Webrobot::Print::FilterHTTP - ???

=head1 SYNOPSIS

See L<WWW::Webrobot::pod::OutputListeners>


=head1 DESCRIPTION

This module if for use with F<HttpSniffer.pl>.
It is quite incomplete,
so do not expect to much.


=head1 METHODS

=over

=item new()

=back

=cut


sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = $class -> SUPER::new();
    init($self, @_);
    bless ($self, $class);
    return $self;
}

#private
sub init {
    my $self = shift;
    # default args
    $self->{mode} = "plain";
    # overwrite default args
    my %parm = (@_);
    $self->{$_} = $parm{$_} foreach (keys %parm);
    # non-default args
    $self->{filter_seq} = WWW::Webrobot::Print::Html -> new(dir => "html_sequence");
    $self->{filter_struct} = WWW::Webrobot::Print::Html -> new(dir => "html_struct");
    $self->{request} = [];
    $self->{missing} = {};
}

sub global_start {
    my ($self) = @_;
    $self->{filter_seq}->global_start();
    $self->{filter_struct}->global_start();
}

sub item_pre {
    my ($self) = @_;
    $self->{filter_seq}->item_pre();
    $self->{filter_struct}->item_pre();
}

sub item_post {
    my ($self, $r) = @_;
    my $arg = {
        is_recursive => 0,
	description => "Generated by HttpSniffer.pl",
    };
    $self->{filter_seq}->item_post($r, $arg);

    my $uri = $r->request()->uri();
    # check, whether this request can be enqueued into a previous one
    if (exists $self->{missing}->{$uri}) {
	# enqueue request
	my $index = $self -> {missing} -> {$uri};
	$r -> previous($self -> {request} -> [$index]);
	$self -> {request} -> [$index] = $r;
	$self -> {filter_struct} -> item_post_change($r, $arg, $index);
    }
    else {
	# push new request
	push @{$self->{request}}, $r;
        $self -> {filter_struct} -> item_post($r, $arg);
    }

    # Now check whether this request is a slot
    # for any following request to enqueue?
    my $index = scalar @{$self->{request}} - 1;
    SWITCH: foreach ($r->code) {
        $_ eq 300 and do {
	    last;
	};
        $_ eq 301 and do {
	    my $location = $r->headers()->header('location');
	    $self->{missing}->{$location} = $index;
	    last;
	};
        $_ eq 302 and do {
	    my $location = $r->headers()->header('location');
	    $self->{missing}->{$location} = $index;
	    last;
	};
        $_ eq 303 and do {
	    last;
	};
        $_ eq 305 and do {
	    last;
	};
        $_ eq 307 and do {
	    last;
	};
        $_ eq 401 and do {
	    my $location = $uri;
	    print STDERR "401: $uri\n";
	    $self->{missing}->{$location} = $index;
	    last;
	};
        $_ eq 407 and do {
	    last;
	};
    }

}

sub global_end {
    my ($self) = @_;
    $self->{filter_seq}->global_end();
    $self->{filter_struct}->global_end();
}

1;
