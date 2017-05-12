package # hide from PAUSE
App::YTDL::Arguments;

use warnings;
use strict;
use 5.010000;

use Exporter qw( import );
our @EXPORT_OK = qw( from_arguments_to_choices );

use Term::ANSIScreen qw( :cursor :screen );
use Term::Choose     qw( choose );

use if $^O eq 'MSWin32', 'Win32::Console::ANSI';

use App::YTDL::ChooseVideos qw( choose_videos );
use App::YTDL::DataExtract  qw( prepare_info );
use App::YTDL::GetData      qw( get_vimeo_list_info get_download_info get_youtube_list_info );



sub from_arguments_to_choices {
    my ( $opt, @ids ) = @_;
    my $info = {};
    for my $webpage_url ( @ids ) {
        if ( $webpage_url =~ /^u#([\p{PerlWord}-]+)\z/ ) {
            $webpage_url = sprintf 'https://www.youtube.com/user/%s/', $1;
        }
        elsif ( $webpage_url =~ /^c#([\p{PerlWord}-]+)\z/ ) {
            $webpage_url = sprintf 'https://www.youtube.com/channel/%s/', $1;
        }
        elsif ( $webpage_url =~ /^p#(?:[FP]L)?([\p{PerlWord}-]+)\z/ ) {
            $webpage_url = sprintf 'https://www.youtube.com/playlist?list=%s/', $1;
        }
        if ( my $video_id = _youtube_video_id( $opt, $webpage_url ) ) {
            my $ex = 'youtube';
            $info->{$ex}{$video_id}{extractor}   = $ex;
            $info->{$ex}{$video_id}{webpage_url} = sprintf 'https://www.youtube.com/watch?v=%s', $video_id;
            prepare_info( $opt, $info, $ex, $video_id );
        }
        elsif ( my $playlist_id = _youtube_playlist_id( $opt, $webpage_url ) ) {
            _generic( $opt, $info, $webpage_url );
        }
        elsif ( my $channel_id = _youtube_channel_id( $opt, $webpage_url ) ) {
            my $ex = 'youtube';
            my $type = 'Channel';
            my $tmp = _youtube_list_info( $opt, $type, $channel_id );
            next if ! defined $tmp;
            my ( $vi ) = keys %{$tmp->{$ex}};
            my $prompt = $tmp->{$ex}{$vi}{uploader};
            choose_videos( $opt, $info, $tmp, $ex, $prompt );
        }
        #elsif ( my $user_id = _youtube_user_id( $opt, $webpage_url ) ) {
        #    my $ex = 'youtube';
        #    my $tmp = _youtube_list_info( $opt, 'User', $user_id );
        #    next if ! defined $tmp;
        #    my ( $vi ) = keys %{$tmp->{$ex}};
        #    my $prompt = $tmp->{$ex}{$vi}{uploader};
        #    choose_videos( $opt, $info, $tmp, $ex, $prompt );
        #}
        elsif ( my ( $type, $user_id ) = _youtube_user_id( $opt, $webpage_url ) ) {
            my $ex = 'youtube';
            my $tmp = _youtube_list_info( $opt, $type, $user_id );
            next if ! defined $tmp;
            my ( $vi ) = keys %{$tmp->{$ex}};
            my $prompt = $tmp->{$ex}{$vi}{uploader};
            choose_videos( $opt, $info, $tmp, $ex, $prompt );
        }
        elsif ( my $vimeo_uploader_id = _vimeo_uploader_id( $opt, $webpage_url )  ) {
            my $ex = 'vimeo';
            my $tmp = _vimeo_list_info( $opt, $vimeo_uploader_id );
            next if ! defined $tmp;
            my ( $vi ) = keys %{$tmp->{$ex}};
            my $prompt = $tmp->{$ex}{$vi}{uploader} || $vimeo_uploader_id;
            choose_videos( $opt, $info, $tmp, $ex, $prompt );
        }
        else {
            _generic( $opt, $info, $webpage_url );
        }
    }
    return $info;
}


sub _generic {
    my ( $opt, $info, $webpage_url ) = @_;
    my $message = "** GET download info: ";
    my $tmp = get_download_info( $opt, $webpage_url, $message );
    return if ! defined $tmp;
    my ( $ex ) = keys %$tmp;
    my @keys = keys %{$tmp->{$ex}};
    if ( @keys == 1 ) {
        my $video_id = $keys[0];
        $info->{$ex}{$video_id} = $tmp->{$ex}{$video_id};
    }
    else {
        my $prompt = $tmp->{$ex}{$keys[0]}{uploader} || $webpage_url;
        choose_videos( $opt, $info, $tmp, $ex, $prompt );
    }
}


