#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Encode ();
use HTTP::Tiny;
use FindBin;
use Path::Tiny;
use File::Basename 'basename';
use Data::Dump ();
chdir $FindBin::Bin;

my $http = HTTP::Tiny->new;

my %url = map {; "http://unicode.org/Public/emoji/latest/$_" => undef } qw(
    emoji-data.txt
    emoji-zwj-sequences.txt
    emoji-sequences.txt
);

for my $url (sort keys %url) {
    warn "-> get $url\n";
    my $file = basename $url;
    my $res = $http->mirror($url, $file);
    die "$url: $res->{status}\n" unless $res->{success};
    warn "-> unmodified $file\n" if $res->{status} == 304;
    $url{$url} = path($file)->slurp_utf8;
}

sub load_emoji {
    my @content = @_;
    my @line = map { split /\n/, $_ } @content;
    my @chr;
    while (defined(my $line = shift @line)) {
        chomp $line;
        $line =~ s/^\s+//; $line =~ s/\s+$//;
        next if !$line || $line =~ /^#/;
        $line =~ s/\s*#.*//;
        $line =~ s/\s*;.*//;
        if ($line !~ /\s+/) {
            my @point;
            if ($line =~ /^([0-9A-F]+)\.\.([0-9A-F]+)$/) {
                @point = hex($1) .. hex($2);
            } else {
                @point = (hex($line));
            }
            for my $point (@point) {
                my $chr = chr $point;
                $chr .= "\N{U+FE0F}" if $point < 256;
                push @chr, $chr;
            }
        } else {
            my @item = split /\s+/, $line;
            my $chr = join "", map { chr hex $_ } @item;
            push @chr, $chr
        }
    }
    \@chr;
}


my $emoji = load_emoji( map { $url{$_} } sort keys %url );
my $dump = Data::Dump::dump($emoji);

warn "-> write ../lib/Acme/RandomEmoji.pm\n";
my $template = path("RandomEmoji.pm")->slurp_utf8;
$template =~ s/## REPLACE ##/$dump/;
path("../lib/Acme/RandomEmoji.pm")->spew_utf8(
    "# THIS FILE IS AUTOMATICALLY GENERATED BY author/generate.pl\n",
    $template
);
