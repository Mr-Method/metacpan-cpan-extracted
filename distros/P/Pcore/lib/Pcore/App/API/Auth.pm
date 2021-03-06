package Pcore::App::API::Auth;

use Pcore -class, -res;
use Pcore::App::API::Const qw[:PERMS];
use Pcore::Util::Scalar qw[is_res is_plain_arrayref];

use overload    #
  q[bool] => sub {
    return $_[0]->{is_authenticated};
  },
  fallback => undef;

has api              => ( required => 1 );    # ConsumerOf ['Pcore::App::API']
has is_authenticated => ( required => 1 );    # Bool
has private_token => ();                      # Maybe [ArrayRef]
has user_id       => ();                      # Maybe [Str]
has user_name     => ();                      # Maybe [Str]
has permissions   => ();                      # Maybe [HashRef]

*TO_JSON = *TO_CBOR = sub ($self) {
    return { $self->%{qw[is_authenticated user_id user_name permissions]} };
};

sub TO_DUMP ( $self, $dumper, %args ) {
    my $tags;

    my $res;

    my %attrs = $self->%*;

    delete $attrs{api};

    $res .= $dumper->_dump( \%attrs, path => $args{path} );

    return $res, $tags;
}

sub is_root ($self) {
    return $self->{api}->user_is_root( $self->{user_id} // $EMPTY );
}

sub api_can_call ( $self, $method_id ) {
    $method_id =~ tr /-/_/;

    return $self->_api_can_call($method_id);
}

sub api_call ( $self, $method_id, @args ) {
    $method_id =~ tr /-/_/;

    my $can_call = $self->_api_can_call($method_id);

    return $can_call if !$can_call;

    my $api = $self->{api};

    # get method
    my $method_cfg = $api->{router}->{method}->{$method_id};

    my $obj = $api->{router}->{obj}->{ $method_cfg->{class_name} };

    my $method_name = $method_cfg->{local_method_name};

    my @res = eval { $obj->$method_name( $self, @args ) };

    # API method eval error
    if ($@) {
        $@->sendlog;

        return res 500;
    }

    # API method didn't returned valid response
    elsif ( !@res ) {
        return res 500;
    }
    else {
        return is_res $res[0] ? $res[0] : res @res;
    }
}

sub _api_can_call ( $self, $method_id ) {
    if ( $self->{is_authenticated} ) {
        my $auth = $self->{api}->authenticate( $self->{private_token} );

        return $auth->_check_permissions($method_id);
    }
    else {
        return $self->_check_permissions($method_id);
    }
}

sub _check_permissions ( $self, $method_id ) {

    # find method
    my $method_cfg = $self->{api}->{router}->{method}->{$method_id};

    # method wasn't found
    return res [ 404, 'Method was not found' ] if !$method_cfg;

    # method was found
    my $method_permissions = $method_cfg->{permissions};

    # method has no permissions, authorization is not required
    return res 200 if !$method_permissions;

    if ( is_plain_arrayref $method_permissions) {

        # compare permissions for authenticated session only
        if ( $self->{is_authenticated} ) {
            my $auth_permissions = $self->{permissions};

            # compare permissions
            for my $permission ( $method_permissions->@* ) {
                return res 200 if $auth_permissions->{$permission};
            }
        }
    }
    else {
        return res 200 if $method_permissions eq $PERMS_AUTHENTICATED && $self->{is_authenticated};
    }

    return res [ 403, 'Insufficient permissions' ];
}

1;
__END__
=pod

=encoding utf8

=head1 NAME

Pcore::App::API::Auth

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 METHODS

=head1 SEE ALSO

=cut
