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
    pop_size = 5
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
    .local int i, fit, len
    .const .Sub lgp_body = 'lgp_body'
    best_inum = 0
    best_fitness = 9999999
    best_len = 9999999

    print "initial lgp_body() and init_indi():\n"
    lgp_body()
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

    fit = lgp_body()
    engine."set_indi_fitness"(inum,fit)

    if fit > best_fitness goto F_INIT_NB
    len = engine."indi_len"(inum)
    if fit < best_fitness goto F_INIT_B
    if fit >= best_len goto F_INIT_NB
F_INIT_B:
    best_inum = inum
    best_fitness = fit
    best_len = len
F_INIT_NB:

#    print inum
#    print ":"
#    print fit
#    print "  "
#    $I0 = engine."indi_fitness"(inum)
#    print fit
#    print "\n"

    inc inum
    if inum < pop_size goto F_INIT_NEXT
    bsr PRINT_POPULATION # debug
ret


F_RUN:
    inum = 0
    .local int ofit0, ofit1, nfit2, nfit3
    .local int olen0, olen1, nlen2, nlen3
    .local pmc parents
    .local int max_inum
    max_inum = pop_size * 10
    print "max fights:"
    print max_inum
    print "\n"

F_NEXT_RUN:
    print "running "
    print inum
    print "\n"
    
    # 0 is worst, 3 is best (less fitness)
    parents = engine."get_parents"()
# debug print parents nums
    print "parent numbers: inum="
    i = parents[0] 
    print i
    print " (fit:"
    fit = engine."indi_fitness"(i)
    print fit
    print "), inum="

    i = parents[1] 
    print i
    print " (fit:"
    fit = engine."indi_fitness"(i)
    print fit
    print "), inum="

    i = parents[2] 
    print i
    print " (fit:"
    fit = engine."indi_fitness"(i)
    print fit
    print "), inum="

    i = parents[3] 
    print i
    print " (fit:"
    fit = engine."indi_fitness"(i)
    print fit
    print ")\n"

    print "--- --- --- --- --- --- --- --- --- ---\n"
    i = parents[2]
    print "temp source inum="
    print i
    print "\n"
    
    engine."copy_to_temp"(i,0)
    i = 0
    bsr PRINT_TEMP_I
    
    engine."mutate_temp_naive"(0)
    nlen2 = engine."temp_indi_len"(0)
    
    i = 0
    bsr PRINT_TEMP_I
    print "--- --- --- --- --- --- --- --- --- ---\n"

    print "load_temp_indi(0)\n"
    engine."load_temp_indi"(0)

    print "lgp_body\n"
    nfit2 = lgp_body()

    i = parents[0]
    ofit0 = engine."indi_fitness"(i)
    olen0 = engine."indi_len"(i)

    if nfit2 > ofit0 goto F_SKIP_LT1
    if nfit2 < ofit0 goto F_RUN_RW1
    if nlen2 > olen0 goto F_SKIP_LT1

F_RUN_RW1:
    print "inum="
    print i
    print ", new fitness="
    print nfit2
    print ", new len="
    print nlen2
    print "\n"

    engine."set_temp_indi_fitness"(0,nfit2)
    engine."rewrite_by_temp"(i,0)

    print "after rewrite inum="
    print i
    print "\n"
    bsr PRINT_I

    if nfit2 > best_fitness goto F_SKIP_LT1
    if nfit2 < best_fitness goto F_RUN_B1
    if nlen2 > best_len goto F_SKIP_LT1
F_RUN_B1:
    print "rewriting best inum="
    print i
    print ", fitness="
    print nfit2
    print ", len="
    print nlen2
    print "\n"

    best_inum = i
    best_fitness = nfit2
    best_len = nlen2
    print "new "
    bsr PRINT_BEST
F_SKIP_LT1:

    print "--- --- --- --- --- --- --- --- --- ---\n"
    i = parents[3]
    print "temp source inum="
    print i
    print "\n"

    engine."copy_to_temp"(i,1)
    i = 1
    bsr PRINT_TEMP_I

    engine."mutate_temp_naive"(1)
    nlen3 = engine."temp_indi_len"(1)

    i = 1
    bsr PRINT_TEMP_I
    print "--- --- --- --- --- --- --- --- --- ---\n"

    print "load_temp_indi(0)\n"
    engine."load_temp_indi"(1)

    print "lgp_body\n"
    nfit3 = lgp_body()

    i = parents[1]
    ofit1 = engine."indi_fitness"(i)

    # less is better
    if nfit3 > ofit1 goto F_SKIP_LT2

    if nfit3 > ofit1 goto F_SKIP_LT2
    if nfit3 < ofit1 goto F_RUN_RW2
    if nlen3 > olen1 goto F_SKIP_LT2

F_RUN_RW2:
    print "inum="
    print i
    print ", new fitness="
    print nfit3
    print ", new len="
    print nlen3
    print "\n"

    engine."set_temp_indi_fitness"(1,nfit3)
    engine."rewrite_by_temp"(i,1)

    print "after rewrite inum="
    print i
    print "\n"
    bsr PRINT_I

    if nfit3 > best_fitness goto F_SKIP_LT2
    if nfit3 < best_fitness goto F_RUN_B2
    if nlen3 >= best_len goto F_SKIP_LT2
F_RUN_B2:
    print "rewriting best inum="
    print i
    print ", fitness="
    print nfit3
    print ", len="
    print nlen3
    print "\n"

    best_inum = i
    best_fitness = nfit3
    best_len = nlen3
    print "new "
    bsr PRINT_BEST
F_SKIP_LT2:
    
    print "running "
    print inum
    print " [ok]\n\n"

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
    # print population
    i = pop_size * 1
    i = inum % i
    if i != 0 goto SKIP_PRINT_INUM
    bsr PRINT_BEST # debug
    bsr PRINT_POPULATION # debug
SKIP_PRINT_INUM:    
    if inum < max_inum goto F_NEXT_RUN
    print "\n"
ret


PRINT_BEST:
    print "best indi: inum="
    print best_inum
    print ", fitness="
    print best_fitness

    print ", real fitness="
    $I0 = engine."indi_fitness"(best_inum)
    print $I0

    print ", len="
    print best_len

    print ", real len="
    $I0 = engine."indi_len"(best_inum)
    print $I0

    print ", code:\n"
    engine."indi_code"(best_inum)
    print "\n"
ret

PRINT_POPULATION:
    i = 0
    print "\n"
    print "printing full population:\n"
    
NEXT_IN_PRINT_POPULATION:
    bsr PRINT_I
    inc i
    if i < pop_size goto NEXT_IN_PRINT_POPULATION
ret

PRINT_I:
    print "indi: inum="
    print i
    print ", fitness="
    $I0 = engine."indi_fitness"(i)
    print $I0
    print ", len="
    $I0 = engine."indi_len"(i)
    print $I0
    print ", code:\n"
    engine."indi_code"(i)
    print "\n"
ret

PRINT_TEMP_I:
    print "temp_indi: inum="
    print i
    print ", fitness="
    $I0 = engine."temp_indi_fitness"(i)
    print $I0
    print ", len="
    $I0 = engine."temp_indi_len"(i)
    print $I0
    print ", code:\n"
    engine."temp_indi_code"(i)
    print "\n"
ret
    
END:
    bsr PRINT_POPULATION # debug
    print "this run "
    bsr PRINT_BEST
    print "done\n"
.end


.include 'parrot-lgp/t/lgp_body.pir'