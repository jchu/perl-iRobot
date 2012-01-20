#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use IRobot;

plan skip_all => 'Set $ENV{IROBOT_TELNET} to run this test' unless $ENV{IROBOT_TELNET};


my $module = IRobot->new({
        comm_class => 'IRobot::Telnet',
        server_name => $ENV{IROBOT_TELNET},
        server_port => 2000,
    });

ok($module->start(1));
sleep(1);
ok($module->drive_forward());
sleep(2);
ok($module->drive_backward());
sleep(2);
ok($module->drive_stop());
sleep(2);
ok($module->turn_left());
sleep(2);
ok($module->turn_right());
sleep(2);
ok($module->drive_stop());
sleep(2);

done_testing;
