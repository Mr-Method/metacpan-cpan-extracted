package App::Timestamper;
$App::Timestamper::VERSION = '0.0.7';
use 5.014;
use strict;
use warnings;

use IO::Handle;
use Getopt::Long 2.36 qw(GetOptionsFromArray);
use Pod::Usage qw/pod2usage/;

use App::Timestamper::Filter::TS;

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

    $self->_init(@_);

    return $self;
}

sub _init
{
    my ($self, $args) = @_;

    my $argv = [@{$args->{argv}}];

    my $help = 0;
    my $man = 0;
    my $version = 0;
    if (! (my $ret = GetOptionsFromArray(
        $argv,
        'help|h' => \$help,
        man => \$man,
        version => \$version,
    )))
    {
        die "GetOptions failed!";
    }

    if ($help)
    {
        pod2usage(1);
    }

    if ($man)
    {
        pod2usage(-verbose => 2);
    }

    if ($version)
    {
        print "timestamper version $App::Timestamper::VERSION .\n";
        exit(0);
    }

    $self->{_argv} = $argv;
}

sub run
{
    my ($self) = @_;

    local @ARGV = @{$self->{_argv}};
    STDOUT->autoflush(1);

    App::Timestamper::Filter::TS->new->fh_filter(\*ARGV, sub {print $_[0];});

    return;
}

1;

__END__

=pod

=head1 NAME

App::Timestamper - prefix lines with the timestamps of their arrivals.

=head1 VERSION

version 0.0.7

=head1 SYNOPSIS

    use App::Timestamper;

    App::Timestamper->new({ argv => [@ARGV] })->run();

=head1 DESCRIPTION

App::Timestamper is a pure-Perl command line program that filters the input
so the timestamps (in seconds+fractions since the UNIX epoch) are prefixed
to the lines based on the time of the arrival.

So if the input was something like:

    First Line
    Second Line
    Third Line

It will become something like:

    1435254285.978485482\tFirst Line
    1435254302.569615087\tSecond Line
    1435254319.809459781\tThird Line

=head2 Some use cases

Some people asked me what is B<timestamper> useful for, so I'll try to
explain because I wrote the first version out of a need.

Let's suppose you have a simulation that outputs a "Reached $N iterations"
line after every certain number of iterations. Like so:

    Reached 100000 iterations
    Reached 200000 iterations
    Reached 300000 iterations
    .
    .
    .

You wish to draw a graph of iterations vs. time to analyse the performance
of the program. So what you can do is pipe it through B<timestamper> and then
get:

    1435254285.978485482\tReached 100000 iterations
    1435254302.569615087\tReached 200000 iterations
    1435254319.809459781\tReached 300000 iterations

And after putting it in a file (using "tee" or whatever), you can filter
the lines like this:

    perl -lane 'print "$1\t$2" if /\A([0-9\.]+)\tReached ([0-9]+) iterations\z/'

And get a nice tab-separated-value report of the time stamps in seconds and
the iterations which you can plot using your favourite spreadsheet program
or visualation framework.

Hope it helps.

=encoding utf8

=head1 COMMON REQUESTS

=head2 Can you add an option to provide formatting options to the timestamp?

This was requested here -
L<https://rt.cpan.org/Public/Bug/Display.html?id=106258> - and my reply was
that it can be easily implemented as a post-processing filter and so may be
considered unnecessary feature creep, which may also hurt performance.
However, since this may be a common request, I have added the
“./contrib/ts-format” program that can be used for that:

    $ export TIMESTAMPER_FORMAT="%Y-%m-%d-%H:%M:%S"
    $ cat | timestamper | ./contrib/ts-format
    Hello
    There
    Good
    2015-09-19-14:05:01     Hello
    2015-09-19-14:05:03     There
    2015-09-19-14:05:05     Good

Enjoy!

I may fork it into its own CPAN distribution in the future.

=head2 I want a Pony!

Sure thing! Here you go:

    $ cat | perl -pE 's#^#Fluttershy\t#' | timestamper
    Arrrrrr!
    Avast!
    Ye scurvy dogs!
    1442662118.609309912    Fluttershy      Arrrrrr!
    1442662118.609441042    Fluttershy      Avast!
    1442662118.609464884    Fluttershy      Ye scurvy dogs!

(Fluttershy being L<http://mlp.wikia.com/wiki/Fluttershy> .)

How to add a different pony is left as an exercise for the reader.

=head1 SUBROUTINES/METHODS

=head2 new

A constructor. Accepts the argv named arguments.

=head2 run

Runs the program.

=head1 SEE ALSO

=head2 “ts” from “moreutils”

“ts” is a program that is reportedely similar to “timestamper” and
is contained in joeyh’s “moreutils” (see L<http://joeyh.name/code/moreutils/>)
package. It is not easy to find online.

=head2 Chumbawamba’s song “Tubthumping”

I really like the song “Tubthumping” by Chumbawamba, which was a hit during
the 1990s and whose title sounds similar to “Timestamping”, so please check it
out:

=over 4

=item * English Wikipedia Page

L<http://en.wikipedia.org/wiki/Tubthumping>

=item * YouTube Search for the Video

L<http://www.youtube.com/results?search_query=chumbawamba%20tubthumping>

=back

=head1 AUTHOR

Shlomi Fish <shlomif@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2015 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Timestamper or by email to
bug-app-timestamper@rt.cpan.org.

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc App::Timestamper

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

MetaCPAN

A modern, open-source CPAN search engine, useful to view POD in HTML format.

L<http://metacpan.org/release/App-Timestamper>

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/App-Timestamper>

=item *

RT: CPAN's Bug Tracker

The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-Timestamper>

=item *

AnnoCPAN

The AnnoCPAN is a website that allows community annotations of Perl module documentation.

L<http://annocpan.org/dist/App-Timestamper>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/App-Timestamper>

=item *

CPAN Forum

The CPAN Forum is a web forum for discussing Perl modules.

L<http://cpanforum.com/dist/App-Timestamper>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.cpanauthors.org/dist/App-Timestamper>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/A/App-Timestamper>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=App-Timestamper>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=App::Timestamper>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-app-timestamper at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/Public/Bug/Report.html?Queue=App-Timestamper>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/shlomif/App-Timestamper>

  git clone git://github.com/shlomif/perl-App-Timestamper.git

=cut
