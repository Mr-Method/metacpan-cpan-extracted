package AsposeWordsCloud::Object::PageNumber;

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

use base "AsposeWordsCloud::Object::BaseObject";

#
#
#
#NOTE: This class is auto generated by the swagger code generator program. Do not edit the class manually.
#

my $swagger_types = {
    'Format' => 'string',
    'Alignment' => 'string',
    'IsTop' => 'boolean',
    'SetPageNumberOnFirstPage' => 'boolean'
};

my $attribute_map = {
    'Format' => 'Format',
    'Alignment' => 'Alignment',
    'IsTop' => 'IsTop',
    'SetPageNumberOnFirstPage' => 'SetPageNumberOnFirstPage'
};

# new object
sub new { 
    my ($class, %args) = @_; 
    my $self = { 
        #
        'Format' => $args{'Format'}, 
        #
        'Alignment' => $args{'Alignment'}, 
        #
        'IsTop' => $args{'IsTop'}, 
        #
        'SetPageNumberOnFirstPage' => $args{'SetPageNumberOnFirstPage'}
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
