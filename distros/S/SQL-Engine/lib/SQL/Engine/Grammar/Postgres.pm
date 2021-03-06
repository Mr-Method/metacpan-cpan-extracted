package SQL::Engine::Grammar::Postgres;

use 5.014;

use strict;
use warnings;

use registry;
use routines;

use Data::Object::Class;

extends 'SQL::Engine::Grammar';

our $VERSION = '0.03'; # VERSION

# METHODS

method column_change(HashRef $data) {
  $self->operation($self->term(qw(begin transaction)));

  my $def = $self->column_definition($data->{column});

  # column type
  $self->operation(do {
    my $sql = [];

    # alter table
    push @$sql, $self->term(qw(alter table));

    # safe
    push @$sql, $self->term(qw(if exists)) if $data->{safe};

    # for
    push @$sql, $self->table($data->{for});

    # alter column
    push @$sql, $self->term('alter');

    # column name
    push @$sql, $self->name($data->{column}{name});

    # column tyoe
    push @$sql, $self->term('type'), $def->{type};

    # sql statement
    join ' ', @$sql
  });

  # column nullable
  if (exists $data->{column}{nullable}) {
    $self->operation(do {
        my $sql = [];

        # alter table
        push @$sql, $self->term(qw(alter table));

        # safe
        push @$sql, $self->term(qw(if exists)) if $data->{safe};

        # for
        push @$sql, $self->table($data->{for});

        # alter column
        push @$sql, $self->term('alter');

        # column name
        push @$sql, $self->name($data->{column}{name});

        # column (set | drop) not null
        push @$sql,
          $data->{column}{nullable}
          ? ($self->term('drop'), $self->term(qw(not null)))
          : ($self->term('set'), $self->term(qw(not null)));

        # sql statement
        join ' ', @$sql
      });
  }

  # column default
  $self->operation(do {
    my $sql = [];

    # alter table
    push @$sql, $self->term(qw(alter table));

    # safe
    push @$sql, $self->term(qw(if exists)) if $data->{safe};

    # for
    push @$sql, $self->table($data->{for});

    # alter column
    push @$sql, $self->term('alter');

    # column name
    push @$sql, $self->name($data->{column}{name});

    # column (set | drop) default
    push @$sql,
      $data->{column}{default}
      ? ($self->term('set'), $def->{default})
      : ($self->term('drop'), $self->term('default'));

    # sql statement
    join ' ', @$sql
  });

  $self->operation($self->term('commit'));

  return $self;
}

method transaction(HashRef $data) {
  my @mode;
  if ($data->{mode}) {
    @mode = map $self->term($_), @{$data->{mode}};
  }
  $self->operation($self->term('begin', 'transaction', @mode));
  $self->process($_) for @{$data->{queries}};
  $self->operation($self->term('commit'));

  return $self;
}

method type_binary(HashRef $data) {

  return 'bytea';
}

method type_boolean(HashRef $data) {

  return 'boolean';
}

method type_char(HashRef $data) {
  my $options = $data->{options} || [];

  return sprintf('char(%s)', $self->value($options->[0] || 1));
}

method type_date(HashRef $data) {

  return 'date';
}

method type_datetime(HashRef $data) {

  return 'timestamp(0) without time zone';
}

method type_datetime_wtz(HashRef $data) {

  return 'timestamp(0) with time zone';
}

method type_decimal(HashRef $data) {
  my $options = $data->{options} || [];

  return sprintf(
    'decimal(%s)',
    join(', ',
      $self->value($options->[0]) || 5,
      $self->value($options->[1]) || 2)
  );
}

method type_double(HashRef $data) {

  return 'double precision';
}

method type_enum(HashRef $data) {
  my $column = $data->{name};
  my $options = $data->{options};

  return sprintf('varchar(225) check (%s in (%s))',
    $column, join(', ', map $self->value($_), @$options));
}

method type_float(HashRef $data) {

  return 'double precision';
}

method type_integer(HashRef $data) {

  return $data->{increment} ? 'serial' : 'integer';
}

method type_integer_big(HashRef $data) {

  return $data->{increment} ? 'bigserial' : 'bigint';
}

method type_integer_big_unsigned(HashRef $data) {

  return $self->type_integer_big($data);
}

method type_integer_medium(HashRef $data) {

  return $data->{increment} ? 'serial' : 'integer';
}

method type_integer_medium_unsigned(HashRef $data) {

  return $self->type_integer_medium($data);
}

method type_integer_small(HashRef $data) {

  return $data->{increment} ? 'smallserial' : 'smallint';
}

