package Paws::MediaLive::PipelinePauseStateSettings;
  use Moose;
  has PipelineId => (is => 'ro', isa => 'Str', request_name => 'pipelineId', traits => ['NameInRequest'], required => 1);
1;

### main pod documentation begin ###

=head1 NAME

Paws::MediaLive::PipelinePauseStateSettings

=head1 USAGE

This class represents one of two things:

=head3 Arguments in a call to a service

Use the attributes of this class as arguments to methods. You shouldn't make instances of this class. 
Each attribute should be used as a named argument in the calls that expect this type of object.

As an example, if Att1 is expected to be a Paws::MediaLive::PipelinePauseStateSettings object:

  $service_obj->Method(Att1 => { PipelineId => $value, ..., PipelineId => $value  });

=head3 Results returned from an API call

Use accessors for each attribute. If Att1 is expected to be an Paws::MediaLive::PipelinePauseStateSettings object:

  $result = $service_obj->Method(...);
  $result->Att1->PipelineId

=head1 DESCRIPTION

Settings for pausing a pipeline.

=head1 ATTRIBUTES


=head2 B<REQUIRED> PipelineId => Str

  Pipeline ID to pause ("PIPELINE_0" or "PIPELINE_1").



=head1 SEE ALSO

This class forms part of L<Paws>, describing an object used in L<Paws::MediaLive>

=head1 BUGS and CONTRIBUTIONS

The source code is located here: L<https://github.com/pplu/aws-sdk-perl>

Please report bugs to: L<https://github.com/pplu/aws-sdk-perl/issues>

=cut

