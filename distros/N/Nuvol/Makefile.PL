# Generated by git-ship. See 'git-ship --man' for help or https://github.com/jhthorsen/app-git-ship
use utf8;
use ExtUtils::MakeMaker;
my %WriteMakefileArgs = (
  NAME           => 'Nuvol',
  AUTHOR         => 'Rolf Stöckli <tekki@cpan.org>',
  LICENSE        => 'artistic_2',
  ABSTRACT_FROM  => 'lib/Nuvol.pm',
  VERSION_FROM   => 'lib/Nuvol.pm',
  EXE_FILES      => [qw()],
  OBJECT         => '',
  BUILD_REQUIRES => {}
,
  TEST_REQUIRES  => {
  'Test::More' => '0.88'
}
,
  PREREQ_PM      => {
  'Mojo::File::Role::Digest' => '0.04',
  'Mojolicious' => '8.32',
  'Print::Colored' => '0.02',
  'Role::Tiny' => 'v2.1.4',
  'perl' => 'v5.24.0'
}
,
  META_MERGE     => {
    'dynamic_config' => 0,
    'meta-spec'      => {version => 2},
    'resources'      => {
      bugtracker => {web => 'https://github.com/Tekki/nuvol/issues'},
      homepage   => 'https://github.com/Tekki/nuvol',
      repository => {
        type => 'git',
        url  => 'https://github.com/Tekki/nuvol.git',
        web  => 'https://github.com/Tekki/nuvol',
      },
    },
    'x_contributors' => []
,
  },
  test => {TESTS => (-e 'META.yml' ? 't/*.t' : 't/*.t xt/*.t')},
);

unless (eval { ExtUtils::MakeMaker->VERSION('6.63_03') }) {
  my $test_requires = delete $WriteMakefileArgs{TEST_REQUIRES};
  @{$WriteMakefileArgs{PREREQ_PM}}{keys %$test_requires} = values %$test_requires;
}

WriteMakefile(%WriteMakefileArgs);
