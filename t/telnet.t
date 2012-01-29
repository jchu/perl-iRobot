#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use IRobot;
use IRobot::Telnet;
use Net::Telnet;

plan skip_all => 'Set $ENV{IROBOT_TELNET} to run this test' unless $ENV{IROBOT_TELNET};

my $module = IRobot->new({
        comm_class => 'IRobot::Telnet',
        server_name => $ENV{IROBOT_TELNET},
        server_port => 2000,
    });

diag("start robot");
ok($module->start(1));
sleep(1);
diag("drive forward");
ok($module->drive_forward());
sleep(2);
diag("drive faster");
ok($module->drive_forward(500,500));
sleep(2);
diag("veer right");
ok($module->drive_forward(500,300)); # veer right
sleep(2);
diag("veer left");
ok($module->drive_forward(300,500)); # veer left
sleep(2);
diag("drive backward");
ok($module->drive_backward());
sleep(2);
diag("drive faster");
ok($module->drive_backward(500,500));
sleep(2);
diag("stop");
ok($module->drive_stop());
sleep(2);
diag("spin left");
ok($module->spin_left());
sleep(2);
diag("spin right");
ok($module->spin_right());
sleep(2);
diag("stop");
ok($module->drive_stop());
sleep(2);

undef $module;
sleep(1);

# supply sock

diag("manual build sock");
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

$module = IRobot->new({
        comm_class => 'IRobot::Telnet',
        server_name => $ENV{IROBOT_TELNET},
        server_port => 2000,
        comm => $telnet
    });

diag("start!");
ok($module->start(1));
sleep(1);
diag("spin left");
ok($module->spin_left());
sleep(2);
diag("spin right");
ok($module->spin_right());
sleep(2);
diag("stop");
ok($module->drive_stop());
sleep(2);
diag("drive forward");
ok($module->drive_forward());
sleep(2);
diag("drive faster");
ok($module->drive_forward(500,500));
sleep(2);
diag("veer right");
ok($module->drive_forward(500,300)); # veer right
sleep(2);
diag("veer left");
ok($module->drive_forward(300,500)); # veer left
sleep(2);
diag("drive backward");
ok($module->drive_backward());
sleep(2);
diag("drive faster");
ok($module->drive_backward(500,500));
sleep(2);
diag("stop");
ok($module->drive_stop());
sleep(2);

done_testing;
