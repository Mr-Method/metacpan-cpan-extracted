package RTx::Shredder::Plugin::Attachments;

use strict;
use warnings FATAL => 'all';
use base qw(RTx::Shredder::Plugin::Base);

=head1 NAME

RTx::Shredder::Plugin::Attachments - search plugin for wiping attachments.

=cut

sub Type { return 'search' }

=head1 ARGUMENTS

=head2 files_only - boolean value

Search only file attachments.

=head2 file - mask

Search files with specific file name only.

Example: '*.xl?' or '*.gif'

=head2 longer - attachment content size

Search attachments which content is longer than specified.
You can use trailing 'K' or 'M' character to specify size in
kilobytes or megabytes.

=cut

sub SupportArgs { return $_[0]->SUPER::SupportArgs, qw(files_only file longer) }

sub TestArgs
{
    my $self = shift;
    my %args = @_;
    my $queue;
    if( $args{'file'} ) {
        unless( $args{'file'} =~ /^[\w\. *?]+$/) {
            return( 0, "Files mask '$args{file}' has invalid characters" );
        }
        $args{'file'} = $self->ConvertMaskToSQL( $args{'file'} );
    }
    if( $args{'longer'} ) {
        unless( $args{'longer'} =~ /^\d+\s*[mk]?$/i ) {
            return( 0, "Invalid file size argument '$args{longer}'" );
        }
    }
    return $self->SUPER::TestArgs( %args );
}

sub Run
{
    my $self = shift;
    my @conditions = ();
    my @values = ();
    if( $self->{'opt'}{'file'} ) {
        my $mask = $self->{'opt'}{'file'};
        push @conditions, "( Filename LIKE ? )";
        push @values, $mask;
    }
    if( $self->{'opt'}{'files_only'} ) {
        push @conditions, "( LENGTH(Filename) > 0 )";
    }
    if( $self->{'opt'}{'longer'} ) {
        my $size = $self->{'opt'}{'longer'};
        $size =~ s/([mk])//i;
        $size *= 1024 if $1 && lc $1 eq 'k';
        $size *= 1024*1024 if $1 && lc $1 eq 'm';
        push @conditions, "( LENGTH(Content) > ? )";
        push @values, $size;
    }
    return (0, "At least one condition should be provided" ) unless @conditions;
    my $query = "SELECT id FROM Attachments WHERE ". join ' AND ', @conditions;
    if( $self->{'opt'}{'limit'} ) {
        $RT::Handle->ApplyLimits( \$query, $self->{'opt'}{'limit'} );
    }
    my $sth = $RT::Handle->SimpleQuery( $query, @values );
    return (0, "Internal error: '$sth'. Please send bug report.") unless $sth;

    my @objs;
    while( my $row = $sth->fetchrow_arrayref ) {
        push @objs, $row->[0];
    }
    return (0, "Internal error: '". $sth->err ."'. Please send bug report.") if $sth->err;

    map { $_ = "RT::Attachment-$_" } @objs;

    return (1, @objs);
}

1;

