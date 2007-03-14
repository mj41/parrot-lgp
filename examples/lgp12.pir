.sub main :main
    get_params "(0)", P5
    set I29, P5
    eq I29, 2, PARAM_OK

	print "set default params\n"
	set I29, 3

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

	.local int pop_size
	pop_size = engine."pop_size"()
    if I29 <= pop_size goto OK_POP_SIZE
    print "Max population size is "
    print pop_size
    print "\n"
    goto END

OK_POP_SIZE:

#	bsr OPS_DUMP
    
    .const .Sub eval_body = 'eval_body'

	# todo - replace this first initialization run with pure init_indi method
    noop
    noop
    noop
#    print "initial eval_body() and init_indi():\n"
    eval_body()
    engine."init_indi"()
#    print "initial eval_body() and init_indi() done\n"

	goto SKIP_FIRST_REAL_EVAL

	noop
	noop
	noop
	print "\n"
	print "trying to run first real eval_body()\n"
    I31 = eval_body()
    print "I31 after eval_body() = "
    print I31
    print "\n"

    engine."eb_mdump"()
    print "eb_mdump() done\n\n"

    engine."eb_cdump"()
    print "eb_cdump done\n\n"

#    engine."ei_cdump"()
#    print "ei_cdump done\n\n"

SKIP_FIRST_REAL_EVAL:

	goto BENCH
#	goto FAST
#	goto SLOW
	goto END

BENCH:
	print "bench init run\n\n"
    bsr F_INIT
    I28 = 1
BENCH_NEXT:
	print "bench run number: "
	print I28
	print "\n"
#    bsr F_RUN
#    bsr SF_RUN
    bsr SSF_RUN
    print "\n"
    inc I28
    if I28 <= 10 goto BENCH_NEXT
    branch END
 
FAST:
    bsr F_INIT
    bsr F_RUN
    branch END

SLOW:
 	bsr D_INIT
    branch END


F_INIT:
	I30 = 0
F_INIT_NEXT:
	engine."initialize"(I30)
    inc I30
    if I30 < I29 goto F_INIT_NEXT
ret


F_RUN:
	I30 = 0
F_NEXT_RUN:
	engine."load_indi"(I30)
    I0 = eval_body()
    print I30
    print ":"
    print I0
    print " "
    inc I30
    I0 = I30 % 100
    if I0 != 0 goto F_RUN_SKIP_NL
    print "\n"
F_RUN_SKIP_NL:    
    if I30 < I29 goto F_NEXT_RUN
    print "\n"
ret


SF_RUN:
	I30 = 0
SF_NEXT_RUN:
	engine."load_indi"(I30)
    I0 = eval_body()
    I0 = I30 % 1000
    if I0 != 0 goto SF_RUN_SKIP_NL
    print I30
    print ":"
    print I0
    print "\n"
SF_RUN_SKIP_NL:    
    inc I30
    if I30 < I29 goto SF_NEXT_RUN
    print "\n"
ret


SSF_RUN:
	I30 = 0
SSF_NEXT_RUN:
	engine."load_indi"(I30)
    I0 = eval_body()
    inc I30
    if I30 < I29 goto SSF_NEXT_RUN
ret


D_INIT:    
	I30 = 0
D_INIT_NEXT:
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
    if I30 < I29 goto D_INIT_NEXT
ret


OPS_DUMP:
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
ret


DEBUG:
	I30 = 10
	print "initialize_todebug("
	print I30
	print ")\n"
	engine."initialize_todebug"(I30)

	print "engine.load_indi("
	print I30
	print ")\n"
	engine."load_indi"(I30)
	print "\n"

    print "eb_cdump():\n"
    engine."eb_cdump"()
    print "eb_cdump done\n\n"

    print "ei_cdump():\n"
    engine."ei_cdump"()
    print "ei_cdump done\n\n"

    print "eb_mdump():\n"
    engine."eb_mdump"()
    print "eb_mdump() done\n\n"

	print "--- 'I0 = eval_body()' output begin ---\n"
	I0 = eval_body()
	print "--- 'I0 = eval_body()' output end ---\n"
	print "I0 = "
	print I0
	print "\n\n"
ret

    
END:
	print "done\n"
#	print "Press any key to continue ...\n"
#	$P0 = getstdin
   
.end


.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub eval_body
	# init_indi hack - todo
	returncc
	bsr INDI_CORE

    S1 = "--- debug indi string ---\n"
	
# error
    save 0

#   set: 0
    I0 = 3
    I1 = 2
    I2 = 1
    I3 = 0
    bsr INDI_CORE
    I0 = 11
    bsr ERR
    save I31

#   set: 1
    I0 = 3
    I1 = 3
    I2 = 1
    I3 = 0
    bsr INDI_CORE
    I0 = 12
    bsr ERR
    save I31

#   set: 2
    I0 = 3
    I1 = 3
    I2 = 3
    I3 = 0
    bsr INDI_CORE
    I0 = 14
    bsr ERR
    save I31

#   set: 3
    I0 = 9
    I1 = 5
    I2 = 3
    I3 = 0
    bsr INDI_CORE
    I0 = 22
    bsr ERR
    set_returns "(0)", I31
    returncc

ERR:
    restore I31
#    print "restored I31 = "
#    print I31
#    print "\n"
    # error, I3 is indi destination register
    I0 = I3 - I0
#    print "sub error: "
#    print I0
#    print "\n"
    abs I0
    I0 = I0 * I0
    I31 = I31 + I0
#    print "new I31 = "
#    print I31
#    print "\n"
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

    ret

.end


