package App::Alice::HTTPD;

use AnyEvent;
use AnyEvent::HTTP;

use Twiggy::Server;
use Plack::Request;
use Plack::Builder;
use Plack::Middleware::Static;
use Plack::Session::Store::File;

use IRC::Formatting::HTML qw/html_to_irc/;

use App::Alice::Stream;
use App::Alice::Commands;

use JSON;
use Encode;
use utf8;
use Any::Moose;
use Try::Tiny;

has 'app' => (
  is  => 'ro',
  isa => 'App::Alice',
  required => 1,
);

has 'httpd' => (is  => 'rw');
has 'ping_timer' => (is  => 'rw');

has 'config' => (
  is => 'ro',
  isa => 'App::Alice::Config',
  lazy => 1,
  default => sub {shift->app->config},
);

my $url_handlers = [
  [ qr{^/$}               => \&send_index ],
  [ qr{^/say/?$}          => \&handle_message ],
  [ qr{^/stream/?$}       => \&setup_stream ],
  [ qr{^/config/?$}       => \&send_config ],
  [ qr{^/prefs/?$}        => \&send_prefs ],
  [ qr{^/serverconfig/?$} => \&server_config ],
  [ qr{^/save/?$}         => \&save_config ],
  [ qr{^/tabs/?$}         => \&tab_order ],
  [ qr{^/login/?$}        => \&login ],
  [ qr{^/logout/?$}       => \&logout ],
  [ qr{^/logs/?$}         => \&send_logs ],
  [ qr{^/search/?$}       => \&send_search ],
  [ qr{^/range/?$}        => \&send_range ],
  [ qr{^/view/?$}         => \&send_index ],
  [ qr{^/get}             => \&image_proxy ],
];

sub url_handlers { return $url_handlers }

has 'streams' => (
  is => 'rw',
  auto_deref => 1,
  isa => 'ArrayRef[App::Alice::Stream]',
  default => sub {[]},
);

sub add_stream {push @{shift->streams}, @_}
sub no_streams {@{$_[0]->streams} == 0}
sub stream_count {scalar @{$_[0]->streams}}

sub BUILD {
  my $self = shift;
  my $httpd = Twiggy::Server->new(
    host => $self->config->http_address,
    port => $self->config->http_port,
  );
  $httpd->register_service(
    builder {
      if ($self->app->auth_enabled) {
        mkdir $self->config->path."/sessions"
          unless -d $self->config->path."/sessions";
        enable "Session",
          store => Plack::Session::Store::File->new(dir => $self->config->path),
          expires => "24h";
      }
      enable "Static", path => qr{^/static/}, root => $self->config->assetdir;
      sub {$self->dispatch(shift)}
    }
  );
  $self->httpd($httpd);
  $self->ping;
}

sub dispatch {
  my ($self, $env) = @_;
  my $req = Plack::Request->new($env);
  if ($self->app->auth_enabled) {
    unless ($req->path eq "/login" or $self->is_logged_in($req)) {
      my $res = $req->new_response;
      $res->redirect("/login");
      return $res->finalize;
    }
  }
  for my $handler (@{$self->url_handlers}) {
    my $re = $handler->[0];
    if ($req->path_info =~ /$re/) {
      return $handler->[1]->($self, $req);
    }
  }
  return $self->not_found($req);
}

sub is_logged_in {
  my ($self, $req) = @_;
  my $session = $req->env->{"psgix.session"};
  return $session->{is_logged_in};
}

sub login {
  my ($self, $req) = @_;
  my $res = $req->new_response;
  if (!$self->app->auth_enabled or $self->is_logged_in($req)) {
    $res->redirect("/");
    return $res->finalize;
  }
  elsif (my $user = $req->param("username")
     and my $pass = $req->param("password")) {
    if ($self->app->authenticate($user, $pass)) {
      $req->env->{"psgix.session"}->{is_logged_in} = 1;
      $res->redirect("/");
      return $res->finalize;
    }
    $res->body($self->app->render("login", "bad username or password"));
  }
  else {
    $res->body($self->app->render("login"));
  }
  $res->status(200);
  return $res->finalize;
}

