package AsposeTasksCloud::Object::Resource;

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

use base "AsposeTasksCloud::Object::BaseObject";

#
#
#
#NOTE: This class is auto generated by the swagger code generator program. Do not edit the class manually.
#

my $swagger_types = {
    'Name' => 'string',
    'Uid' => 'int',
    'Id' => 'int',
    'Type' => 'ResourceType',
    'IsNull' => 'boolean',
    'Initials' => 'string',
    'Phonetics' => 'string',
    'NtAccount' => 'string',
    'MaterialLabel' => 'string',
    'Code' => 'string',
    'Group' => 'string',
    'EMailAddress' => 'string',
    'EmailAddress' => 'string',
    'Hyperlink' => 'string',
    'HyperlinkAddress' => 'string',
    'HyperlinkSubAddress' => 'string',
    'MaxUnits' => 'double',
    'PeakUnits' => 'double',
    'Overallocated' => 'boolean',
    'OverAllocated' => 'boolean',
    'AvailableFrom' => 'string',
    'AvailableTo' => 'string',
    'Start' => 'string',
    'Finish' => 'string',
    'CanLevel' => 'boolean',
    'AccrueAt' => 'CostAccrualType',
    'Work' => 'string',
    'WorkString' => 'string',
    'RegularWork' => 'string',
    'RegularWorkString' => 'string',
    'OvertimeWork' => 'string',
    'OvertimeWorkString' => 'string',
    'ActualWork' => 'string',
    'ActualWorkString' => 'string',
    'RemainingWork' => 'string',
    'RemainingWorkString' => 'string',
    'ActualOvertimeWork' => 'string',
    'ActualOvertimeWorkString' => 'string',
    'RemainingOvertimeWork' => 'string',
    'RemainingOvertimeWorkString' => 'string',
    'PercentWorkComplete' => 'int',
    'StandardRate' => 'double',
    'StandardRateFormat' => 'RateFormatType',
    'Cost' => 'double',
    'OvertimeRateFormat' => 'RateFormatType',
    'OvertimeCost' => 'double',
    'CostPerUse' => 'double',
    'ActualCost' => 'double',
    'ActualOvertimeCost' => 'double',
    'RemainingCost' => 'double',
    'RemainingOvertimeCost' => 'double',
    'WorkVariance' => 'double',
    'CostVariance' => 'double',
    'Sv' => 'double',
    'SV' => 'double',
    'Cv' => 'double',
    'CV' => 'double',
    'Acwp' => 'double',
    'ACWP' => 'double',
    'CalendarUid' => 'int',
    'NotesText' => 'string',
    'Bcws' => 'double',
    'BCWS' => 'double',
    'Bcwp' => 'double',
    'BCWP' => 'double',
    'IsGeneric' => 'boolean',
    'IsInactive' => 'boolean',
    'IsEnterprise' => 'boolean',
    'BookingType' => 'BookingType',
    'ActualWorkProtected' => 'string',
    'ActualWorkProtectedString' => 'string',
    'ActualOvertimeWorkProtected' => 'string',
    'ActualOvertimeWorkProtectedString' => 'string',
    'ActiveDirectoryGuid' => 'string',
    'CreationDate' => 'string',
    'Created' => 'string',
    'CostCenter' => 'string',
    'IsCostResource' => 'boolean',
    'TeamAssignmentPool' => 'boolean',
    'IsTeamAssignmentPool' => 'boolean',
    'AssignmentOwner' => 'string',
    'AssignmentOwnerGuid' => 'string',
    'IsBudget' => 'boolean',
    'BudgetWork' => 'string',
    'BudgetWorkString' => 'string',
    'BudgetCost' => 'double',
    'OvertimeRate' => 'double',
    'BaselineWork' => 'string',
    'BaselineWorkString' => 'string',
    'BaselineCost' => 'double',
    'BaselineBcws' => 'double',
    'BaselineBcwp' => 'double',
    'Baseline1Work' => 'string',
    'Baseline1WorkString' => 'string',
    'Baseline1Cost' => 'double',
    'Baseline1Bcws' => 'double',
    'Baseline1Bcwp' => 'double',
    'Baseline2Work' => 'string',
    'Baseline2WorkString' => 'string',
    'Baseline2Cost' => 'double',
    'Baseline2Bcws' => 'double',
    'Baseline2Bcwp' => 'double',
    'Baseline3Work' => 'string',
    'Baseline3WorkString' => 'string',
    'Baseline3Cost' => 'double',
    'Baseline3Bcws' => 'double',
    'Baseline3Bcwp' => 'double',
    'Baseline4Work' => 'string',
    'Baseline4WorkString' => 'string',
    'Baseline4Cost' => 'double',
    'Baseline4Bcws' => 'double',
    'Baseline4Bcwp' => 'double',
    'Baseline5Work' => 'string',
    'Baseline5WorkString' => 'string',
    'Baseline5Cost' => 'double',
    'Baseline5Bcws' => 'double',
    'Baseline5Bcwp' => 'double',
    'Baseline6Work' => 'string',
    'Baseline6WorkString' => 'string',
    'Baseline6Cost' => 'double',
    'Baseline6Bcws' => 'double',
    'Baseline6Bcwp' => 'double',
    'Baseline7Work' => 'string',
    'Baseline7WorkString' => 'string',
    'Baseline7Cost' => 'double',
    'Baseline7Bcws' => 'double',
    'Baseline7Bcwp' => 'double',
    'Baseline8Work' => 'string',
    'Baseline8WorkString' => 'string',
    'Baseline8Cost' => 'double',
    'Baseline8Bcws' => 'double',
    'Baseline8Bcwp' => 'double',
    'Baseline9Work' => 'string',
    'Baseline9WorkString' => 'string',
    'Baseline9Cost' => 'double',
    'Baseline9Bcws' => 'double',
    'Baseline9Bcwp' => 'double',
    'Baseline10Work' => 'string',
    'Baseline10WorkString' => 'string',
    'Baseline10Cost' => 'double',
    'Baseline10Bcws' => 'double',
    'Baseline10Bcwp' => 'double',
    'ExtendedAttributes' => 'ARRAY[ExtendedAttribute]',
    'OutlineCodes' => 'ARRAY[OutlineCode]'
};

