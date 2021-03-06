use utf8;
package Schema::RackTables::0_18_5::Result::Script;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::RackTables::0_18_5::Result::Script

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<Script>

=cut

__PACKAGE__->table("Script");

=head1 ACCESSORS

=head2 script_name

  data_type: 'char'
  is_nullable: 0
  size: 64

=head2 script_text

  data_type: 'longtext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "script_name",
  { data_type => "char", is_nullable => 0, size => 64 },
  "script_text",
  { data_type => "longtext", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</script_name>

=back

=cut

__PACKAGE__->set_primary_key("script_name");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-22 23:03:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wun8q/L2OLYZjLvzeXvIYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