method type_integer_small_unsigned(HashRef $data) {

  return $self->type_integer_small($data);
}

method type_integer_tiny(HashRef $data) {

  return $data->{increment} ? 'smallserial' : 'smallint';
}

method type_integer_tiny_unsigned(HashRef $data) {

  return $self->type_integer_tiny($data);
}

method type_integer_unsigned(HashRef $data) {

  return $self->type_integer($data);
}

method type_json(HashRef $data) {

  return 'json';
}

method type_number(HashRef $data) {

  return $self->type_integer($data);
}

method type_string(HashRef $data) {
  my $options = $data->{options} || [];

  return sprintf('varchar(%s)', $options->[0] || 255);
}

method type_text(HashRef $data) {

  return 'text';
}

method type_text_long(HashRef $data) {

  return 'text';
}

method type_text_medium(HashRef $data) {

  return 'text';
}

method type_time(HashRef $data) {

  return 'time(0) without time zone';
}

method type_time_wtz(HashRef $data) {

  return 'time(0) with time zone';
}

method type_timestamp(HashRef $data) {

  return 'timestamp(0) without time zone';
}

method type_timestamp_wtz(HashRef $data) {

  return 'timestamp(0) with time zone';
}

method type_uuid(HashRef $data) {

  return 'uuid';
}

method wrap(Str $name) {

  return qq("$name");
}

1;

=encoding utf8

=head1 NAME

SQL::Engine::Grammar::Postgres - Grammar For PostgreSQL

=cut

=head1 ABSTRACT

SQL::Engine Grammar For PostgreSQL

=cut

=head1 SYNOPSIS

  use SQL::Engine::Grammar::Postgres;

  my $grammar = SQL::Engine::Grammar::Postgres->new(
    schema => {
      select => {
        from => {
          table => 'users'
        },
        columns => [
          {
            column => '*'
          }
        ]
      }
    }
  );

  # $grammar->execute;

=cut

=head1 DESCRIPTION

This package provides methods for converting
L<json-sql|https://github.com/iamalnewkirk/json-sql> data structures into
PostgreSQL statements.

=cut

=head1 INHERITS

This package inherits behaviors from:

L<SQL::Engine::Grammar>

=cut

=head1 LIBRARIES

This package uses type constraints from:

L<Types::Standard>

=cut

=head1 METHODS

This package implements the following methods:

=cut

=head2 column_change

  column_change(HashRef $data) : Object

The column_change method generates SQL statements to change a column
definition.

=over 4

=item column_change example #1

  my $grammar = SQL::Engine::Grammar::Postgres->new(
    schema => {
      'column-change' => {
        for => {
          table => 'users'
        },
        column => {
          name => 'accessed',
          type => 'datetime',
          nullable => 1
        }
      }
    }
  );

  $grammar->column_change($grammar->schema->{'column-change'});

=back

=cut

=head2 transaction

  transaction(HashRef $data) : Object

The transaction method generates SQL statements to commit an atomic database
transaction.

=over 4

=item transaction example #1

  my $grammar = SQL::Engine::Grammar::Postgres->new(
    schema => {
      'transaction' => {
        queries => [
          {
            'table-create' => {
              name => 'users',
              columns => [
                {
                  name => 'id',
                  type => 'integer',
                  primary => 1
                }
              ]
            }
          }
        ]
      }
    }
  );

  $grammar->transaction($grammar->schema->{'transaction'});

=back

=cut

=head2 type_binary

  type_binary(HashRef $data) : Str

The type_binary method returns the SQL expression representing a binary data
type.

=over 4

=item type_binary example #1

  # given: synopsis

  $grammar->type_binary({});

  # bytea

=back

=cut

=head2 type_boolean

  type_boolean(HashRef $data) : Str

The type_boolean method returns the SQL expression representing a boolean data type.

=over 4

=item type_boolean example #1

  # given: synopsis

  $grammar->type_boolean({});

  # boolean

=back

=cut

=head2 type_char

  type_char(HashRef $data) : Str

The type_char method returns the SQL expression representing a char data type.

=over 4

=item type_char example #1

  # given: synopsis

  $grammar->type_char({});

  # char(1)

=back

=cut

=head2 type_date

  type_date(HashRef $data) : Str

The type_date method returns the SQL expression representing a date data type.

=over 4

=item type_date example #1

  # given: synopsis

  $grammar->type_date({});

  # date

=back

=cut

=head2 type_datetime

  type_datetime(HashRef $data) : Str

