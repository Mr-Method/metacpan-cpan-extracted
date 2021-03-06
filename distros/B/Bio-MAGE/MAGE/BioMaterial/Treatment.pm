##############################
#
# Bio::MAGE::BioMaterial::Treatment
#
##############################
# C O P Y R I G H T   N O T I C E
#  Copyright (c) 2001-2006 by:
#    * The MicroArray Gene Expression Database Society (MGED)
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.



package Bio::MAGE::BioMaterial::Treatment;
use strict;
use Carp;

use base qw(Bio::MAGE::BioEvent::BioEvent);

use Bio::MAGE::Association;

use vars qw($__ASSOCIATIONS
	    $__CLASS_NAME
	    $__PACKAGE_NAME
	    $__SUBCLASSES
	    $__SUPERCLASSES
	    $__ATTRIBUTE_NAMES
	    $__ASSOCIATION_NAMES
	   );


=head1 NAME

Bio::MAGE::BioMaterial::Treatment - Class for the MAGE-OM API

=head1 SYNOPSIS

  use Bio::MAGE::BioMaterial::Treatment

  # creating an empty instance
  my $treatment = Bio::MAGE::BioMaterial::Treatment->new();

  # creating an instance with existing data
  my $treatment = Bio::MAGE::BioMaterial::Treatment->new(
        identifier=>$identifier_val,
        order=>$order_val,
        name=>$name_val,
        sourceBioMaterialMeasurements=>\@biomaterialmeasurement_list,
        auditTrail=>\@audit_list,
        propertySets=>\@namevaluetype_list,
        protocolApplications=>\@protocolapplication_list,
        descriptions=>\@description_list,
        security=>$security_ref,
        action=>$ontologyentry_ref,
        actionMeasurement=>$measurement_ref,
        compoundMeasurements=>\@compoundmeasurement_list,
  );


  # 'identifier' attribute
  my $identifier_val = $treatment->identifier(); # getter
  $treatment->identifier($value); # setter

  # 'order' attribute
  my $order_val = $treatment->order(); # getter
  $treatment->order($value); # setter

  # 'name' attribute
  my $name_val = $treatment->name(); # getter
  $treatment->name($value); # setter


  # 'sourceBioMaterialMeasurements' association
  my $biomaterialmeasurement_array_ref = $treatment->sourceBioMaterialMeasurements(); # getter
  $treatment->sourceBioMaterialMeasurements(\@biomaterialmeasurement_list); # setter

  # 'auditTrail' association
  my $audit_array_ref = $treatment->auditTrail(); # getter
  $treatment->auditTrail(\@audit_list); # setter

  # 'propertySets' association
  my $namevaluetype_array_ref = $treatment->propertySets(); # getter
  $treatment->propertySets(\@namevaluetype_list); # setter

  # 'protocolApplications' association
  my $protocolapplication_array_ref = $treatment->protocolApplications(); # getter
  $treatment->protocolApplications(\@protocolapplication_list); # setter

  # 'descriptions' association
  my $description_array_ref = $treatment->descriptions(); # getter
  $treatment->descriptions(\@description_list); # setter

  # 'security' association
  my $security_ref = $treatment->security(); # getter
  $treatment->security($security_ref); # setter

  # 'action' association
  my $ontologyentry_ref = $treatment->action(); # getter
  $treatment->action($ontologyentry_ref); # setter

  # 'actionMeasurement' association
  my $measurement_ref = $treatment->actionMeasurement(); # getter
  $treatment->actionMeasurement($measurement_ref); # setter

  # 'compoundMeasurements' association
  my $compoundmeasurement_array_ref = $treatment->compoundMeasurements(); # getter
  $treatment->compoundMeasurements(\@compoundmeasurement_list); # setter



=head1 DESCRIPTION

From the MAGE-OM documentation for the C<Treatment> class:

The process by which a biomaterial is created (from source biomaterials).  Treatments have an order and an action.



=cut

=head1 INHERITANCE


Bio::MAGE::BioMaterial::Treatment has the following superclasses:

=over


=item * Bio::MAGE::BioEvent::BioEvent


=back



=cut

