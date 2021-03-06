use Module::Build;
my $build = Module::Build->new(
  dist_name => 'JSON-ize',
  dist_abstract => 'Use JSON easily in one-liners',
  dist_author => 'Mark A. Jensen',
  dist_version_from => 'lib/JSON/ize.pm',
  license => 'apache',
  requires => {
    'JSON::MaybeXS' => '1.0',
    'YAML::Any' => '1.29',
    'Try::Tiny' => 0,
    'PerlIO::gzip' => 0,
    'perl' => '5.8.0'
   },
  recommends => {
    'JSON::XS' => "3.0",
    'YAML::XS' => "0.76"
   },
  build_requires => {
    'Test::More' => 0,
    'Test::Exception' => 0
   },
  configure_requires => {
    'Module::Build' => 0
   },
  meta_merge => {
    resources => {
      bugtracker => 'http://rt.cpan.org/Public/Dist/Display.html?Name=JSON::ize',
      repository => 'https://github.com/majensen/jsonize'
     }
   },
 );

$build->create_build_script;
