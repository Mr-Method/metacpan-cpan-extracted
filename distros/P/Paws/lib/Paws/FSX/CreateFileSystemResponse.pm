
package Paws::FSX::CreateFileSystemResponse;
  use Moose;
  has FileSystem => (is => 'ro', isa => 'Paws::FSX::FileSystem');

  has _request_id => (is => 'ro', isa => 'Str');

### main pod documentation begin ###

=head1 NAME

Paws::FSX::CreateFileSystemResponse

=head1 ATTRIBUTES


=head2 FileSystem => L<Paws::FSX::FileSystem>

The configuration of the file system that was created.


=head2 _request_id => Str


=cut

1;