sub logout {
  my ($self, $req) = @_;
  my $res = $req->new_response;
  if (!$self->app->auth_enabled) {
    $res->redirect("/");
  } else {
    $req->env->{"psgix.session"}{is_logged_in} = 0;
    $req->env->{"psgix.session.options"}{expire} = 1;
    $res->redirect("/login");
  }
  return $res->finalize;
}

sub ping {
  my $self = shift;
  $self->ping_timer(AnyEvent->timer(
    after    => 5,
    interval => 10,
    cb       => sub {
      $self->broadcast({
        type => "action",
        event => "ping",
      });
    }
  ));
}

sub shutdown {
  my $self = shift;
  $_->close for $self->streams;
  $self->streams([]);
  $self->ping_timer(undef);
  $self->httpd(undef);
}

sub image_proxy {
  my ($self, $req) = @_;
  my $url = $req->request_uri;
  $url =~ s/^\/get\///;
  return sub {
    my $respond = shift;
    http_get $url, sub {
      my ($data, $headers) = @_;
      my $res = $req->new_response($headers->{Status});
      $res->headers($headers);
      $res->body($data);
      $respond->($res->finalize);
    };
  }
}

sub broadcast {
  my ($self, @data) = @_;
  return if $self->no_streams or !@data;
  my $purge = 0;
  for my $stream ($self->streams) {
    try {
      $stream->send(@data);
    } catch {
      $stream->close;
      $purge = 1;
    };
  }
  $self->purge_disconnects if $purge;
};

sub setup_stream {
  my ($self, $req) = @_;
  $self->app->log(info => "opening new stream");
  my $min = $req->param('msgid') || 0;
  return sub {
    my $respond = shift;
    my $stream = App::Alice::Stream->new(
      queue      => [ map({$_->join_action} $self->app->windows) ],
      writer     => $respond,
      start_time => $req->param('t'),
      # android requires 4K updates to trigger loading event
      min_bytes  => $req->user_agent =~ /android/i ? 4096 : 0,
    );
    $self->add_stream($stream);
    $self->app->with_messages(sub {
      return unless @_;
      $stream->enqueue(
        map  {$_->{buffered} = 1; $_}
        grep {$_->{msgid} > $min}
        @_
      );
      $stream->send;
    });
  }
}

sub purge_disconnects {
  my ($self) = @_;
  $self->app->log(debug => "removing broken streams");
  $self->streams([grep {!$_->closed} $self->streams]);
}

sub handle_message {
  my ($self, $req) = @_;
  my $msg  = $req->param('msg');
  my $is_html = $req->param('html');
  utf8::decode($msg) unless utf8::is_utf8($msg);
  $msg = html_to_irc($msg) if $is_html;
  my $source = $req->param('source');
  my $window = $self->app->get_window($source);
  if ($window) {
    for (split /\n/, $msg) {
      try {
        $self->app->handle_command($_, $window) if length $_
      } catch {
        $self->app->log(info => $_);
      }
    }
  }
  my $res = $req->new_response(200);
  $res->content_type('text/plain');
  $res->content_length(2);
  $res->body('ok');
  return $res->finalize;
}

sub send_index {
  my ($self, $req) = @_;
  return sub {
    my $respond = shift;
    my $writer = $respond->([200, ["Content-type" => "text/html; charset=utf-8"]]);
    my @windows = $self->app->sorted_windows;
    @windows > 1 ? $windows[1]->{active} = 1 : $windows[0]->{active} = 1;
    $writer->write(encode_utf8 $self->app->render('index_head', @windows));
    $self->send_windows($writer, sub {
      $writer->write(encode_utf8 $self->app->render('index_footer', @windows));
      $writer->close;
      delete $_->{active} for @windows;
    }, @windows);
  }
}

