use strict;
use warnings;
use Test::More;

use Capture::Tiny 'capture_stderr';
use Term::ANSIColor ();
use Dancer2::Logger::Console::Colored;

# part of this file is borrowed from the Dancer2 distribution

my $file = __FILE__;
my $l    = Dancer2::Logger::Console::Colored->new(
    app_name  => 'test',
    log_level => 'core'
);

my %defaults = (
    core    => "\e[1;97m",
    debug   => "\e[1;94m",
    info    => "\e[1;32m",
    warning => "\e[1;33m",
    error   => "\e[1;33;41m",
);

for my $level ( sort keys %defaults ) {
    my $stderr = capture_stderr { $l->$level("$level") };    # this is the call to log

    # We are dealing directly with the logger, not through the DSL.
    # Skipping 5 stack frames is likely to point to somewhere outside
    # this test; however Capture::Tiny adds in several call frames
    # (see below) to capture the output, giving a reasonable caller
    # to test for
    like $stderr, qr{
        \Q$defaults{$level}\E   # color of this level, escaped
            $level              # name of the level
        \e\[0m                  # end of coloring
        \s                      # whitespace
        in                      # "in"
        \s                      # whitespace
        \e\[36m                 # cyan for the origin of the message
            \Q$file\E           # the origin of the message
        \e\[0m                  # end of coloring
        \s                      # whitespace
        l[.]                    # "l."
        \s                      # whitespace
        \e\[36m                 # cyan for the origin of the message
            26                  # line "26", see in the code above
        \e\[0m                  # end of coloring
        }x, "$level message sent";

    like $stderr, qr{
        \]                       # closing bracket from after the process
        \s                      # whitespace
        \Q$defaults{$level}\E   # color of this level, escaped
            \s*                 # there might be whitespace
            $level              # name of the level
        \e\[0m                  # end of coloring
    }x, "$level with default level colors";
}

for my $level (qw( core debug info warning error )) {
    $l->colored_levels(
        {
            $level => "magenta",
        }
    );
    $l->colored_messages(
        {
            $level => "bright_blue",
        }
    );
    $l->colored_origin("bright_green");

    my $stderr = capture_stderr { $l->$level("$level") };    # this is the call to log

    like $stderr, qr{
        \e\[94m                 # bright_blue, we set that above
            $level              # name of the level
        \e\[0m                  # end of coloring
        \s                      # whitespace
        in                      # "in"
        \s                      # whitespace
        \e\[92m                 # bright green for the origin, we set that above
            \Q$file\E           # the origin of the message
        \e\[0m                  # end of coloring
        \s                      # whitespace
        l[.]                    # "l."
        \s                      # whitespace
        \e\[92m                 # bright green for the origin, we set that above
            74                  # line "74", see in the code above
        \e\[0m                  # end of coloring
        }x, "$level with custom message colors";

    like $stderr, qr{
        \]                      # closing bracket from after the process
        \s                      # whitespace
        \e\[35m                 # magenta, we just set that above
            \s*                 # there might be whitespace
            $level              # name of the level
        \e\[0m                  # end of coloring
    }x, "$level with custom level colors";
}

{
    # set this explicitly to see if we don't overwrite it in the code
    $l->colored_levels(
        {
            info => "magenta",
        }
    );

    $l->colored_regex(
        [
            {
                re    => 'foobar',
                color => 'cyan',
            },
            {
                re    => '\d+',
                color => 'magenta',
            },
        ]
    );

    my $stderr = capture_stderr { $l->info("hello foobar hello foobar") };

    like $stderr, qr{
        hello
        \s
        \e\[36m                 # cyan, we set that above
            foobar
        \e\[0m                  # end of coloring
        \s
        hello
        \s
        \e\[36m                 # cyan, we set that above
            foobar
        \e\[0m                  # end of coloring
        \s                      # whitespace
        in                      # "in"
        \s                      # whitespace
        \e\[92m                 # bright green for the origin, we set that above
            \Q$file\E           # the origin of the message
        \e\[0m                  # end of coloring
        \s                      # whitespace
        l[.]                    # "l."
        \s                      # whitespace
        \e\[92m                 # bright green for the origin, we set that above
            \d+                 # line
        \e\[0m                  # end of coloring
        }x, "call with regex color where a pattern matches multiple times";

    like $stderr, qr{
        \]                      # closing bracket from after the process
        \s                      # whitespace
        \e\[35m                 # magenta, we just set that above
            \s*                 # there might be whitespace
            info                # name of the level
        \e\[0m                  # end of coloring
    }x, "... and the level is unaffected";

    $stderr = capture_stderr { $l->info("asdf 1234") };

    like $stderr, qr{
        asdf
        \s
        \e\[35m                 # magenta, we set that above
            1234
        \e\[0m                  # end of coloring
        \s                      # whitespace
        in                      # "in"
        \s                      # whitespace
        \e\[92m                 # bright green for the origin, we set that above
            \Q$file\E           # the origin of the message
        \e\[0m                  # end of coloring
        \s                      # whitespace
        l[.]                    # "l."
        \s                      # whitespace
        \e\[92m                 # bright green for the origin, we set that above
            \d+                 # line
        \e\[0m                  # end of coloring
    }x, "call with regex color where two different pattern match";
}

{
    # we don't want a wide character warning going into our STDERR capture
    use open qw/:std :encoding(UTF-8)/;

    $l->log_format('%t');
    my $stderr = capture_stderr { $l->info('foo') };
    like $stderr, qr{
        ^                       # there is no color for the date by default
        \d+/.*?/\d{4}           # date (containing a named month)
        \s                      # whitespace
        \d\d:\d\d:\d\d          # time
        $
    }x, 'regression gh-11: %t works';
}

done_testing;
