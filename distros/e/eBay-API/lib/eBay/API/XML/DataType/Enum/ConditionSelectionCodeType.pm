#!/usr/bin/perl

package eBay::API::XML::DataType::Enum::ConditionSelectionCodeType;

use strict;
use warnings;  

##########################################################################
#
# Module: ............... <user defined location>eBay/API/XML
# File: ................. ConditionSelectionCodeType.pm
# Generated by: ......... genEBayApiDataTypes.pl
# Last Generated: ....... 07/07/2008 17:42
# API Release Number: ... 571
#
##########################################################################  

=head1 NAME

eBay::API::XML::DataType::Enum::ConditionSelectionCodeType

=head1 DESCRIPTION

Filter that retrieves only items with the specified item conditon.



=head1 SYNOPSIS

=cut



=head1 Enums:

=cut


=head2 All

(in) Retrieve all items that match the query, regardless of condition.



=cut


use constant All => scalar('All');


=head2 New

(in) Only retrieve items that are listed as new (or the equivalent).
That is, do not retrieve used or refurbished items (or the equivalent).
New is the default setting. (Items that waive the Item Condition requirement
are also returned with this setting. If necessary, you can use GetCategoryFeatures to determine
which categories waive the Item Condition requirement.)



=cut


use constant New => scalar('New');


=head2 CustomCode

(out) Reserved for internal or future use.



=cut


use constant CustomCode => scalar('CustomCode');







1;   
