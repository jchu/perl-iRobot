#-----------------------------------------------------------
#
# IRobot::Serial
# 
# Serial Communication
#
#-----------------------------------------------------------

package IRobot::Serial;

use Moo;
use Device::SerialPort;

with('IRobot::Comm');

has serial_device => (
    is => 'ro',
    required => 1,
);

has baud_rate => (
    is => 'ro',
    default => sub { 57600 },
);

has serialport => (
    is => 'rw',
    lazy => 1,
    builder => '_build_port',
);
sub send {
    my $self = shift;
    my $cmd = shift;

    my $count_out = $self->serialport->write($cmd);
    return $count_out;
}

sub read_more {
    my $self = shift;

    my ($count_in, $string_in) = $self->serialport->read(16);
    return $string_in;
}

sub _build_port {
    my $self = shift;

    my $port = new Device::SerialPort($self->serial_device, 1)
        || die "Can't open " . $self->serial_device . ": $!\n";
    $port->baudrate($self->baud_rate);
    $port->parity("none");
    $port->databits(8);
    $port->stopbits(1);
    return $port;
}

1;
