#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use IRobot;

plan skip_all => 'Set $ENV{IROBOT_SERIAL} to run this test' unless $ENV{IROBOT_SERIAL};


my $module = IRobot->new({
        comm_class => 'IRobot::Serial',
        serial_device => $ENV{IROBOT_SERIAL},
        baud_rate => 57600,
    });

ok($module->start(1));
sleep(1);
ok($module->drive_forward());
sleep(2);
ok($module->drive_backward());
sleep(2);
ok($module->drive_stop());

done_testing;
