.sub main :main
    get_params "(0)", $P10

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

	.local int max_pop_size
	max_pop_size = engine."max_pop_size"()

    .local int pop_size
    $I10 = $P10
    eq $I10, 2, PS_PARAM_OK

	print "setting default params\n"
#	pop_size = max_pop_size
	pop_size = 10
	print "pop_size="
	print pop_size
	print "\n"
	goto PARAMS_DONE

PS_PARAM_OK:    
    pop_size = $P10[1]
    if pop_size <= max_pop_size goto OK_POP_SIZE
    print "Max population size is "
    print max_pop_size
    print "\n"
    goto END
OK_POP_SIZE:
PARAMS_DONE:

    .local int best_inum, best_fitness, best_len
    .const .Sub eval_body = 'eval_body'
	best_inum = 0
	best_fitness = 9999999
	best_len = 9999999

#    print "initial eval_body() and init_indi():\n"
    eval_body()
    engine."prepare_lgp"(pop_size)

    .local int inum
	print "initialization\n"
	bsr F_INIT
    print "initialization [ok]\n"
    bsr PRINT_BEST

	print "run\n"
	bsr F_RUN
	print "run [ok]\n"
	goto END


F_INIT:
	inum = 0
F_INIT_NEXT:
	engine."initialize"(inum)
	engine."load_indi"(inum)

    I0 = eval_body()

    if I0 > best_fitness goto F_INIT_NB
    I1 = engine."indi_len"(inum)
    if I0 < best_fitness goto F_INIT_B
    if I1 >= best_len goto F_INIT_NB
F_INIT_B:
    best_inum = inum
    best_fitness = I0
    best_len = I1
F_INIT_NB:

#    print inum
#    print ":"
#    print I0
#    print "  "
    engine."set_indi_fitness"(inum,I0)
#    I0 = engine."indi_fitness"(inum)
#    print I0
#    print "\n"

    inc inum
    if inum < pop_size goto F_INIT_NEXT
ret


F_RUN:
	inum = 0
	.local int ofi0, ofi1, nfi2, nfi3
	.local int temp
	.local pmc parents

F_NEXT_RUN:
#	print "running "
#    print inum
#    print "\n"
	
	# 0 is worst, 3 is best (less fitness)
	parents = engine."get_parents"()

	temp = parents[2]
	engine."copy_to_temp"(temp,0)
	engine."mutate_temp"(0)
	engine."load_temp_indi"(0)
	nfi2 = eval_body()
	temp = parents[0]
	ofi0 = engine."indi_fitness"(temp)
	# less is better
	if nfi2 >= ofi0 goto F_SKIP_LT1
#    print "indi="
#    print temp
#    print ", new_fitness="
#    print nfi2
#    print "\n"
	engine."rewrite_by_temp"(temp,0)
    engine."set_indi_fitness"(temp,nfi2)

    if nfi2 > best_fitness goto F_RUN_NB1
    I1 = engine."indi_len"(temp)
    if nfi2 < best_fitness goto F_RUN_B1
    if I1 >= best_len goto F_RUN_NB1
F_RUN_B1:
    best_inum = inum
    best_fitness = nfi2
    best_len = I1
    bsr PRINT_BEST
F_RUN_NB1:
F_SKIP_LT1:

	temp = parents[3]
	engine."copy_to_temp"(temp,1)
	engine."mutate_temp"(1)
	engine."load_temp_indi"(1)
	nfi3 = eval_body()
	temp = parents[1]
	ofi1 = engine."indi_fitness"(temp)
	# less is better
	if nfi3 >= ofi1 goto F_SKIP_LT2
#    print "indi="
#    print temp
#    print ", new_fitness="
#    print nfi3
#    print "\n"
	engine."rewrite_by_temp"(temp,1)
    engine."set_indi_fitness"(temp,nfi3)

    if nfi3 > best_fitness goto F_RUN_NB2
    I1 = engine."indi_len"(temp)
    if nfi3 < best_fitness goto F_RUN_B2
    if I1 >= best_len goto F_RUN_NB2
F_RUN_B2:
    best_inum = inum
    best_fitness = nfi3
    best_len = I1
    bsr PRINT_BEST
F_RUN_NB2:
F_SKIP_LT2:
	
#	print "running "
#	print inum
#	print " [ok]\n\n"
    inc inum
    if inum < 9900000 goto F_NEXT_RUN
#    if inum < 900 goto F_NEXT_RUN
    print "\n"
ret


PRINT_BEST:
    print "best indi: inum="
    print best_inum
    print ", fitness="
    print best_fitness
    print ", len="
    print best_len
    print ", code:\n"
	engine."indi_code"(best_inum)
	print "\n"
ret

    
END:
	print "done\n"
.end


.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub eval_body
	# init_indi hack - todo
	returncc
	bsr INDI_CORE

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
    abs I31
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