sub send_windows {
  my ($self, $writer, $cb, @windows) = @_;
  if (!@windows) {
    $cb->();
  }
  else {
    my $window = pop @windows;
    $writer->write(encode_utf8 $self->app->render('window_head', $window));
    $window->buffer->with_messages(sub {
      my @messages = @_;
      $writer->write(encode_utf8 $_->{html}) for @messages;
    }, 0, sub {
      $writer->write(encode_utf8 $self->app->render('window_footer', $window));
      $self->send_windows($writer, $cb, @windows);
    });
  }    
}

sub send_logs {
  my ($self, $req) = @_;
  my $output = $self->app->render('logs');
  my $res = $req->new_response(200);
  $res->body(encode_utf8 $output);
  return $res->finalize;
}

sub send_search {
  my ($self, $req) = @_;
  return sub {
    my $respond = shift;
    $self->app->history->search(
      user => $self->app->user, %{$req->parameters}, sub {
      my $rows = shift;
      my $content = $self->app->render('results', $rows);
      my $res = $req->new_response(200);
      $res->body(encode_utf8 $content);
      $respond->($res->finalize);
    });
  }
}

sub send_range {
  my ($self, $req) = @_;
  return sub {
    my $respond = shift;
    $self->app->history->range(
      $self->app->user, $req->param('channel'), $req->param('id'), sub {
        my ($before, $after) = @_;
        $before = $self->app->render('range', $before, 'before');
        $after = $self->app->render('range', $after, 'after');
        my $res = $req->new_response(200);
        $res->body(to_json [$before, $after]);
        $respond->($res->finalize);
      }
    ); 
  }
}

sub send_config {
  my ($self, $req) = @_;
  $self->app->log(info => "serving config");
  my $output = $self->app->render('servers');
  my $res = $req->new_response(200);
  $res->body($output);
  return $res->finalize;
}

sub send_prefs {
  my ($self, $req) = @_;
  $self->app->log(info => "serving prefs");
  my $output = $self->app->render('prefs');
  my $res = $req->new_response(200);
  $res->body($output);
  return $res->finalize;
}

sub server_config {
  my ($self, $req) = @_;
  $self->app->log(info => "serving blank server config");
  
  my $name = $req->param('name');
  $name =~ s/\s+//g;
  my $config = $self->app->render('new_server', $name);
  my $listitem = $self->app->render('server_listitem', $name);
  
  my $res = $req->new_response(200);
  $res->body(to_json({config => $config, listitem => $listitem}));
  $res->header("Cache-control" => "no-cache");
  return $res->finalize;
}

sub save_config {
  my ($self, $req) = @_;
  $self->app->log(info => "saving config");
  
  my $new_config = {};
  if ($req->parameters->{has_servers}) {
    $new_config->{servers} = {};
  }
  for my $name (keys %{$req->parameters}) {
    next unless $req->parameters->{$name};
    next if $name eq "has_servers";
    if ($name =~ /^(.+?)_(.+)/ and exists $new_config->{servers}) {
      if ($2 eq "channels" or $2 eq "on_connect") {
        $new_config->{servers}{$1}{$2} = [$req->parameters->get_all($name)];
      } else {
        $new_config->{servers}{$1}{$2} = $req->param($name);
      }
    }
    elsif ($name eq "highlights") {
      $new_config->{$name} = [$req->parameters->get_all($name)];
    }
    else {
      $new_config->{$name} = $req->param($name);
    }
  }
  $self->app->reload_config($new_config);

  $self->app->broadcast(
    $self->app->format_info("config", "saved")
  );

  my $res = $req->new_response(200);
  $res->content_type('text/plain');
  $res->content_length(2);
  $res->body('ok');
  return $res->finalize;
}

sub tab_order  {
  my ($self, $req) = @_;
  $self->app->log(debug => "updating tab order");
  
  $self->app->tab_order([grep {defined $_} $req->parameters->get_all('tabs')]);
  my $res = $req->new_response(200);
  $res->content_type('text/plain');
  $res->content_length(2);
  $res->body('ok');
  return $res->finalize;
}

sub not_found  {
  my ($self, $req) = @_;
  $self->app->log(debug => "sending 404 " . $req->path_info);
  my $res = $req->new_response(404);
  return $res->finalize;
}

__PACKAGE__->meta->make_immutable;
1;
