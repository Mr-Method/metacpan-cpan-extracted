#!perl
# This file was automatically generated by Dist::Zilla::Plugin::Test::Pod::Coverage::Configurable.

use Test::Pod::Coverage 1.08;
use Test::More 0.88;

BEGIN {
    if ( $] <= 5.008008 ) {
        plan skip_all => 'These tests require Pod::Coverage::TrustPod, which only works with Perl 5.8.9+';
    }
}
use Pod::Coverage::TrustPod;

my %skip = map { $_ => 1 } qw( App::GHPT::Types App::GHPT::WorkSubmitter App::GHPT::WorkSubmitter::Role::FileInspector App::GHPT::WorkSubmitter::Role::Question App::GHPT::Wrapper::OurMoose App::GHPT::Wrapper::OurMoose::Role App::GHPT::Wrapper::OurMooseX::Role::Parameterized App::GHPT::Wrapper::OurMooseX::Role::Parameterized::Meta::Trait::Parameterizable::Strict );

my @modules;
for my $module ( all_modules() ) {
    next if $skip{$module};

    push @modules, $module;
}

plan skip_all => 'All the modules we found were excluded from POD coverage test.'
    unless @modules;

plan tests => scalar @modules;

my %trustme = ();

my @also_private = (
                  qr/\A (?: BUILD(?:ARGS)? | DEMOLISH ) \z/x
                );

for my $module ( sort @modules ) {
    pod_coverage_ok(
        $module,
        {
            coverage_class => 'Pod::Coverage::TrustPod',
            also_private   => \@also_private,
            trustme        => $trustme{$module} || [],
        },
        "pod coverage for $module"
    );
}

done_testing();
