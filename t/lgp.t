#! perl
# Copyright (C) 2005, The Perl Foundation.
# $Id: lgp.t 12838 2006-06-16 14:19:10Z mj41 $

use strict;
use warnings;
use lib qw( . lib ../lib ../../lib );
use Test::More;
use Parrot::Test tests => 3;
use Parrot::Config;


=head1 NAME

t/dynpmc/lgp.t

=head1 SYNOPSIS

    % prove t/dynpmc/lgp.t

=head1 DESCRIPTION

Linear Genetic Programming

=cut


pir_output_is(<< 'CODE', << 'OUTPUT', "loadlib");
.sub main :main
    .local pmc lib
    lib = loadlib "lgp"
    unless lib goto not_loaded
    print "ok\n"
    end
not_loaded:
    print "not loaded\n"
.end
CODE
ok
OUTPUT

pir_output_is(<< 'CODE', << 'OUTPUT', "test type of HLL_mapped .Sub");
.sub main :main
    .const .Sub b = 'bar'
    $S0 = typeof b
    print $S0
    print "\n"
    .const .Sub f = 'foo'
    $S0 = typeof f
    print $S0
    print "\n"
.end

.sub bar
    noop
.end

.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub foo
    noop
.end
CODE
Sub
LGP
OUTPUT


pir_output_is(<< 'CODE', << 'OUTPUT', "eval initialized individual");
.sub main :main
    .const .Sub indi = 'indi'
    print "before eval\n"
    indi()
    print "after eval\n"
.end

.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub indi
    I10 = 10
    I10 = I10 + 1
    print I10
    print "\n"
    noop
    noop
    returncc
    noop
    noop
.end
CODE
before eval
11
after eval
OUTPUT
