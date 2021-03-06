# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.036.
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Dist::Zilla plugins for AJGB",
  "AUTHOR" => "Alex J. G. Burzy\x{144}ski <ajgb\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Module::Build" => "0.28"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "Module::Build" => "0.28"
  },
  "DISTNAME" => "Dist-Zilla-PluginBundle-AJGB",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.006",
  "NAME" => "Dist::Zilla::PluginBundle::AJGB",
  "PREREQ_PM" => {
    "Dist::Zilla::Plugin::Authority" => 0,
    "Dist::Zilla::Plugin::AutoMetaResources" => 0,
    "Dist::Zilla::Plugin::AutoPrereqs" => 0,
    "Dist::Zilla::Plugin::CheckChangesHasContent" => 0,
    "Dist::Zilla::Plugin::CheckExtraTests" => 0,
    "Dist::Zilla::Plugin::ConfirmRelease" => 0,
    "Dist::Zilla::Plugin::CopyFilesFromBuild" => 0,
    "Dist::Zilla::Plugin::ExecDir" => 0,
    "Dist::Zilla::Plugin::GatherDir" => 0,
    "Dist::Zilla::Plugin::Git::Check" => 0,
    "Dist::Zilla::Plugin::Git::Commit" => 0,
    "Dist::Zilla::Plugin::Git::NextVersion" => 0,
    "Dist::Zilla::Plugin::Git::Push" => 0,
    "Dist::Zilla::Plugin::Git::Tag" => 0,
    "Dist::Zilla::Plugin::InstallGuide" => 0,
    "Dist::Zilla::Plugin::License" => 0,
    "Dist::Zilla::Plugin::MakeMaker" => 0,
    "Dist::Zilla::Plugin::Manifest" => 0,
    "Dist::Zilla::Plugin::ManifestSkip" => 0,
    "Dist::Zilla::Plugin::MetaConfig" => 0,
    "Dist::Zilla::Plugin::MetaJSON" => 0,
    "Dist::Zilla::Plugin::MetaYAML" => 0,
    "Dist::Zilla::Plugin::ModuleBuild" => 0,
    "Dist::Zilla::Plugin::NextRelease" => 0,
    "Dist::Zilla::Plugin::PkgVersion" => 0,
    "Dist::Zilla::Plugin::PodCoverageTests" => 0,
    "Dist::Zilla::Plugin::PodSyntaxTests" => 0,
    "Dist::Zilla::Plugin::PodWeaver" => 0,
    "Dist::Zilla::Plugin::PruneCruft" => 0,
    "Dist::Zilla::Plugin::ReadmeFromPod" => 0,
    "Dist::Zilla::Plugin::ShareDir" => 0,
    "Dist::Zilla::Plugin::Test::Compile" => 0,
    "Dist::Zilla::Plugin::Test::EOL" => 0,
    "Dist::Zilla::Plugin::Test::Kwalitee" => 0,
    "Dist::Zilla::Plugin::Test::NoTabs" => 0,
    "Dist::Zilla::Plugin::Test::Portability" => 0,
    "Dist::Zilla::Plugin::Test::Synopsis" => 0,
    "Dist::Zilla::Plugin::TestRelease" => 0,
    "Dist::Zilla::Plugin::UploadToCPAN" => 0,
    "Dist::Zilla::Role::PluginBundle::Easy" => 0,
    "Moose" => 0,
    "Pod::Weaver::Config::Assembler" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Pod::Coverage::TrustPod" => 0,
    "Test::More" => 0,
    "Test::Pod" => 0,
    "Test::Pod::Coverage" => 0
  },
  "VERSION" => "2.04",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Dist::Zilla::Plugin::Authority" => 0,
  "Dist::Zilla::Plugin::AutoMetaResources" => 0,
  "Dist::Zilla::Plugin::AutoPrereqs" => 0,
  "Dist::Zilla::Plugin::CheckChangesHasContent" => 0,
  "Dist::Zilla::Plugin::CheckExtraTests" => 0,
  "Dist::Zilla::Plugin::ConfirmRelease" => 0,
  "Dist::Zilla::Plugin::CopyFilesFromBuild" => 0,
  "Dist::Zilla::Plugin::ExecDir" => 0,
  "Dist::Zilla::Plugin::GatherDir" => 0,
  "Dist::Zilla::Plugin::Git::Check" => 0,
  "Dist::Zilla::Plugin::Git::Commit" => 0,
  "Dist::Zilla::Plugin::Git::NextVersion" => 0,
  "Dist::Zilla::Plugin::Git::Push" => 0,
  "Dist::Zilla::Plugin::Git::Tag" => 0,
  "Dist::Zilla::Plugin::InstallGuide" => 0,
  "Dist::Zilla::Plugin::License" => 0,
  "Dist::Zilla::Plugin::MakeMaker" => 0,
  "Dist::Zilla::Plugin::Manifest" => 0,
  "Dist::Zilla::Plugin::ManifestSkip" => 0,
  "Dist::Zilla::Plugin::MetaConfig" => 0,
  "Dist::Zilla::Plugin::MetaJSON" => 0,
  "Dist::Zilla::Plugin::MetaYAML" => 0,
  "Dist::Zilla::Plugin::ModuleBuild" => 0,
  "Dist::Zilla::Plugin::NextRelease" => 0,
  "Dist::Zilla::Plugin::PkgVersion" => 0,
  "Dist::Zilla::Plugin::PodCoverageTests" => 0,
  "Dist::Zilla::Plugin::PodSyntaxTests" => 0,
  "Dist::Zilla::Plugin::PodWeaver" => 0,
  "Dist::Zilla::Plugin::PruneCruft" => 0,
  "Dist::Zilla::Plugin::ReadmeFromPod" => 0,
  "Dist::Zilla::Plugin::ShareDir" => 0,
  "Dist::Zilla::Plugin::Test::Compile" => 0,
  "Dist::Zilla::Plugin::Test::EOL" => 0,
  "Dist::Zilla::Plugin::Test::Kwalitee" => 0,
  "Dist::Zilla::Plugin::Test::NoTabs" => 0,
  "Dist::Zilla::Plugin::Test::Portability" => 0,
  "Dist::Zilla::Plugin::Test::Synopsis" => 0,
  "Dist::Zilla::Plugin::TestRelease" => 0,
  "Dist::Zilla::Plugin::UploadToCPAN" => 0,
  "Dist::Zilla::Role::PluginBundle::Easy" => 0,
  "ExtUtils::MakeMaker" => 0,
  "File::Spec" => 0,
  "IO::Handle" => 0,
  "IPC::Open3" => 0,
  "Module::Build" => "0.28",
  "Moose" => 0,
  "Pod::Coverage::TrustPod" => 0,
  "Pod::Weaver::Config::Assembler" => 0,
  "Test::More" => 0,
  "Test::Pod" => 0,
  "Test::Pod::Coverage" => 0,
  "strict" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
