package Paws::Chime::StreamingConfiguration;
  use Moose;
  has DataRetentionInHours => (is => 'ro', isa => 'Int', required => 1);
  has Disabled => (is => 'ro', isa => 'Bool');
1;

### main pod documentation begin ###

=head1 NAME

Paws::Chime::StreamingConfiguration

=head1 USAGE

This class represents one of two things:

=head3 Arguments in a call to a service

Use the attributes of this class as arguments to methods. You shouldn't make instances of this class. 
Each attribute should be used as a named argument in the calls that expect this type of object.

As an example, if Att1 is expected to be a Paws::Chime::StreamingConfiguration object:

  $service_obj->Method(Att1 => { DataRetentionInHours => $value, ..., Disabled => $value  });

=head3 Results returned from an API call

Use accessors for each attribute. If Att1 is expected to be an Paws::Chime::StreamingConfiguration object:

  $result = $service_obj->Method(...);
  $result->Att1->DataRetentionInHours

=head1 DESCRIPTION

The streaming configuration associated with an Amazon Chime Voice
Connector. Specifies whether media streaming is enabled for sending to
Amazon Kinesis, and shows the retention period for the Amazon Kinesis
data, in hours.

=head1 ATTRIBUTES


=head2 B<REQUIRED> DataRetentionInHours => Int

  The retention period, in hours, for the Amazon Kinesis data.


=head2 Disabled => Bool

  When true, media streaming to Amazon Kinesis is turned off.



=head1 SEE ALSO

This class forms part of L<Paws>, describing an object used in L<Paws::Chime>

=head1 BUGS and CONTRIBUTIONS

The source code is located here: L<https://github.com/pplu/aws-sdk-perl>

Please report bugs to: L<https://github.com/pplu/aws-sdk-perl/issues>

=cut

