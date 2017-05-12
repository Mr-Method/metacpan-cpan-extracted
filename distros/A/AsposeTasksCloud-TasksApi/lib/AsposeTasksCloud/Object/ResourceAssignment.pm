package AsposeTasksCloud::Object::ResourceAssignment;

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
    'TaskUid' => 'int',
    'ResourceUid' => 'int',
    'Uid' => 'int',
    'PercentWorkComplete' => 'int',
    'ActualCost' => 'double',
    'ActualFinish' => 'string',
    'ActualOvertimeCost' => 'double',
    'ActualOvertimeWork' => 'string',
    'ActualOvertimeWorkString' => 'string',
    'ActualStart' => 'string',
    'ActualWork' => 'string',
    'ActualWorkString' => 'string',
    'Acwp' => 'double',
    'ACWP' => 'double',
    'Confirmed' => 'boolean',
    'Cost' => 'double',
    'CostRateTableType' => 'RateType',
    'CostVariance' => 'double',
    'Cv' => 'double',
    'CV' => 'double',
    'Delay' => 'int',
    'Finish' => 'string',
    'FinishVariance' => 'int',
    'Hyperlink' => 'string',
    'HyperlinkAddress' => 'string',
    'HyperlinkSubAddress' => 'string',
    'WorkVariance' => 'double',
    'HasFixedRateUnits' => 'boolean',
    'FixedMaterial' => 'boolean',
    'LevelingDelay' => 'int',
    'LevelingDelayFormat' => 'TimeUnitType',
    'LinkedFields' => 'boolean',
    'Milestone' => 'boolean',
    'Notes' => 'string',
    'Overallocated' => 'boolean',
    'OvertimeCost' => 'double',
    'OvertimeWork' => 'string',
    'OvertimeWorkString' => 'string',
    'PeakUnits' => 'double',
    'RegularWork' => 'string',
    'RegularWorkString' => 'string',
    'RemainingCost' => 'double',
    'RemainingOvertimeCost' => 'double',
    'RemainingOvertimeWork' => 'string',
    'RemainingOvertimeWorkString' => 'string',
    'RemainingWork' => 'string',
    'RemainingWorkString' => 'string',
    'ResponsePending' => 'boolean',
    'Start' => 'string',
    'Stop' => 'string',
    'Resume' => 'string',
    'StartVariance' => 'int',
    'Summary' => 'boolean',
    'Sv' => 'double',
    'SV' => 'double',
    'Units' => 'double',
    'UpdateNeeded' => 'boolean',
    'Vac' => 'double',
    'VAC' => 'double',
    'Work' => 'string',
    'WorkString' => 'string',
    'WorkContour' => 'WorkContourType',
    'Bcws' => 'double',
    'BCWS' => 'double',
    'Bcwp' => 'double',
    'BCWP' => 'double',
    'BookingType' => 'BookingType',
    'ActualWorkProtected' => 'string',
    'ActualWorkProtectedString' => 'string',
    'ActualOvertimeWorkProtected' => 'string',
    'ActualOvertimeWorkProtectedString' => 'string',
    'CreationDate' => 'string',
    'Created' => 'string',
    'AssnOwner' => 'string',
    'AssignmentOwner' => 'string',
    'AssnOwnerGuid' => 'string',
    'AssignmentOwnerGuid' => 'string',
    'BudgetCost' => 'double',
    'BudgetWork' => 'string',
    'BudgetWorkString' => 'string',
    'RateScale' => 'int',
    'BaselineStart' => 'string',
    'BaselineFinish' => 'string',
    'BaselineWork' => 'string',
    'BaselineWorkString' => 'string',
    'BaselineCost' => 'double',
    'BaselineBcws' => 'double',
    'BaselineBcwp' => 'double',
    'Baseline1Start' => 'string',
    'Baseline1Finish' => 'string',
    'Baseline1Work' => 'string',
    'Baseline1WorkString' => 'string',
    'Baseline1Cost' => 'double',
    'Baseline1Bcws' => 'double',
    'Baseline1Bcwp' => 'double',
    'Baseline2Start' => 'string',
    'Baseline2Finish' => 'string',
    'Baseline2Work' => 'string',
    'Baseline2WorkString' => 'string',
    'Baseline2Cost' => 'double',
    'Baseline2Bcws' => 'double',
    'Baseline2Bcwp' => 'double',
    'Baseline3Start' => 'string',
    'Baseline3Finish' => 'string',
    'Baseline3Work' => 'string',
    'Baseline3WorkString' => 'string',
    'Baseline3Cost' => 'double',
    'Baseline3Bcws' => 'double',
    'Baseline3Bcwp' => 'double',
    'Baseline4Start' => 'string',
    'Baseline4Finish' => 'string',
    'Baseline4Work' => 'string',
    'Baseline4WorkString' => 'string',
    'Baseline4Cost' => 'double',
    'Baseline4Bcws' => 'double',
    'Baseline4Bcwp' => 'double',
    'Baseline5Start' => 'string',
    'Baseline5Finish' => 'string',
    'Baseline5Work' => 'string',
    'Baseline5WorkString' => 'string',
    'Baseline5Cost' => 'double',
    'Baseline5Bcws' => 'double',
    'Baseline5Bcwp' => 'double',
    'Baseline6Start' => 'string',
    'Baseline6Finish' => 'string',
    'Baseline6Work' => 'string',
    'Baseline6WorkString' => 'string',
    'Baseline6Cost' => 'double',
    'Baseline6Bcws' => 'double',
    'Baseline6Bcwp' => 'double',
    'Baseline7Start' => 'string',
    'Baseline7Finish' => 'string',
    'Baseline7Work' => 'string',
    'Baseline7WorkString' => 'string',
    'Baseline7Cost' => 'double',
    'Baseline7Bcws' => 'double',
    'Baseline7Bcwp' => 'double',
    'Baseline8Start' => 'string',
    'Baseline8Finish' => 'string',
    'Baseline8Work' => 'string',
    'Baseline8WorkString' => 'string',
    'Baseline8Cost' => 'double',
    'Baseline8Bcws' => 'double',
    'Baseline8Bcwp' => 'double',
    'Baseline9Start' => 'string',
    'Baseline9Finish' => 'string',
    'Baseline9Work' => 'string',
    'Baseline9WorkString' => 'string',
    'Baseline9Cost' => 'double',
    'Baseline9Bcws' => 'double',
    'Baseline9Bcwp' => 'double',
    'Baseline10Start' => 'string',
    'Baseline10Finish' => 'string',
    'Baseline10Work' => 'string',
    'Baseline10WorkString' => 'string',
    'Baseline10Cost' => 'double',
    'Baseline10Bcws' => 'double',
    'Baseline10Bcwp' => 'double',
    'ExtendedAttributes' => 'ARRAY[ExtendedAttribute]'
};

