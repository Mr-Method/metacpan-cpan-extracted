package Bencher::ScenarioR::DigestSHA::SHA256;

our $VERSION = 0.003; # VERSION

our $results = [
  [
    200,
    "OK",
    [
      {
        errors => 0.00024,
        participant => "Digest::SHA",
        rate => 4.5,
        samples => 7,
        time => 220,
        vs_slowest => 1,
      },
      {
        errors => 7.2e-05,
        participant => "sha256sum",
        rate => 4.65,
        samples => 6,
        time => 215,
        vs_slowest => 1.03,
      },
    ],
    {
      "func.bencher_args"              => {
                                            action => "bench",
                                            note => "Run by Pod::Weaver::Plugin::Bencher::Scenario",
                                            scenario_module => "DigestSHA::SHA256",
                                          },
      "func.bencher_version"           => undef,
      "func.cpu_info"                  => [
                                            {
                                              address_width                => 64,
                                              architecture                 => "AMD-64",
                                              bus_speed                    => undef,
                                              data_width                   => 64,
                                              family                       => 6,
                                              flags                        => [
                                                                                "fpu",
                                                                                "vme",
                                                                                "de",
                                                                                "pse",
                                                                                "tsc",
                                                                                "msr",
                                                                                "pae",
                                                                                "mce",
                                                                                "cx8",
                                                                                "apic",
                                                                                "sep",
                                                                                "mtrr",
                                                                                "pge",
                                                                                "mca",
                                                                                "cmov",
                                                                                "pat",
                                                                                "pse36",
                                                                                "clflush",
                                                                                "dts",
                                                                                "acpi",
                                                                                "mmx",
                                                                                "fxsr",
                                                                                "sse",
                                                                                "sse2",
                                                                                "ss",
                                                                                "ht",
                                                                                "tm",
                                                                                "pbe",
                                                                                "syscall",
                                                                                "nx",
                                                                                "rdtscp",
                                                                                "lm",
                                                                                "constant_tsc",
                                                                                "arch_perfmon",
                                                                                "pebs",
                                                                                "bts",
                                                                                "rep_good",
                                                                                "nopl",
                                                                                "xtopology",
                                                                                "nonstop_tsc",
                                                                                "aperfmperf",
                                                                                "eagerfpu",
                                                                                "pni",
                                                                                "pclmulqdq",
                                                                                "dtes64",
                                                                                "monitor",
                                                                                "ds_cpl",
                                                                                "vmx",
                                                                                "smx",
                                                                                "est",
                                                                                "tm2",
                                                                                "ssse3",
                                                                                "cx16",
                                                                                "xtpr",
                                                                                "pdcm",
                                                                                "pcid",
                                                                                "sse4_1",
                                                                                "sse4_2",
                                                                                "x2apic",
                                                                                "popcnt",
                                                                                "tsc_deadline_timer",
                                                                                "aes",
                                                                                "xsave",
                                                                                "avx",
                                                                                "lahf_lm",
                                                                                "ida",
                                                                                "arat",
                                                                                "epb",
                                                                                "xsaveopt",
                                                                                "pln",
                                                                                "pts",
                                                                                "dtherm",
                                                                                "tpr_shadow",
                                                                                "vnmi",
                                                                                "flexpriority",
                                                                                "ept",
                                                                                "vpid",
                                                                              ],
                                              L2_cache                     => { max_cache_size => "6144 KB" },
                                              manufacturer                 => "GenuineIntel",
                                              model                        => 42,
                                              name                         => "Intel(R) Core(TM) i5-2400 CPU \@ 3.10GHz",
                                              number_of_cores              => 4,
                                              number_of_logical_processors => 4,
                                              processor_id                 => 0,
                                              speed                        => 3297.019,
                                              stepping                     => 7,
                                            },
                                            {
                                              address_width                => 64,
                                              architecture                 => "AMD-64",
                                              bus_speed                    => undef,
                                              data_width                   => 64,
                                              family                       => 6,
                                              flags                        => [
                                                                                "fpu",
                                                                                "vme",
                                                                                "de",
                                                                                "pse",
                                                                                "tsc",
                                                                                "msr",
                                                                                "pae",
                                                                                "mce",
                                                                                "cx8",
                                                                                "apic",
                                                                                "sep",
                                                                                "mtrr",
                                                                                "pge",
                                                                                "mca",
                                                                                "cmov",
                                                                                "pat",
                                                                                "pse36",
                                                                                "clflush",
                                                                                "dts",
                                                                                "acpi",
                                                                                "mmx",
                                                                                "fxsr",
                                                                                "sse",
                                                                                "sse2",
                                                                                "ss",
                                                                                "ht",
                                                                                "tm",
                                                                                "pbe",
                                                                                "syscall",
                                                                                "nx",
                                                                                "rdtscp",
                                                                                "lm",
                                                                                "constant_tsc",
                                                                                "arch_perfmon",
                                                                                "pebs",
                                                                                "bts",
                                                                                "rep_good",
                                                                                "nopl",
                                                                                "xtopology",
                                                                                "nonstop_tsc",
                                                                                "aperfmperf",
                                                                                "eagerfpu",
                                                                                "pni",
                                                                                "pclmulqdq",
                                                                                "dtes64",
                                                                                "monitor",
                                                                                "ds_cpl",
                                                                                "vmx",
                                                                                "smx",
                                                                                "est",
                                                                                "tm2",
                                                                                "ssse3",
                                                                                "cx16",
                                                                                "xtpr",
                                                                                "pdcm",
                                                                                "pcid",
                                                                                "sse4_1",
                                                                                "sse4_2",
                                                                                "x2apic",
                                                                                "popcnt",
                                                                                "tsc_deadline_timer",
                                                                                "aes",
                                                                                "xsave",
                                                                                "avx",
                                                                                "lahf_lm",
                                                                                "ida",
                                                                                "arat",
                                                                                "epb",
                                                                                "xsaveopt",
                                                                                "pln",
                                                                                "pts",
                                                                                "dtherm",
                                                                                "tpr_shadow",
                                                                                "vnmi",
                                                                                "flexpriority",
                                                                                "ept",
                                                                                "vpid",
                                                                              ],
                                              L2_cache                     => { max_cache_size => "6144 KB" },
                                              manufacturer                 => "GenuineIntel",
                                              model                        => 42,
                                              name                         => "Intel(R) Core(TM) i5-2400 CPU \@ 3.10GHz",
                                              number_of_cores              => 4,
                                              number_of_logical_processors => 4,
                                              processor_id                 => 1,
                                              speed                        => 3292.296,
                                              stepping                     => 7,
                                            },
                                            {
                                              address_width                => 64,
                                              architecture                 => "AMD-64",
                                              bus_speed                    => undef,
                                              data_width                   => 64,
                                              family                       => 6,
                                              flags                        => [
                                                                                "fpu",
                                                                                "vme",
                                                                                "de",
                                                                                "pse",
                                                                                "tsc",
                                                                                "msr",
                                                                                "pae",
                                                                                "mce",
                                                                                "cx8",
                                                                                "apic",
                                                                                "sep",
                                                                                "mtrr",
                                                                                "pge",
                                                                                "mca",
                                                                                "cmov",
                                                                                "pat",
                                                                                "pse36",
                                                                                "clflush",
                                                                                "dts",
                                                                                "acpi",
                                                                                "mmx",
                                                                                "fxsr",
                                                                                "sse",
                                                                                "sse2",
                                                                                "ss",
                                                                                "ht",
                                                                                "tm",
                                                                                "pbe",
                                                                                "syscall",
                                                                                "nx",
                                                                                "rdtscp",
                                                                                "lm",
                                                                                "constant_tsc",
                                                                                "arch_perfmon",
                                                                                "pebs",
                                                                                "bts",
                                                                                "rep_good",
                                                                                "nopl",
                                                                                "xtopology",
                                                                                "nonstop_tsc",
                                                                                "aperfmperf",
                                                                                "eagerfpu",
                                                                                "pni",
                                                                                "pclmulqdq",
                                                                                "dtes64",
                                                                                "monitor",
                                                                                "ds_cpl",
                                                                                "vmx",
                                                                                "smx",
                                                                                "est",
                                                                                "tm2",
                                                                                "ssse3",
                                                                                "cx16",
                                                                                "xtpr",
                                                                                "pdcm",
                                                                                "pcid",
                                                                                "sse4_1",
                                                                                "sse4_2",
                                                                                "x2apic",
                                                                                "popcnt",
                                                                                "tsc_deadline_timer",
                                                                                "aes",
                                                                                "xsave",
                                                                                "avx",
                                                                                "lahf_lm",
                                                                                "ida",
                                                                                "arat",
                                                                                "epb",
                                                                                "xsaveopt",
                                                                                "pln",
                                                                                "pts",
                                                                                "dtherm",
                                                                                "tpr_shadow",
                                                                                "vnmi",
                                                                                "flexpriority",
                                                                                "ept",
                                                                                "vpid",
                                                                              ],
                                              L2_cache                     => { max_cache_size => "6144 KB" },
                                              manufacturer                 => "GenuineIntel",
                                              model                        => 42,
                                              name                         => "Intel(R) Core(TM) i5-2400 CPU \@ 3.10GHz",
                                              number_of_cores              => 4,
                                              number_of_logical_processors => 4,
                                              processor_id                 => 2,
                                              speed                        => "3273.890",
                                              stepping                     => 7,
                                            },
                                            {
                                              address_width                => 64,
                                              architecture                 => "AMD-64",
                                              bus_speed                    => undef,
                                              data_width                   => 64,
                                              family                       => 6,
                                              flags                        => [
                                                                                "fpu",
                                                                                "vme",
                                                                                "de",
                                                                                "pse",
                                                                                "tsc",
                                                                                "msr",
                                                                                "pae",
                                                                                "mce",
                                                                                "cx8",
                                                                                "apic",
                                                                                "sep",
                                                                                "mtrr",
                                                                                "pge",
                                                                                "mca",
                                                                                "cmov",
                                                                                "pat",
                                                                                "pse36",
                                                                                "clflush",
                                                                                "dts",
                                                                                "acpi",
                                                                                "mmx",
                                                                                "fxsr",
                                                                                "sse",
                                                                                "sse2",
                                                                                "ss",
                                                                                "ht",
                                                                                "tm",
                                                                                "pbe",
                                                                                "syscall",
                                                                                "nx",
                                                                                "rdtscp",
                                                                                "lm",
                                                                                "constant_tsc",
                                                                                "arch_perfmon",
                                                                                "pebs",
                                                                                "bts",
                                                                                "rep_good",
                                                                                "nopl",
                                                                                "xtopology",
                                                                                "nonstop_tsc",
                                                                                "aperfmperf",
                                                                                "eagerfpu",
                                                                                "pni",
                                                                                "pclmulqdq",
                                                                                "dtes64",
                                                                                "monitor",
                                                                                "ds_cpl",
                                                                                "vmx",
                                                                                "smx",
                                                                                "est",
                                                                                "tm2",
                                                                                "ssse3",
                                                                                "cx16",
                                                                                "xtpr",
                                                                                "pdcm",
                                                                                "pcid",
                                                                                "sse4_1",
                                                                                "sse4_2",
                                                                                "x2apic",
                                                                                "popcnt",
                                                                                "tsc_deadline_timer",
                                                                                "aes",
                                                                                "xsave",
                                                                                "avx",
                                                                                "lahf_lm",
                                                                                "ida",
                                                                                "arat",
                                                                                "epb",
                                                                                "xsaveopt",
                                                                                "pln",
                                                                                "pts",
                                                                                "dtherm",
                                                                                "tpr_shadow",
                                                                                "vnmi",
                                                                                "flexpriority",
                                                                                "ept",
                                                                                "vpid",
                                                                              ],
                                              L2_cache                     => { max_cache_size => "6144 KB" },
                                              manufacturer                 => "GenuineIntel",
                                              model                        => 42,
                                              name                         => "Intel(R) Core(TM) i5-2400 CPU \@ 3.10GHz",
                                              number_of_cores              => 4,
                                              number_of_logical_processors => 4,
                                              processor_id                 => 3,
                                              speed                        => 3297.019,
                                              stepping                     => 7,
                                            },
                                          ],
      "func.elapsed_time"              => 3.29015111923218,
      "func.module_startup"            => undef,
      "func.module_versions"           => {
                                            "__PACKAGE__" => 1.039,
                                            "Bencher::Scenario::DigestSHA::SHA256" => undef,
                                            "Benchmark::Dumb" => 0.111,
                                            "Devel::Platform::Info" => 0.16,
                                            "Digest::SHA" => 5.96,
                                            "perl" => "v5.26.0",
                                            "String::ShellQuote" => 1.04,
                                            "Sys::Info" => 0.78,
                                          },
      "func.note"                      => "Run by Pod::Weaver::Plugin::Bencher::Scenario",
      "func.permute"                   => ["perl", ["perl"], "participant", [0, 1], "dataset", [0]],
      "func.platform_info"             => {
                                            archname => "x86_64",
                                            codename => "jessie",
                                            is32bit  => 0,
                                            is64bit  => 1,
                                            kernel   => "linux-3.16.0-4-amd64",
                                            kname    => "Linux",
                                            kvers    => "3.16.0-4-amd64",
                                            osflag   => "linux",
                                            oslabel  => "Debian",
                                            osname   => "GNU/Linux",
                                            osvers   => "8.0",
                                            source   => {
                                                          "cat /etc/.issue" => "",
                                                          "cat /etc/issue"  => "Debian GNU/Linux 8 \\n \\l",
                                                          "lsb_release -a"  => "Distributor ID:\tDebian\nDescription:\tDebian GNU/Linux 8.0 (jessie)\nRelease:\t8.0\nCodename:\tjessie",
                                                          "uname -a"        => "Linux builder 3.16.0-4-amd64 #1 SMP Debian 3.16.36-1+deb8u2 (2016-10-19) x86_64 GNU/Linux",
                                                          "uname -m"        => "x86_64",
                                                          "uname -o"        => "GNU/Linux",
                                                          "uname -r"        => "3.16.0-4-amd64",
                                                          "uname -s"        => "Linux",
                                                        },
                                          },
      "func.precision"                 => 6,
      "func.scenario_module"           => "Bencher::Scenario::DigestSHA::SHA256",
      "func.scenario_module_md5sum"    => "248f0dc97a749b62e99ed502e89506f5",
      "func.scenario_module_mtime"     => 1499687192,
      "func.scenario_module_sha1sum"   => "1cec91ebdfe8ef23b77157de3285a4e35cb73e40",
      "func.scenario_module_sha256sum" => "2082d5b3030c6758cf6600bb7ee82ddb575201a8bb5cdd11ad45cb02c67cb67d",
      "func.time_end"                  => 1499687225.25906,
      "func.time_factor"               => 1000,
      "func.time_start"                => 1499687221.96891,
      "table.field_aligns"             => ["left", "number", "number", "number", "number", "number"],
      "table.field_units"              => [undef, "/s", "ms"],
      "table.fields"                   => ["participant", "rate", "time", "vs_slowest", "errors", "samples"],
    },
  ],
];

1;
# ABSTRACT: Benchmark Digest::SHA against sha512sum

=head1 DESCRIPTION

This module is automatically generated by Pod::Weaver::Plugin::Bencher::Scenario during distribution build.

A Bencher::ScenarioR::* module contains the raw result of sample benchmark and might be useful for some stuffs later.

