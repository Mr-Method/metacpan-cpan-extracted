package Android::Releases;

our $DATE = '2015-11-06'; # DATE
our $VERSION = '0.01'; # VERSION

use 5.010001;
use strict;
use warnings;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       list_android_releases
               );

our %SPEC;

# BEGIN FRAGMENT id=meta
# note: This section is generated by a script. Do not edit manually!
# src-file: /mnt/home/s1/repos/gudangdata/table/android_release/meta.yaml
# src-revision: bcd38551cd0cf53ff658d0eb432d480b80dd5fcf
# revision-date: Fri Nov 6 11:58:56 2015 +0700
# generate-date: Fri Nov  6 12:04:52 2015
# generated-by: /mnt/home/s1/repos/gudangdata/bin/gen-perl-meta-snippet
our $meta = {
  fields => {
    api_level => { pos => 2, schema => "int*", sortable => 1, summary => "API level" },
    code_name => { pos => 1, schema => "str*", sortable => 1, summary => "Code name", unique => 1 },
    reldate   => { pos => 3, schema => "date*", sortable => 1, summary => "Release date" },
    version   => { pos => 0, schema => "str*", sortable => 1, summary => "Version", unique => 1 },
  },
  pk => "version",
  summary => "Android releases",
};
# END FRAGMENT id=meta
# BEGIN FRAGMENT id=data
# note: This section is generated by a script. Do not edit manually!
# src-file: /mnt/home/s1/repos/gudangdata/table/android_release/data.csv
# src-revision: bcd38551cd0cf53ff658d0eb432d480b80dd5fcf
# revision-date: Fri Nov 6 11:58:56 2015 +0700
# generate-date: Fri Nov  6 12:04:52 2015
# generated-by: /mnt/home/s1/repos/gudangdata/bin/gen-perl-data-snippet
our $data = [
    ['1.0','','1','2008-09-23'],
    ['1.1','Petit Four','2','2009-02-09'],
    ['1.5','Cupcake','3','2009-04-27'],
    ['1.6','Donut','4','2009-09-15'],
    ['2.0','Eclair','5','2009-10-26'],
    ['2.0.1','Eclair','6','2009-12-03'],
    ['2.1','Eclair','7','2010-01-12'],
    ['2.2','Froyo','8','2010-05-20'],
    ['2.3','Gingerbread','9','2010-12-06'],
    ['2.3.3','Gingerbread','10','2011-02-09'],
    ['3.0','Honeycomb','11','2011-02-22'],
    ['3.1','Honeycomb','12','2011-05-10'],
    ['3.2','Honeycomb','13','2011-07-15'],
    ['4.0','Ice Cream Sandwich','14','2011-10-18'],
    ['4.0.3','Ice Cream Sandwich','15','2011-12-16'],
    ['4.1','Jelly Bean','16','2012-07-19'],
    ['4.2','Jelly Bean','17','2012-11-13'],
    ['4.3','Jelly Bean','18','2013-07-24'],
    ['4.4','KitKat','19','2013-10-31'],
    ['4.4W','KitKat','20','2014-06-25'],
    ['5.0','Lollipop','21','2014-11-12'],
    ['5.1','Lollipop','22','2015-03-09'],
    ['6.0','Marshmallow','23','2015-10-05'],
]
;
# END FRAGMENT id=data

my $res = gen_read_table_func(
    name => 'list_android_releases',
    table_data => $data,
    table_spec => $meta,
    #langs => ['en_US', 'id_ID'],
);
die "BUG: Can't generate func: $res->[0] - $res->[1]" unless $res->[0] == 200;

1;
# ABSTRACT: List Android releases

__END__

=pod

=encoding UTF-8

=head1 NAME

Android::Releases - List Android releases

=head1 VERSION

This document describes version 0.01 of Android::Releases (from Perl distribution Android-Releases), released on 2015-11-06.

=head1 SYNOPSIS

 use Android::Releases;
 my $res = list_android_releases(detail=>1);
 # raw data is in $Android::Releases::data;

=head1 DESCRIPTION

This module contains list of Android releases. Data source is currently at:
https://github.com/perlancar/gudangdata (table/android_release).

=head1 FUNCTIONS


=head2 list_android_releases(%args) -> [status, msg, result, meta]

Android releases.

REPLACE ME

This function is not exported by default, but exportable.

Arguments ('*' denotes required arguments):

=over 4

=item * B<api_level> => I<int>

Only return records where the 'api_level' field equals specified value.

=item * B<api_level.in> => I<array[int]>

Only return records where the 'api_level' field is in the specified values.

=item * B<api_level.is> => I<int>

Only return records where the 'api_level' field equals specified value.

=item * B<api_level.isnt> => I<int>

Only return records where the 'api_level' field does not equal specified value.

=item * B<api_level.max> => I<int>

Only return records where the 'api_level' field is less than or equal to specified value.