The type_datetime method returns the SQL expression representing a datetime
data type.

=over 4

=item type_datetime example #1

  # given: synopsis

  $grammar->type_datetime({});

  # timestamp(0) without time zone

=back

=cut

=head2 type_datetime_wtz

  type_datetime_wtz(HashRef $data) : Str

The type_datetime_wtz method returns the SQL expression representing a datetime
(and timezone) data type.

=over 4

=item type_datetime_wtz example #1

  # given: synopsis

  $grammar->type_datetime_wtz({});

  # timestamp(0) with time zone

=back

=cut

=head2 type_decimal

  type_decimal(HashRef $data) : Str

The type_decimal method returns the SQL expression representing a decimal data
type.

=over 4

=item type_decimal example #1

  # given: synopsis

  $grammar->type_decimal({});

  # decimal(NULL, NULL)

=back

=cut

=head2 type_double

  type_double(HashRef $data) : Str

The type_double method returns the SQL expression representing a double data
type.

=over 4

=item type_double example #1

  # given: synopsis

  $grammar->type_double({});

  # double precision

=back

=cut

=head2 type_enum

  type_enum(HashRef $data) : Str

The type_enum method returns the SQL expression representing a enum data type.

=over 4

=item type_enum example #1

  # given: synopsis

  $grammar->type_enum({ name => 'theme', options => ['light', 'dark'] });

  # varchar(225) check ("theme" in ('light', 'dark'))

=back

=cut

=head2 type_float

  type_float(HashRef $data) : Str

The type_float method returns the SQL expression representing a float data
type.

=over 4

=item type_float example #1

  # given: synopsis

  $grammar->type_float({});

  # double precision

=back

=cut

=head2 type_integer

  type_integer(HashRef $data) : Str

The type_integer method returns the SQL expression representing a integer data
type.

=over 4

=item type_integer example #1

  # given: synopsis

  $grammar->type_integer({});

  # integer

=back

=cut

=head2 type_integer_big

  type_integer_big(HashRef $data) : Str

The type_integer_big method returns the SQL expression representing a
big-integer data type.

=over 4

=item type_integer_big example #1

  # given: synopsis

  $grammar->type_integer_big({});

  # bigint

=back

=cut

=head2 type_integer_big_unsigned

  type_integer_big_unsigned(HashRef $data) : Str

The type_integer_big_unsigned method returns the SQL expression representing a
big unsigned integer data type.

=over 4

=item type_integer_big_unsigned example #1

  # given: synopsis

  $grammar->type_integer_big_unsigned({});

  # bigint

=back

=cut

=head2 type_integer_medium

  type_integer_medium(HashRef $data) : Str

The type_integer_medium method returns the SQL expression representing a medium
integer data type.

=over 4

=item type_integer_medium example #1

  # given: synopsis

  $grammar->type_integer_medium({});

  # integer

=back

=cut

=head2 type_integer_medium_unsigned

  type_integer_medium_unsigned(HashRef $data) : Str

The type_integer_medium_unsigned method returns the SQL expression representing
a unsigned medium integer data type.

=over 4

=item type_integer_medium_unsigned example #1

  # given: synopsis

  $grammar->type_integer_medium_unsigned({});

  # integer

=back

=cut

=head2 type_integer_small

  type_integer_small(HashRef $data) : Str

The type_integer_small method returns the SQL expression representing a small
integer data type.

=over 4

=item type_integer_small example #1

  # given: synopsis

  $grammar->type_integer_small({});

  # smallint

=back

=cut

=head2 type_integer_small_unsigned

  type_integer_small_unsigned(HashRef $data) : Str

The type_integer_small_unsigned method returns the SQL expression representing
a unsigned small integer data type.

=over 4

=item type_integer_small_unsigned example #1

  # given: synopsis

  $grammar->type_integer_small_unsigned({});

  # smallint

=back

=cut

=head2 type_integer_tiny

  type_integer_tiny(HashRef $data) : Str

The type_integer_tiny method returns the SQL expression representing a tiny
integer data type.

=over 4

=item type_integer_tiny example #1

  # given: synopsis

  $grammar->type_integer_tiny({});

  # smallint

=back

=cut

=head2 type_integer_tiny_unsigned

  type_integer_tiny_unsigned(HashRef $data) : Str

The type_integer_tiny_unsigned method returns the SQL expression representing a
unsigned tiny integer data type.

=over 4

=item type_integer_tiny_unsigned example #1

  # given: synopsis

  $grammar->type_integer_tiny_unsigned({});

  # smallint