BEGIN {
  $__CLASS_NAME        = q[Bio::MAGE::BioMaterial::Treatment];
  $__PACKAGE_NAME      = q[BioMaterial];
  $__SUBCLASSES        = [];
  $__SUPERCLASSES      = ['Bio::MAGE::BioEvent::BioEvent'];
  $__ATTRIBUTE_NAMES   = ['identifier', 'order', 'name'];
  $__ASSOCIATION_NAMES = ['sourceBioMaterialMeasurements', 'auditTrail', 'propertySets', 'protocolApplications', 'descriptions', 'action', 'security', 'compoundMeasurements', 'actionMeasurement'];
  $__ASSOCIATIONS      = [
          'action',
          bless( {
                   '__SELF' => bless( {
                                        '__NAME' => undef,
                                        '__IS_REF' => 0,
                                        '__CARDINALITY' => '1',
                                        '__DOCUMENTATION' => 'The event that occurred (e.g. grow, wait, add, etc...).  The actions should be a recommended vocabulary',
                                        '__CLASS_NAME' => 'Treatment',
                                        '__RANK' => undef,
                                        '__ORDERED' => undef
                                      }, 'Bio::MAGE::Association::End' ),
                   '__OTHER' => bless( {
                                         '__NAME' => 'action',
                                         '__IS_REF' => 1,
                                         '__CARDINALITY' => '1',
                                         '__DOCUMENTATION' => 'The event that occurred (e.g. grow, wait, add, etc...).  The actions should be a recommended vocabulary',
                                         '__CLASS_NAME' => 'OntologyEntry',
                                         '__RANK' => '1',
                                         '__ORDERED' => 0
                                       }, 'Bio::MAGE::Association::End' )
                 }, 'Bio::MAGE::Association' ),
          'actionMeasurement',
          bless( {
                   '__SELF' => bless( {
                                        '__NAME' => undef,
                                        '__IS_REF' => 0,
                                        '__CARDINALITY' => '1',
                                        '__DOCUMENTATION' => 'Measures events like duration, centrifuge speed, etc.',
                                        '__CLASS_NAME' => 'Treatment',
                                        '__RANK' => undef,
                                        '__ORDERED' => undef
                                      }, 'Bio::MAGE::Association::End' ),
                   '__OTHER' => bless( {
                                         '__NAME' => 'actionMeasurement',
                                         '__IS_REF' => 1,
                                         '__CARDINALITY' => '0..1',
                                         '__DOCUMENTATION' => 'Measures events like duration, centrifuge speed, etc.',
                                         '__CLASS_NAME' => 'Measurement',
                                         '__RANK' => '2',
                                         '__ORDERED' => 0
                                       }, 'Bio::MAGE::Association::End' )
                 }, 'Bio::MAGE::Association' ),
          'compoundMeasurements',
          bless( {
                   '__SELF' => bless( {
                                        '__NAME' => undef,
                                        '__IS_REF' => 0,
                                        '__CARDINALITY' => '1',
                                        '__DOCUMENTATION' => 'The compounds and their amounts used in the treatment.',
                                        '__CLASS_NAME' => 'Treatment',
                                        '__RANK' => undef,
                                        '__ORDERED' => undef
                                      }, 'Bio::MAGE::Association::End' ),
                   '__OTHER' => bless( {
                                         '__NAME' => 'compoundMeasurements',
                                         '__IS_REF' => 1,
                                         '__CARDINALITY' => '0..N',
                                         '__DOCUMENTATION' => 'The compounds and their amounts used in the treatment.',
                                         '__CLASS_NAME' => 'CompoundMeasurement',
                                         '__RANK' => '3',
                                         '__ORDERED' => 0
                                       }, 'Bio::MAGE::Association::End' )
                 }, 'Bio::MAGE::Association' ),
          'sourceBioMaterialMeasurements',
          bless( {
                   '__SELF' => bless( {
                                        '__NAME' => undef,
                                        '__IS_REF' => 0,
                                        '__CARDINALITY' => '1',
                                        '__DOCUMENTATION' => 'The BioMaterials and the amounts used in the treatment',
                                        '__CLASS_NAME' => 'Treatment',
                                        '__RANK' => undef,
                                        '__ORDERED' => undef
                                      }, 'Bio::MAGE::Association::End' ),
                   '__OTHER' => bless( {
                                         '__NAME' => 'sourceBioMaterialMeasurements',
                                         '__IS_REF' => 1,
                                         '__CARDINALITY' => '0..N',
                                         '__DOCUMENTATION' => 'The BioMaterials and the amounts used in the treatment',
                                         '__CLASS_NAME' => 'BioMaterialMeasurement',
                                         '__RANK' => '4',
                                         '__ORDERED' => 0
                                       }, 'Bio::MAGE::Association::End' )
                 }, 'Bio::MAGE::Association' )
        ]

}

=head1 CLASS METHODS

The following methods can all be called without first having an
instance of the class via the Bio::MAGE::BioMaterial::Treatment->methodname() syntax.

=over

=item new()

=item new(%args)


The object constructor C<new()> accepts the following optional
named-value style arguments:

=over

=item * identifier

Sets the value of the C<identifier> attribute (this attribute was inherited from class C<Bio::MAGE::Identifiable>).


=item * order

Sets the value of the C<order> attribute

=item * name

Sets the value of the C<name> attribute (this attribute was inherited from class C<Bio::MAGE::Identifiable>).



=item * sourceBioMaterialMeasurements

Sets the value of the C<sourceBioMaterialMeasurements> association

The value must be of type: array of C<Bio::MAGE::BioMaterial::BioMaterialMeasurement>.


=item * auditTrail

Sets the value of the C<auditTrail> association (this association was inherited from class C<Bio::MAGE::Describable>).


The value must be of type: array of C<Bio::MAGE::AuditAndSecurity::Audit>.


=item * propertySets

Sets the value of the C<propertySets> association (this association was inherited from class C<Bio::MAGE::Extendable>).


The value must be of type: array of C<Bio::MAGE::NameValueType>.


=item * protocolApplications

Sets the value of the C<protocolApplications> association (this association was inherited from class C<Bio::MAGE::BioEvent::BioEvent>).


The value must be of type: array of C<Bio::MAGE::Protocol::ProtocolApplication>.


=item * descriptions

Sets the value of the C<descriptions> association (this association was inherited from class C<Bio::MAGE::Describable>).


The value must be of type: array of C<Bio::MAGE::Description::Description>.


=item * action

Sets the value of the C<action> association

The value must be of type: instance of C<Bio::MAGE::Description::OntologyEntry>.


=item * security

Sets the value of the C<security> association (this association was inherited from class C<Bio::MAGE::Describable>).


The value must be of type: instance of C<Bio::MAGE::AuditAndSecurity::Security>.


=item * compoundMeasurements

