package WebService::Recruit::AbRoad::Area;

use strict;
use base qw( WebService::Recruit::AbRoad::Base );
use vars qw( $VERSION );
use Class::Accessor::Fast;
use Class::Accessor::Children::Fast;

$VERSION = '0.0.1';

sub http_method { 'GET'; }

sub url { 'http://webservice.recruit.co.jp/ab-road/area/v1/'; }

sub query_class { 'WebService::Recruit::AbRoad::Area::Query'; }

sub query_fields { [
    'key'
]; }

sub default_param { {
    'format' => 'xml'
}; }

sub notnull_param { [
    'key'
]; }

sub elem_class { 'WebService::Recruit::AbRoad::Area::Element'; }

sub root_elem { 'results'; }

sub elem_fields { {
    'area' => ['code', 'name', 'tour_count'],
    'error' => ['message'],
    'results' => ['api_version', 'results_available', 'results_returned', 'results_start', 'area', 'api_version', 'error'],

}; }

sub force_array { [
    'area'
]; }

# __PACKAGE__->mk_query_accessors();

@WebService::Recruit::AbRoad::Area::Query::ISA = qw( Class::Accessor::Fast );
WebService::Recruit::AbRoad::Area::Query->mk_accessors( @{query_fields()} );

# __PACKAGE__->mk_elem_accessors();

@WebService::Recruit::AbRoad::Area::Element::ISA = qw( Class::Accessor::Children::Fast );
WebService::Recruit::AbRoad::Area::Element->mk_ro_accessors( root_elem() );
WebService::Recruit::AbRoad::Area::Element->mk_child_ro_accessors( %{elem_fields()} );

=head1 NAME

WebService::Recruit::AbRoad::Area - AB-ROAD Web Service "area" API

=head1 SYNOPSIS

    use WebService::Recruit::AbRoad;
    
    my $service = WebService::Recruit::AbRoad->new();
    
    my $param = {
        'key' => $ENV{'WEBSERVICE_RECRUIT_KEY'},
    };
    my $res = $service->area( %$param );
    my $data = $res->root;
    print "api_version: $data->api_version\n";
    print "results_available: $data->results_available\n";
    print "results_returned: $data->results_returned\n";
    print "results_start: $data->results_start\n";
    print "area: $data->area\n";
    print "...\n";

=head1 DESCRIPTION

This module is a interface for the C<area> API.
It accepts following query parameters to make an request.

    my $param = {
        'key' => 'XXXXXXXX',
    };
    my $res = $service->area( %$param );

C<$service> above is an instance of L<WebService::Recruit::AbRoad>.

=head1 METHODS

=head2 root

This returns the root element of the response.

    my $root = $res->root;

You can retrieve each element by the following accessors.

    $root->api_version
    $root->results_available
    $root->results_returned
    $root->results_start
    $root->area
    $root->area->[0]->code
    $root->area->[0]->name
    $root->area->[0]->tour_count


=head2 xml

This returns the raw response context itself.

    print $res->xml, "\n";

=head2 code

This returns the response status code.

    my $code = $res->code; # usually "200" when succeeded

=head2 is_error

This returns true value when the response has an error.

    die 'error!' if $res->is_error;

=head1 SEE ALSO

L<WebService::Recruit::AbRoad>

=head1 AUTHOR

RECRUIT Media Technology Labs <mtl@cpan.org>

=head1 COPYRIGHT

Copyright 2008 RECRUIT Media Technology Labs

=cut
1;
