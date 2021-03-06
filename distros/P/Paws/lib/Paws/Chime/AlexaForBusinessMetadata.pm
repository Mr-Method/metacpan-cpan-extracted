package Paws::Chime::AlexaForBusinessMetadata;
  use Moose;
  has AlexaForBusinessRoomArn => (is => 'ro', isa => 'Str');
  has IsAlexaForBusinessEnabled => (is => 'ro', isa => 'Bool');
1;

### main pod documentation begin ###

=head1 NAME

Paws::Chime::AlexaForBusinessMetadata

=head1 USAGE

This class represents one of two things:

=head3 Arguments in a call to a service

Use the attributes of this class as arguments to methods. You shouldn't make instances of this class. 
Each attribute should be used as a named argument in the calls that expect this type of object.

As an example, if Att1 is expected to be a Paws::Chime::AlexaForBusinessMetadata object:

  $service_obj->Method(Att1 => { AlexaForBusinessRoomArn => $value, ..., IsAlexaForBusinessEnabled => $value  });

=head3 Results returned from an API call

Use accessors for each attribute. If Att1 is expected to be an Paws::Chime::AlexaForBusinessMetadata object:

  $result = $service_obj->Method(...);
  $result->Att1->AlexaForBusinessRoomArn

=head1 DESCRIPTION

The Alexa for Business metadata associated with an Amazon Chime user,
used to integrate Alexa for Business with a device.

=head1 ATTRIBUTES


=head2 AlexaForBusinessRoomArn => Str

  The ARN of the room resource.


=head2 IsAlexaForBusinessEnabled => Bool

  Starts or stops Alexa for Business.



=head1 SEE ALSO

This class forms part of L<Paws>, describing an object used in L<Paws::Chime>

=head1 BUGS and CONTRIBUTIONS

The source code is located here: L<https://github.com/pplu/aws-sdk-perl>

Please report bugs to: L<https://github.com/pplu/aws-sdk-perl/issues>

=cut

