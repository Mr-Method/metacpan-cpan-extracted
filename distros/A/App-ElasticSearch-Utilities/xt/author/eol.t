use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::EOL 0.18

use Test::More 0.88;
use Test::EOL;

my @files = (
    'lib/App/ElasticSearch/Utilities.pm',
    'lib/App/ElasticSearch/Utilities/Connection.pm',
    'lib/App/ElasticSearch/Utilities/HTTPRequest.pm',
    'lib/App/ElasticSearch/Utilities/Query.pm',
    'lib/App/ElasticSearch/Utilities/QueryString.pm',
    'lib/App/ElasticSearch/Utilities/QueryString/BareWords.pm',
    'lib/App/ElasticSearch/Utilities/QueryString/FileExpansion.pm',
    'lib/App/ElasticSearch/Utilities/QueryString/IP.pm',
    'lib/App/ElasticSearch/Utilities/QueryString/Plugin.pm',
    'lib/App/ElasticSearch/Utilities/QueryString/Underscored.pm',
    'lib/App/ElasticSearch/Utilities/VersionHacks.pm',
    'scripts/es-alias-manager.pl',
    'scripts/es-apply-settings.pl',
    'scripts/es-copy-index.pl',
    'scripts/es-daily-index-maintenance.pl',
    'scripts/es-graphite-dynamic.pl',
    'scripts/es-graphite-static.pl',
    'scripts/es-nagios-check.pl',
    'scripts/es-nodes.pl',
    'scripts/es-open.pl',
    'scripts/es-search.pl',
    'scripts/es-status.pl',
    'scripts/es-storage-data.pl',
    't/00-compile.t',
    't/01-querystring.t',
    't/02-index-data.t'
);

eol_unix_ok($_, { trailing_whitespace => 1 }) foreach @files;
done_testing;