Sets the value of the C<compoundMeasurements> association

The value must be of type: array of C<Bio::MAGE::BioMaterial::CompoundMeasurement>.


=item * actionMeasurement

Sets the value of the C<actionMeasurement> association

The value must be of type: instance of C<Bio::MAGE::Measurement::Measurement>.


=back

=item $obj = class->new(%parameters)

The C<new()> method is the class constructor.

B<Parameters>: if given a list of name/value parameters the
corresponding slots, attributes, or associations will have their
initial values set by the constructor.

B<Return value>: It returns a reference to an object of the class.

B<Side effects>: It invokes the C<initialize()> method if it is defined
by the class.

=cut

#
# code for new() inherited from Base.pm
#

=item @names = class->get_slot_names()

The C<get_slot_names()> method is used to retrieve the name of all
slots defined in a given class.

B<NOTE>: the list of names does not include attribute or association
names.

B<Return value>: A list of the names of all slots defined for this class.

B<Side effects>: none

=cut

#
# code for get_slot_names() inherited from Base.pm
#

=item @name_list = get_attribute_names()

returns the list of attribute data members for this class.

=cut

#
# code for get_attribute_names() inherited from Base.pm
#

=item @name_list = get_association_names()

returns the list of association data members for this class.

=cut

#
# code for get_association_names() inherited from Base.pm
#

=item @class_list = get_superclasses()

returns the list of superclasses for this class.

=cut

#
# code for get_superclasses() inherited from Base.pm
#

=item @class_list = get_subclasses()

returns the list of subclasses for this class.

=cut

#
# code for get_subclasses() inherited from Base.pm
#

=item $name = class_name()

Returns the full class name for this class.

=cut

#
# code for class_name() inherited from Base.pm
#

=item $package_name = package_name()

Returns the base package name (i.e. no 'namespace::') of the package
that contains this class.

=cut

#
# code for package_name() inherited from Base.pm
#

=item %assns = associations()

returns the association meta-information in a hash where the keys are
the association names and the values are C<Association> objects that
provide the meta-information for the association.

=cut

#
# code for associations() inherited from Base.pm
#



=back

=head1 INSTANCE METHODS

=item $obj_copy = $obj->new()

When invoked with an existing object reference and not a class name,
the C<new()> method acts as a copy constructor - with the new object's
initial values set to be those of the existing object.

B<Parameters>: No input parameters  are used in the copy  constructor,
the initial values are taken directly from the object to be copied.

B<Return value>: It returns a reference to an object of the class.

B<Side effects>: It invokes the C<initialize()> method if it is defined
by the class.

=cut

#
# code for new() inherited from Base.pm
#

=item $obj->set_slots(%parameters)

=item $obj->set_slots(\@name_list, \@value_list)

The C<set_slots()> method is used to set a number of slots at the same
time. It has two different invocation methods. The first takes a named
parameter list, and the second takes two array references.

B<Return value>: none

B<Side effects>: will call C<croak()> if a slot_name is used that the class
does not define.

=cut

#
# code for set_slots() inherited from Base.pm
#

=item @obj_list = $obj->get_slots(@name_list)

The C<get_slots()> method is used to get the values of a number of
slots at the same time.

B<Return value>: a list of instance objects

B<Side effects>: none

=cut

#
# code for get_slots() inherited from Base.pm
#

=item $val = $obj->set_slot($name,$val)

The C<set_slot()> method sets the slot C<$name> to the value C<$val>

B<Return value>: the new value of the slot, i.e. C<$val>

B<Side effects>: none

=cut

#
# code for set_slot() inherited from Base.pm
#

=item $val = $obj->get_slot($name)

The C<get_slot()> method is used to get the values of a number of
slots at the same time.

B<Return value>: a single slot value, or undef if the slot has not been
initialized.

B<Side effects>: none

=cut

#
# code for get_slot() inherited from Base.pm
#


=head2 ATTRIBUTES

Attributes are simple data types that belong to a single instance of a
class. In the Perl implementation of the MAGE-OM classes, the
interface to attributes is implemented using separate setter and
getter methods for each attribute.

C<Bio::MAGE::BioMaterial::Treatment> has the following attribute accessor methods:

=over


=item identifier

Methods for the C<identifier> attribute.


From the MAGE-OM documentation:

An identifier is an unambiguous string that is unique within the scope (i.e. a document, a set of related documents, or a repository) of its use.


=over


=item $val = $treatment->setIdentifier($val)

The restricted setter method for the C<identifier> attribute.


Input parameters: the value to which the C<identifier> attribute will be set 

Return value: the current value of the C<identifier> attribute 

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified

=cut


