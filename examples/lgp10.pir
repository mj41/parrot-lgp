.sub main :main
    get_params "(0)", P5
    set I29, P5
    eq I29, 2, PARAM_OK

	print "set default params\n"
	set I29, 1

PARAM_OK:    
    set I29, P5[1]

    .local pmc lib
    lib = loadlib "LGP"
    loadlib P1, "LGP"
    find_type $I0, "LGP"

    .local pmc engine
    new engine, $I0
    $S0 = typeof engine
    print "loaded dynpmc: "
    print $S0
    print "\n"
    
    .const .Sub eval = 'eval'

	# todo - replace this first initialization run with pure init_indi method
    eval()
    print "indi() done\n\n"
    engine."init_indi"()
    print "init_indi done\n\n"

    engine."gvdump"()
    print "gvdump() done\n\n"

#    engine."edump"()
#    print "edump() done\n\n"

#    engine."idump"()
#    print "idump done\n\n"

    I31 = eval()
    print "error: "
    print I31
    print "\n\n"
	
	print "engine.test():\n"
	S0 = engine."test"()
	print S0
	print "\n"

	branch END

    set I30, I29
    
NEXT_INDI:
    engine."new_indi"()
    print "new_indi done\n"
    I31 = indi()
    print "indi() done\n"

AGAIN:
    dec I30
    print "bench_num: "
    print I30
    print "\n"
    gt I30, 0, NEXT_INDI
    branch END
    
END:
	print "done\n"
#	print "Press any key to continue ...\n"
#	$P0 = getstdin
   
.end

.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub eval
	# hack - todo
	bsr INDI_CORE
	
# error
    save 0

#   set: 0
    cleari
    I0 = 3
    I1 = 2
    I2 = 1
    bsr INDI_CORE
    I0 = 11
    bsr ERR
    save I31

#   set: 1
    cleari
    I0 = 3
    I1 = 3
    I2 = 1
    bsr INDI_CORE
    I0 = 12
    bsr ERR
    save I31

#   set: 2
    cleari
    I0 = 3
    I1 = 3
    I2 = 3
    bsr INDI_CORE
    I0 = 14
    bsr ERR
    save I31

#   set: 3
    cleari
    I0 = 9
    I1 = 5
    I2 = 3
    bsr INDI_CORE
    I0 = 22
    bsr ERR
    save I31

    set_returns "(0)", I31
    returncc

ERR:
    restore I31
    # error, I3 is indi destination register
    I0 = I3 - I0
    print "sub error: "
    print I0
    print "\n"
    abs I0
    I0 = I0 * I0
    I31 = I31 + I0
    ret

INDI_CORE:

	# 10
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

	# 20
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

	# 30
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

	# 40
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

	# 50
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

	# 60
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

	# 70
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

	# 80
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

	# 90
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

	# 100
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

    ret

.end


