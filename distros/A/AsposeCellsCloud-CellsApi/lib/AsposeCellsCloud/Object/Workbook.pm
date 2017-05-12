package AsposeCellsCloud::Object::Workbook;

require 5.6.0;
use strict;
use warnings;
use utf8;
use JSON qw(decode_json);
use Data::Dumper;
use Module::Runtime qw(use_module);
use Log::Any qw($log);
use Date::Parse;
use DateTime;

use base "AsposeCellsCloud::Object::BaseObject";

#
#
#
#NOTE: This class is auto generated by the swagger code generator program. Do not edit the class manually.
#

my $swagger_types = {
    'FileName' => 'string',
    'Links' => 'ARRAY[Link]',
    'Worksheets' => 'LinkElement',
    'DefaultStyle' => 'LinkElement',
    'DocumentProperties' => 'LinkElement',
    'Names' => 'LinkElement',
    'Settings' => 'LinkElement',
    'IsWriteProtected' => 'string',
    'IsProtected' => 'string',
    'IsEncryption' => 'string',
    'Password' => 'string'
};

my $attribute_map = {
    'FileName' => 'FileName',
    'Links' => 'Links',
    'Worksheets' => 'Worksheets',
    'DefaultStyle' => 'DefaultStyle',
    'DocumentProperties' => 'DocumentProperties',
    'Names' => 'Names',
    'Settings' => 'Settings',
    'IsWriteProtected' => 'IsWriteProtected',
    'IsProtected' => 'IsProtected',
    'IsEncryption' => 'IsEncryption',
    'Password' => 'Password'
};

# new object
sub new { 
    my ($class, %args) = @_; 
    my $self = { 
        #
        'FileName' => $args{'FileName'}, 
        #
        'Links' => $args{'Links'}, 
        #
        'Worksheets' => $args{'Worksheets'}, 
        #
        'DefaultStyle' => $args{'DefaultStyle'}, 
        #
        'DocumentProperties' => $args{'DocumentProperties'}, 
        #
        'Names' => $args{'Names'}, 
        #
        'Settings' => $args{'Settings'}, 
        #
        'IsWriteProtected' => $args{'IsWriteProtected'}, 
        #
        'IsProtected' => $args{'IsProtected'}, 
        #
        'IsEncryption' => $args{'IsEncryption'}, 
        #
        'Password' => $args{'Password'}
    }; 

    return bless $self, $class; 
}  

# get swagger type of the attribute
sub get_swagger_types {
    return $swagger_types;
}

# get attribute mappping
sub get_attribute_map {
    return $attribute_map;
}

1;