my $attribute_map = {
    'Name' => 'Name',
    'Uid' => 'Uid',
    'Id' => 'Id',
    'Type' => 'Type',
    'IsNull' => 'IsNull',
    'Initials' => 'Initials',
    'Phonetics' => 'Phonetics',
    'NtAccount' => 'NtAccount',
    'MaterialLabel' => 'MaterialLabel',
    'Code' => 'Code',
    'Group' => 'Group',
    'EMailAddress' => 'EMailAddress',
    'EmailAddress' => 'EmailAddress',
    'Hyperlink' => 'Hyperlink',
    'HyperlinkAddress' => 'HyperlinkAddress',
    'HyperlinkSubAddress' => 'HyperlinkSubAddress',
    'MaxUnits' => 'MaxUnits',
    'PeakUnits' => 'PeakUnits',
    'Overallocated' => 'Overallocated',
    'OverAllocated' => 'OverAllocated',
    'AvailableFrom' => 'AvailableFrom',
    'AvailableTo' => 'AvailableTo',
    'Start' => 'Start',
    'Finish' => 'Finish',
    'CanLevel' => 'CanLevel',
    'AccrueAt' => 'AccrueAt',
    'Work' => 'Work',
    'WorkString' => 'WorkString',
    'RegularWork' => 'RegularWork',
    'RegularWorkString' => 'RegularWorkString',
    'OvertimeWork' => 'OvertimeWork',
    'OvertimeWorkString' => 'OvertimeWorkString',
    'ActualWork' => 'ActualWork',
    'ActualWorkString' => 'ActualWorkString',
    'RemainingWork' => 'RemainingWork',
    'RemainingWorkString' => 'RemainingWorkString',
    'ActualOvertimeWork' => 'ActualOvertimeWork',
    'ActualOvertimeWorkString' => 'ActualOvertimeWorkString',
    'RemainingOvertimeWork' => 'RemainingOvertimeWork',
    'RemainingOvertimeWorkString' => 'RemainingOvertimeWorkString',
    'PercentWorkComplete' => 'PercentWorkComplete',
    'StandardRate' => 'StandardRate',
    'StandardRateFormat' => 'StandardRateFormat',
    'Cost' => 'Cost',
    'OvertimeRateFormat' => 'OvertimeRateFormat',
    'OvertimeCost' => 'OvertimeCost',
    'CostPerUse' => 'CostPerUse',
    'ActualCost' => 'ActualCost',
    'ActualOvertimeCost' => 'ActualOvertimeCost',
    'RemainingCost' => 'RemainingCost',
    'RemainingOvertimeCost' => 'RemainingOvertimeCost',
    'WorkVariance' => 'WorkVariance',
    'CostVariance' => 'CostVariance',
    'Sv' => 'Sv',
    'SV' => 'SV',
    'Cv' => 'Cv',
    'CV' => 'CV',
    'Acwp' => 'Acwp',
    'ACWP' => 'ACWP',
    'CalendarUid' => 'CalendarUid',
    'NotesText' => 'NotesText',
    'Bcws' => 'Bcws',
    'BCWS' => 'BCWS',
    'Bcwp' => 'Bcwp',
    'BCWP' => 'BCWP',
    'IsGeneric' => 'IsGeneric',
    'IsInactive' => 'IsInactive',
    'IsEnterprise' => 'IsEnterprise',
    'BookingType' => 'BookingType',
    'ActualWorkProtected' => 'ActualWorkProtected',
    'ActualWorkProtectedString' => 'ActualWorkProtectedString',
    'ActualOvertimeWorkProtected' => 'ActualOvertimeWorkProtected',
    'ActualOvertimeWorkProtectedString' => 'ActualOvertimeWorkProtectedString',
    'ActiveDirectoryGuid' => 'ActiveDirectoryGuid',
    'CreationDate' => 'CreationDate',
    'Created' => 'Created',
    'CostCenter' => 'CostCenter',
    'IsCostResource' => 'IsCostResource',
    'TeamAssignmentPool' => 'TeamAssignmentPool',
    'IsTeamAssignmentPool' => 'IsTeamAssignmentPool',
    'AssignmentOwner' => 'AssignmentOwner',
    'AssignmentOwnerGuid' => 'AssignmentOwnerGuid',
    'IsBudget' => 'IsBudget',
    'BudgetWork' => 'BudgetWork',
    'BudgetWorkString' => 'BudgetWorkString',
    'BudgetCost' => 'BudgetCost',
    'OvertimeRate' => 'OvertimeRate',
    'BaselineWork' => 'BaselineWork',
    'BaselineWorkString' => 'BaselineWorkString',
    'BaselineCost' => 'BaselineCost',
    'BaselineBcws' => 'BaselineBcws',
    'BaselineBcwp' => 'BaselineBcwp',
    'Baseline1Work' => 'Baseline1Work',
    'Baseline1WorkString' => 'Baseline1WorkString',
    'Baseline1Cost' => 'Baseline1Cost',
    'Baseline1Bcws' => 'Baseline1Bcws',
    'Baseline1Bcwp' => 'Baseline1Bcwp',
    'Baseline2Work' => 'Baseline2Work',
    'Baseline2WorkString' => 'Baseline2WorkString',
    'Baseline2Cost' => 'Baseline2Cost',
    'Baseline2Bcws' => 'Baseline2Bcws',
    'Baseline2Bcwp' => 'Baseline2Bcwp',
    'Baseline3Work' => 'Baseline3Work',
    'Baseline3WorkString' => 'Baseline3WorkString',
    'Baseline3Cost' => 'Baseline3Cost',
    'Baseline3Bcws' => 'Baseline3Bcws',
    'Baseline3Bcwp' => 'Baseline3Bcwp',
    'Baseline4Work' => 'Baseline4Work',
    'Baseline4WorkString' => 'Baseline4WorkString',
    'Baseline4Cost' => 'Baseline4Cost',
    'Baseline4Bcws' => 'Baseline4Bcws',
    'Baseline4Bcwp' => 'Baseline4Bcwp',
    'Baseline5Work' => 'Baseline5Work',
    'Baseline5WorkString' => 'Baseline5WorkString',
    'Baseline5Cost' => 'Baseline5Cost',
    'Baseline5Bcws' => 'Baseline5Bcws',
    'Baseline5Bcwp' => 'Baseline5Bcwp',
    'Baseline6Work' => 'Baseline6Work',
    'Baseline6WorkString' => 'Baseline6WorkString',
    'Baseline6Cost' => 'Baseline6Cost',
    'Baseline6Bcws' => 'Baseline6Bcws',
    'Baseline6Bcwp' => 'Baseline6Bcwp',
    'Baseline7Work' => 'Baseline7Work',
    'Baseline7WorkString' => 'Baseline7WorkString',
    'Baseline7Cost' => 'Baseline7Cost',
    'Baseline7Bcws' => 'Baseline7Bcws',
    'Baseline7Bcwp' => 'Baseline7Bcwp',
    'Baseline8Work' => 'Baseline8Work',
    'Baseline8WorkString' => 'Baseline8WorkString',
    'Baseline8Cost' => 'Baseline8Cost',
    'Baseline8Bcws' => 'Baseline8Bcws',
    'Baseline8Bcwp' => 'Baseline8Bcwp',
    'Baseline9Work' => 'Baseline9Work',
    'Baseline9WorkString' => 'Baseline9WorkString',
    'Baseline9Cost' => 'Baseline9Cost',
    'Baseline9Bcws' => 'Baseline9Bcws',
    'Baseline9Bcwp' => 'Baseline9Bcwp',
    'Baseline10Work' => 'Baseline10Work',
    'Baseline10WorkString' => 'Baseline10WorkString',
    'Baseline10Cost' => 'Baseline10Cost',
    'Baseline10Bcws' => 'Baseline10Bcws',
    'Baseline10Bcwp' => 'Baseline10Bcwp',
    'ExtendedAttributes' => 'ExtendedAttributes',
    'OutlineCodes' => 'OutlineCodes'
};

