use Test::More tests => 3;


# build the testing class
package Person;
use Storm::Object;
storm_table( 'People' );

use MooseX::Types::Moose qw( Int );

has 'identifier' => ( is => 'rw', traits => [qw( PrimaryKey )] );
has 'first_name' => ( is => 'rw' );
has 'last_name' => ( is => 'rw' );
has 'age' => ( is => 'rw', isa => Int );


# run the tests
package main;

use_ok 'StormX::Query::DeleteWhere';

use Storm;
my $storm = Storm->new( source => ['DBI:SQLite:dbname=:memory:'] );
$storm->aeolus->install_class( 'Person' );

my @test_info = (
    [qw/Marge  Simpson  38/],
    [qw/Maggie Simpson   1/],
    [qw/Homer  Simpson  40/],
    [qw/Lisa   Simpson   8/],
    [qw/Bart   Simpson  10/],
    [qw/Ned    Flanders 43/],
    [qw/Maude  Flanders 28/],
    [qw/Todd   Flanders  9/],
    [qw/Rod    Flanders  9/],
);

# build test objects

my $x = 1;
for (@test_info) {
    my %info; @info{qw/first_name last_name age/} = @{$_};
    $info{identifier} = $x++;
    $storm->insert( Person->new(%info) );
}


{ # with place holder
    my $q = StormX::Query::DeleteWhere->new( $storm, 'Person' );
    $q->where( qw[.last_name = ?] );
    $q->delete( 'Flanders' );
    
    my @results = $storm->select('Person')->results->all;
    is scalar (@results), 5, 'delete where succssful';
}

{ # delete all
    StormX::Query::DeleteWhere->new( $storm, 'Person', safe_mode => 0  )->delete;
    
    my @results = $storm->select('Person')->results->all;
    is scalar (@results), 0, 'delete all successful';
}

