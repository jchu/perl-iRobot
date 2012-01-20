#-----------------------------------------------------------
#
# OEMModule3
# 
# API for iRobot CREATE
#
#-----------------------------------------------------------

package IRobot;

use strict;
use warnings;

use Moo;

use IRobot::Serial;
use IRobot::Telnet;

our $VERSION = '0.1';

use Moo;

#-----------------------------------------------------------
#
# Class Variables
#
#-----------------------------------------------------------

has comm => (
    is => 'ro',
    lazy => 1,
    builder => '_build_comm',
);

has comm_class => (
    is => 'ro',
    isa => sub {
        die "Only IRobot::Serial and IRobot::Telnet supported" unless $_[0] =~ /IRobot::Serial|IRobot::Telnet/
    },
    required => 1,
);

# IRobot::Serial
has serial_device => (
    is => 'ro',
);

has baud_rate => (
    is => 'ro',
);

# IRobot::Telnet

has server_name => (
    is => 'ro',
);

has server_port => (
    is => 'ro',
);

my $START       = "\x80"; # 128
my $SAFEMODE    = "\x83"; # 131
my $FULLMODE    = "\x84"; # 132

my $DRIVE       = "\x89"; # 137
my $DRIVEDIRECT = "\x91"; # 145

my $SEP         = "\t";

#-----------------------------------------------------------
#
# Commands
#
#-----------------------------------------------------------

sub start {
    my ($self, $mode) = @_;

    if( $mode ) {
        $self->send_command("${START}${FULLMODE}${SEP}");
    } else {
        $self->send_command("${START}${SAFEMODE}${SEP}");
    }
}

sub drive_forward {
    my ($self, $mode) = @_;

    my $left = pack('n',500);
    my $right = pack('n',500);

    $self->send_command("${DRIVEDIRECT}${right}${left}${SEP}");
}

sub drive_backward {
    my ($self, $mode) = @_;

    my $left = pack('n',-500);
    my $right = pack('n',-500);

    $self->send_command("${DRIVEDIRECT}${right}${left}${SEP}");
}

sub drive_stop {
    my ($self, $mode) = @_;

    $self->send_command("${DRIVEDIRECT}\x00\x00\x00\x00${SEP}");
}

sub turn_left {
    my ($self, $mode) = @_;

    $self->send_command("${DRIVE}\x00\x64\xFF\xFF${SEP}");
}

sub turn_right {
    my ($self, $mode) = @_;

    $self->send_command("${DRIVE}\x00\x64\x00\x01${SEP}");
}

#-----------------------------------------------------------
#
# Utiliies
#
#-----------------------------------------------------------

sub send_command {
    my($self, $command) = @_;

    # validate command
    #unless( any { $command == $_ } @commands;
    #    $self->error('Unsupported command');
    #    return false;
    #}
    
    $self->comm->send($command);
}

sub _build_comm {
    my $self = shift;

    if( $self->comm_class eq 'IRobot::Serial' ) {
        return $self->comm_class->new({
                serial_device => $self->serial_device,
                baud_rate => $self->baud_rate
            });
    } elsif( $self->comm_class eq 'IRobot::Telnet' ) {
        my $telnet = $self->comm_class->new({
                server_name => $self->server_name,
                server_port => $self->server_port
            });
        return $telnet;
    }
}
