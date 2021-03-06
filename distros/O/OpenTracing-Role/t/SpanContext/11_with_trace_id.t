use Test::Most;

BEGIN {
    $ENV{OPENTRACING_INTERFACE} = 1 unless exists $ENV{OPENTRACING_INTERFACE};
}
#
# This breaks if it would be set to 0 externally, so, don't do that!!!


use strict;
use warnings;



subtest 'Clone with trace_id' => sub {
    
    my $span_context_1;
    my $span_context_2;
    
    lives_ok {
        $span_context_1 = MyStub::SpanContext->new(
#           trace_id      => 12345, # you can not assign to trace_id!
#           span_id       => 67890, # you can not assign to span_id!
            baggage_items => { foo => 1, bar => 2 },
        )
    } "Created a SpanContext [1]"
    
    or return;
    
    my $trace_id_1 = $span_context_1->trace_id;
    
    lives_ok {
        $span_context_2 = $span_context_1->with_trace_id('12345');
    } "... and cloned a new SpanContext [2]"
    
    or return;
    
    isnt $span_context_1, $span_context_2,
    "... that is not the same object reference as the original";
    
    is $span_context_1->span_id, $span_context_2->span_id,
        "... but has still the same 'span_id'";
    
    is $span_context_1->trace_id, $trace_id_1,
        "... and the original SpanContext [1] has not changed";
    
    is $span_context_2->trace_id, '12345',
        "... and the cloned SpanContext [2] has the expected values [12345]";
    
};



done_testing;



package MyStub::SpanContext;
use Moo;

BEGIN { with 'OpenTracing::Role::SpanContext'; }



1;
