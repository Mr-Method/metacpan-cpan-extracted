use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.15

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'bin/zofcms_helper',
    'lib/App/ZofCMS.pm',
    'lib/App/ZofCMS/Config.pm',
    'lib/App/ZofCMS/Output.pm',
    'lib/App/ZofCMS/Plugin.pm',
    'lib/App/ZofCMS/Plugin/AccessDenied.pm',
    'lib/App/ZofCMS/Plugin/AntiSpamMailTo.pm',
    'lib/App/ZofCMS/Plugin/AutoDump.pm',
    'lib/App/ZofCMS/Plugin/AutoEmptyQueryDelete.pm',
    'lib/App/ZofCMS/Plugin/AutoIMGSize.pm',
    'lib/App/ZofCMS/Plugin/Barcode.pm',
    'lib/App/ZofCMS/Plugin/Base.pm',
    'lib/App/ZofCMS/Plugin/BasicLWP.pm',
    'lib/App/ZofCMS/Plugin/BoolSettingsManager.pm',
    'lib/App/ZofCMS/Plugin/BreadCrumbs.pm',
    'lib/App/ZofCMS/Plugin/CRUD.pm',
    'lib/App/ZofCMS/Plugin/CSSMinifier.pm',
    'lib/App/ZofCMS/Plugin/Comments.pm',
    'lib/App/ZofCMS/Plugin/ConditionalRedirect.pm',
    'lib/App/ZofCMS/Plugin/ConfigToTemplate.pm',
    'lib/App/ZofCMS/Plugin/Cookies.pm',
    'lib/App/ZofCMS/Plugin/CurrentPageURI.pm',
    'lib/App/ZofCMS/Plugin/DBI.pm',
    'lib/App/ZofCMS/Plugin/DBIPPT.pm',
    'lib/App/ZofCMS/Plugin/DataToExcel.pm',
    'lib/App/ZofCMS/Plugin/DateSelector.pm',
    'lib/App/ZofCMS/Plugin/Debug/Dumper.pm',
    'lib/App/ZofCMS/Plugin/Debug/Validator/HTML.pm',
    'lib/App/ZofCMS/Plugin/DirTreeBrowse.pm',
    'lib/App/ZofCMS/Plugin/Doctypes.pm',
    'lib/App/ZofCMS/Plugin/FeatureSuggestionBox.pm',
    'lib/App/ZofCMS/Plugin/FileList.pm',
    'lib/App/ZofCMS/Plugin/FileToTemplate.pm',
    'lib/App/ZofCMS/Plugin/FileTypeIcon.pm',
    'lib/App/ZofCMS/Plugin/FileUpload.pm',
    'lib/App/ZofCMS/Plugin/FloodControl.pm',
    'lib/App/ZofCMS/Plugin/FormChecker.pm',
    'lib/App/ZofCMS/Plugin/FormFiller.pm',
    'lib/App/ZofCMS/Plugin/FormMailer.pm',
    'lib/App/ZofCMS/Plugin/FormToDatabase.pm',
    'lib/App/ZofCMS/Plugin/GetRemotePageTitle.pm',
    'lib/App/ZofCMS/Plugin/GoogleCalculator.pm',
    'lib/App/ZofCMS/Plugin/GooglePageRank.pm',
    'lib/App/ZofCMS/Plugin/GoogleTime.pm',
    'lib/App/ZofCMS/Plugin/HTMLFactory/Entry.pm',
    'lib/App/ZofCMS/Plugin/HTMLFactory/PageToBodyId.pm',
    'lib/App/ZofCMS/Plugin/HTMLMailer.pm',
    'lib/App/ZofCMS/Plugin/InstalledModuleChecker.pm',
    'lib/App/ZofCMS/Plugin/JavaScriptMinifier.pm',
    'lib/App/ZofCMS/Plugin/LinkifyText.pm',
    'lib/App/ZofCMS/Plugin/LinksToSpecs/CSS.pm',
    'lib/App/ZofCMS/Plugin/LinksToSpecs/HTML.pm',
    'lib/App/ZofCMS/Plugin/NavMaker.pm',
    'lib/App/ZofCMS/Plugin/PreferentialOrder.pm',
    'lib/App/ZofCMS/Plugin/QueryToTemplate.pm',
    'lib/App/ZofCMS/Plugin/QuickNote.pm',
    'lib/App/ZofCMS/Plugin/RandomBashOrgQuote.pm',
    'lib/App/ZofCMS/Plugin/RandomPasswordGeneratorPurePerl.pm',
    'lib/App/ZofCMS/Plugin/SendFile.pm',
    'lib/App/ZofCMS/Plugin/Session.pm',
    'lib/App/ZofCMS/Plugin/SplitPriceSelect.pm',
    'lib/App/ZofCMS/Plugin/StartPage.pm',
    'lib/App/ZofCMS/Plugin/StyleSwitcher.pm',
    'lib/App/ZofCMS/Plugin/Sub.pm',
    'lib/App/ZofCMS/Plugin/Syntax/Highlight/CSS.pm',
    'lib/App/ZofCMS/Plugin/Syntax/Highlight/HTML.pm',
    'lib/App/ZofCMS/Plugin/TOC.pm',
    'lib/App/ZofCMS/Plugin/TagCloud.pm',
    'lib/App/ZofCMS/Plugin/Tagged.pm',
    'lib/App/ZofCMS/Plugin/UserLogin.pm',
    'lib/App/ZofCMS/Plugin/UserLogin/ChangePassword.pm',
    'lib/App/ZofCMS/Plugin/UserLogin/ForgotPassword.pm',
    'lib/App/ZofCMS/Plugin/ValidationLinks.pm',
    'lib/App/ZofCMS/Plugin/YouTube.pm',
    'lib/App/ZofCMS/Template.pm',
    'lib/App/ZofCMS/Test/Plugin.pm',
    't/00-compile.t',
    't/00-load.t',
    't/01-plugin.t'
);

notabs_ok($_) foreach @files;
done_testing;
