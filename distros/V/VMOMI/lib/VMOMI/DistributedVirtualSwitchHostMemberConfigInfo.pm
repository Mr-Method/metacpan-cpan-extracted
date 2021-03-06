package VMOMI::DistributedVirtualSwitchHostMemberConfigInfo;
use parent 'VMOMI::DynamicData';

use strict;
use warnings;

our @class_ancestors = ( 
    'DynamicData',
);

our @class_members = ( 
    ['host', 'ManagedObjectReference', 0, 1],
    ['maxProxySwitchPorts', undef, 0, ],
    ['vendorSpecificConfig', 'DistributedVirtualSwitchKeyedOpaqueBlob', 1, 1],
    ['backing', 'DistributedVirtualSwitchHostMemberBacking', 0, ],
);

sub get_class_ancestors {
    return @class_ancestors;
}

sub get_class_members {
    my $class = shift;
    my @super_members = $class->SUPER::get_class_members();
    return (@super_members, @class_members);
}

1;