my $attribute_map = {
    'TaskUid' => 'TaskUid',
    'ResourceUid' => 'ResourceUid',
    'Uid' => 'Uid',
    'PercentWorkComplete' => 'PercentWorkComplete',
    'ActualCost' => 'ActualCost',
    'ActualFinish' => 'ActualFinish',
    'ActualOvertimeCost' => 'ActualOvertimeCost',
    'ActualOvertimeWork' => 'ActualOvertimeWork',
    'ActualOvertimeWorkString' => 'ActualOvertimeWorkString',
    'ActualStart' => 'ActualStart',
    'ActualWork' => 'ActualWork',
    'ActualWorkString' => 'ActualWorkString',
    'Acwp' => 'Acwp',
    'ACWP' => 'ACWP',
    'Confirmed' => 'Confirmed',
    'Cost' => 'Cost',
    'CostRateTableType' => 'CostRateTableType',
    'CostVariance' => 'CostVariance',
    'Cv' => 'Cv',
    'CV' => 'CV',
    'Delay' => 'Delay',
    'Finish' => 'Finish',
    'FinishVariance' => 'FinishVariance',
    'Hyperlink' => 'Hyperlink',
    'HyperlinkAddress' => 'HyperlinkAddress',
    'HyperlinkSubAddress' => 'HyperlinkSubAddress',
    'WorkVariance' => 'WorkVariance',
    'HasFixedRateUnits' => 'HasFixedRateUnits',
    'FixedMaterial' => 'FixedMaterial',
    'LevelingDelay' => 'LevelingDelay',
    'LevelingDelayFormat' => 'LevelingDelayFormat',
    'LinkedFields' => 'LinkedFields',
    'Milestone' => 'Milestone',
    'Notes' => 'Notes',
    'Overallocated' => 'Overallocated',
    'OvertimeCost' => 'OvertimeCost',
    'OvertimeWork' => 'OvertimeWork',
    'OvertimeWorkString' => 'OvertimeWorkString',
    'PeakUnits' => 'PeakUnits',
    'RegularWork' => 'RegularWork',
    'RegularWorkString' => 'RegularWorkString',
    'RemainingCost' => 'RemainingCost',
    'RemainingOvertimeCost' => 'RemainingOvertimeCost',
    'RemainingOvertimeWork' => 'RemainingOvertimeWork',
    'RemainingOvertimeWorkString' => 'RemainingOvertimeWorkString',
    'RemainingWork' => 'RemainingWork',
    'RemainingWorkString' => 'RemainingWorkString',
    'ResponsePending' => 'ResponsePending',
    'Start' => 'Start',
    'Stop' => 'Stop',
    'Resume' => 'Resume',
    'StartVariance' => 'StartVariance',
    'Summary' => 'Summary',
    'Sv' => 'Sv',
    'SV' => 'SV',
    'Units' => 'Units',
    'UpdateNeeded' => 'UpdateNeeded',
    'Vac' => 'Vac',
    'VAC' => 'VAC',
    'Work' => 'Work',
    'WorkString' => 'WorkString',
    'WorkContour' => 'WorkContour',
    'Bcws' => 'Bcws',
    'BCWS' => 'BCWS',
    'Bcwp' => 'Bcwp',
    'BCWP' => 'BCWP',
    'BookingType' => 'BookingType',
    'ActualWorkProtected' => 'ActualWorkProtected',
    'ActualWorkProtectedString' => 'ActualWorkProtectedString',
    'ActualOvertimeWorkProtected' => 'ActualOvertimeWorkProtected',
    'ActualOvertimeWorkProtectedString' => 'ActualOvertimeWorkProtectedString',
    'CreationDate' => 'CreationDate',
    'Created' => 'Created',
    'AssnOwner' => 'AssnOwner',
    'AssignmentOwner' => 'AssignmentOwner',
    'AssnOwnerGuid' => 'AssnOwnerGuid',
    'AssignmentOwnerGuid' => 'AssignmentOwnerGuid',
    'BudgetCost' => 'BudgetCost',
    'BudgetWork' => 'BudgetWork',
    'BudgetWorkString' => 'BudgetWorkString',
    'RateScale' => 'RateScale',
    'BaselineStart' => 'BaselineStart',
    'BaselineFinish' => 'BaselineFinish',
    'BaselineWork' => 'BaselineWork',
    'BaselineWorkString' => 'BaselineWorkString',
    'BaselineCost' => 'BaselineCost',
    'BaselineBcws' => 'BaselineBcws',
    'BaselineBcwp' => 'BaselineBcwp',
    'Baseline1Start' => 'Baseline1Start',
    'Baseline1Finish' => 'Baseline1Finish',
    'Baseline1Work' => 'Baseline1Work',
    'Baseline1WorkString' => 'Baseline1WorkString',
    'Baseline1Cost' => 'Baseline1Cost',
    'Baseline1Bcws' => 'Baseline1Bcws',
    'Baseline1Bcwp' => 'Baseline1Bcwp',
    'Baseline2Start' => 'Baseline2Start',
    'Baseline2Finish' => 'Baseline2Finish',
    'Baseline2Work' => 'Baseline2Work',
    'Baseline2WorkString' => 'Baseline2WorkString',
    'Baseline2Cost' => 'Baseline2Cost',
    'Baseline2Bcws' => 'Baseline2Bcws',
    'Baseline2Bcwp' => 'Baseline2Bcwp',
    'Baseline3Start' => 'Baseline3Start',
    'Baseline3Finish' => 'Baseline3Finish',
    'Baseline3Work' => 'Baseline3Work',
    'Baseline3WorkString' => 'Baseline3WorkString',
    'Baseline3Cost' => 'Baseline3Cost',
    'Baseline3Bcws' => 'Baseline3Bcws',
    'Baseline3Bcwp' => 'Baseline3Bcwp',
    'Baseline4Start' => 'Baseline4Start',
    'Baseline4Finish' => 'Baseline4Finish',
    'Baseline4Work' => 'Baseline4Work',
    'Baseline4WorkString' => 'Baseline4WorkString',
    'Baseline4Cost' => 'Baseline4Cost',
    'Baseline4Bcws' => 'Baseline4Bcws',
    'Baseline4Bcwp' => 'Baseline4Bcwp',
    'Baseline5Start' => 'Baseline5Start',
    'Baseline5Finish' => 'Baseline5Finish',
    'Baseline5Work' => 'Baseline5Work',
    'Baseline5WorkString' => 'Baseline5WorkString',
    'Baseline5Cost' => 'Baseline5Cost',
    'Baseline5Bcws' => 'Baseline5Bcws',
    'Baseline5Bcwp' => 'Baseline5Bcwp',
    'Baseline6Start' => 'Baseline6Start',
    'Baseline6Finish' => 'Baseline6Finish',
    'Baseline6Work' => 'Baseline6Work',
    'Baseline6WorkString' => 'Baseline6WorkString',
    'Baseline6Cost' => 'Baseline6Cost',
    'Baseline6Bcws' => 'Baseline6Bcws',
    'Baseline6Bcwp' => 'Baseline6Bcwp',
    'Baseline7Start' => 'Baseline7Start',
    'Baseline7Finish' => 'Baseline7Finish',
    'Baseline7Work' => 'Baseline7Work',
    'Baseline7WorkString' => 'Baseline7WorkString',
    'Baseline7Cost' => 'Baseline7Cost',
    'Baseline7Bcws' => 'Baseline7Bcws',
    'Baseline7Bcwp' => 'Baseline7Bcwp',
    'Baseline8Start' => 'Baseline8Start',
    'Baseline8Finish' => 'Baseline8Finish',
    'Baseline8Work' => 'Baseline8Work',
    'Baseline8WorkString' => 'Baseline8WorkString',
    'Baseline8Cost' => 'Baseline8Cost',
    'Baseline8Bcws' => 'Baseline8Bcws',
    'Baseline8Bcwp' => 'Baseline8Bcwp',
    'Baseline9Start' => 'Baseline9Start',
    'Baseline9Finish' => 'Baseline9Finish',
    'Baseline9Work' => 'Baseline9Work',
    'Baseline9WorkString' => 'Baseline9WorkString',
    'Baseline9Cost' => 'Baseline9Cost',
    'Baseline9Bcws' => 'Baseline9Bcws',
    'Baseline9Bcwp' => 'Baseline9Bcwp',
    'Baseline10Start' => 'Baseline10Start',
    'Baseline10Finish' => 'Baseline10Finish',
    'Baseline10Work' => 'Baseline10Work',
    'Baseline10WorkString' => 'Baseline10WorkString',
    'Baseline10Cost' => 'Baseline10Cost',
    'Baseline10Bcws' => 'Baseline10Bcws',
    'Baseline10Bcwp' => 'Baseline10Bcwp',
    'ExtendedAttributes' => 'ExtendedAttributes'
};

