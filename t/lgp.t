#! perl

use strict;
use warnings;
use lib qw( . lib ../lib ../../lib );
use lib qw( ./parrot/lib );
use Test::More;
use Parrot::Test tests => 3;
use Parrot::Config;


=head1 NAME

t/lgp.t

=head1 SYNOPSIS

    % prove t/lgp.t

=head1 DESCRIPTION

Linear Genetic Programming

=cut


pir_output_is(<< 'CODE', << 'OUTPUT', "loadlib");
.sub main :main
    .local pmc lib
    lib = loadlib "lgp"
    unless lib goto NOT_LOADED
    print "lgp lib loaded\n"

    $I0 = find_type "LGP"
    if $I0 == 0 goto FIND_TYPE_ERR
    print "find_type found LGP\n"
    
    .local pmc engine
    engine = new $I0
    
    $S0 = typeof engine
    print $S0
    print "\n"
    end
    
NOT_LOADED:
    print "lgp lib not loaded\n"
    end
FIND_TYPE_ERR:
    print "find type return 0"
    end
.end
CODE
lgp lib loaded
find_type found LGP
LGP
OUTPUT

pir_output_is(<< 'CODE', << 'OUTPUT', "loadlib (macro)");
.loadlib "lgp"

.sub main :main

    $I0 = find_type "LGP"
    if $I0 == 0 goto FIND_TYPE_ERR
    print "find_type found LGP\n"
    
    .local pmc engine
    engine = new $I0
    
    $S0 = typeof engine
    print $S0
    print "\n"
    end
    
FIND_TYPE_ERR:
    print "find type return 0"
    end
.end
CODE
find_type found LGP
LGP
OUTPUT


pir_output_is(<< 'CODE', << 'OUTPUT', "pasm compiler, namespace and prepare_eval_space");
.loadlib "lgp"

.sub main :main

    $I0 = find_type "LGP"
    if $I0 == 0 goto FIND_TYPE_ERR
    
    .local pmc engine
    new engine, $I0

    .local string pir_code_lgp

    pir_code_lgp = <<'EOC_LGP'
.namespace [ "LGP" ]
.pcc_sub eval_space:
    noop
    returncc
INDI_CORE:
    noop
    bsr INDI_CORE
    ret
EOC_LGP

    .local pmc pasm_compiler
    pasm_compiler = compreg "PASM"

    .local pmc eval_code
    push_eh COMPILE_ERR
    eval_code = pasm_compiler(pir_code_lgp)
    clear_eh

    .local pmc eval_space
    eval_space = get_global ['LGP'], 'eval_space'

    $P0 = eval_space.'get_namespace'()
    $P0 = $P0.'get_name'()
    $S0 = join ';', $P0
    print "namespace: '"
    print $S0
    print "'\n"

    engine.prepare_eval_space( eval_space )
    print "eval_space sub prepared\n"
    end
FIND_TYPE_ERR:
    print "find_type for LGP failed\n"
    end
    
COMPILE_ERR:
    print "compilation failed\n"
    end   
.end
CODE
namespace: 'parrot;LGP'
eval_space sub prepared
OUTPUT
