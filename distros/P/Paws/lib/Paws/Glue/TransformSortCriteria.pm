package Paws::Glue::TransformSortCriteria;
  use Moose;
  has Column => (is => 'ro', isa => 'Str', required => 1);
  has SortDirection => (is => 'ro', isa => 'Str', required => 1);
1;

### main pod documentation begin ###

=head1 NAME

Paws::Glue::TransformSortCriteria

=head1 USAGE

This class represents one of two things:

=head3 Arguments in a call to a service

Use the attributes of this class as arguments to methods. You shouldn't make instances of this class. 
Each attribute should be used as a named argument in the calls that expect this type of object.

As an example, if Att1 is expected to be a Paws::Glue::TransformSortCriteria object:

  $service_obj->Method(Att1 => { Column => $value, ..., SortDirection => $value  });

=head3 Results returned from an API call

Use accessors for each attribute. If Att1 is expected to be an Paws::Glue::TransformSortCriteria object:

  $result = $service_obj->Method(...);
  $result->Att1->Column

=head1 DESCRIPTION

The sorting criteria that are associated with the machine learning
transform.

=head1 ATTRIBUTES


=head2 B<REQUIRED> Column => Str

  The column to be used in the sorting criteria that are associated with
the machine learning transform.


=head2 B<REQUIRED> SortDirection => Str

  The sort direction to be used in the sorting criteria that are
associated with the machine learning transform.



=head1 SEE ALSO

This class forms part of L<Paws>, describing an object used in L<Paws::Glue>

=head1 BUGS and CONTRIBUTIONS

The source code is located here: L<https://github.com/pplu/aws-sdk-perl>

Please report bugs to: L<https://github.com/pplu/aws-sdk-perl/issues>

=cut

