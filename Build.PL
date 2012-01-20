#!/usr/bin/perl

use strict;
use warnings;


use Module::Build;

Module::Build->new(

    module_name     => 'IRobot',
    dist_abstract   => 'API for IRobot CREATE',
    dist_author     => 'Jonathan Chu <jrchu@cs.ucla.edu>',
    license         => 'perl',
    requires        => {
        'Moo'               => 0,
    },
    create_packlist => 0,
    installdirs     => 'vendor',
)->create_build_script;
