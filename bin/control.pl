#!/usr/bin/perl

use strict;
use warnings;

use Term::TermKey qw( FLAG_UTF8 RES_EOF FORMAT_LONGMOD );
use IRobot;

my $module = IRobot->new({
        comm_class => 'IRobot::Telnet',
        server_name => $ENV{IROBOT_TELNET},
        server_port => 2000,
    });

my $tk = Term::TermKey->new(\*STDIN);

binmode(STDOUT, ":encoding(UTF-8)" ) if $tk->get_flags & FLAG_UTF8;

$| = 1;

init_robot();

my $keyname;
while( (my $ret = $tk->waitkey( my $key ) ) != RES_EOF ) {
    $keyname = $tk->format_key( $key, FORMAT_LONGMOD );

    if( $keyname eq 'Up' ) {
        $module->drive_forward();
    } elsif( $keyname eq 'Down' ) {
        $module->drive_backward();
    } elsif( $keyname eq 'Left' ) {
        $module->spin_left();
    } elsif( $keyname eq 'Right' ) {
        $module->spin_right();
    }
}

sub init_robot() {
    $module->start(1);
    sleep(1);
}
