#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'CPAN-Mini-Inject-REST';
all_from 'lib/CPAN/Mini/Inject/REST.pm';

requires 'Catalyst::Runtime' => '5.80030';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Controller::REST';
requires 'JSON';
requires 'Catalyst::Action::Serialize::JSON';
requires 'Archive::Extract';
requires 'CPAN::Mini::Inject';
requires 'File::Find::Rule';
requires 'List::MoreUtils';
requires 'Parse::CPAN::Meta';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Try::Tiny';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
