#!/usr/bin/perl

use strict;
use warnings;

use Switch 'Perl6';

use SDL qw(:init);
use SDL::Event;
use SDL::Events qw(:all);
use SDL::Video;

use IRobot;

use enum qw(
    IDLE
    FORWARD FORWARD_LEFT FORWARD_RIGHT
    BACKWARD BACKWARD_LEFT BACKWARD_RIGHT
    SPIN_LEFT SPIN_RIGHT);

my $arrow_key_filter = sub {
    given( $_[0]->type ) {
        when SDL_KEYDOWN { return 1; }
        when SDL_KEYUP { return 1; }
        default { return 0; }
    }
};

SDL::Events::set_event_filter($arrow_key_filter);

my $prev_state = IDLE;
my $state = IDLE;

my $fast = 400;
my $slow = 300;

my ($left, $right) = ($fast, $fast);

my $module = IRobot->new({
        comm_class => 'IRobot::Telnet',
        server_name => $ENV{IROBOT_TELNET},
        server_port => 2000,
    });

SDL::init(SDL_INIT_VIDEO);
my $display = SDL::Video::set_video_mode(100,50,32, SDL_SWSURFACE );

my $event = SDL::Event->new();

while(1) {
    if( SDL::Events::poll_event($event) ) {
        given( $event->key_sym ) {
            when SDLK_LEFT {
                if( $event->type == SDL_KEYDOWN ) {
                    given( $state ) {
                        when (IDLE)            { $state = SPIN_LEFT; }
                        when (SPIN_RIGHT)      { $state = SPIN_LEFT; }
                        when (FORWARD)         { $state = FORWARD_LEFT; }
                        when (FORWARD_RIGHT)   { $state = FORWARD_LEFT; }
                        when (BACKWARD)        { $state = BACKWARD_LEFT; }
                        when (BACKWARD_RIGHT)  { $state = BACKWARD_LEFT; }
                    }
                } elsif( $event->type == SDL_KEYUP ) {
                    given( $state ) {
                        when (SPIN_LEFT)    { $state = IDLE; }
                        when (FORWARD_LEFT) { $state = FORWARD; }
                        when (BACKWARD_LEFT){ $state = BACKWARD; }
                    }
                }
            }
            when SDLK_RIGHT {
                if( $event->type == SDL_KEYDOWN ) {
                    given( $state ) {
                        when (IDLE)         { $state = SPIN_RIGHT; }
                        when (SPIN_LEFT)    { $state = SPIN_RIGHT; }
                        when (FORWARD)      { $state = FORWARD_RIGHT; }
                        when (FORWARD_LEFT) { $state = FORWARD_RIGHT; }
                        when (BACKWARD)     { $state = BACKWARD_RIGHT; }
                        when (BACKWARD_LEFT){ $state = BACKWARD_RIGHT; }
                    }
                } elsif( $event->type == SDL_KEYUP ) {
                    given( $state ) {
                        when (SPIN_RIGHT)      { $state = IDLE; }
                        when (FORWARD_RIGHT)   { $state = FORWARD; }
                        when (BACKWARD_RIGHT)  { $state = BACKWARD; }
                    }
                }
            }
            when SDLK_UP {
                if( $event->type == SDL_KEYDOWN ) {
                    given( $state ) {
                        when (IDLE)            { $state = FORWARD; }
                        when (SPIN_LEFT)       { $state = FORWARD_LEFT; }
                        when (SPIN_RIGHT)      { $state = FORWARD_RIGHT; }
                        when (BACKWARD)        { $state = FORWARD; }
                        when (BACKWARD_LEFT)   { $state = FORWARD_LEFT; }
                        when (BACKWARD_RIGHT)  { $state = FORWARD_RIGHT; }
                    }
                } elsif( $event->type == SDL_KEYUP ) {
                    given( $state ) {
                        when (FORWARD)         { $state = IDLE; }
                        when (FORWARD_LEFT)    { $state = SPIN_LEFT; }
                        when (FORWARD_RIGHT)   { $state = SPIN_RIGHT; }
                    }
                }
            }
            when SDLK_DOWN {
                if( $event->type == SDL_KEYDOWN ) {
                    given( $state ) {
                        when (IDLE)            { $state = BACKWARD; }
                        when (SPIN_LEFT)       { $state = BACKWARD_LEFT; }
                        when (SPIN_RIGHT)      { $state = BACKWARD_RIGHT; }
                        when (FORWARD)         { $state = BACKWARD; }
                        when (FORWARD_LEFT)    { $state = BACKWARD_LEFT; }
                        when (FORWARD_RIGHT)   { $state = BACKWARD_RIGHT; }
                    }
                } elsif( $event->type == SDL_KEYUP ) {
                    given( $state ) {
                        when (BACKWARD)        { $state = IDLE; }
                        when (BACKWARD_LEFT)   { $state = SPIN_LEFT; }
                        when (BACKWARD_RIGHT)  { $state = SPIN_RIGHT; }
                    }
                }
            }
            default { next; }
        }

        next if $prev_state == $state;

        print "\tsym: " . SDL::Events::get_key_name($event->key_sym) . "\n";
        print "state: $state\n";

        given( $state ) {
            when (IDLE)             { $module->drive_stop(); }
            when (FORWARD)          { $left = $right = $fast; $module->drive_forward($left, $right) }
            when (FORWARD_LEFT)     { $left = $slow; $right = $fast; $module->drive_forward($left, $right) }
            when (FORWARD_RIGHT)    { $left = $fast; $right = $slow; $module->drive_forward($left, $right) }
            when (BACKWARD)         { $left = $right = $fast; $module->drive_backward($left, $right); }
            when (BACKWARD_LEFT)    { $left = $slow; $right = $fast; $module->drive_backward($left, $right); }
            when (BACKWARD_RIGHT)   { $left = $fast; $right = $slow; $module->drive_backward($left, $right); }
            when (SPIN_LEFT)        { $module->spin_left(); }
            when (SPIN_RIGHT)       { $module->spin_right(); }
        }
        $prev_state = $state;
    }
}

sub init_robot() {
    $module->start(1);
    sleep(1);
}
