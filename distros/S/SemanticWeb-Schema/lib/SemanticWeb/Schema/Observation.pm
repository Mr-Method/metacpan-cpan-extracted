use utf8;

package SemanticWeb::Schema::Observation;

# ABSTRACT: Instances of the class Observation are used to specify observations about an entity (which may or may not be an instance of a StatisticalPopulation )

use Moo;

extends qw/ SemanticWeb::Schema::Intangible /;


use MooX::JSON_LD 'Observation';
use Ref::Util qw/ is_plain_hashref /;
# RECOMMEND PREREQ: Ref::Util::XS

use namespace::autoclean;

our $VERSION = 'v9.0.0';


has margin_of_error => (
    is        => 'rw',
    predicate => '_has_margin_of_error',
    json_ld   => 'marginOfError',
);



has measured_property => (
    is        => 'rw',
    predicate => '_has_measured_property',
    json_ld   => 'measuredProperty',
);



has measured_value => (
    is        => 'rw',
    predicate => '_has_measured_value',
    json_ld   => 'measuredValue',
);



has observation_date => (
    is        => 'rw',
    predicate => '_has_observation_date',
    json_ld   => 'observationDate',
);



has observed_node => (
    is        => 'rw',
    predicate => '_has_observed_node',
    json_ld   => 'observedNode',
);





1;

__END__

=pod

=encoding UTF-8

=head1 NAME

SemanticWeb::Schema::Observation - Instances of the class Observation are used to specify observations about an entity (which may or may not be an instance of a StatisticalPopulation )

=head1 VERSION

version v9.0.0

=head1 DESCRIPTION

=for html <p>Instances of the class <a class="localLink"
href="http://schema.org/Observation">Observation</a> are used to specify
observations about an entity (which may or may not be an instance of a <a
class="localLink"
href="http://schema.org/StatisticalPopulation">StatisticalPopulation</a>),
at a particular time. The principal properties of an <a class="localLink"
href="http://schema.org/Observation">Observation</a> are <a
class="localLink" href="http://schema.org/observedNode">observedNode</a>,
<a class="localLink"
href="http://schema.org/measuredProperty">measuredProperty</a>, <a
class="localLink" href="http://schema.org/measuredValue">measuredValue</a>
(or <a class="localLink" href="http://schema.org/median">median</a>, etc.)
and <a class="localLink"
href="http://schema.org/observationDate">observationDate</a> (<a
class="localLink"
href="http://schema.org/measuredProperty">measuredProperty</a> properties
can, but need not always, be W3C RDF Data Cube "measure properties", as in
the <a
href="https://www.w3.org/TR/vocab-data-cube/#dsd-example">lifeExpectancy
example</a>). See also <a class="localLink"
href="http://schema.org/StatisticalPopulation">StatisticalPopulation</a>,
and the <a href="/docs/data-and-datasets.html">data and datasets</a>
overview for more details.<p>

=head1 ATTRIBUTES

=head2 C<margin_of_error>

C<marginOfError>

=for html <p>A marginOfError for an <a class="localLink"
href="http://schema.org/Observation">Observation</a>.<p>

A margin_of_error should be one of the following types:

=over

=item C<Str>

=back

=head2 C<_has_margin_of_error>

A predicate for the L</margin_of_error> attribute.

=head2 C<measured_property>

C<measuredProperty>

=for html <p>The measuredProperty of an <a class="localLink"
href="http://schema.org/Observation">Observation</a>, either a schema.org
property, a property from other RDF-compatible systems e.g. W3C RDF Data
Cube, or schema.org extensions such as <a
href="https://www.gs1.org/voc/?show=properties">GS1's</a>.<p>

A measured_property should be one of the following types:

=over

=item C<InstanceOf['SemanticWeb::Schema::Property']>

=back

=head2 C<_has_measured_property>

A predicate for the L</measured_property> attribute.

=head2 C<measured_value>

C<measuredValue>

=for html <p>The measuredValue of an <a class="localLink"
href="http://schema.org/Observation">Observation</a>.<p>

A measured_value should be one of the following types:

=over

=item C<InstanceOf['SemanticWeb::Schema::DataType']>

=back

=head2 C<_has_measured_value>

A predicate for the L</measured_value> attribute.

=head2 C<observation_date>

C<observationDate>

=for html <p>The observationDate of an <a class="localLink"
href="http://schema.org/Observation">Observation</a>.<p>

A observation_date should be one of the following types:

=over

=item C<Str>

=back

=head2 C<_has_observation_date>

A predicate for the L</observation_date> attribute.

=head2 C<observed_node>

C<observedNode>

=for html <p>The observedNode of an <a class="localLink"
href="http://schema.org/Observation">Observation</a>, often a <a
class="localLink"
href="http://schema.org/StatisticalPopulation">StatisticalPopulation</a>.<p
>

A observed_node should be one of the following types:

=over

=item C<InstanceOf['SemanticWeb::Schema::StatisticalPopulation']>

=back

=head2 C<_has_observed_node>

A predicate for the L</observed_node> attribute.

=head1 SEE ALSO

L<SemanticWeb::Schema::Intangible>

=head1 SOURCE

The development version is on github at L<https://github.com/robrwo/SemanticWeb-Schema>
and may be cloned from L<git://github.com/robrwo/SemanticWeb-Schema.git>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
L<https://github.com/robrwo/SemanticWeb-Schema/issues>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Robert Rothenberg <rrwo@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2018-2020 by Robert Rothenberg.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
