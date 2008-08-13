use Log::Log4perl qw(:easy);
use Log::Log4perl::CommandLine qw(:all :logconfig log4perl.conf);

TRACE "trace message";
DEBUG "debug message";
INFO  "info  message";
WARN  "warn  message";
ERROR "error message";
FATAL "fatal message";
