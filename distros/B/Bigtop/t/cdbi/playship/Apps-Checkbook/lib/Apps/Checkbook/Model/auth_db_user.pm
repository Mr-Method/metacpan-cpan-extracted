package Apps::Checkbook::Model::auth_db_user;
use strict; use warnings;

use base 'Gantry::Utils::AuthCDBI', 'Exporter';

use Apps::Checkbook::Model::GEN::auth_db_user;

our $AUTH_DB_USER = 'Apps::Checkbook::Model::auth_db_user';

our @EXPORT_OK = ( '$AUTH_DB_USER' );

1;

=head1 NAME

Apps::Checkbook::Model::auth_db_user - model for auth_db_user table (stub part)

=head1 DESCRIPTION

This model inherits from Gantry::Utils::AuthCDBI and uses its generated
helper Apps::Checkbook::Model::GEN::auth_db_user.

It was generated by Bigtop, but is NOT subject to regeneration.

=cut
