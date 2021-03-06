package AddressBook::Model;
use strict; use warnings;

__PACKAGE__->load_classes( qw/
    family
    child
/ );

1;

=head1 NAME

AddressBook::GENModel - regenerating schema for AddressBook

=head1 SYNOPSIS

In your base schema:

    use base 'DBIx::Class::Schema';
    use AddressBook::GENModel;

=head1 DESCRIPTION

This module was generated by Bigtop (and IS subject to regeneration).

=head1 DEPENDENCIES

    Gantry::Utils::DBIxClass

=head1 AUTHOR

Phil Crow, E<lt>phil@localdomainE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 Phil Crow

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.

=cut
