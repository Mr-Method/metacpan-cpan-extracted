# ABSTRACT: request - role - URI format for relationships requests
package PONAPI::Client::Request::Role::HasUriRelationships;

use Moose::Role;

has uri_template => (
    is      => 'ro',
    isa     => 'Str',
    default => sub { '/{type}/{id}/relationships/{rel_type}' },
);

sub path   {
    my $self = shift;
    return +{ type => $self->type, id => $self->id, rel_type => $self->rel_type };
}

no Moose::Role; 1;

__END__

=pod

=encoding UTF-8

=head1 NAME

PONAPI::Client::Request::Role::HasUriRelationships - request - role - URI format for relationships requests

=head1 VERSION

version 0.002012

=head1 AUTHORS

=over 4

=item *

Mickey Nasriachi <mickey@cpan.org>

=item *

Stevan Little <stevan@cpan.org>

=item *

Brian Fraser <hugmeir@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2019 by Mickey Nasriachi, Stevan Little, Brian Fraser.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
