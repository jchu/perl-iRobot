#-----------------------------------------------------------
#
# IRobot::Comm
# 
# Communication Base
#
#-----------------------------------------------------------

package IRobot::Comm;

use strict;
use warnings;

use Moo::Role;

requires qw/send read_more/;

1;
