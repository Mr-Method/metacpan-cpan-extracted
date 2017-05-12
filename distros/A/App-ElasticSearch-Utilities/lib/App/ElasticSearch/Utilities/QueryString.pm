package App::ElasticSearch::Utilities::QueryString;
# ABSTRACT: CLI query string fixer

use strict;
use warnings;

use App::ElasticSearch::Utilities qw(:config);
use App::ElasticSearch::Utilities::Query;
use CLI::Helpers qw(:output);
use Module::Pluggable::Object;
use Moo;
use Sub::Quote;

use namespace::autoclean;


my %LEADING  = map { $_ => 1 } qw( AND OR );
my %TRAILING = map { $_ => 1 } qw( AND OR NOT );


has search_path => (
    is => 'rw',
    isa => quote_sub(q{die "Not an ARRAY" unless ref $_[0] eq 'ARRAY'}),
    default => sub {[]},
);


has plugins => (
    is => 'ro',
    isa => quote_sub(q{die "Not an ARRAY" unless ref $_[0] eq 'ARRAY' }),
    builder => '_build_plugins',
    lazy => 1,
);


sub expand_query_string {
    my $self = shift;

    my $query  = App::ElasticSearch::Utilities::Query->new();
    my @processed = ();
    TOKEN: foreach my $token (@_) {
        foreach my $p (@{ $self->plugins }) {
            my $res = $p->handle_token($token);
            if( defined $res ) {
                push @processed, ref $res eq 'ARRAY' ? @{$res} : $res;
                next TOKEN;
            }
        }
        push @processed, { query_string => $token };
    }

    debug({color=>"magenta"}, "Processed parts");
    debug_var({color=>"magenta"},\@processed);

    my $invert=0;
    my @dangling=();
    my @qs=();
    foreach my $part (@processed) {
        if( exists $part->{dangles} ) {
            push @dangling, $part->{query_string};
        }
        elsif( exists $part->{query_string} ) {
            push @qs, @dangling, $part->{query_string};
            @dangling=(),
        }
        elsif( exists $part->{condition} ) {
            my $target = $invert ? 'must_not' : 'must';
            $query->add_bool( $target => $part->{condition} );
            @dangling=();
        }
        # Carry over the Inversion for instance where we jump out of the QS
        $invert = exists $part->{invert} && $part->{invert};
    }
    if(@qs)  {
        pop   @qs while @qs && exists $TRAILING{$qs[-1]};
        shift @qs while @qs && exists $LEADING{$qs[0]};
    }
    # $query->add_aggregation();
    $query->add_bool(must => { query_string => { query => join(' ', @qs) } }) if @qs;

    return $query;
}

# Builder Routines for QS Objects
sub _build_plugins {
    my $self    = shift;
    my $globals = es_globals('plugins');
    my $finder = Module::Pluggable::Object->new(
        search_path => ['App::ElasticSearch::Utilities::QueryString',@{ $self->search_path }],
        except      => [qw(App::ElasticSearch::Utilities::QueryString::Plugin)],
        instantiate => 'new',
    );
    my @plugins;
    foreach my $p ( sort { $a->priority <=> $b->priority || $a->name cmp $b->name }
        $finder->plugins( options => defined $globals ? $globals : {} )
    ) {
        debug(sprintf "Loaded %s with priority:%d", $p->name, $p->priority);
        push @plugins, $p;
    }
    return \@plugins;
}

# Return true
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::ElasticSearch::Utilities::QueryString - CLI query string fixer

=head1 VERSION

version 5.3

=head1 SYNOPSIS

This class provides a pluggable architecture to expand query strings on the
command-line into complex Elasticsearch queries.

=head1 ATTRIBUTES

=head2 search_path

An array reference of additional namespaces to search for loading the query string
processing plugins.  Example:

    $qs->search_path([qw(My::Company::QueryString)]);

This will search:

    App::ElasticSearch::Utilities::QueryString::*
    My::Company::QueryString::*

For query processing plugins.

=head2 plugins

Array reference of ordered query string processing plugins, lazily assembled.

=head1 METHODS

=head2 expand_query_string(@tokens)

This function takes a list of tokens, often from the command line via @ARGV.  Uses
a plugin infrastructure to allow customization.

Returns: L<App::ElasticSearch::Utilities::Query> object

=head1 TOKENS

The token expansion plugins can return undefined, which is basically a noop on the token.
The plugin can return a hash reference, which marks that token as handled and no other plugins
receive that token.  The hash reference may contain:

=item query_string

This is the rewritten bits that will be reassembled in to the final query string.

=item condition

This is usually a hash reference representing the condition going into the bool query. For instance:

    { terms => { field => [qw(alice bob charlie)] } }

Or

    { prefix => { user_agent => 'Go ' } }

These conditions will wind up in the B<must> or B<must_not> section of the B<bool> query depending on the
state of the the invert flag.

=item invert

This is used by the bareword "not" to track whether the token invoked a flip from the B<must> to the B<must_not>
state.  After each token is processed, if it didn't set this flag, the flag is reset.

=item dangles

This is used for bare words like "not", "or", and "and" to denote that these terms cannot dangle from the
beginning or end of the query_string.  This allows the final pass of the query_string builder to strip these
words to prevent syntax errors.

=head1 Extended Syntax

The search string is pre-analyzed before being sent to ElasticSearch.  The following plugins
work to manipulate the query string and provide richer, more complete syntax for CLI applications.

=head2 App::ElasticSearch::Utilities::Barewords

The following barewords are transformed:

    or => OR
    and => AND
    not => NOT

=head2 App::ElasticSearch::Utilities::QueryString::IP

If a field is an IP address wild card, it is transformed:

    src_ip:10.* => src_ip:[10.0.0.0 TO 10.255.255.255]

=head2 App::ElasticSearch::Utilities::Underscored

This plugin translates some special underscore surrounded tokens into
the Elasticsearch Query DSL.

Implemented:

=head3 _prefix_

Example query string:

    _prefix_:useragent:'Go '

Translates into:

    { prefix => { useragent => 'Go ' } }

=head2 App::ElasticSearch::Utilities::QueryString::FileExpansion

If the match ends in .dat, .txt, or .csv, then we attempt to read a file with that name and OR the condition:

    $ cat test.dat
    50  1.2.3.4
    40  1.2.3.5
    30  1.2.3.6
    20  1.2.3.7

Or

    $ cat test.csv
    50,1.2.3.4
    40,1.2.3.5
    30,1.2.3.6
    20,1.2.3.7

Or

    $ cat test.txt
    1.2.3.4
    1.2.3.5
    1.2.3.6
    1.2.3.7

We can source that file:

    src_ip:test.dat => src_ip:(1.2.3.4 1.2.3.5 1.2.3.6 1.2.3.7)

This make it simple to use the --data-file output options and build queries
based off previous queries. For .txt and .dat file, the delimiter for columns
in the file must be either a tab, comma, or a semicolon.  For files ending in
.csv, Text::CSV_XS is used to accurate parsing of the file format.

You can also specify the column of the data file to use, the default being the last column or (-1).  Columns are
B<zero-based> indexing. This means the first column is index 0, second is 1, ..  The previous example can be rewritten
as:

    src_ip:test.dat[1]

or:
    src_ip:test.dat[-1]

This option will iterate through the whole file and unique the elements of the list.  They will then be transformed into
an appropriate L<terms query|http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-terms-query.html>.

=head1 AUTHOR

Brad Lhotsky <brad@divisionbyzero.net>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Brad Lhotsky.

This is free software, licensed under:

  The (three-clause) BSD License

=cut
