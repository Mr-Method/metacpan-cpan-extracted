#! perl -T
use strict;
use warnings;

use Test::More;
use Test::Fatal qw/dies_ok lives_ok/;
use Log::Log4perl;

my $SENTRY_DSN = $ENV{SENTRY_DSN} || 'https://blabla:blabla@app.getsentry.com/some_id';

    my $conf = q|
log4perl.rootLogger=ERROR, Raven

layout_class=Log::Log4perl::Layout::PatternLayout
layout_pattern=%d %F{1} %L> %m %n

log4perl.appender.Raven=Log::Log4perl::Appender::Raven
log4perl.appender.Raven.sentry_dsn="|.$SENTRY_DSN.q|"
log4perl.appender.Raven.layout=${layout_class}
log4perl.appender.Raven.layout.ConversionPattern=${layout_pattern}
log4perl.appender.Raven.sentry_culprit_template={$function}-{$line}-{sign($message, 40)}

|;

lives_ok { Log::Log4perl::init(\$conf); } "Ok config is good";
ok( my $ra =  Log::Log4perl->appender_by_name('Raven') , "Ok got appender 'Raven'");

package My::Shiny::Package;
use Carp;

my $LOGGER = Log::Log4perl->get_logger();
sub emit_error{
    my ($class, $number) = @_;
    eval{
        confess("Cannot do some stuff for this number $number");
    };
    if( my $err = $@ ){
        $LOGGER->error("Error in doing stuff: ".$err);
    }
    $class->and_another_one();
}

sub and_another_one{
    $LOGGER->error('Deeper error');
}

1;

package main;


my @sentry_calls = ();

# HACK Sentry::Raven so we capture capture_message
{
    no strict;
    no warnings;
    *{'Sentry::Raven::capture_message'} = sub{
        my ($self, $message ,  %args) = @_;
        push @sentry_calls , { message => $message , %args };
    };
    use warnings;
    use strict;
}

My::Shiny::Package->emit_error(1);

is( scalar(@sentry_calls) , 2 , "Ok two calls in sentry");
is( $sentry_calls[0]->{culprit}  , 'My::Shiny::Package::emit_error-38-a7ce' );
is( $sentry_calls[1]->{culprit}  , 'My::Shiny::Package::and_another_one-44-c8d0' );

My::Shiny::Package->emit_error(2);

is( scalar(@sentry_calls) , 4 , "Ok four calls in sentry");

$LOGGER = Log::Log4perl->get_logger();

$LOGGER->error("Error at main level");

is( scalar( @sentry_calls) , 5 , "One more call to sentry");
is( $sentry_calls[4]->{culprit}, 'main-78-95b9');


done_testing();
