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


pir_output_is(<< 'CODE', << 'OUTPUT', "eval eval_body individual");
.sub main :main
    print "loading lib\n"
    .local pmc lib
    lib = loadlib "LGP"
    find_type $I0, "LGP"

    print "creating engine\n"
    .local pmc engine
    new engine, $I0

    $S0 = typeof engine
    print "loaded dynpmc: "
    print $S0
    print "\n"

    print "getting eval_body\n"
    .const .Sub indi = 'eval_body'
    print "running eval_body first time\n"
    eval_body()
    print "preparing lgp\n"
    engine.prepare_lgp(2)
    print "evaluating body\n"
    eval_body()
    print "back in main\n"
.end

.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub eval_body
    returncc
    bsr INDI_CORE
    I0 = 10
    I1 = 20
    I3 = 5

INDI_CORE:
    print "indi core begin\n"
    I4 = I0 + I1
    I4 += I3
    I4 += 1
    print I4
    print "\n"
    noop
    noop
    noop
    noop
    noop
    noop
    noop
    print "indi core end\n"
    returncc

    noop
    noop
    noop
    noop
    noop
    noop
    noop
    noop
    noop
    noop

    noop
    noop
    noop
    noop
    noop
    noop
    noop
    noop
    noop
    noop

    noop
    noop
    noop
    noop
    noop
    noop
    noop
    noop
    noop
    returncc
.end
CODE
loading lib
creating engine
loaded dynpmc: LGP
getting eval_body
running eval_body first time
preparing lgp
evaluating body
indi core begin
36
indi core end
back in main
OUTPUT
