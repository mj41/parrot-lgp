.sub main :main
    .local int pop_size
    get_params "(0)", P0
    set pop_size, P0
    eq pop_size, 2, PARAM_OK

	print "set default params\n"
	set pop_size, 3
	goto PARAMS_DONE
PARAM_OK:    
    set pop_size, P0[1]
PARAMS_DONE:

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
    if pop_size <= max_pop_size goto OK_POP_SIZE
    print "Max population size is "
    print max_pop_size
    print "\n"
    goto END
OK_POP_SIZE:

    .const .Sub eval_body = 'eval_body'

#    print "initial eval_body() and init_indi():\n"
    eval_body()
    engine."prepare_lgp"(pop_size)

    .local int inum
	bsr F_INIT
	bsr F_RUN
	goto END


F_INIT:
	print "initialization\n"
	inum = 0
F_INIT_NEXT:
	engine."initialize"(inum)
	engine."load_indi"(inum)

    I0 = eval_body()
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
    print "initialization [ok]\n"
ret


F_RUN:
	inum = 0
	.local int ofi0, ofi1, nfi2, nfi3
	.local int temp
	.local pmc parents

F_NEXT_RUN:
	print "running "
    print inum
    print "\n"
	
	parents = engine."get_parents"()

	temp = parents[2]
	engine."copy_to_temp"(temp,0)
	engine."mutate_temp"(0)
	engine."load_temp_indi"(0)
	nfi2 = eval_body()
	temp = parents[0]
	ofi0 = engine."indi_fitness"(temp)
	# less is better
	if nfi2 > ofi0 goto F_SKIP_LT1
    print "indi="
    print temp
    print ", new_fitness="
    print nfi2
    print "\n"
	engine."rewrite_by_temp"(temp,0)
    engine."set_indi_fitness"(temp,nfi2)
F_SKIP_LT1:

	temp = parents[3]
	engine."copy_to_temp"(temp,1)
	engine."mutate_temp"(1)
	engine."load_temp_indi"(1)
	nfi3 = eval_body()
	temp = parents[1]
	ofi1 = engine."indi_fitness"(temp)
	# less is better
	if nfi3 > ofi1 goto F_SKIP_LT2
    print "indi="
    print temp
    print ", new_fitness="
    print nfi3
    print "\n"
	engine."rewrite_by_temp"(temp,1)
    engine."set_indi_fitness"(temp,nfi3)
F_SKIP_LT2:
	
	print "running "
	print inum
	print " [ok]\n\n"
    inc inum
    if inum < 10 goto F_NEXT_RUN
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


