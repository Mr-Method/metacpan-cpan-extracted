package Paws::ImageBuilder::InfrastructureConfiguration;
  use Moose;
  has Arn => (is => 'ro', isa => 'Str', request_name => 'arn', traits => ['NameInRequest']);
  has DateCreated => (is => 'ro', isa => 'Str', request_name => 'dateCreated', traits => ['NameInRequest']);
  has DateUpdated => (is => 'ro', isa => 'Str', request_name => 'dateUpdated', traits => ['NameInRequest']);
  has Description => (is => 'ro', isa => 'Str', request_name => 'description', traits => ['NameInRequest']);
  has InstanceProfileName => (is => 'ro', isa => 'Str', request_name => 'instanceProfileName', traits => ['NameInRequest']);
  has InstanceTypes => (is => 'ro', isa => 'ArrayRef[Str|Undef]', request_name => 'instanceTypes', traits => ['NameInRequest']);
  has KeyPair => (is => 'ro', isa => 'Str', request_name => 'keyPair', traits => ['NameInRequest']);
  has Logging => (is => 'ro', isa => 'Paws::ImageBuilder::Logging', request_name => 'logging', traits => ['NameInRequest']);
  has Name => (is => 'ro', isa => 'Str', request_name => 'name', traits => ['NameInRequest']);
  has SecurityGroupIds => (is => 'ro', isa => 'ArrayRef[Str|Undef]', request_name => 'securityGroupIds', traits => ['NameInRequest']);
  has SnsTopicArn => (is => 'ro', isa => 'Str', request_name => 'snsTopicArn', traits => ['NameInRequest']);
  has SubnetId => (is => 'ro', isa => 'Str', request_name => 'subnetId', traits => ['NameInRequest']);
  has Tags => (is => 'ro', isa => 'Paws::ImageBuilder::TagMap', request_name => 'tags', traits => ['NameInRequest']);
  has TerminateInstanceOnFailure => (is => 'ro', isa => 'Bool', request_name => 'terminateInstanceOnFailure', traits => ['NameInRequest']);
1;

### main pod documentation begin ###

=head1 NAME

Paws::ImageBuilder::InfrastructureConfiguration

=head1 USAGE

This class represents one of two things:

=head3 Arguments in a call to a service

Use the attributes of this class as arguments to methods. You shouldn't make instances of this class. 
Each attribute should be used as a named argument in the calls that expect this type of object.

As an example, if Att1 is expected to be a Paws::ImageBuilder::InfrastructureConfiguration object:

  $service_obj->Method(Att1 => { Arn => $value, ..., TerminateInstanceOnFailure => $value  });

=head3 Results returned from an API call

Use accessors for each attribute. If Att1 is expected to be an Paws::ImageBuilder::InfrastructureConfiguration object:

  $result = $service_obj->Method(...);
  $result->Att1->Arn

=head1 DESCRIPTION

Details of the infrastructure configuration.

=head1 ATTRIBUTES


=head2 Arn => Str

  The Amazon Resource Name (ARN) of the infrastructure configuration.


=head2 DateCreated => Str

  The date on which the infrastructure configuration was created.


=head2 DateUpdated => Str

  The date on which the infrastructure configuration was last updated.


=head2 Description => Str

  The description of the infrastructure configuration.


=head2 InstanceProfileName => Str

  The instance profile of the infrastructure configuration.


=head2 InstanceTypes => ArrayRef[Str|Undef]

  The instance types of the infrastructure configuration.


=head2 KeyPair => Str

  The EC2 key pair of the infrastructure configuration.


=head2 Logging => L<Paws::ImageBuilder::Logging>

  The logging configuration of the infrastructure configuration.


=head2 Name => Str

  The name of the infrastructure configuration.


=head2 SecurityGroupIds => ArrayRef[Str|Undef]

  The security group IDs of the infrastructure configuration.


=head2 SnsTopicArn => Str

  The SNS topic Amazon Resource Name (ARN) of the infrastructure
configuration.


=head2 SubnetId => Str

  The subnet ID of the infrastructure configuration.


=head2 Tags => L<Paws::ImageBuilder::TagMap>

  The tags of the infrastructure configuration.


=head2 TerminateInstanceOnFailure => Bool

  The terminate instance on failure configuration of the infrastructure
configuration.



=head1 SEE ALSO

This class forms part of L<Paws>, describing an object used in L<Paws::ImageBuilder>

=head1 BUGS and CONTRIBUTIONS

The source code is located here: L<https://github.com/pplu/aws-sdk-perl>

Please report bugs to: L<https://github.com/pplu/aws-sdk-perl/issues>

=cut

