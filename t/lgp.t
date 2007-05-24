#! perl

use strict;
use warnings;
use lib qw( . lib ../lib ../../lib );
use lib qw( ./parrot/lib );
use Test::More;
use Parrot::Test tests => 4;
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

    .local string pasm_eval_space

    pasm_eval_space = <<'EOC_LGP'
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
    eval_code = pasm_compiler(pasm_eval_space)
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

pir_output_is(<< 'CODE', << 'OUTPUT', "all for validate_conf");
.loadlib "lgp"

.sub main :main

    $I0 = find_type "LGP"
    if $I0 == 0 goto FIND_TYPE_ERR
    
    .local pmc engine
    new engine, $I0

    .local string pasm_eval_space

    pasm_eval_space = <<'EOC_LGP'
.namespace [ "LGP" ]
.pcc_sub eval_space:
    noop
    returncc

EOC_LGP

    # adding indi core
    pasm_eval_space = concat "INDI_CORE:\n"
    .local int add_core_len
    add_core_len = engine.'indi_max_len'()
    add_core_len -= 2 # 'bsr' -2, 'ret' -1, + 1 for loop
ADD_NOOP:    
    pasm_eval_space = concat "    noop\n"
    add_core_len -= 1
    if add_core_len >= 0 goto ADD_NOOP
    # mandatory instructions for prepare_eval_space()
    pasm_eval_space = concat "    bsr INDI_CORE\n"
    pasm_eval_space = concat "    ret\n"

    .local pmc pasm_compiler
    pasm_compiler = compreg "PASM"

    .local pmc eval_code
    push_eh COMPILE_ERR
    eval_code = pasm_compiler(pasm_eval_space)
    clear_eh

    .local pmc eval_space
    eval_space = get_global ['LGP'], 'eval_space'

    engine.prepare_eval_space( eval_space )
    print "eval_space sub prepared\n"

    engine.set_pop_size(10)
    print "population set\n"

    engine.validate_conf()
    
    print "validation finished sucessful\n"

    end
FIND_TYPE_ERR:
    print "find_type for LGP failed\n"
    end
    
COMPILE_ERR:
    print "compilation failed\n"
    end   
.end
CODE
eval_space sub prepared
population set
validation finished sucessful
OUTPUT