# new object
sub new { 
    my ($class, %args) = @_; 
    my $self = { 
        #
        'Name' => $args{'Name'}, 
        #
        'Uid' => $args{'Uid'}, 
        #
        'Id' => $args{'Id'}, 
        #
        'Type' => $args{'Type'}, 
        #
        'IsNull' => $args{'IsNull'}, 
        #
        'Initials' => $args{'Initials'}, 
        #
        'Phonetics' => $args{'Phonetics'}, 
        #
        'NtAccount' => $args{'NtAccount'}, 
        #
        'MaterialLabel' => $args{'MaterialLabel'}, 
        #
        'Code' => $args{'Code'}, 
        #
        'Group' => $args{'Group'}, 
        #
        'EMailAddress' => $args{'EMailAddress'}, 
        #
        'EmailAddress' => $args{'EmailAddress'}, 
        #
        'Hyperlink' => $args{'Hyperlink'}, 
        #
        'HyperlinkAddress' => $args{'HyperlinkAddress'}, 
        #
        'HyperlinkSubAddress' => $args{'HyperlinkSubAddress'}, 
        #
        'MaxUnits' => $args{'MaxUnits'}, 
        #
        'PeakUnits' => $args{'PeakUnits'}, 
        #
        'Overallocated' => $args{'Overallocated'}, 
        #
        'OverAllocated' => $args{'OverAllocated'}, 
        #
        'AvailableFrom' => $args{'AvailableFrom'}, 
        #
        'AvailableTo' => $args{'AvailableTo'}, 
        #
        'Start' => $args{'Start'}, 
        #
        'Finish' => $args{'Finish'}, 
        #
        'CanLevel' => $args{'CanLevel'}, 
        #
        'AccrueAt' => $args{'AccrueAt'}, 
        #
        'Work' => $args{'Work'}, 
        #
        'WorkString' => $args{'WorkString'}, 
        #
        'RegularWork' => $args{'RegularWork'}, 
        #
        'RegularWorkString' => $args{'RegularWorkString'}, 
        #
        'OvertimeWork' => $args{'OvertimeWork'}, 
        #
        'OvertimeWorkString' => $args{'OvertimeWorkString'}, 
        #
        'ActualWork' => $args{'ActualWork'}, 
        #
        'ActualWorkString' => $args{'ActualWorkString'}, 
        #
        'RemainingWork' => $args{'RemainingWork'}, 
        #
        'RemainingWorkString' => $args{'RemainingWorkString'}, 
        #
        'ActualOvertimeWork' => $args{'ActualOvertimeWork'}, 
        #
        'ActualOvertimeWorkString' => $args{'ActualOvertimeWorkString'}, 
        #
        'RemainingOvertimeWork' => $args{'RemainingOvertimeWork'}, 
        #
        'RemainingOvertimeWorkString' => $args{'RemainingOvertimeWorkString'}, 
        #
        'PercentWorkComplete' => $args{'PercentWorkComplete'}, 
        #
        'StandardRate' => $args{'StandardRate'}, 
        #
        'StandardRateFormat' => $args{'StandardRateFormat'}, 
        #
        'Cost' => $args{'Cost'}, 
        #
        'OvertimeRateFormat' => $args{'OvertimeRateFormat'}, 
        #
        'OvertimeCost' => $args{'OvertimeCost'}, 
        #
        'CostPerUse' => $args{'CostPerUse'}, 
        #
        'ActualCost' => $args{'ActualCost'}, 
        #
        'ActualOvertimeCost' => $args{'ActualOvertimeCost'}, 
        #
        'RemainingCost' => $args{'RemainingCost'}, 
        #
        'RemainingOvertimeCost' => $args{'RemainingOvertimeCost'}, 
        #
        'WorkVariance' => $args{'WorkVariance'}, 
        #
        'CostVariance' => $args{'CostVariance'}, 
        #
        'Sv' => $args{'Sv'}, 
        #
        'SV' => $args{'SV'}, 
        #
        'Cv' => $args{'Cv'}, 
        #
        'CV' => $args{'CV'}, 
        #
        'Acwp' => $args{'Acwp'}, 
        #
        'ACWP' => $args{'ACWP'}, 
        #
        'CalendarUid' => $args{'CalendarUid'}, 
        #
        'NotesText' => $args{'NotesText'}, 
        #
        'Bcws' => $args{'Bcws'}, 
        #
        'BCWS' => $args{'BCWS'}, 
        #
        'Bcwp' => $args{'Bcwp'}, 
        #
        'BCWP' => $args{'BCWP'}, 
        #
        'IsGeneric' => $args{'IsGeneric'}, 
        #
        'IsInactive' => $args{'IsInactive'}, 
        #
        'IsEnterprise' => $args{'IsEnterprise'}, 
        #
        'BookingType' => $args{'BookingType'}, 
        #
        'ActualWorkProtected' => $args{'ActualWorkProtected'}, 
        #
        'ActualWorkProtectedString' => $args{'ActualWorkProtectedString'}, 
        #
        'ActualOvertimeWorkProtected' => $args{'ActualOvertimeWorkProtected'}, 
        #
        'ActualOvertimeWorkProtectedString' => $args{'ActualOvertimeWorkProtectedString'}, 
        #
        'ActiveDirectoryGuid' => $args{'ActiveDirectoryGuid'}, 
        #
        'CreationDate' => $args{'CreationDate'}, 
        #
        'Created' => $args{'Created'}, 
        #
        'CostCenter' => $args{'CostCenter'}, 
        #
        'IsCostResource' => $args{'IsCostResource'}, 
        #
        'TeamAssignmentPool' => $args{'TeamAssignmentPool'}, 
        #
        'IsTeamAssignmentPool' => $args{'IsTeamAssignmentPool'}, 
        #
        'AssignmentOwner' => $args{'AssignmentOwner'}, 
        #
        'AssignmentOwnerGuid' => $args{'AssignmentOwnerGuid'}, 
        #
        'IsBudget' => $args{'IsBudget'}, 
        #
        'BudgetWork' => $args{'BudgetWork'}, 
        #
        'BudgetWorkString' => $args{'BudgetWorkString'}, 
        #
        'BudgetCost' => $args{'BudgetCost'}, 
        #
        'OvertimeRate' => $args{'OvertimeRate'}, 
        #
        'BaselineWork' => $args{'BaselineWork'}, 
        #
        'BaselineWorkString' => $args{'BaselineWorkString'}, 
        #
        'BaselineCost' => $args{'BaselineCost'}, 
        #
        'BaselineBcws' => $args{'BaselineBcws'}, 
        #
        'BaselineBcwp' => $args{'BaselineBcwp'}, 
        #
        'Baseline1Work' => $args{'Baseline1Work'}, 
        #
        'Baseline1WorkString' => $args{'Baseline1WorkString'}, 
        #
        'Baseline1Cost' => $args{'Baseline1Cost'}, 
        #
        'Baseline1Bcws' => $args{'Baseline1Bcws'}, 
        #
        'Baseline1Bcwp' => $args{'Baseline1Bcwp'}, 
        #
        'Baseline2Work' => $args{'Baseline2Work'}, 
        #
        'Baseline2WorkString' => $args{'Baseline2WorkString'}, 
        #
        'Baseline2Cost' => $args{'Baseline2Cost'}, 
        #
        'Baseline2Bcws' => $args{'Baseline2Bcws'}, 
        #
        'Baseline2Bcwp' => $args{'Baseline2Bcwp'}, 
        #
        'Baseline3Work' => $args{'Baseline3Work'}, 
        #
        'Baseline3WorkString' => $args{'Baseline3WorkString'}, 
        #
        'Baseline3Cost' => $args{'Baseline3Cost'}, 
        #
        'Baseline3Bcws' => $args{'Baseline3Bcws'}, 
        #
        'Baseline3Bcwp' => $args{'Baseline3Bcwp'}, 
        #
        'Baseline4Work' => $args{'Baseline4Work'}, 
        #
        'Baseline4WorkString' => $args{'Baseline4WorkString'}, 
        #
        'Baseline4Cost' => $args{'Baseline4Cost'}, 
        #
        'Baseline4Bcws' => $args{'Baseline4Bcws'}, 
        #
        'Baseline4Bcwp' => $args{'Baseline4Bcwp'}, 
        #
        'Baseline5Work' => $args{'Baseline5Work'}, 
        #
        'Baseline5WorkString' => $args{'Baseline5WorkString'}, 
        #
        'Baseline5Cost' => $args{'Baseline5Cost'}, 
        #
        'Baseline5Bcws' => $args{'Baseline5Bcws'}, 
        #
        'Baseline5Bcwp' => $args{'Baseline5Bcwp'}, 
        #
        'Baseline6Work' => $args{'Baseline6Work'}, 
        #
        'Baseline6WorkString' => $args{'Baseline6WorkString'}, 
        #
        'Baseline6Cost' => $args{'Baseline6Cost'}, 
        #
        'Baseline6Bcws' => $args{'Baseline6Bcws'}, 
        #
        'Baseline6Bcwp' => $args{'Baseline6Bcwp'}, 
        #
        'Baseline7Work' => $args{'Baseline7Work'}, 
        #
        'Baseline7WorkString' => $args{'Baseline7WorkString'}, 
        #
        'Baseline7Cost' => $args{'Baseline7Cost'}, 
        #
        'Baseline7Bcws' => $args{'Baseline7Bcws'}, 
        #
        'Baseline7Bcwp' => $args{'Baseline7Bcwp'}, 
        #
        'Baseline8Work' => $args{'Baseline8Work'}, 
        #
        'Baseline8WorkString' => $args{'Baseline8WorkString'}, 
        #
        'Baseline8Cost' => $args{'Baseline8Cost'}, 
        #
        'Baseline8Bcws' => $args{'Baseline8Bcws'}, 
        #
        'Baseline8Bcwp' => $args{'Baseline8Bcwp'}, 
        #
        'Baseline9Work' => $args{'Baseline9Work'}, 
        #
        'Baseline9WorkString' => $args{'Baseline9WorkString'}, 
        #
        'Baseline9Cost' => $args{'Baseline9Cost'}, 
        #
        'Baseline9Bcws' => $args{'Baseline9Bcws'}, 
        #
        'Baseline9Bcwp' => $args{'Baseline9Bcwp'}, 
        #
        'Baseline10Work' => $args{'Baseline10Work'}, 
        #
        'Baseline10WorkString' => $args{'Baseline10WorkString'}, 
        #
        'Baseline10Cost' => $args{'Baseline10Cost'}, 
        #
        'Baseline10Bcws' => $args{'Baseline10Bcws'}, 
        #
        'Baseline10Bcwp' => $args{'Baseline10Bcwp'}, 
        #
        'ExtendedAttributes' => $args{'ExtendedAttributes'}, 
        #
        'OutlineCodes' => $args{'OutlineCodes'}
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
