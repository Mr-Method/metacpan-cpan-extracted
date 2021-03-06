#!/usr/bin/env perl

package Prty::File::Image::Test;
use base qw/Prty::Test::Class/;

use strict;
use warnings;
use v5.10.0;

# -----------------------------------------------------------------------------

sub test_loadClass : Init(1) {
    shift->useOk('Prty::File::Image');
}

# -----------------------------------------------------------------------------

sub test_unitTest : Test(7) {
    my $self = shift;

    my $file = $self->testPath('t/data/image/test001.jpg');
    my $img = Prty::File::Image->new($file);
    $self->is(ref($img),'Prty::File::Image');

    my $width = $img->width;
    $self->is($width=>640);

    my $height = $img->height;
    $self->is($height=>360);

    ($width,$height) = $img->size;
    $self->is($width=>640);
    $self->is($height=>360);

    my $aspectRatio = $img->aspectRatio;
    $self->is($aspectRatio=>'16:9');

    my $type = $img->type;
    $self->is($type=>'jpg');
}

# -----------------------------------------------------------------------------

sub test_scaleFactor : Test(1) {
    my $self = shift;

    my $file = $self->testPath('t/data/image/test001.jpg');
    my $img = Prty::File::Image->new($file);
    my $scale = $img->scaleFactor(320,180);
    $self->floatIs($scale,0.5);
}

# -----------------------------------------------------------------------------

sub test_property : Test(4) {
    my $self = shift;

    my $file = $self->testPath('t/data/image/test001.jpg');
    my $img = Prty::File::Image->new($file);
    $self->is(ref($img),'Prty::File::Image');

    my $prop = $img->property;
    $self->is(ref($prop),'Prty::Hash');

    $img->property->set(sizeFill=>[1440,1080]);
    my ($width,$height) = $img->property->getArray('sizeFill');
    $self->is($width,1440);
    $self->is($height,1080);
}

# -----------------------------------------------------------------------------

package main;
Prty::File::Image::Test->runTests;

# eof
