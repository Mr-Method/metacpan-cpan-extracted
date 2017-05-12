package App::ZofCMS::Plugin::Tagged;

use warnings;
use strict;

our $VERSION = '1.001007'; # VERSION

use Data::Transformer;

sub new { bless {}, shift }

my %Tags;

sub process {
    my ( $self, $template, $query, $config ) = @_;
    @Tags{ qw/T Q C/ } = (
        $template,
        $query,
        $config->conf,
    );

    my $opts = delete $template->{tagged_options};
    $opts = {}
        unless ref $opts eq 'HASH';

    return
        if $opts->{no_parse};

    my $t = Data::Transformer->new( normal => \&callback );
    $t->traverse( $template );
}

sub callback {
    my $in = shift;

    while ( my ( $tag  ) = $$in =~ /<TAG:([^>]+)>/ ) {
        if ( $tag eq 'NOOP' ) {
            $$in =~ s/<TAG:[^>]+>//;
            return;
        }
        elsif ( $tag =~ s/^RAND\s*// ) {
            my $integer_form;
            if ( $tag =~ s/^I\s*// ) {
                $integer_form = 1;
            }
            my $rand_number = $tag =~ /^[\d.]+$/ ? rand($tag) : rand;

            if ( $integer_form ) {
                $rand_number = int $rand_number;
            }

            $$in =~ s/<TAG:[^>]+>/$rand_number/;
        }

        my ( $cell, $var ) = split /:/, $tag, 2;
        my $default;
        if ( length($cell) > 1 ) {
            $default = substr $cell, 1;
            $cell = substr $cell, 0, 1;
        }

        my $tag_result = $Tags{ $cell };

        my @parts = $var =~ /([{\[]) \s* ( [^}\]]+? ) \s* [}\]]/xg;

        for ( map [splice @parts, 0, 2 ], 0 .. $#parts/2 ) {
            $tag_result = $_->[0] eq '{'
                        ? $tag_result->{ $_->[1] }
                        : $tag_result->[ $_->[1] ]
        }

        $tag_result = $default
            unless defined $tag_result;

        if ( $@ ) {
            $Tags{T}{t}{tagged_error} = $@;
        }

        $tag_result = '' unless defined $tag_result;
        $$in =~ s/<TAG:[^>]+>/$tag_result/;

    }
}

1;
__END__

=encoding utf8

=head1 NAME

App::ZofCMS::Plugin::Tagged - ZofCMS plugin to fill templates with data from query, template variables and configuration using <TAGS>

=head1 SYNOPSIS

Your ZofCMS template:

    {
        cookie_foo  => '<TAG:TNo cookies:{d}{cookies}{foo}>',
        query_foo   => '[<TAG:Q:{foo}>]',
        set_cookies => [ ['foo', 'bar' ]],
        plugins     => [ { Cookies => 10 }, { Tagged => 20 } ],
        conf => {
            base => 'test.tmpl',
        },
    }

In your 'test.tmpl' base L<HTML::Template> template:

    Cookie 'foo' is set to: <tmpl_var name="cookie_foo"><br>
    Query 'foo' is set to: <tmpl_var name="query_foo">

In ZofCMS template the Cookies plugin is set to run before Tagged plugin,
thus on first page access cookies will not be set, and we will access
the page without setting the 'foo' query parameter. What do we see:

    Cookie 'foo' is set to: No cookies
    Query 'foo' is set to: []

No, if we run the page the second time it (now cookies are set with
L<App::ZofCMS::Plugin::Cookies> plugin) will look like this:

    Cookie 'foo' is set to: bar
    Query 'foo' is set to: []

If we pass query parameter 'foo' to the page, setting it to 'beer'
our page will look like this:

    Cookie 'foo' is set to: bar
    Query 'foo' is set to: [beer]

That's the power of Tagged plugin... now I'll explain what those weird
looking tags mean.

=head1 DESCRIPTION

The module provides means to the user to use special "tags" in B<scalar>
values inside ZofCMS template. This provides the ability to display
data generated by templates (i.e. stored in C<{d}> first level key), access
query or configuration hashref. Possibilities are endless.

B<This documentation assumes you have read documentation for>
L<App::ZofCMS> B<including> L<App::ZofCMS::Config> B<and>
L<App::ZofCMS::Template>

=head1 STARTING WITH THE PRIORITY

First of all, when using App::ZofCMS::Plugin::Tagged with other plugins
make sure to set the correct priority. In our example above, we used
L<App::ZofCMS::Plugin::Cookies> which reads currently set cookies into
C<{d}> special key in ZofCMS template. That's why we set priority of C<10>
to Cookies plugin and priority of C<20> to Tagged plugin - to insure
Tagged runs after C<{d}{cookies}> have been filled in.

B<Note:> currently there is no support to run Tagged plugin twice,
I'm not sure that will ever be needed, but if you do come across such
situation, you can easily cheat. Just copy Tagged.pm in your
C<$core/App/ZofCMS/Plugin/Tagged.pm> to Tagged2.pm (and ajust the name
accordingly in the C<package> line inside the file). Now you have two
Tagged plugins, and you can do stuff like
C<< plugins => [ {Tagged => 10}, { SomePlugin => 20 }, { Tagged2 => 30 } ] >>

