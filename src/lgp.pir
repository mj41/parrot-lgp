# usign mutate_temp_naive
# 
.sub main :main
    get_params "(0)", $P10

    .local pmc lib
    lib = loadlib "LGP"
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
#   pop_size = max_pop_size
    pop_size = 50000
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
    print "after initialization "
    bsr PRINT_BEST
    print "\n"

    print "running ...\n\n"
    bsr F_RUN
    print "run [ok]\n"
    goto END


F_INIT:
    inum = 0
F_INIT_NEXT:
    engine."initialize"(inum)
    engine."load_indi"(inum)

    I0 = eval_body()
    engine."set_indi_fitness"(inum,I0)
    
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
#    I0 = engine."indi_fitness"(inum)
#    print I0
#    print "\n"

    inc inum
    if inum < pop_size goto F_INIT_NEXT
#    bsr PRINT_POPULATION # debug
ret


F_RUN:
    inum = 0
    .local int ofi0, ofi1, nfi2, nfi3
    .local int i
    .local pmc parents
    .local int max_inum
    max_inum = pop_size * 60

F_NEXT_RUN:
#   print "running "
#    print inum
#    print "\n"
    
    # 0 is worst, 3 is best (less fitness)
    parents = engine."get_parents"()
# debug print parents nums
#   i = parents[0] 
#   print i
#   print " "
#   i = parents[1] 
#   print i
#   print " "
#   i = parents[2] 
#   print i
#   print " "
#   i = parents[3] 
#   print i
#   print "\n"

    i = parents[2]
    engine."copy_to_temp"(i,0)

#    print "temp_indi_code(0):\n"
#    engine."temp_indi_code"(0)
#    print "\n"
    
    engine."mutate_temp_naive"(0)

#    print "temp_indi_code(0):\n"
#    engine."temp_indi_code"(0)
#    print "\n"
#   ret # debug

#   print "load_temp_indi(0)\n"
    engine."load_temp_indi"(0)
#   print "eval_body\n"
    nfi2 = eval_body()
    i = parents[0]
    ofi0 = engine."indi_fitness"(i)
    # less is better
    if nfi2 > ofi0 goto F_SKIP_LT1
#    print "indi="
#    print i
#    print ", new_fitness="
#    print nfi2
#    print "\n"
    engine."rewrite_by_temp"(i,0)
    engine."set_indi_fitness"(i,nfi2)

    if nfi2 > best_fitness goto F_RUN_NB1
    I1 = engine."indi_len"(i)
    if nfi2 < best_fitness goto F_RUN_B1
    if I1 >= best_len goto F_RUN_NB1
F_RUN_B1:
    best_inum = i
    best_fitness = nfi2
    best_len = I1
    bsr PRINT_BEST
F_RUN_NB1:
F_SKIP_LT1:

    i = parents[3]
    engine."copy_to_temp"(i,1)
    engine."mutate_temp_naive"(1)
    engine."load_temp_indi"(1)
    nfi3 = eval_body()
    i = parents[1]
    ofi1 = engine."indi_fitness"(i)
    # less is better
    if nfi3 > ofi1 goto F_SKIP_LT2
#    print "indi="
#    print i
#    print ", new_fitness="
#    print nfi3
#    print "\n"
    engine."rewrite_by_temp"(i,1)
    engine."set_indi_fitness"(i,nfi3)

    if nfi3 > best_fitness goto F_RUN_NB2
    I1 = engine."indi_len"(i)
    if nfi3 < best_fitness goto F_RUN_B2
    if I1 >= best_len goto F_RUN_NB2
F_RUN_B2:
    best_inum = i
    best_fitness = nfi3
    best_len = I1
    print "new "
    bsr PRINT_BEST
F_RUN_NB2:
F_SKIP_LT2:
    
#   print "running "
#   print inum
#   print " [ok]\n\n"

    inc inum

    i = inum % pop_size
    if i != 0 goto SKIP_PRINT_INUM
    print "gen "
    i = inum / pop_size
    print i
    print ", fights "
    print inum
    print " ( max gen "
    i = max_inum / pop_size
    print i
    print ", max fights "
    print max_inum
    print " )\n"
#    # print population
#    i = pop_size * 20
#    i = inum % i
#    if i != 0 goto SKIP_PRINT_INUM
#    bsr PRINT_POPULATION # debug
SKIP_PRINT_INUM:
    if inum < max_inum goto F_NEXT_RUN
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

PRINT_POPULATION:
    i = 0
    print "\n"
    print "printing full population:\n"
    
NEXT_IN_PRINT_POPULATION:
    print "indi: inum="
    print i
    print ", fitness="
    I0 = engine."indi_fitness"(i)
    print I0
    print ", len="
    I0 = engine."indi_len"(i)
    print I0
    print ", code:\n"
    engine."indi_code"(i)
    print "\n"
    inc i
    if i < pop_size goto NEXT_IN_PRINT_POPULATION
ret
    
END:
    bsr PRINT_POPULATION # debug
    print "this run "
    bsr PRINT_BEST
    print "done\n"
.end


.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub eval_body
    # init_indi hack - todo
    returncc
    bsr INDI_CORE

# i1 + i2 + i3 + 5
# 3 2 1 - 11
# 3 3 1 - 12
# 3 3 3 - 14
# 9 5 3 - 22

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


