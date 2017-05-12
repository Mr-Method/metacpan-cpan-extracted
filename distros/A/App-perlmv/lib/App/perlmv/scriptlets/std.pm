package App::perlmv::scriptlets::std;

use 5.010;
use strict;
use warnings;

our $VERSION = '0.50'; # VERSION

# ABSTRACT: A collection of perlmv scriptlets


our %scriptlets;


$scriptlets{'dedup-space'} = <<'EOT';
### Summary: Replace multiple spaces into a single space, example: "1  2.txt " -> "1 2.txt"
s/\s{2,}/ /g; $_
EOT


$scriptlets{'keep-one-ext'} = <<'EOT';
### Summary: Remove all but the last file extension if there are more than one, e.g. (1.tar, 2.mp3.mp3) -> (1.tar, 2.mp3)
s/(.+?)(?:\.\w{1,5})+(\.\w{1,5})$/$1$2/
EOT


$scriptlets{'pinyin'} = <<'EOT';
### Summary: Rename Chinese characters in filename into their pinyin
### Requires: Lingua::Han::Pinyin
use Lingua::Han::PinYin;
$h||=Lingua::Han::PinYin->new; $h->han2pinyin($_)
EOT


$scriptlets{'remove-common-prefix'} = <<'EOT';
### Summary: Remove prefix that are common to all args, e.g. (file1, file2b) -> (1, 2b)
if (!defined($COMMON_PREFIX) && !$TESTING) {
    for ($i=0; $i<length($FILES->[0]); $i++) {
        last if grep { substr($_, $i, 1) ne substr($FILES->[0], $i, 1) } @{$FILES}[1..@$FILES-1];
    }
    $COMMON_PREFIX = substr($FILES->[0], 0, $i);
}
s/^\Q$COMMON_PREFIX//;
$_
EOT


$scriptlets{'remove-common-suffix'} = <<'EOT';
### Summary: Remove suffix that are common to all args, while preserving extension, e.g. (1-radiolab.mp3, 2-radiolab.mp3) -> (1.mp3, 2.mp3)
if (!defined($COMMON_SUFFIX) && !$TESTING) {
    for (@$FILES) { $_ = reverse };
    for ($i=0; $i<length($FILES->[0]); $i++) {
        last if grep { substr($_, $i, 1) ne substr($FILES->[0], $i, 1) } @{$FILES}[1..@$FILES-1];
    }
    $COMMON_SUFFIX = reverse substr($FILES->[0], 0, $i);
    for (@$FILES) { $_ = reverse };
    # don't wipe extension, if exists
    $EXT = $COMMON_SUFFIX =~ /.(\.\w+)$/ ? $1 : "";
}
s/\Q$COMMON_SUFFIX\E$/$EXT/;
$_
EOT


$scriptlets{'remove-ext'} = <<'EOT';
### Summary: Remove the last file extension, e.g. (1, 2.mp3, 3.tar.gz) -> (1, 2, 3.tar)
s/(.+)\.\w{1,5}$/$1/
EOT


$scriptlets{'remove-all-ext'} = <<'EOT';
### Summary: Remove all file extensions, e.g. (file.html.gz) -> (file)
s/(.+?)(?:\.\w{1,5})+$/$1/
EOT


$scriptlets{'to-number'} = <<'EOT';
### Summary: Rename files into numbers. Ex: (file1.txt, foo.jpg, quux.mpg) -> (1, 2, 3)
if ($COMPILING || $CLEANING) { $i=0 } else { $i++ }
$ndig = @$FILES >= 1000 ? 4 : @$FILES >= 100 ? 3 : @$FILES >= 10 ? 2 : 1;
sprintf "%0${ndig}d", $i
EOT


$scriptlets{'to-number-ext'} = <<'EOT';
### Summary: Rename files into numbers. Preserve extensions. Ex: (file1.txt, foo.jpg, quux.mpg) -> (1.txt, 2.jpg, 3.mpg)
if ($COMPILING || $CLEANING) { $i=0 } else { $i++ }
if (/.+\.(.+)/) {$ext=$1} else {$ext=undef}
$ndig = @$FILES >= 1000 ? 4 : @$FILES >= 100 ? 3 : @$FILES >= 10 ? 2 : 1;
sprintf "%0${ndig}d%s", $i, (defined($ext) ? ".$ext" : "")
EOT