=back

=cut

=head2 type_integer_unsigned

  type_integer_unsigned(HashRef $data) : Str

The type_integer_unsigned method returns the SQL expression representing a
unsigned integer data type.

=over 4

=item type_integer_unsigned example #1

  # given: synopsis

  $grammar->type_integer_unsigned({});

  # integer

=back

=cut

=head2 type_json

  type_json(HashRef $data) : Str

The type_json method returns the SQL expression representing a json data type.

=over 4

=item type_json example #1

  # given: synopsis

  $grammar->type_json({});

  # json

=back

=cut

=head2 type_number

  type_number(HashRef $data) : Str

The type_number method returns the SQL expression representing a number data
type.

=over 4

=item type_number example #1

  # given: synopsis

  $grammar->type_number({});

  # integer

=back

=cut

=head2 type_string

  type_string(HashRef $data) : Str

The type_string method returns the SQL expression representing a string data
type.

=over 4

=item type_string example #1

  # given: synopsis

  $grammar->type_string({});

  # varchar(255)

=back

=cut

=head2 type_text

  type_text(HashRef $data) : Str

The type_text method returns the SQL expression representing a text data type.

=over 4

=item type_text example #1

  # given: synopsis

  $grammar->type_text({});

  # text

=back

=cut

=head2 type_text_long

  type_text_long(HashRef $data) : Str

The type_text_long method returns the SQL expression representing a long text
data type.

=over 4

=item type_text_long example #1

  # given: synopsis

  $grammar->type_text_long({});

  # text

=back

=cut

=head2 type_text_medium

  type_text_medium(HashRef $data) : Str

The type_text_medium method returns the SQL expression representing a medium
text data type.

=over 4

=item type_text_medium example #1

  # given: synopsis

  $grammar->type_text_medium({});

  # text

=back

=cut

=head2 type_time

  type_time(HashRef $data) : Str

The type_time method returns the SQL expression representing a time data type.

=over 4

=item type_time example #1

  # given: synopsis

  $grammar->type_time({});

  # time(0) without time zone

=back

=cut

=head2 type_time_wtz

  type_time_wtz(HashRef $data) : Str

The type_time_wtz method returns the SQL expression representing a time (and
timezone) data type.

=over 4

=item type_time_wtz example #1

  # given: synopsis

  $grammar->type_time_wtz({});

  # time(0) with time zone

=back

=cut

=head2 type_timestamp

  type_timestamp(HashRef $data) : Str

The type_timestamp method returns the SQL expression representing a timestamp
data type.

=over 4

=item type_timestamp example #1

  # given: synopsis

  $grammar->type_timestamp({});

  # timestamp(0) without time zone

=back

=cut

=head2 type_timestamp_wtz

  type_timestamp_wtz(HashRef $data) : Str

The type_timestamp_wtz method returns the SQL expression representing a
timestamp (and timezone) data type.

=over 4

=item type_timestamp_wtz example #1

  # given: synopsis

  $grammar->type_timestamp_wtz({});

  # timestamp(0) with time zone

=back

=cut

=head2 type_uuid

  type_uuid(HashRef $data) : Str

The type_uuid method returns the SQL expression representing a uuid data type.

=over 4

=item type_uuid example #1

  # given: synopsis

  $grammar->type_uuid({});

  # uuid

=back

=cut

=head2 wrap

  wrap(Str $name) : Str

The wrap method returns a SQL-escaped string.

=over 4

=item wrap example #1

  # given: synopsis

  $grammar->wrap('field');

  # "field"

=back

=cut

=head1 AUTHOR

Al Newkirk, C<awncorp@cpan.org>

=head1 LICENSE

Copyright (C) 2011-2019, Al Newkirk, et al.

This is free software; you can redistribute it and/or modify it under the terms
of the The Apache License, Version 2.0, as elucidated in the L<"license
file"|https://github.com/iamalnewkirk/sql-engine/blob/master/LICENSE>.

=head1 PROJECT

L<Wiki|https://github.com/iamalnewkirk/sql-engine/wiki>

L<Project|https://github.com/iamalnewkirk/sql-engine>

L<Initiatives|https://github.com/iamalnewkirk/sql-engine/projects>

L<Milestones|https://github.com/iamalnewkirk/sql-engine/milestones>

L<Contributing|https://github.com/iamalnewkirk/sql-engine/blob/master/CONTRIBUTE.md>

L<Issues|https://github.com/iamalnewkirk/sql-engine/issues>

=cut