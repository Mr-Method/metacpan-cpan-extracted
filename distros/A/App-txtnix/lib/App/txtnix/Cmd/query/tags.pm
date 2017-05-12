package App::txtnix::Cmd::query::tags;
use Mojo::Base 'App::txtnix::Cmd::query';
use App::txtnix::Registry;

has [qw( search_term )];

sub run {
    my $self = shift;
    die "Missing parameter registry." if !$self->registry;
    my $registry =
      App::txtnix::Registry->new( url => $self->registry, ua => $self->ua );

    my @results = $registry->get_tags( $self->search_term );

    $self->display_tweets( 1, $self->query_result_to_tweets(@results) );

    return 0;
}

1;
