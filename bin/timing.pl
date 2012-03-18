#!/usr/bin/perl

use strict;
use warnings;

use Time::HiRes qw( sleep );

use IRobot;
use IRobot::Telnet;
use Net::Telnet;

my $sock = new Net::Telnet(
    Host => $ENV{IROBOT_TELNET},
    Port => 2000,
    Binmode => 1,
);
$sock->open();
sleep(2);

my $telnet = IRobot::Telnet->new(
        server_name => $ENV{IROBOT_TELNET},
        server_port => 2000,
        telnet => $sock
    );

my $module = IRobot->new({
        comm_class => 'IRobot::Telnet',
        server_name => $ENV{IROBOT_TELNET},
        server_port => 2000,
        comm => $telnet
    });

print "Initializing...\n";
$module->start(1);
sleep(1);
$module->drive_stop();
sleep(1);
print "Initialized!\n";

print "Full spin\n";
$module->spin_left();
print "slept for " . sleep(9.1) . "\n";
$module->drive_stop();
sleep(1);
$module->spin_right();
print "slept for " . sleep(9.1) . "\n";
$module->drive_stop();
sleep(2);

print "Half spin\n";
$module->spin_left();
print "slept for " . sleep(4.6) . "\n";
$module->drive_stop();
sleep(1);
$module->spin_right();
print "slept for " . sleep(4.6) . "\n";
$module->drive_stop();
sleep(2);

print "Quarter spin\n";
$module->spin_left();
print "slept for " . sleep(2.35) . "\n";
$module->drive_stop();
sleep(1);
$module->spin_right();
print "slept for " . sleep(2.35) . "\n";
$module->drive_stop();
sleep(2);


print "Forward/Backward 1 M\n";
$module->drive_forward();
print "sleep for " . sleep(4.25) . "\n";
$module->drive_stop();
sleep(1);
$module->drive_backward();
print "sleep for " . sleep(4.25) . "\n";
$module->drive_stop();
sleep(2);

print "Forward/Backward 1 M again\n";
$module->drive_forward();
print "sleep for " . sleep(4.25) . "\n";
$module->drive_stop();
sleep(1);
$module->drive_backward();
print "sleep for " . sleep(4.25) . "\n";
$module->drive_stop();
sleep(0.15);


$module->drive_forward();
sleep(0.2);
$module->spin_left();
sleep(0.2);
$module->drive_backward();
sleep(0.2);
$module->spin_left();
sleep(0.2);
$module->drive_stop();
sleep(0.15);