$scriptlets{'to-timestamp'} = <<'EOT';
### Summary: Rename files into timestamp. Ex: file1.txt -> 2010-05-13-10_43_49
use POSIX;
@st = lstat $_;
POSIX::strftime("%Y-%m-%d-%H_%M_%S", localtime $st[9])
EOT


$scriptlets{'to-timestamp-ext'} = <<'EOT';
### Summary: Rename files into timestamp. Preserve extensions. Ex: file1.txt -> 2010-05-13-10_43_49.txt
use POSIX; /.+\.(.+)/; $ext=$1;
@st = lstat $_;
POSIX::strftime("%Y-%m-%d-%H_%M_%S", localtime $st[9]).(defined($ext) ? ".$ext" : "")
EOT


$scriptlets{'trim'} = <<'EOT';
### Summary: Remove leading and trailing blanks, example: " abc def .txt " -> "abc def.txt"
s/^\s+//; s/\s+(\.\w{1,8})?$/$1/; $_
EOT


$scriptlets{'unaccent'} = <<'EOT';
### Summary: Remove accents in filename, e.g. accéder.txt -> acceder.txt
### Requires: Text::Unaccent::PurePerl
use Text::Unaccent::PurePerl;
unac_string("UTF8", $_)
EOT


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::perlmv::scriptlets::std - A collection of perlmv scriptlets

=head1 VERSION

This document describes version 0.50 of App::perlmv::scriptlets::std (from Perl distribution App-perlmv), released on 2015-11-17.

=head1 SCRIPTLETS

=head2 dedup-space

Replace multiple spaces into a single space, example (<space>
signifies actual space): "1<space><space>2.txt " -> "1<space>2.txt"

=head2 keep-one-ext

Remove all but the last file extension if there are more than one, e.g. (1.tar,
2.mp3.mp3) -> (1.tar, 2.mp3). TODO: treat tar.gz/tar.bz2/etc as one
extension.

=head2 pinyin

Rename Chinese characters in filename into their pinyin. Requires
L<Lingua::Han::Pinyin>.

=head2 remove-common-prefix

Remove prefix that are common to all args, e.g. (file1, file2b) -> (1,
2b)

=head2 remove-common-suffix

Remove suffix that are common to all args, while preserving extension,
e.g. (1-radiolab.mp3, 2-radiolab.mp3) -> (1.mp3, 2.mp3)

=head2 remove-ext

Remove the last file extension, e.g. (1, 2.mp3, 3.tar.gz) -> (1, 2, 3.tar)

=head2 remove-all-ext

Remove all file extensions, e.g. (file.html.gz) -> (file)

=head2 to-number

Rename files into numbers. Ex: (file1.txt, foo.jpg, quux.mpg) -> (1.txt, 2.jpg,
3.mpg). See also: to-number-ext.

=head2 to-number-ext

Rename files into numbers. Preserve extensions. Ex: (file1.txt,
foo.jpg, quux.mpg) -> (1.txt, 2.jpg, 3.mpg)

=head2 to-timestamp

Rename files into timestamp. Ex: file1.txt -> 2010-05-13-10_43_49. See also:
to-timestamp-ext.

=head2 to-timestamp-ext

Rename files into timestamp. Preserve extensions. Ex: file1.txt ->
2010-05-13-10_43_49.txt

=head2 trim

Remove leading and trailing blanks, example: " abc def .txt " -> "abc
def.txt"

=head2 unaccent

Remove accents in filename, e.g. accéder.txt -> acceder.txt. Requires
L<Text::Unaccent::PurePerl>.

=head2 HAVE MORE?

If you have cool scriptlets to share, feel free to contact me so I can
include them here.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/App-perlmv>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-App-perlmv>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-perlmv>

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
