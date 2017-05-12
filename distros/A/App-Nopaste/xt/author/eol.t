use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::EOL 0.19

use Test::More 0.88;
use Test::EOL;

my @files = (
    'lib/App/Nopaste.pm',
    'lib/App/Nopaste/Command.pm',
    'lib/App/Nopaste/Service.pm',
    'lib/App/Nopaste/Service/Codepeek.pm',
    'lib/App/Nopaste/Service/Debian.pm',
    'lib/App/Nopaste/Service/Gist.pm',
    'lib/App/Nopaste/Service/Mojopaste.pm',
    'lib/App/Nopaste/Service/PastebinCom.pm',
    'lib/App/Nopaste/Service/Pastie.pm',
    'lib/App/Nopaste/Service/Shadowcat.pm',
    'lib/App/Nopaste/Service/Snitch.pm',
    'lib/App/Nopaste/Service/Ubuntu.pm',
    'lib/App/Nopaste/Service/ssh.pm',
    'script/nopaste',
    't/00-report-prereqs.dd',
    't/00-report-prereqs.t',
    't/000-load.t',
    't/001-subclass_cmd.t',
    't/002-encoding.t',
    't/003-command.t',
    't/004-02-debian.t',
    't/004-03-gist.t',
    't/004-04-mojopaste.t',
    't/004-06-pastie.t',
    't/004-07-shadowcat.t',
    't/004-08-snitch.t',
    't/004-10-ubuntu.t',
    't/004-service.t',
    'xt/author/00-compile.t',
    'xt/author/clean-namespaces.t',
    'xt/author/eol.t',
    'xt/author/kwalitee.t',
    'xt/author/mojibake.t',
    'xt/author/no-tabs.t',
    'xt/author/pod-spell.t',
    'xt/author/pod-syntax.t',
    'xt/author/portability.t',
    'xt/release/changes_has_content.t',
    'xt/release/cpan-changes.t',
    'xt/release/minimum-version.t'
);

eol_unix_ok($_, { trailing_whitespace => 1 }) foreach @files;
done_testing;