=item * B<api_level.min> => I<int>

Only return records where the 'api_level' field is greater than or equal to specified value.

=item * B<api_level.not_in> => I<array[int]>

Only return records where the 'api_level' field is not in the specified values.

=item * B<api_level.xmax> => I<int>

Only return records where the 'api_level' field is less than specified value.

=item * B<api_level.xmin> => I<int>

Only return records where the 'api_level' field is greater than specified value.

=item * B<code_name> => I<str>

Only return records where the 'code_name' field equals specified value.

=item * B<code_name.contains> => I<str>

Only return records where the 'code_name' field contains specified text.

=item * B<code_name.in> => I<array[str]>

Only return records where the 'code_name' field is in the specified values.

=item * B<code_name.is> => I<str>

Only return records where the 'code_name' field equals specified value.

=item * B<code_name.isnt> => I<str>

Only return records where the 'code_name' field does not equal specified value.

=item * B<code_name.max> => I<str>

Only return records where the 'code_name' field is less than or equal to specified value.

=item * B<code_name.min> => I<str>

Only return records where the 'code_name' field is greater than or equal to specified value.

=item * B<code_name.not_contains> => I<str>

Only return records where the 'code_name' field does not contain specified text.

=item * B<code_name.not_in> => I<array[str]>

Only return records where the 'code_name' field is not in the specified values.

=item * B<code_name.xmax> => I<str>

Only return records where the 'code_name' field is less than specified value.

=item * B<code_name.xmin> => I<str>

Only return records where the 'code_name' field is greater than specified value.

=item * B<detail> => I<bool> (default: 0)

Return array of full records instead of just ID fields.

By default, only the key (ID) field is returned per result entry.

=item * B<fields> => I<array[str]>

Select fields to return.

=item * B<query> => I<str>

Search.

=item * B<random> => I<bool> (default: 0)

Return records in random order.

=item * B<reldate> => I<date>

Only return records where the 'reldate' field equals specified value.

=item * B<reldate.in> => I<array[date]>

Only return records where the 'reldate' field is in the specified values.

=item * B<reldate.is> => I<date>

Only return records where the 'reldate' field equals specified value.

=item * B<reldate.isnt> => I<date>

Only return records where the 'reldate' field does not equal specified value.

=item * B<reldate.max> => I<date>

Only return records where the 'reldate' field is less than or equal to specified value.

=item * B<reldate.min> => I<date>

Only return records where the 'reldate' field is greater than or equal to specified value.

=item * B<reldate.not_in> => I<array[date]>

Only return records where the 'reldate' field is not in the specified values.

=item * B<reldate.xmax> => I<date>

Only return records where the 'reldate' field is less than specified value.

=item * B<reldate.xmin> => I<date>

Only return records where the 'reldate' field is greater than specified value.

=item * B<result_limit> => I<int>

Only return a certain number of records.

=item * B<result_start> => I<int> (default: 1)

Only return starting from the n'th record.

=item * B<sort> => I<str>

Order records according to certain field(s).

A list of field names separated by comma. Each field can be prefixed with '-' to
specify descending order instead of the default ascending.

=item * B<version> => I<str>

Only return records where the 'version' field equals specified value.

=item * B<version.contains> => I<str>

Only return records where the 'version' field contains specified text.

=item * B<version.in> => I<array[str]>

Only return records where the 'version' field is in the specified values.

=item * B<version.is> => I<str>

Only return records where the 'version' field equals specified value.

=item * B<version.isnt> => I<str>

Only return records where the 'version' field does not equal specified value.

=item * B<version.max> => I<str>

Only return records where the 'version' field is less than or equal to specified value.

=item * B<version.min> => I<str>

Only return records where the 'version' field is greater than or equal to specified value.

=item * B<version.not_contains> => I<str>

Only return records where the 'version' field does not contain specified text.

=item * B<version.not_in> => I<array[str]>

Only return records where the 'version' field is not in the specified values.

=item * B<version.xmax> => I<str>

Only return records where the 'version' field is less than specified value.

=item * B<version.xmin> => I<str>

Only return records where the 'version' field is greater than specified value.

=item * B<with_field_names> => I<bool>

Return field names in each record (as hash/associative array).

When enabled, function will return each record as hash/associative array
(field name => value pairs). Otherwise, function will return each record
as list/array (field value, field value, ...).

=back

Returns an enveloped result (an array).

First element (status) is an integer containing HTTP status code
(200 means OK, 4xx caller error, 5xx function error). Second element
(msg) is a string containing error message, or 'OK' if status is
200. Third element (result) is optional, the actual result. Fourth
element (meta) is called result metadata and is optional, a hash
that contains extra information.

Return value:  (any)

=head1 SEE ALSO

L<Debian::Releases>

L<Ubuntu::Releases>

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Android-Releases>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-Android-Releases>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Android-Releases>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
