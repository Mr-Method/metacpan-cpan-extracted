#  You may distribute under the terms of either the GNU General Public License
#  or the Artistic License (the same terms as Perl itself)
#
#  (C) Paul Evans, 2015-2020 -- leonerd@leonerd.org.uk

use v5.26;
use Object::Pad 0.19;

package Device::Chip::SSD1306::I2C 0.09;
class Device::Chip::SSD1306::I2C
   extends Device::Chip::SSD1306;

use constant PROTOCOL => "I2C";

use constant DEFAULT_ADDR => 0x3C;

=encoding UTF-8

=head1 NAME

C<Device::Chip::SSD1306::I2C> - use a F<SSD1306> OLED driver in I²C mode

=head1 DESCRIPTION

This L<Device::Chip::SSD1306> subclass provides specific communication to an
F<SSD1306> chip attached via I²C.

For actually interacting with the attached module, see the main
L<Device::Chip::SSD1306> documentation.

=cut

method mount ( $adapter, %params )
{
   $self->{addr} = delete $params{addr} // DEFAULT_ADDR;

   return $self->SUPER::mount( $adapter, %params );
}

method I2C_options
{
   return (
      addr => $self->{addr},
   );
}

# passthrough
method power { $self->protocol->power( $_[0] ) }

method send_cmd ( @vals )
{
   my $final = pop @vals;

   $self->protocol->write( join "", ( map { "\x80" . chr $_ } @vals ),
      "\x00" . chr $final );
}

method send_data ( $bytes )
{
   $self->protocol->write( "\x40" . $_[0] )
}

=head1 AUTHOR

Paul Evans <leonerd@leonerd.org.uk>

=cut

0x55AA;
