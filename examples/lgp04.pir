.sub main :main
    print "main start\n"

    .local pmc lib
    lib = loadlib "LGP"
    find_type $I0, "LGP"

    .local pmc engine
    new engine, $I0
    $S0 = typeof engine
    print "loaded dynpmc: "
    print $S0
    print "\n"

    .const .Sub indi = 'indi'
    indi()
    engine.prepare_lgp(1)
    indi()
    print "main end\n"
.end

.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub indi
	returncc
	bsr INDI_CORE
	
INDI_CORE:	
    print "indi start\n"
    I1 = 0
    I0 += 5
    noop
    I1 += 10
    noop
    noop
    print "indi end\n"
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
    noop
    noop
    noop
    
    returncc
    
.end
