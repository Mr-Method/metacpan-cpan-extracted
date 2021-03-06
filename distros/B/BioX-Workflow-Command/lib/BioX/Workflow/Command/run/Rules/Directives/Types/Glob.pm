package BioX::Workflow::Command::run::Rules::Directives::Types::Glob;

use Moose::Role;
use namespace::autoclean;

use File::Glob;

after 'BUILD' => sub {
    my $self = shift;

    $self->set_register_types(
        'glob',
        {
            builder => 'create_reg_attr',
            lookup  => ['.*_glob$']
        }
    );

    $self->set_register_process_directives( 'glob',
        { builder => 'process_directive_glob', lookup => ['.*_glob$'] } );
};

sub process_directive_glob {
    my $self = shift;
    my $k    = shift;
    my $v    = shift;

    return if $k eq 'sample_glob';

    my $text = $self->interpol_directive($v);
    my @data = glob($text);
    $self->$k( \@data );
}

no Moose;

1;
