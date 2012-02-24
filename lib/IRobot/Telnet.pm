#-----------------------------------------------------------
#
# IRobot::Telnet
# 
# Telnet Communication
#
#-----------------------------------------------------------

package IRobot::Telnet;

use Moo;
use Net::Telnet;

with('IRobot::Comm');

has server_name => (
    is => 'ro',
    required => 1,
);

has server_port => (
    is => 'ro',
    required => 1,
);

has telnet => (
    is => 'rw',
    lazy => 1,
    builder => '_build_telnet',
);

sub send {
    my $self = shift;
    my $cmd = shift;

    #warn "Sending command: $cmd";
    $self->telnet->put($cmd);
}

sub read_more {
    my $self = shift;

    my $string_in = $self->telnet->getline();
    return $string_in;
}

sub _build_telnet {
    my $self = shift;

    my $telnet = new Net::Telnet(
        Host => $self->server_name,
        Port => $self->server_port
    );
    $telnet->open();
    sleep(1);
    return $telnet;
}

sub DEMOLISH {
    my $self = shift;
    $self->telnet->close();
}

1;
