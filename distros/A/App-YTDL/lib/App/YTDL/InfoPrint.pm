package # hide from PAUSE
App::YTDL::InfoPrint;

use warnings;
use strict;
use 5.010000;

use Exporter qw( import );
our @EXPORT_OK = qw( linefolded_print_info );

use Term::ANSIScreen       qw( :cursor :screen );
use Term::Choose::LineFold qw( line_fold );
use Term::Choose::Util     qw( term_size );

use if $^O eq 'MSWin32', 'Win32::Console::ANSI';

use App::YTDL::GetData qw( get_download_info );
use App::YTDL::Helper  qw( check_mapping_stdout );


sub _download_info {
    my ( $opt, $info, $ex, $video_id ) = @_;
    return if $info->{$ex}{$video_id}{fmt_to_info};
    my $webpage_url = $info->{$ex}{$video_id}{webpage_url};
    my $message     = "** GET download info: ";
    my $tmp = get_download_info( $opt, $webpage_url, $message );
    for my $video_id ( keys %{$tmp->{$ex}} ) {
        for my $key ( keys %{$tmp->{$ex}{$video_id}} ) {
            $info->{$ex}{$video_id}{$key} = $tmp->{$ex}{$video_id}{$key};
        }
    }
}


sub _prepare_print_info {
    my ( $opt, $info, $ex, $video_id ) = @_;
    _download_info( $opt, $info, $ex, $video_id );
    $info->{$ex}{$video_id}{published}  = $info->{$ex}{$video_id}{upload_date};
    $info->{$ex}{$video_id}{author}     = $info->{$ex}{$video_id}{uploader};
    $info->{$ex}{$video_id}{avg_rating} = $info->{$ex}{$video_id}{average_rating};
    if ( length $info->{$ex}{$video_id}{author} && length $info->{$ex}{$video_id}{uploader_id} ) {
        if ( $info->{$ex}{$video_id}{author} ne $info->{$ex}{$video_id}{uploader_id} ) {
            $info->{$ex}{$video_id}{author} .= ' (' . $info->{$ex}{$video_id}{uploader_id} . ')';
        }
    }
    my @keys = ( 'title', 'video_id' );
    push @keys, 'extractor'                                    if $ex ne 'youtube';
    push @keys, 'author', 'duration', 'raters', 'avg_rating';
    push @keys, 'view_count'                                   if $info->{$ex}{$video_id}{view_count};
    push @keys, 'published'                                    if $info->{$ex}{$video_id}{upload_date} ne '0000-00-00';
    push @keys, 'description'; # categories
    for my $key ( @keys ) {
        next if ! $info->{$ex}{$video_id}{$key};
        $info->{$ex}{$video_id}{$key} =~ s/\R/ /g;
        $info->{$ex}{$video_id}{$key} = check_mapping_stdout( $opt, $info->{$ex}{$video_id}{$key} );
    }
    return @keys;
}


sub linefolded_print_info {
    my ( $opt, $info, $ex, $video_id, $key_len ) = @_;
    my @keys = _prepare_print_info( $opt, $info, $ex, $video_id );
    my $s_tab = $key_len + length( ' : ' );
    my ( $maxcols, $maxrows ) = term_size();
    $maxcols -= $opt->{right_margin};
    my $col_max = $maxcols > $opt->{max_info_width} ? $opt->{max_info_width} : $maxcols;
    my $print_array = [];
    for my $key ( @keys ) {
        next if ! length $info->{$ex}{$video_id}{$key};
        $info->{$ex}{$video_id}{$key} =~ s/\n+/\n/g;
        $info->{$ex}{$video_id}{$key} =~ s/^\s+//;
        ( my $kk = $key ) =~ s/_/ /g;
        my $pr_key = sprintf "%*.*s : ", $key_len, $key_len, $kk;
        my $text = line_fold(
            $pr_key . $info->{$ex}{$video_id}{$key},
            $col_max,
            '' , ' ' x $s_tab
        );
        $text =~ s/\R+\z//;
        push @$print_array, map { "$_\n" } split /\R+/, $text;
    }
    return $print_array if ! @$print_array;
    # auto width:
    my $ratio = @$print_array / $maxrows;
    my $begin = 0.70;
    my $end   = 1.50;
    my $step  = 0.0125;
    my $div   = ( $end - $begin ) / $step + 1;
    my $plus;
    if ( $ratio >= $begin ) {
        $ratio = $end if $ratio > $end;
        $plus = int( ( ( $maxcols - $col_max ) / $div ) * ( ( $ratio - $begin  ) / $step + 1 ) );
    }
    if ( $plus ) {
        $col_max += $plus;
        $print_array = [];
        for my $key ( @keys ) {
            next if ! length $info->{$ex}{$video_id}{$key};
            ( my $kk = $key ) =~ s/_/ /g;
            my $pr_key = sprintf "%*.*s : ", $key_len, $key_len, $kk;
            my $text = line_fold(
                $pr_key . $info->{$ex}{$video_id}{$key},
                $col_max,
                '' , ' ' x $s_tab
            );
            $text =~ s/\R+\z//;
            push @$print_array, map { "$_\n" } split /\R+/, $text;
        }
    }
    if ( @$print_array > ( $maxrows - 6 ) ) {
        $col_max = $maxcols;
        $print_array = [];
        for my $key ( @keys ) {
            next if ! length $info->{$ex}{$video_id}{$key};
            ( my $kk = $key ) =~ s/_/ /g;
            my $pr_key = sprintf "%*.*s : ", $key_len, $key_len, $kk;
            my $text = line_fold(
                $pr_key . $info->{$ex}{$video_id}{$key},
                $col_max,
                '' , ' ' x $s_tab
            );
            $text =~ s/\R+\z//;
            push @$print_array, map { "$_\n" } split /\R+/, $text;
        }
    }
    return $print_array;
}





1;


__END__
