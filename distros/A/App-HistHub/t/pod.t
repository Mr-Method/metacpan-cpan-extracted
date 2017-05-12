use Test::More;
plan skip_all => 'set TEST_POD to run this test' unless $ENV{TEST_POD};

eval "use Test::Pod 1.00";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
all_pod_files_ok();
