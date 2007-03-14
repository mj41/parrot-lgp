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
    
    .const .Sub eval_body = 'eval_body'

	# todo - replace this first initialization run with pure init_indi method
    eval_body()
    print "initial eval_body() done\n\n"
    engine."init_indi"()
    print "init_indi done\n\n"

    engine."eb_mdump"()
    print "eb_mdump() done\n\n"

    engine."eb_cdump"()
    print "eb_cdump done\n\n"

#    engine."ei_cdump"()
#    print "ei_cdump done\n\n"

    print "ops_num: "
    I0 = engine."ops_num"()
    print I0
    print "\n\n"

    print "ops: "
    P0 = engine."ops"()
    I0 = P0
    print "ops_num: "
    print I0
    print "\n"

	I1 = 0
PRINT_NEXT_OP:	
    I2 = P0[I1]
    print "op "
    print I1
    print ": "
    print I2
    print "\n"
    I1 = I1 + 1
    if I1 < I0 goto PRINT_NEXT_OP
    print "\n\n"

    I30 = 0

#    branch NEXT_INDI
    branch F_NEXT_INDI
    

F_NEXT_INDI:
	engine."initialize"(I30)
	engine."load_indi"(I30)
    I0 = eval_body()
    print I30
    print ":"
    print I0
    print " "
    inc I30
    I0 = I30 % 1000
    if I0 != 0 goto SKIP_NL
    print "\n"
SKIP_NL:    
    if I30 < I29 goto F_NEXT_INDI
    print "\n"
    branch END

    
NEXT_INDI:
	print "engine.initialize("
	print I30
	print ")\n"
	engine."initialize"(I30)
	print "\n"

    print "indi_code("
	print I30
	print "):\n"
    engine."indi_code"(I30)
    print "\n"

	print "engine.indi_len("
	print I30
	print ") = "
	I0 = engine."indi_len"(I30)
	print I0
	print "\n"

	print "engine.load_indi("
	print I30
	print ")\n"
	engine."load_indi"(I30)
	print "\n"

    engine."eb_cdump"()
    print "eb_cdump done\n\n"

    engine."ei_cdump"()
    print "ei_cdump done\n\n"

    print "fitness = "
    I0 = eval_body()
    print I0
    print "\n"

    inc I30
    print "bench_num: "
    print I30
    print "\n"
    if I30 < I29 goto NEXT_INDI
    branch END
    
END:
	print "done\n"
#	print "Press any key to continue ...\n"
#	$P0 = getstdin
   
.end

.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub eval_body
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
#    print "sub error: "
#    print I0
#    print "\n"
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

	# 51
    ret

.end