=head1 THE TAG

    foo => '<TAG:Q:{foo}>',
    bar => 'beeer <TAG:Qdefault:{bar}>  baz',
    baz => 'foo <TAG:T:{d}{baz}[1]{beer}[2]> bar',
    nop => "<TAG:NOOP><TAG:T:I'm NOT a tag!!!>",
    random => '<TAG::RAND I 100>',

B<NOTE: everything in the tag is CASE-SENSITIVE>

First of all, the tag starts with C<< '<TAG:' >> and ends with with a
closing angle bracket (C<< '>' >>). The first character that follows
C<< '<TAG:' >> is a I<cell>. It can be either C<'Q>', C<'T'> or C<'C'>,
which
stand for B<Q>uery, B<T>emplate and B<C>onfiguration file. Each of those
three cells is a hashref: a hashref of query parameters, your ZofCMS
template hashref and your main configuration file hashref.

What follows the cell letter until the colon (C<':'>) is the I<default
value>, it will be used if whatever your tag references is undefined. Of
course, you don't have to define the default value; if you don't - the
tag value will be an empty string (not undef). B<Note:> currently you
can't use the actual colon (C<':'>) in your default variable. Currently
it will stay that way, but there are plans to add custom delimiters in the
future.

After the colon (C<':'>) which signifies the end of the I<cell> and possible
I<default value> follows a sequence which would access the value which
you are after. This sequence is exactly how you would write it in perl.
Let's look at some examples. First, let's define C<$template>, C<$query>
and C<$config> variables as C<T>, C<Q> and C<C> "cells", these variables
hold respective hashrefs (same as "cells"):

    <TAG:Q:{foo}>              same as   $query->{foo}
    <TAG:T:{d}{foo}>           same as   $template->{d}{foo}
    <TAG:C:{ fo o }{ b a r }>  same as   $config->{"fo o"}{"b a r"}
    <TAG:Qnone:{foo}>          same as   $query->{foo} // 'none'
    <TAG:Txxx:{t}{bar}>        same as   $template->{t}{bar} // 'xxx'

    # arrayrefs are supported as well

    <TAG:T:{d}{foo}[0]>        same as   $template->{d}{foo}[0]
    <TAG>C:{plugins}[1]>       same as   $config->{plugins}[1]

=head1 THE RAND TAG

    rand1 => '<TAG:RAND>',
    rand2 => '<TAG:RAND 100>',
    rand3 => '<TAG:RAND I 200>',
    rand4 => '<TAG:RAND100>',
    rand5 => '<TAG:RANDI100>',

The I<RAND tag> will be replaced by a pseudo-random number (obtained from
perl's rand() function). In it's plainest form, C<< <TAG:RAND> >>, it
will be replaced by exactly what comes out from C<rand()>, in other
words, same as calling C<rand(1)>. If a letter C<'I'> follows word
C<'RAND'> in the tag, then C<int()> will be called on the result of
C<rand()>. When a number follows word C<RAND>, that number will be used
in the call to C<rand()>. In other words, tag C<< <TAG:RAND 100> >>
will be replaced by a number which is obtained by the call to
C<rand(100)>. Note: the number must be B<after> the letter C<'I'> if you
are using it. You can have spaces between the letter C<'I'> or the number
and the word C<RAND>. In other words, these tags are equal:
C<< <TAG:RANDI100> >> and C<< <TAG:RAND I 100> >>.

=head1 THE NOOP TAG

    nop => "<TAG:NOOP><TAG:T:I'm NOT a tag!!!>",

The I<NOOP tag> (read B<no> B<op>eration) is a special tag which tells
Tagged plugin to stop processing this string as soon as it sees this tag.
Tagged will remove the noop tag from the string. The above example would
end up looking as C<< nop => "<TAG:T:I'm NOT a tag!!!>", >>

B<Note:> any tags I<before> the noop tag B<WILL> be parsed.

=head1 OPTIONS

    {
        tagged_options => { no_parse => 1 },
    }

Behaviour options can be set for App::ZofCMS::Plugin::Tagged via
C<tagged_options> first level ZofCMS template key. This key takes a
hashref as a value. The only currently supported key in that hashref
is C<no_parse> which can be either a true or a false value. If it's set
to a true value, Tagged will not parse this template.

=head1 NOTE ON DEPLOYMENT

This plugin requires L<Data::Transformer> module which is not in Perl's
core. If your webserver does not allow instalation of modules from CPAN,
run the helper script to copy this module into your $core_dir/CPAN/
directory

    zofcms_helper --nocore --core your_sites_core --cpan Data::Transformer

=head1 CAVEATS

If your tag references some element of ZofCMS template which itself contains
a tag the behaviour is undefined.

=head1 SEE ALSO

L<App::ZofCMS>, L<App::ZofCMS::Config>, L<App::ZofCMS::Template>

=head1 REPOSITORY

Fork this module on GitHub:
L<https://github.com/zoffixznet/App-ZofCMS>

=head1 BUGS

To report bugs or request features, please use
L<https://github.com/zoffixznet/App-ZofCMS/issues>

If you can't access GitHub, you can email your request
to C<bug-App-ZofCMS at rt.cpan.org>

=head1 AUTHOR

Zoffix Znet <zoffix at cpan.org>
(L<http://zoffix.com/>, L<http://haslayout.net/>)

=head1 LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the C<LICENSE> file included in this distribution for complete
details.

=cut