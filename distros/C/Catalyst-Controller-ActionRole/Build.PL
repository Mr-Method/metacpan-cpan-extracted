# This Build.PL for Catalyst-Controller-ActionRole was generated by
# Dist::Zilla::Plugin::ModuleBuildTiny::Fallback 0.015
use strict;
use warnings;

my %configure_requires = (
    'Module::Build::Tiny' => '0.039',
);

my @missing = grep {
    ! eval "require $_; $_->VERSION($configure_requires{$_}); 1"
} keys %configure_requires;

if (not @missing)
{
    # This section for Catalyst-Controller-ActionRole was generated by Dist::Zilla::Plugin::ModuleBuildTiny 0.008.
    use strict;
    use warnings;

    use 5.006;
    # use Module::Build::Tiny 0.039;
    Module::Build::Tiny::Build_PL();
}
else
{
    $ENV{PERL_MB_FALLBACK_SILENCE_WARNING} or warn <<'EOW';
*** WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING ***

If you're seeing this warning, your toolchain is really, really old* and you'll
almost certainly have problems installing CPAN modules from this century. But
never fear, dear user, for we have the technology to fix this!

If you're using CPAN.pm to install things, then you can upgrade it using:

    cpan CPAN

If you're using CPANPLUS to install things, then you can upgrade it using:

    cpanp CPANPLUS

If you're using cpanminus, you shouldn't be seeing this message in the first
place, so please file an issue on github.

This public service announcement was brought to you by the Perl Toolchain
Gang, the irc.perl.org #toolchain IRC channel, and the number 42.

----

* Alternatively, you are running this file manually, in which case you need
to learn to first fulfill all configure requires prerequisites listed in
META.yml or META.json -- or use a cpan client to install this distribution.

You can also silence this warning for future installations by setting the
PERL_MB_FALLBACK_SILENCE_WARNING environment variable, but please don't do
that until you fix your toolchain as described above.

EOW
    sleep 10 if -t STDIN && (-t STDOUT || !(-f STDOUT || -c STDOUT));


    # This section was automatically generated by Dist::Zilla::Plugin::ModuleBuild v5.031.
    use strict;
    use warnings;

    require Module::Build; Module::Build->VERSION(0.28);


    my %module_build_args = (
      "build_requires" => {},
      "configure_requires" => {
        "Module::Build::Tiny" => "0.039",
        "perl" => "5.006"
      },
      "dist_abstract" => "(DEPRECATED) Apply roles to action instances",
      "dist_author" => [
        "Florian Ragwitz <rafl\@debian.org>"
      ],
      "dist_name" => "Catalyst-Controller-ActionRole",
      "dist_version" => "0.17",
      "license" => "perl",
      "module_name" => "Catalyst::Controller::ActionRole",
      "recommends" => {},
      "recursive_test_files" => 1,
      "requires" => {
        "Catalyst::Controller" => 0,
        "Catalyst::Runtime" => "5.80025",
        "Catalyst::Utils" => 0,
        "Class::Load" => 0,
        "List::Util" => 0,
        "Moose" => 0,
        "Moose::Meta::Class" => 0,
        "MooseX::Types::Moose" => 0,
        "String::RewritePrefix" => "0.004",
        "namespace::autoclean" => 0,
        "perl" => "5.006"
      },
      "script_files" => [],
      "test_requires" => {
        "Catalyst" => 0,
        "Catalyst::Action" => 0,
        "Catalyst::Action::REST" => "0.74",
        "Catalyst::Test" => 0,
        "ExtUtils::MakeMaker" => 0,
        "File::Spec" => 0,
        "FindBin" => 0,
        "Moose::Role" => 0,
        "Test::More" => 0,
        "lib" => 0,
        "namespace::clean" => 0,
        "parent" => 0,
        "perl" => "5.006",
        "strict" => 0,
        "warnings" => 0
      }
    );


    my %fallback_build_requires = (
      "Catalyst" => 0,
      "Catalyst::Action" => 0,
      "Catalyst::Action::REST" => "0.74",
      "Catalyst::Test" => 0,
      "ExtUtils::MakeMaker" => 0,
      "File::Spec" => 0,
      "FindBin" => 0,
      "Moose::Role" => 0,
      "Test::More" => 0,
      "lib" => 0,
      "namespace::clean" => 0,
      "parent" => 0,
      "perl" => "5.006",
      "strict" => 0,
      "warnings" => 0
    );


    unless ( eval { Module::Build->VERSION(0.4004) } ) {
      delete $module_build_args{test_requires};
      $module_build_args{build_requires} = \%fallback_build_requires;
    }

    my $build = Module::Build->new(%module_build_args);

    $build->create_build_script;
}
