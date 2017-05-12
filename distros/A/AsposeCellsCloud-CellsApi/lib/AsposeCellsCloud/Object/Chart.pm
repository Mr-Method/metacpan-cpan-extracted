package AsposeCellsCloud::Object::Chart;

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
    		'Name' => 'string',
            'Placement' => 'string',
            'Type' => 'string',
            'AutoScaling' => 'boolean',
            'BackWall' => 'Link',
            'CategoryAxis' => 'Link',
            'ChartArea' => 'Link',
            'ChartDataTable' => 'Link',
            'ChartObject' => 'Link',
            'DepthPercent' => 'int',
            'Elevation' => 'int',
            'FirstSliceAngle' => 'int',
            'Floor' => 'Link',
            'GapDepth' => 'int',
            'GapWidth' => 'int',
            'HeightPercent' => 'int',
            'HidePivotFieldButtons' => 'boolean',
            'Is3D' => 'boolean',
            'IsRectangularCornered' => 'boolean',
            'Legend' => 'Link',
            'NSeries' => 'Link',
            'PageSetup' => 'Link',
            'Perspective' => 'int',
            'PivotSource' => 'string',
            'PlotArea' => 'Link',
            'PlotEmptyCellsType' => 'string',
            'PlotVisibleCells' => 'boolean',
            'PrintSize' => 'string',
            'RightAngleAxes' => 'boolean',
            'RotationAngle' => 'int',
            'SecondCategoryAxis' => 'Link',
            'SecondValueAxis' => 'Link',
            'SeriesAxis' => 'Link',
            'Shapes' => 'Link',
            'ShowDataTable' => 'boolean',
            'ShowLegend' => 'boolean',
            'SideWall' => 'Link',
            'SizeWithWindow' => 'boolean',
            'Style' => 'int',
            'Title' => 'Link',
            'ValueAxis' => 'Link',
            'Walls' => 'Link',
            'WallsAndGridlines2D' => 'boolean',
    		'link' => 'Link'
};

my $attribute_map = {
    		'Name' => 'Name',
            'Placement' => 'Placement',
            'Type' => 'Type',
            'AutoScaling' => 'AutoScaling',
            'BackWall' => 'BackWall',
            'CategoryAxis' => 'CategoryAxis',
            'ChartArea' => 'ChartArea',
            'ChartDataTable' => 'ChartDataTable',
            'ChartObject' => 'ChartObject',
            'DepthPercent' => 'DepthPercent',
            'Elevation' => 'Elevation',
            'FirstSliceAngle' => 'FirstSliceAngle',
            'Floor' => 'Floor',
            'GapDepth' => 'GapDepth',
            'GapWidth' => 'GapWidth',
            'HeightPercent' => 'HeightPercent',
            'HidePivotFieldButtons' => 'HidePivotFieldButtons',
            'Is3D' => 'Is3D',
            'IsRectangularCornered' => 'IsRectangularCornered',
            'Legend' => 'Legend',
            'NSeries' => 'NSeries',
            'PageSetup' => 'PageSetup',
            'Perspective' => 'Perspective',
            'PivotSource' => 'PivotSource',
            'PlotArea' => 'PlotArea',
            'PlotEmptyCellsType' => 'PlotEmptyCellsType',
            'PlotVisibleCells' => 'PlotVisibleCells',
            'PrintSize' => 'PrintSize',
            'RightAngleAxes' => 'RightAngleAxes',
            'RotationAngle' => 'RotationAngle',
            'SecondCategoryAxis' => 'SecondCategoryAxis',
            'SecondValueAxis' => 'SecondValueAxis',
            'SeriesAxis' => 'SeriesAxis',
            'Shapes' => 'Shapes',
            'ShowDataTable' => 'ShowDataTable',
            'ShowLegend' => 'ShowLegend',
            'SideWall' => 'SideWall',
            'SizeWithWindow' => 'SizeWithWindow',
            'Style' => 'Style',
            'Title' => 'Title',
            'ValueAxis' => 'ValueAxis',
            'Walls' => 'Walls',
            'WallsAndGridlines2D' => 'WallsAndGridlines2D',
    		'link' => 'link'
};

# new object
sub new { 
    my ($class, %args) = @_; 
    my $self = { 
        #
        	'Name' => $args{'Name'},
            'Placement' => $args{'Placement'},
            'Type' => $args{'Type'},
            'AutoScaling' => $args{'AutoScaling'},
            'BackWall' => $args{'BackWall'},
            'CategoryAxis' => $args{'CategoryAxis'},
            'ChartArea' => $args{'ChartArea'},
            'ChartDataTable' => $args{'ChartDataTable'},
            'ChartObject' => $args{'ChartObject'},
            'DepthPercent' => $args{'DepthPercent'},
            'Elevation' => $args{'Elevation'},
            'FirstSliceAngle' => $args{'FirstSliceAngle'},
            'Floor' => $args{'Floor'},
            'GapDepth' => $args{'GapDepth'},
            'GapWidth' => $args{'GapWidth'},
            'HeightPercent' => $args{'HeightPercent'},
            'HidePivotFieldButtons' => $args{'HidePivotFieldButtons'},
            'Is3D' => $args{'Is3D'},
            'IsRectangularCornered' => $args{'IsRectangularCornered'},
            'Legend' => $args{'Legend'},
            'NSeries' => $args{'NSeries'},
            'PageSetup' => $args{'PageSetup'},
            'Perspective' => $args{'Perspective'},
            'PivotSource' => $args{'PivotSource'},
            'PlotArea' => $args{'PlotArea'},
            'PlotEmptyCellsType' => $args{'PlotEmptyCellsType'},
            'PlotVisibleCells' => $args{'PlotVisibleCells'},
            'PrintSize' => $args{'PrintSize'},
            'RightAngleAxes' => $args{'RightAngleAxes'},
            'RotationAngle' => $args{'RotationAngle'},
            'SecondCategoryAxis' => $args{'SecondCategoryAxis'},
            'SecondValueAxis' => $args{'SecondValueAxis'},
            'SeriesAxis' => $args{'SeriesAxis'},
            'Shapes' => $args{'Shapes'},
            'ShowDataTable' => $args{'ShowDataTable'},
            'ShowLegend' => $args{'ShowLegend'},
            'SideWall' => $args{'SideWall'},
            'SizeWithWindow' => $args{'SizeWithWindow'},
            'Style' => $args{'Style'},
            'Title' => $args{'Title'},
            'ValueAxis' => $args{'ValueAxis'},
            'Walls' => $args{'Walls'},
            'WallsAndGridlines2D' => $args{'WallsAndGridlines2D'},
        	'link' => $args{'link'}
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