# new object
sub new { 
    my ($class, %args) = @_; 
    my $self = { 
        #
        'TaskUid' => $args{'TaskUid'}, 
        #
        'ResourceUid' => $args{'ResourceUid'}, 
        #
        'Uid' => $args{'Uid'}, 
        #
        'PercentWorkComplete' => $args{'PercentWorkComplete'}, 
        #
        'ActualCost' => $args{'ActualCost'}, 
        #
        'ActualFinish' => $args{'ActualFinish'}, 
        #
        'ActualOvertimeCost' => $args{'ActualOvertimeCost'}, 
        #
        'ActualOvertimeWork' => $args{'ActualOvertimeWork'}, 
        #
        'ActualOvertimeWorkString' => $args{'ActualOvertimeWorkString'}, 
        #
        'ActualStart' => $args{'ActualStart'}, 
        #
        'ActualWork' => $args{'ActualWork'}, 
        #
        'ActualWorkString' => $args{'ActualWorkString'}, 
        #
        'Acwp' => $args{'Acwp'}, 
        #
        'ACWP' => $args{'ACWP'}, 
        #
        'Confirmed' => $args{'Confirmed'}, 
        #
        'Cost' => $args{'Cost'}, 
        #
        'CostRateTableType' => $args{'CostRateTableType'}, 
        #
        'CostVariance' => $args{'CostVariance'}, 
        #
        'Cv' => $args{'Cv'}, 
        #
        'CV' => $args{'CV'}, 
        #
        'Delay' => $args{'Delay'}, 
        #
        'Finish' => $args{'Finish'}, 
        #
        'FinishVariance' => $args{'FinishVariance'}, 
        #
        'Hyperlink' => $args{'Hyperlink'}, 
        #
        'HyperlinkAddress' => $args{'HyperlinkAddress'}, 
        #
        'HyperlinkSubAddress' => $args{'HyperlinkSubAddress'}, 
        #
        'WorkVariance' => $args{'WorkVariance'}, 
        #
        'HasFixedRateUnits' => $args{'HasFixedRateUnits'}, 
        #
        'FixedMaterial' => $args{'FixedMaterial'}, 
        #
        'LevelingDelay' => $args{'LevelingDelay'}, 
        #
        'LevelingDelayFormat' => $args{'LevelingDelayFormat'}, 
        #
        'LinkedFields' => $args{'LinkedFields'}, 
        #
        'Milestone' => $args{'Milestone'}, 
        #
        'Notes' => $args{'Notes'}, 
        #
        'Overallocated' => $args{'Overallocated'}, 
        #
        'OvertimeCost' => $args{'OvertimeCost'}, 
        #
        'OvertimeWork' => $args{'OvertimeWork'}, 
        #
        'OvertimeWorkString' => $args{'OvertimeWorkString'}, 
        #
        'PeakUnits' => $args{'PeakUnits'}, 
        #
        'RegularWork' => $args{'RegularWork'}, 
        #
        'RegularWorkString' => $args{'RegularWorkString'}, 
        #
        'RemainingCost' => $args{'RemainingCost'}, 
        #
        'RemainingOvertimeCost' => $args{'RemainingOvertimeCost'}, 
        #
        'RemainingOvertimeWork' => $args{'RemainingOvertimeWork'}, 
        #
        'RemainingOvertimeWorkString' => $args{'RemainingOvertimeWorkString'}, 
        #
        'RemainingWork' => $args{'RemainingWork'}, 
        #
        'RemainingWorkString' => $args{'RemainingWorkString'}, 
        #
        'ResponsePending' => $args{'ResponsePending'}, 
        #
        'Start' => $args{'Start'}, 
        #
        'Stop' => $args{'Stop'}, 
        #
        'Resume' => $args{'Resume'}, 
        #
        'StartVariance' => $args{'StartVariance'}, 
        #
        'Summary' => $args{'Summary'}, 
        #
        'Sv' => $args{'Sv'}, 
        #
        'SV' => $args{'SV'}, 
        #
        'Units' => $args{'Units'}, 
        #
        'UpdateNeeded' => $args{'UpdateNeeded'}, 
        #
        'Vac' => $args{'Vac'}, 
        #
        'VAC' => $args{'VAC'}, 
        #
        'Work' => $args{'Work'}, 
        #
        'WorkString' => $args{'WorkString'}, 
        #
        'WorkContour' => $args{'WorkContour'}, 
        #
        'Bcws' => $args{'Bcws'}, 
        #
        'BCWS' => $args{'BCWS'}, 
        #
        'Bcwp' => $args{'Bcwp'}, 
        #
        'BCWP' => $args{'BCWP'}, 
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
        'CreationDate' => $args{'CreationDate'}, 
        #
        'Created' => $args{'Created'}, 
        #
        'AssnOwner' => $args{'AssnOwner'}, 
        #
        'AssignmentOwner' => $args{'AssignmentOwner'}, 
        #
        'AssnOwnerGuid' => $args{'AssnOwnerGuid'}, 
        #
        'AssignmentOwnerGuid' => $args{'AssignmentOwnerGuid'}, 
        #
        'BudgetCost' => $args{'BudgetCost'}, 
        #
        'BudgetWork' => $args{'BudgetWork'}, 
        #
        'BudgetWorkString' => $args{'BudgetWorkString'}, 
        #
        'RateScale' => $args{'RateScale'}, 
        #
        'BaselineStart' => $args{'BaselineStart'}, 
        #
        'BaselineFinish' => $args{'BaselineFinish'}, 
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
        'Baseline1Start' => $args{'Baseline1Start'}, 
        #
        'Baseline1Finish' => $args{'Baseline1Finish'}, 
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
        'Baseline2Start' => $args{'Baseline2Start'}, 
        #
        'Baseline2Finish' => $args{'Baseline2Finish'}, 
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
        'Baseline3Start' => $args{'Baseline3Start'}, 
        #
        'Baseline3Finish' => $args{'Baseline3Finish'}, 
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
        'Baseline4Start' => $args{'Baseline4Start'}, 
        #
        'Baseline4Finish' => $args{'Baseline4Finish'}, 
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
        'Baseline5Start' => $args{'Baseline5Start'}, 
        #
        'Baseline5Finish' => $args{'Baseline5Finish'}, 
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
        'Baseline6Start' => $args{'Baseline6Start'}, 
        #
        'Baseline6Finish' => $args{'Baseline6Finish'}, 
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
        'Baseline7Start' => $args{'Baseline7Start'}, 
        #
        'Baseline7Finish' => $args{'Baseline7Finish'}, 
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
        'Baseline8Start' => $args{'Baseline8Start'}, 
        #
        'Baseline8Finish' => $args{'Baseline8Finish'}, 
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
        'Baseline9Start' => $args{'Baseline9Start'}, 
        #
        'Baseline9Finish' => $args{'Baseline9Finish'}, 
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
        'Baseline10Start' => $args{'Baseline10Start'}, 
        #
        'Baseline10Finish' => $args{'Baseline10Finish'}, 
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
        'ExtendedAttributes' => $args{'ExtendedAttributes'}
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
