use utf8;

package SemanticWeb::Schema::Article;

# ABSTRACT: An article

use Moo;

extends qw/ SemanticWeb::Schema::CreativeWork /;


use MooX::JSON_LD 'Article';
use Ref::Util qw/ is_plain_hashref /;
# RECOMMEND PREREQ: Ref::Util::XS

use namespace::autoclean;

our $VERSION = 'v9.0.0';


has article_body => (
    is        => 'rw',
    predicate => '_has_article_body',
    json_ld   => 'articleBody',
);



has article_section => (
    is        => 'rw',
    predicate => '_has_article_section',
    json_ld   => 'articleSection',
);



has backstory => (
    is        => 'rw',
    predicate => '_has_backstory',
    json_ld   => 'backstory',
);



has page_end => (
    is        => 'rw',
    predicate => '_has_page_end',
    json_ld   => 'pageEnd',
);



has page_start => (
    is        => 'rw',
    predicate => '_has_page_start',
    json_ld   => 'pageStart',
);



has pagination => (
    is        => 'rw',
    predicate => '_has_pagination',
    json_ld   => 'pagination',
);



has speakable => (
    is        => 'rw',
    predicate => '_has_speakable',
    json_ld   => 'speakable',
);



has word_count => (
    is        => 'rw',
    predicate => '_has_word_count',
    json_ld   => 'wordCount',
);





1;

__END__

=pod

=encoding UTF-8

=head1 NAME

SemanticWeb::Schema::Article - An article

=head1 VERSION

version v9.0.0

=head1 DESCRIPTION

=for html <p>An article, such as a news article or piece of investigative report.
Newspapers and magazines have articles of many different types and this is
intended to cover them all.<br/><br/> See also <a
href="http://blog.schema.org/2014/09/schemaorg-support-for-bibliographic_2.
html">blog post</a>.<p>

=head1 ATTRIBUTES

=head2 C<article_body>

C<articleBody>

The actual body of the article.

A article_body should be one of the following types:

=over

=item C<Str>

=back

=head2 C<_has_article_body>

A predicate for the L</article_body> attribute.

=head2 C<article_section>

C<articleSection>

Articles may belong to one or more 'sections' in a magazine or newspaper,
such as Sports, Lifestyle, etc.

A article_section should be one of the following types:

=over

=item C<Str>

=back

=head2 C<_has_article_section>

A predicate for the L</article_section> attribute.

=head2 C<backstory>

=for html <p>For an <a class="localLink"
href="http://schema.org/Article">Article</a>, typically a <a
class="localLink" href="http://schema.org/NewsArticle">NewsArticle</a>, the
backstory property provides a textual summary giving a brief explanation of
why and how an article was created. In a journalistic setting this could
include information about reporting process, methods, interviews, data
sources, etc.<p>

A backstory should be one of the following types:

=over

=item C<InstanceOf['SemanticWeb::Schema::CreativeWork']>

=item C<Str>

=back

=head2 C<_has_backstory>

A predicate for the L</backstory> attribute.

=head2 C<page_end>

C<pageEnd>

The page on which the work ends; for example "138" or "xvi".

A page_end should be one of the following types:

=over

=item C<InstanceOf['SemanticWeb::Schema::Integer']>

=item C<Str>

=back

=head2 C<_has_page_end>

A predicate for the L</page_end> attribute.

=head2 C<page_start>

C<pageStart>

The page on which the work starts; for example "135" or "xiii".

A page_start should be one of the following types:

=over

=item C<InstanceOf['SemanticWeb::Schema::Integer']>

=item C<Str>

=back

=head2 C<_has_page_start>

A predicate for the L</page_start> attribute.

=head2 C<pagination>

Any description of pages that is not separated into pageStart and pageEnd;
for example, "1-6, 9, 55" or "10-12, 46-49".

A pagination should be one of the following types:

=over

=item C<Str>

=back

=head2 C<_has_pagination>

A predicate for the L</pagination> attribute.

=head2 C<speakable>

=for html <p>Indicates sections of a Web page that are particularly 'speakable' in
the sense of being highlighted as being especially appropriate for
text-to-speech conversion. Other sections of a page may also be usefully
spoken in particular circumstances; the 'speakable' property serves to
indicate the parts most likely to be generally useful for speech.<br/><br/>
The <em>speakable</em> property can be repeated an arbitrary number of
times, with three kinds of possible 'content-locator' values:<br/><br/> 1.)
<em>id-value</em> URL references - uses <em>id-value</em> of an element in
the page being annotated. The simplest use of <em>speakable</em> has
(potentially relative) URL values, referencing identified sections of the
document concerned.<br/><br/> 2.) CSS Selectors - addresses content in the
annotated page, eg. via class attribute. Use the <a class="localLink"
href="http://schema.org/cssSelector">cssSelector</a> property.<br/><br/>
3.) XPaths - addresses content via XPaths (assuming an XML view of the
content). Use the <a class="localLink"
href="http://schema.org/xpath">xpath</a> property.<br/><br/> For more
sophisticated markup of speakable sections beyond simple ID references,
either CSS selectors or XPath expressions to pick out document section(s)
as speakable. For this we define a supporting type, <a class="localLink"
href="http://schema.org/SpeakableSpecification">SpeakableSpecification</a>
which is defined to be a possible value of the <em>speakable</em>
property.<p>

A speakable should be one of the following types:

=over

=item C<InstanceOf['SemanticWeb::Schema::SpeakableSpecification']>

=item C<Str>

=back

=head2 C<_has_speakable>

A predicate for the L</speakable> attribute.

=head2 C<word_count>

C<wordCount>

The number of words in the text of the Article.

A word_count should be one of the following types:

=over

=item C<InstanceOf['SemanticWeb::Schema::Integer']>

=back

=head2 C<_has_word_count>

A predicate for the L</word_count> attribute.

=head1 SEE ALSO

L<SemanticWeb::Schema::CreativeWork>

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