sub _youtube_video_id {
    my ( $opt, $webpage_url ) = @_;
    return if ! $opt->{fast_list_youtube};
    return if ! $webpage_url;
    return if   $webpage_url =~ m|http://|;
    my $regexp_video_url = qr"          # youtube-dl/youtube_dl/extractor/youtube.py    2016.10.11
        ^
        (
            (?:https?://|//)                                    # http(s):// or protocol-independent URL
            (?:(?:(?:(?:\w+\.)?[yY][oO][uU][tT][uU][bB][eE](?:-nocookie)?\.com/|
            (?:www\.)?deturl\.com/www\.youtube\.com/|
            (?:www\.)?pwnyoutube\.com/|
            (?:www\.)?yourepeat\.com/|
            tube\.majestyc\.net/|
            youtube\.googleapis\.com/)                        # the various hostnames, with wildcard subdomains
            (?:.*?\#/)?                                          # handle anchor (#/) redirect urls
            (?:                                                  # the various things that can precede the ID:
                (?:(?:v|embed|e)/(?!videoseries))                # v/ or embed/ or e/
                |(?:                                             # or the v= param in all its forms
                    (?:(?:watch|movie)(?:_popup)?(?:\.php)?/?)?  # preceding watch(_popup|.php) or nothing (like /?v=xxxx)
                    (?:\?|\#!?)                                  # the params delimiter ? or # or #!
                    (?:.*?[&;])??                                # any other preceding param (like /?s=tuff&v=xxxx or ?s=tuff&amp;v=V36LpHqtcDY)
                    v=
                )
            ))
            |(?:
            youtu\.be|                                        # just youtu.be/xxxx
            vid\.plus|                                        # or vid.plus/xxxx
            zwearz\.com/watch|                                # or zwearz.com/watch/xxxx
            )/
            |(?:www\.)?cleanvideosearch\.com/media/action/yt/watch\?videoId=
            )
        )?                                                       # all until now is optional -> you can pass the naked ID
        ([0-9A-Za-z_-]{11})                                      # here is it! the YouTube video ID
        (?!.*?\blist=)                                            # combined list/video URLs are handled by the playlist IE
        (?(1).+)?                                                # if we found the ID, everything can follow
        $
    "x;
    return $2 if $webpage_url =~ $regexp_video_url; # $2
    return;
}


sub _youtube_playlist_id {
    my ( $opt, $webpage_url ) = @_;
    return if ! $opt->{fast_list_youtube};
    return if ! $webpage_url;
    return if   $webpage_url =~ m|http://|;
    my $regexp_playlist_url = qr"           # youtube-dl/youtube_dl/extractor/youtube.py    2016.10.11
        (?:
            (?:https?://)?
            (?:\w+\.)?
            (?:
                youtube\.com/
                (?:
                    (?:course|view_play_list|my_playlists|artist|playlist|watch|embed/videoseries)
                    \? (?:.*?[&;])*? (?:p|a|list)=
                |  p/
                )|
                youtu\.be/[0-9A-Za-z_-]{11}\?.*?\blist=
            )
            (
                (?:PL|LL|EC|UU|FL|RD|UL)?[0-9A-Za-z-_]{10,}
                # Top tracks, they can also include dots
                |(?:MC)[\w\.]*
            )
            .*
            |
            ((?:PL|LL|EC|UU|FL|RD|UL)[0-9A-Za-z-_]{10,})
        )

    "x;
    return $1 if $webpage_url =~ $regexp_playlist_url; # $1
    return;
}


sub _youtube_channel_id {
    my ( $opt, $webpage_url ) = @_;
    return if ! $opt->{fast_list_youtube};
    return if ! $webpage_url;
    return if   $webpage_url =~ m|http://|;
    my $regexp_channel_url = qr"            # youtube-dl/youtube_dl/extractor/youtube.py    2016.10.11
        https?://(?:youtu\.be|(?:\w+\.)?youtube(?:-nocookie)?\.com)/channel/(?P<id>[0-9A-Za-z_-]+)
    "x;
    return $+{id} if $webpage_url =~ $regexp_channel_url; # $+{id}
    return;
}


sub _youtube_user_id {
    my ( $opt, $webpage_url ) = @_;
    return if ! $opt->{fast_list_youtube};
    return if ! $webpage_url;
    return if   $webpage_url =~ m|http://|;
    #my $regexp_user_url = qr"           # youtube-dl/youtube_dl/extractor/youtube.py
    #    (?:(?:(?:https?://)?(?:\w+\.)?youtube\.com/(?:user/)?(?!(?:attribution_link|watch|results)(?:$|[^a-z_A-Z0-9-])))|ytuser:)(?!feed/)(?P<id>[A-Za-z0-9_-]+)
    #"x; #
    #return $+{id} if $webpage_url =~ $regexp_user_url; # $+{id}
    my $regexp_user_url = qr"           # youtube-dl/youtube_dl/extractor/youtube.py    2016.10.11
        (?:(?:https?://(?:\w+\.)?youtube\.com/(?:(?P<user>user|c)/)?(?!(?:attribution_link|watch|results)(?:$|[^a-z_A-Z0-9-])))|ytuser:)(?!feed/)(?P<id>[A-Za-z0-9_-]+)
    "x;
    return $+{user}, $+{id} if $webpage_url =~ $regexp_user_url;
    return;
}


sub _vimeo_uploader_id {
    my ( $opt, $webpage_url ) = @_;
    return    if ! $opt->{fast_list_vimeo};
    return    if ! $webpage_url;
    return $1 if   $webpage_url =~ m{https?://vimeo\.com/(?![0-9]+(?:$|[?#/]))([^/]+)(?:/videos|[#?]|$)};
    return;
}


sub _youtube_list_info {
    my( $opt, $type, $list_id ) = @_;
    printf "Fetching info data ... \n";
    #my $url = sprintf 'https://www.youtube.com/user/%s/videos?sort=dd&view=0&flow=list', $list_id;
    my $url = sprintf 'https://www.youtube.com/%s/%s/videos', lc $type, $list_id;
    my $ex = 'youtube';
    my $tmp_info = {};
    my $a_ref = get_youtube_list_info( $opt, $url );
    if ( ! defined $a_ref ) {
        push @{$opt->{error_get_download_infos}}, sprintf "%s: %s", $type, $list_id;
        #my $prompt = "Error list-info: $url";
        #choose( [ 'ENTER to continue' ], { prompt => $prompt } );
        return;
    }
    for my $entry ( @{$a_ref} ) {
        my $video_id = $entry->{video_id};
        $tmp_info->{$ex}{$video_id} = {
            video_id        => $video_id,
            title           => $entry->{title},
            upload_date_rel => $entry->{upload_date_rel},
            uploader        => $entry->{uploader},
            view_count      => $entry->{view_count},
            duration        => $entry->{duration},
            date_sort       => $entry->{date_sort},
            webpage_url     => $entry->{webpage_url},
        };
        prepare_info( $opt, $tmp_info, $ex, $video_id );
    }
    if ( ! keys %{$tmp_info->{$ex}} ) {
        my $prompt = "No videos found: $type - $url";
        choose( [ 'Continue with ENTER' ], { prompt => $prompt } );
    }
    my $up = keys %{$tmp_info->{$ex}};
    print up( $up + 2 ), cldown;
    return $tmp_info;
}


sub _vimeo_list_info {
    my( $opt, $list_id ) = @_;
    printf "Fetching info ... \n";
    my $page_nr = 1;
    my $ex = 'vimeo';
    my $tmp_info = {};
    my $videos = 0;
    my $url;
    while ( 1 ) {
        $url = sprintf 'https://vimeo.com/%s/videos/page:%d/sort:date', $list_id, $page_nr;
        my ( $a_ref, $next ) = get_vimeo_list_info( $opt, $url );
        if ( ! defined $a_ref ) {
            push @{$opt->{error_get_download_infos}}, sprintf "%s: error", $list_id;
            return;
        }
        if ( ! @$a_ref ) {
            push @{$opt->{error_get_download_infos}}, sprintf "%s: no videos found.", $url;
        }
        for my $entry ( @{$a_ref} ) {
            my $video_id = $entry->{video_id};
            $tmp_info->{$ex}{$video_id} = {
                video_id    => $video_id,
                title       => $entry->{title},
                upload_date => $entry->{upload_date},
                uploader    => $entry->{uploader},
                webpage_url => $entry->{webpage_url},
            };
            prepare_info( $opt, $tmp_info, $ex, $video_id );
        }
        $videos += @{$a_ref};
        last if $opt->{small_list_size} && $videos >= 48;
        last if ! $next;
        $page_nr++;
    }
    if ( ! keys %{$tmp_info->{$ex}} ) {
        my $prompt = "No videos found: $url";
        choose( [ 'Continue with ENTER' ], { prompt => $prompt } );
    }
    my $up = keys %{$tmp_info->{$ex}};
    print up( $up + 2 ), cldown;
    return $tmp_info;
}




1;


__END__