sub setIdentifier {
  my $self = shift;
  croak(__PACKAGE__ . "::setIdentifier: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setIdentifier: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
  
  return $self->{__IDENTIFIER} = $val;
}


=item $val = $treatment->getIdentifier()

The restricted getter method for the C<identifier> attribute.

Input parameters: none

Return value: the current value of the C<identifier> attribute 

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getIdentifier {
  my $self = shift;
  croak(__PACKAGE__ . "::getIdentifier: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__IDENTIFIER};
}





=back


=item order

Methods for the C<order> attribute.


From the MAGE-OM documentation:

The chronological order in which a treatment occurred (in relation to other treatments).  More than one treatment can have the same chronological order indicating that they happened (or were caused to happen) simultaneously.


=over


=item $val = $treatment->setOrder($val)

The restricted setter method for the C<order> attribute.


Input parameters: the value to which the C<order> attribute will be set 

Return value: the current value of the C<order> attribute 

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified

=cut


sub setOrder {
  my $self = shift;
  croak(__PACKAGE__ . "::setOrder: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setOrder: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
  
  return $self->{__ORDER} = $val;
}


=item $val = $treatment->getOrder()

The restricted getter method for the C<order> attribute.

Input parameters: none

Return value: the current value of the C<order> attribute 

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getOrder {
  my $self = shift;
  croak(__PACKAGE__ . "::getOrder: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__ORDER};
}





=back


=item name

Methods for the C<name> attribute.


From the MAGE-OM documentation:

The potentially ambiguous common identifier.


=over


=item $val = $treatment->setName($val)

The restricted setter method for the C<name> attribute.


Input parameters: the value to which the C<name> attribute will be set 

Return value: the current value of the C<name> attribute 

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified

=cut


sub setName {
  my $self = shift;
  croak(__PACKAGE__ . "::setName: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setName: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
  
  return $self->{__NAME} = $val;
}


=item $val = $treatment->getName()

The restricted getter method for the C<name> attribute.

Input parameters: none

Return value: the current value of the C<name> attribute 

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getName {
  my $self = shift;
  croak(__PACKAGE__ . "::getName: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__NAME};
}





=back


=back


=head2 ASSOCIATIONS

Associations are references to other classes. Associations in MAGE-OM have a cardinality that determines the minimum and
maximum number of instances of the 'other' class that maybe included
in the association:

=over

=item 1

There B<must> be exactly one item in the association, i.e. this is a
mandatory data field.

=item 0..1

There B<may> be one item in the association, i.e. this is an optional
data field.

=item 1..N

There B<must> be one or more items in the association, i.e. this is a
mandatory data field, with list cardinality.

=item 0..N

There B<may> be one or more items in the association, i.e. this is an
optional data field, with list cardinality.

=back

Bio::MAGE::BioMaterial::Treatment has the following association accessor methods:

=over


=item sourceBioMaterialMeasurements

Methods for the C<sourceBioMaterialMeasurements> association.


From the MAGE-OM documentation:

The BioMaterials and the amounts used in the treatment


=over


=item $array_ref = $treatment->setSourceBioMaterialMeasurements($array_ref)

The restricted setter method for the C<sourceBioMaterialMeasurements> association.


Input parameters: the value to which the C<sourceBioMaterialMeasurements> association will be set : a reference to an array of objects of type C<Bio::MAGE::BioMaterial::BioMaterialMeasurement>

Return value: the current value of the C<sourceBioMaterialMeasurements> association : a reference to an array of objects of type C<Bio::MAGE::BioMaterial::BioMaterialMeasurement>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified, or if C<$array_ref> is not a reference to an array class C<Bio::MAGE::BioMaterial::BioMaterialMeasurement> instances

=cut


sub setSourceBioMaterialMeasurements {
  my $self = shift;
  croak(__PACKAGE__ . "::setSourceBioMaterialMeasurements: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setSourceBioMaterialMeasurements: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
    croak(__PACKAGE__ . "::setSourceBioMaterialMeasurements: expected array reference, got $self")
    unless (not defined $val) or UNIVERSAL::isa($val,'ARRAY');
  if (defined $val) {
    foreach my $val_ent (@{$val}) {
      croak(__PACKAGE__ . "::setSourceBioMaterialMeasurements: wrong type: " . ref($val_ent) . " expected Bio::MAGE::BioMaterial::BioMaterialMeasurement")
        unless UNIVERSAL::isa($val_ent,'Bio::MAGE::BioMaterial::BioMaterialMeasurement');
    }
  }

  return $self->{__SOURCEBIOMATERIALMEASUREMENTS} = $val;
}


=item $array_ref = $treatment->getSourceBioMaterialMeasurements()

The restricted getter method for the C<sourceBioMaterialMeasurements> association.

Input parameters: none

Return value: the current value of the C<sourceBioMaterialMeasurements> association : a reference to an array of objects of type C<Bio::MAGE::BioMaterial::BioMaterialMeasurement>

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getSourceBioMaterialMeasurements {
  my $self = shift;
  croak(__PACKAGE__ . "::getSourceBioMaterialMeasurements: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__SOURCEBIOMATERIALMEASUREMENTS};
}




=item $val = $treatment->addSourceBioMaterialMeasurements(@vals)

Because the sourceBioMaterialMeasurements association has list cardinality, it may store more
than one value. This method adds the current list of objects in the sourceBioMaterialMeasurements association.

Input parameters: the list of values C<@vals> to add to the sourceBioMaterialMeasurements association. B<NOTE>: submitting a single value is permitted.

Return value: the number of items stored in the slot B<after> adding C<@vals>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or if any of the objects in @vals is not an instance of class C<Bio::MAGE::BioMaterial::BioMaterialMeasurement>

=cut


sub addSourceBioMaterialMeasurements {
  my $self = shift;
  croak(__PACKAGE__ . "::addSourceBioMaterialMeasurements: no arguments passed to adder")
    unless @_;
  my @vals = @_;
    foreach my $val (@vals) {
    croak(__PACKAGE__ . "::addSourceBioMaterialMeasurements: wrong type: " . ref($val) . " expected Bio::MAGE::BioMaterial::BioMaterialMeasurement")
      unless UNIVERSAL::isa($val,'Bio::MAGE::BioMaterial::BioMaterialMeasurement');
  }

  return push(@{$self->{__SOURCEBIOMATERIALMEASUREMENTS}},@vals);
}





=back


=item auditTrail

Methods for the C<auditTrail> association.


From the MAGE-OM documentation:

A list of Audit instances that track changes to the instance of Describable.


=over


=item $array_ref = $treatment->setAuditTrail($array_ref)

The restricted setter method for the C<auditTrail> association.


Input parameters: the value to which the C<auditTrail> association will be set : a reference to an array of objects of type C<Bio::MAGE::AuditAndSecurity::Audit>

Return value: the current value of the C<auditTrail> association : a reference to an array of objects of type C<Bio::MAGE::AuditAndSecurity::Audit>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified, or if C<$array_ref> is not a reference to an array class C<Bio::MAGE::AuditAndSecurity::Audit> instances

=cut


sub setAuditTrail {
  my $self = shift;
  croak(__PACKAGE__ . "::setAuditTrail: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setAuditTrail: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
    croak(__PACKAGE__ . "::setAuditTrail: expected array reference, got $self")
    unless (not defined $val) or UNIVERSAL::isa($val,'ARRAY');
  if (defined $val) {
    foreach my $val_ent (@{$val}) {
      croak(__PACKAGE__ . "::setAuditTrail: wrong type: " . ref($val_ent) . " expected Bio::MAGE::AuditAndSecurity::Audit")
        unless UNIVERSAL::isa($val_ent,'Bio::MAGE::AuditAndSecurity::Audit');
    }
  }

  return $self->{__AUDITTRAIL} = $val;
}


=item $array_ref = $treatment->getAuditTrail()

The restricted getter method for the C<auditTrail> association.

Input parameters: none

Return value: the current value of the C<auditTrail> association : a reference to an array of objects of type C<Bio::MAGE::AuditAndSecurity::Audit>

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getAuditTrail {
  my $self = shift;
  croak(__PACKAGE__ . "::getAuditTrail: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__AUDITTRAIL};
}




=item $val = $treatment->addAuditTrail(@vals)

Because the auditTrail association has list cardinality, it may store more
than one value. This method adds the current list of objects in the auditTrail association.

Input parameters: the list of values C<@vals> to add to the auditTrail association. B<NOTE>: submitting a single value is permitted.

Return value: the number of items stored in the slot B<after> adding C<@vals>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or if any of the objects in @vals is not an instance of class C<Bio::MAGE::AuditAndSecurity::Audit>

=cut


sub addAuditTrail {
  my $self = shift;
  croak(__PACKAGE__ . "::addAuditTrail: no arguments passed to adder")
    unless @_;
  my @vals = @_;
    foreach my $val (@vals) {
    croak(__PACKAGE__ . "::addAuditTrail: wrong type: " . ref($val) . " expected Bio::MAGE::AuditAndSecurity::Audit")
      unless UNIVERSAL::isa($val,'Bio::MAGE::AuditAndSecurity::Audit');
  }

  return push(@{$self->{__AUDITTRAIL}},@vals);
}





=back


=item propertySets

Methods for the C<propertySets> association.


From the MAGE-OM documentation:

Allows specification of name/value pairs.  Meant to primarily help in-house, pipeline processing of instances by providing a place for values that aren't part of the specification proper.


=over


=item $array_ref = $treatment->setPropertySets($array_ref)

The restricted setter method for the C<propertySets> association.


Input parameters: the value to which the C<propertySets> association will be set : a reference to an array of objects of type C<Bio::MAGE::NameValueType>

Return value: the current value of the C<propertySets> association : a reference to an array of objects of type C<Bio::MAGE::NameValueType>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified, or if C<$array_ref> is not a reference to an array class C<Bio::MAGE::NameValueType> instances

=cut


sub setPropertySets {
  my $self = shift;
  croak(__PACKAGE__ . "::setPropertySets: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setPropertySets: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
    croak(__PACKAGE__ . "::setPropertySets: expected array reference, got $self")
    unless (not defined $val) or UNIVERSAL::isa($val,'ARRAY');
  if (defined $val) {
    foreach my $val_ent (@{$val}) {
      croak(__PACKAGE__ . "::setPropertySets: wrong type: " . ref($val_ent) . " expected Bio::MAGE::NameValueType")
        unless UNIVERSAL::isa($val_ent,'Bio::MAGE::NameValueType');
    }
  }

  return $self->{__PROPERTYSETS} = $val;
}


=item $array_ref = $treatment->getPropertySets()

The restricted getter method for the C<propertySets> association.

Input parameters: none

Return value: the current value of the C<propertySets> association : a reference to an array of objects of type C<Bio::MAGE::NameValueType>

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getPropertySets {
  my $self = shift;
  croak(__PACKAGE__ . "::getPropertySets: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__PROPERTYSETS};
}




=item $val = $treatment->addPropertySets(@vals)

Because the propertySets association has list cardinality, it may store more
than one value. This method adds the current list of objects in the propertySets association.

Input parameters: the list of values C<@vals> to add to the propertySets association. B<NOTE>: submitting a single value is permitted.

Return value: the number of items stored in the slot B<after> adding C<@vals>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or if any of the objects in @vals is not an instance of class C<Bio::MAGE::NameValueType>

=cut


sub addPropertySets {
  my $self = shift;
  croak(__PACKAGE__ . "::addPropertySets: no arguments passed to adder")
    unless @_;
  my @vals = @_;
    foreach my $val (@vals) {
    croak(__PACKAGE__ . "::addPropertySets: wrong type: " . ref($val) . " expected Bio::MAGE::NameValueType")
      unless UNIVERSAL::isa($val,'Bio::MAGE::NameValueType');
  }

  return push(@{$self->{__PROPERTYSETS}},@vals);
}





=back


=item protocolApplications

Methods for the C<protocolApplications> association.


From the MAGE-OM documentation:

The applied protocols to the BioEvent.


=over


=item $array_ref = $treatment->setProtocolApplications($array_ref)

The restricted setter method for the C<protocolApplications> association.


Input parameters: the value to which the C<protocolApplications> association will be set : a reference to an array of objects of type C<Bio::MAGE::Protocol::ProtocolApplication>

Return value: the current value of the C<protocolApplications> association : a reference to an array of objects of type C<Bio::MAGE::Protocol::ProtocolApplication>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified, or if C<$array_ref> is not a reference to an array class C<Bio::MAGE::Protocol::ProtocolApplication> instances

=cut


sub setProtocolApplications {
  my $self = shift;
  croak(__PACKAGE__ . "::setProtocolApplications: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setProtocolApplications: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
    croak(__PACKAGE__ . "::setProtocolApplications: expected array reference, got $self")
    unless (not defined $val) or UNIVERSAL::isa($val,'ARRAY');
  if (defined $val) {
    foreach my $val_ent (@{$val}) {
      croak(__PACKAGE__ . "::setProtocolApplications: wrong type: " . ref($val_ent) . " expected Bio::MAGE::Protocol::ProtocolApplication")
        unless UNIVERSAL::isa($val_ent,'Bio::MAGE::Protocol::ProtocolApplication');
    }
  }

  return $self->{__PROTOCOLAPPLICATIONS} = $val;
}


=item $array_ref = $treatment->getProtocolApplications()

The restricted getter method for the C<protocolApplications> association.

Input parameters: none

Return value: the current value of the C<protocolApplications> association : a reference to an array of objects of type C<Bio::MAGE::Protocol::ProtocolApplication>

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getProtocolApplications {
  my $self = shift;
  croak(__PACKAGE__ . "::getProtocolApplications: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__PROTOCOLAPPLICATIONS};
}




=item $val = $treatment->addProtocolApplications(@vals)

Because the protocolApplications association has list cardinality, it may store more
than one value. This method adds the current list of objects in the protocolApplications association.

Input parameters: the list of values C<@vals> to add to the protocolApplications association. B<NOTE>: submitting a single value is permitted.

Return value: the number of items stored in the slot B<after> adding C<@vals>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or if any of the objects in @vals is not an instance of class C<Bio::MAGE::Protocol::ProtocolApplication>

=cut


sub addProtocolApplications {
  my $self = shift;
  croak(__PACKAGE__ . "::addProtocolApplications: no arguments passed to adder")
    unless @_;
  my @vals = @_;
    foreach my $val (@vals) {
    croak(__PACKAGE__ . "::addProtocolApplications: wrong type: " . ref($val) . " expected Bio::MAGE::Protocol::ProtocolApplication")
      unless UNIVERSAL::isa($val,'Bio::MAGE::Protocol::ProtocolApplication');
  }

  return push(@{$self->{__PROTOCOLAPPLICATIONS}},@vals);
}





=back


=item descriptions

Methods for the C<descriptions> association.


From the MAGE-OM documentation:

Free hand text descriptions.  Makes available the associations of Description to an instance of Describable.


=over


=item $array_ref = $treatment->setDescriptions($array_ref)

The restricted setter method for the C<descriptions> association.


Input parameters: the value to which the C<descriptions> association will be set : a reference to an array of objects of type C<Bio::MAGE::Description::Description>

Return value: the current value of the C<descriptions> association : a reference to an array of objects of type C<Bio::MAGE::Description::Description>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified, or if C<$array_ref> is not a reference to an array class C<Bio::MAGE::Description::Description> instances

=cut


sub setDescriptions {
  my $self = shift;
  croak(__PACKAGE__ . "::setDescriptions: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setDescriptions: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
    croak(__PACKAGE__ . "::setDescriptions: expected array reference, got $self")
    unless (not defined $val) or UNIVERSAL::isa($val,'ARRAY');
  if (defined $val) {
    foreach my $val_ent (@{$val}) {
      croak(__PACKAGE__ . "::setDescriptions: wrong type: " . ref($val_ent) . " expected Bio::MAGE::Description::Description")
        unless UNIVERSAL::isa($val_ent,'Bio::MAGE::Description::Description');
    }
  }

  return $self->{__DESCRIPTIONS} = $val;
}


=item $array_ref = $treatment->getDescriptions()

The restricted getter method for the C<descriptions> association.

Input parameters: none

Return value: the current value of the C<descriptions> association : a reference to an array of objects of type C<Bio::MAGE::Description::Description>

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getDescriptions {
  my $self = shift;
  croak(__PACKAGE__ . "::getDescriptions: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__DESCRIPTIONS};
}




=item $val = $treatment->addDescriptions(@vals)

Because the descriptions association has list cardinality, it may store more
than one value. This method adds the current list of objects in the descriptions association.

Input parameters: the list of values C<@vals> to add to the descriptions association. B<NOTE>: submitting a single value is permitted.

Return value: the number of items stored in the slot B<after> adding C<@vals>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or if any of the objects in @vals is not an instance of class C<Bio::MAGE::Description::Description>

=cut


sub addDescriptions {
  my $self = shift;
  croak(__PACKAGE__ . "::addDescriptions: no arguments passed to adder")
    unless @_;
  my @vals = @_;
    foreach my $val (@vals) {
    croak(__PACKAGE__ . "::addDescriptions: wrong type: " . ref($val) . " expected Bio::MAGE::Description::Description")
      unless UNIVERSAL::isa($val,'Bio::MAGE::Description::Description');
  }

  return push(@{$self->{__DESCRIPTIONS}},@vals);
}





=back


=item action

Methods for the C<action> association.


From the MAGE-OM documentation:

The event that occurred (e.g. grow, wait, add, etc...).  The actions should be a recommended vocabulary


=over


=item $val = $treatment->setAction($val)

The restricted setter method for the C<action> association.


Input parameters: the value to which the C<action> association will be set : one of the accepted enumerated values.

Return value: the current value of the C<action> association : one of the accepted enumerated values.

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified, or if C<$val> is not an instance of class C<Bio::MAGE::Description::OntologyEntry>

=cut


sub setAction {
  my $self = shift;
  croak(__PACKAGE__ . "::setAction: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setAction: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
  croak(__PACKAGE__ . "::setAction: wrong type: " . ref($val) . " expected Bio::MAGE::Description::OntologyEntry") unless (not defined $val) or UNIVERSAL::isa($val,'Bio::MAGE::Description::OntologyEntry');
  return $self->{__ACTION} = $val;
}


=item $val = $treatment->getAction()

The restricted getter method for the C<action> association.

Input parameters: none

Return value: the current value of the C<action> association : an instance of type C<Bio::MAGE::Description::OntologyEntry>.

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getAction {
  my $self = shift;
  croak(__PACKAGE__ . "::getAction: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__ACTION};
}





=back


=item security

Methods for the C<security> association.


From the MAGE-OM documentation:

Information on the security for the instance of the class.


=over


=item $val = $treatment->setSecurity($val)

The restricted setter method for the C<security> association.


Input parameters: the value to which the C<security> association will be set : one of the accepted enumerated values.

Return value: the current value of the C<security> association : one of the accepted enumerated values.

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified, or if C<$val> is not an instance of class C<Bio::MAGE::AuditAndSecurity::Security>

=cut


sub setSecurity {
  my $self = shift;
  croak(__PACKAGE__ . "::setSecurity: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setSecurity: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
  croak(__PACKAGE__ . "::setSecurity: wrong type: " . ref($val) . " expected Bio::MAGE::AuditAndSecurity::Security") unless (not defined $val) or UNIVERSAL::isa($val,'Bio::MAGE::AuditAndSecurity::Security');
  return $self->{__SECURITY} = $val;
}


=item $val = $treatment->getSecurity()

The restricted getter method for the C<security> association.

Input parameters: none

Return value: the current value of the C<security> association : an instance of type C<Bio::MAGE::AuditAndSecurity::Security>.

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getSecurity {
  my $self = shift;
  croak(__PACKAGE__ . "::getSecurity: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__SECURITY};
}





=back


=item compoundMeasurements

Methods for the C<compoundMeasurements> association.


From the MAGE-OM documentation:

The compounds and their amounts used in the treatment.


=over


=item $array_ref = $treatment->setCompoundMeasurements($array_ref)

The restricted setter method for the C<compoundMeasurements> association.


Input parameters: the value to which the C<compoundMeasurements> association will be set : a reference to an array of objects of type C<Bio::MAGE::BioMaterial::CompoundMeasurement>

Return value: the current value of the C<compoundMeasurements> association : a reference to an array of objects of type C<Bio::MAGE::BioMaterial::CompoundMeasurement>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified, or if C<$array_ref> is not a reference to an array class C<Bio::MAGE::BioMaterial::CompoundMeasurement> instances

=cut


sub setCompoundMeasurements {
  my $self = shift;
  croak(__PACKAGE__ . "::setCompoundMeasurements: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setCompoundMeasurements: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
    croak(__PACKAGE__ . "::setCompoundMeasurements: expected array reference, got $self")
    unless (not defined $val) or UNIVERSAL::isa($val,'ARRAY');
  if (defined $val) {
    foreach my $val_ent (@{$val}) {
      croak(__PACKAGE__ . "::setCompoundMeasurements: wrong type: " . ref($val_ent) . " expected Bio::MAGE::BioMaterial::CompoundMeasurement")
        unless UNIVERSAL::isa($val_ent,'Bio::MAGE::BioMaterial::CompoundMeasurement');
    }
  }

  return $self->{__COMPOUNDMEASUREMENTS} = $val;
}


=item $array_ref = $treatment->getCompoundMeasurements()

The restricted getter method for the C<compoundMeasurements> association.

Input parameters: none

Return value: the current value of the C<compoundMeasurements> association : a reference to an array of objects of type C<Bio::MAGE::BioMaterial::CompoundMeasurement>

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getCompoundMeasurements {
  my $self = shift;
  croak(__PACKAGE__ . "::getCompoundMeasurements: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__COMPOUNDMEASUREMENTS};
}




=item $val = $treatment->addCompoundMeasurements(@vals)

Because the compoundMeasurements association has list cardinality, it may store more
than one value. This method adds the current list of objects in the compoundMeasurements association.

Input parameters: the list of values C<@vals> to add to the compoundMeasurements association. B<NOTE>: submitting a single value is permitted.

Return value: the number of items stored in the slot B<after> adding C<@vals>

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or if any of the objects in @vals is not an instance of class C<Bio::MAGE::BioMaterial::CompoundMeasurement>

=cut


sub addCompoundMeasurements {
  my $self = shift;
  croak(__PACKAGE__ . "::addCompoundMeasurements: no arguments passed to adder")
    unless @_;
  my @vals = @_;
    foreach my $val (@vals) {
    croak(__PACKAGE__ . "::addCompoundMeasurements: wrong type: " . ref($val) . " expected Bio::MAGE::BioMaterial::CompoundMeasurement")
      unless UNIVERSAL::isa($val,'Bio::MAGE::BioMaterial::CompoundMeasurement');
  }

  return push(@{$self->{__COMPOUNDMEASUREMENTS}},@vals);
}





=back


=item actionMeasurement

Methods for the C<actionMeasurement> association.


From the MAGE-OM documentation:

Measures events like duration, centrifuge speed, etc.


=over


=item $val = $treatment->setActionMeasurement($val)

The restricted setter method for the C<actionMeasurement> association.


Input parameters: the value to which the C<actionMeasurement> association will be set : one of the accepted enumerated values.

Return value: the current value of the C<actionMeasurement> association : one of the accepted enumerated values.

Side effects: none

Exceptions: will call C<croak()> if no input parameters are specified, or
if too many input parameters are specified, or if C<$val> is not an instance of class C<Bio::MAGE::Measurement::Measurement>

=cut


sub setActionMeasurement {
  my $self = shift;
  croak(__PACKAGE__ . "::setActionMeasurement: no arguments passed to setter")
    unless @_;
  croak(__PACKAGE__ . "::setActionMeasurement: too many arguments passed to setter")
    if @_ > 1;
  my $val = shift;
  croak(__PACKAGE__ . "::setActionMeasurement: wrong type: " . ref($val) . " expected Bio::MAGE::Measurement::Measurement") unless (not defined $val) or UNIVERSAL::isa($val,'Bio::MAGE::Measurement::Measurement');
  return $self->{__ACTIONMEASUREMENT} = $val;
}


=item $val = $treatment->getActionMeasurement()

The restricted getter method for the C<actionMeasurement> association.

Input parameters: none

Return value: the current value of the C<actionMeasurement> association : an instance of type C<Bio::MAGE::Measurement::Measurement>.

Side effects: none

Exceptions: will call C<croak()> if any input parameters are specified

=cut


sub getActionMeasurement {
  my $self = shift;
  croak(__PACKAGE__ . "::getActionMeasurement: arguments passed to getter")
    if @_;
  my $val = shift;
  return $self->{__ACTIONMEASUREMENT};
}





=back


sub initialize {


  my $self = shift;
  return 1;


}

=back


=cut


=head1 SLOTS, ATTRIBUTES, AND ASSOCIATIONS

In the Perl implementation of MAGE-OM classes, there are
three types of class data members: C<slots>, C<attributes>, and
C<associations>.

=head2 SLOTS

This API uses the term C<slot> to indicate a data member of the class
that was not present in the UML model and is used for mainly internal
purposes - use only if you understand the inner workings of the
API. Most often slots are used by generic methods such as those in the
XML writing and reading classes.

Slots are implemented using unified getter/setter methods:

=over

=item $var = $obj->slot_name();

Retrieves the current value of the slot.

=item $new_var = $obj->slot_name($new_var);

Store $new_var in the slot - the return value is also $new_var.

=item @names = $obj->get_slot_names()

Returns the list of all slots in the class.

=back

B<DATA CHECKING>: No data type checking is made for these methods.

=head2 ATTRIBUTES AND ASSOCIATIONS

The terms C<attribute> and C<association> indicate data members of the
class that were specified directly from the UML model.

In the Perl implementation of MAGE-OM classes,
association and attribute accessors are implemented using three
separate methods:

=over

=item get*

Retrieves the current value.

B<NOTE>: For associations, if the association has list cardinality, an
array reference is returned.

B<DATA CHECKING>: Ensure that no argument is provided.

=item set*

Sets the current value, B<replacing> any existing value.

B<NOTE>: For associations, if the association has list cardinality,
the argument must be an array reference. Because of this, you probably
should be using the add* methods.

B<DATA CHECKING>: For attributes, ensure that a single value is
provided as the argument. For associations, if the association has
list cardinality, ensure that the argument is a reference to an array
of instances of the correct MAGE-OM class, otherwise
ensure that there is a single argument of the correct MAGE-OM class.

=item add*

B<NOTE>: Only present in associations with list cardinality. 

Appends a list of objects to any values that may already be stored
in the association.

B<DATA CHECKING>: Ensure that all arguments are of the correct MAGE-OM class.

=back

=head2 GENERIC METHODS

The unified base class of all MAGE-OM classes, C<Bio::MAGE::Base>, provides a set of generic methods that
will operate on slots, attributes, and associations:

=over

=item $val = $obj->get_slot($name)

=item \@list_ref = $obj->get_slots(@name_list);

=item $val = $obj->set_slot($name,$val)

=item $obj->set_slots(%parameters)

=item $obj->set_slots(\@name_list, \@value_list)

See elsewhere in this page for a detailed description of these
methods.

=back

=cut


=head1 BUGS

Please send bug reports to the project mailing list: (mged-mage 'at' lists 'dot' sf 'dot' net)

=head1 AUTHOR

Jason E. Stewart (jasons 'at' cpan 'dot' org)

=head1 SEE ALSO

perl(1).

=cut

# all perl modules must be true...
1;

