.loadlib "lgp"

.sub main :main
    get_params "(0)", $P10

    $I0 = find_type "LGP"
    if $I0 == 0 goto FIND_TYPE_ERR
    
    .local pmc engine
    new engine, $I0

    .local int max_pop_size
    max_pop_size = engine."max_pop_size"()

    .local int pop_size
    $I10 = $P10
    eq $I10, 2, PS_PARAM_OK

    print "setting default params\n"
    #pop_size = max_pop_size
    pop_size = 10                                #@ pop_size = 100000
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

    .local string pasm_eval_space

    pasm_eval_space = <<'EOC_LGP'

.namespace [ "LGP" ]

.pcc_sub eval_space:
    # i1 + i2 + i3 + 5
    # 3 2 1 - 11
    # 3 3 1 - 12
    # 3 3 3 - 14
    # 9 5 3 - 22

#    print "null fitness\n"
    save 0

    # set: 0
    set I0, 3
    set I1, 2
    set I2, 1
    set I3, 0
    bsr INDI_CORE
    set I0, 11
    bsr CALC_FITNESS
    save I31

    # set: 1
    set I0, 3
    set I1, 3
    set I2, 1
    set I3, 0
    bsr INDI_CORE
    set I0, 12
    bsr CALC_FITNESS
    save I31

    # set: 2
    set I0, 3
    set I1, 3
    set I2, 3
    set I3, 0
    bsr INDI_CORE
    set I0, 14
    bsr CALC_FITNESS
    save I31

    # set: 3
    set I0, 9
    set I1, 5
    set I2, 3
    set I3, 0
    bsr INDI_CORE
    set I0, 22
    bsr CALC_FITNESS

#    print "fintess: "
#    print I31
#    print "\n\n"
    set_returns "(0)", I31
    returncc

CALC_FITNESS:
    restore I31
#    print "restored I31 = "
#    print I31
#    print "\n"
    # error, I3 is indi destination register
    sub I0, I3, I0
#    print "sub error: "
#    print I0
#    print "\n"
    abs I0
    mul I0, I0, I0
    add I31, I31, I0
    abs I31
#    print "new I31 = "
#    print I31
#    print "\n"
    ret

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

    engine.set_pop_size(pop_size)
    engine.validate_conf()


    .local int best_inum, best_fitness, best_len
    .local int i, fit, len
    best_inum = 0
    best_fitness = 9999999
    best_len = 9999999

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

    fit = eval_space()
    engine."set_indi_fitness"(inum,fit)

    if fit > best_fitness goto F_SKIP_NB
    len = engine."indi_len"(inum)
    if fit < best_fitness goto F_INIT_B
    if len >= best_len goto F_SKIP_NB
F_INIT_B:
    best_inum = inum
    best_fitness = fit
    best_len = len
F_SKIP_NB:

#    print inum
#    print ":"
#    print fit
#    print "  "
#    $I0 = engine."indi_fitness"(inum)
#    print fit
#    print "\n"

    inc inum
    if inum < pop_size goto F_INIT_NEXT
    bsr PRINT_POPULATION                         #@
ret


F_RUN:
    inum = 0
    .local int ofit0, ofit1, nfit2, nfit3
    .local int olen0, olen1, nlen2, nlen3
    .local pmc parents
    .local int max_inum
    max_inum = pop_size * 10                     #@ max_inum = pop_size * 50
    print "max fights:"
    print max_inum
    print "\n"

F_NEXT_RUN:
    print "running "                             #@
    print inum                                   #@
    print "\n"                                   #@
    
    # 0 is worst, 3 is best (less fitness)
    parents = engine."get_parents"()
    # debug print parents nums                   #@
    print "parent numbers: inum="                #@
    i = parents[0]                               #@
    print i                                      #@
    print " (fit:"                               #@
    fit = engine."indi_fitness"(i)               #@
    print fit                                    #@
    print "), inum="                             #@
                                                 #@
    i = parents[1]                               #@
    print i                                      #@
    print " (fit:"                               #@
    fit = engine."indi_fitness"(i)               #@
    print fit                                    #@
    print "), inum="                             #@
                                                 #@
    i = parents[2]                               #@
    print i                                      #@
    print " (fit:"                               #@
    fit = engine."indi_fitness"(i)               #@
    print fit                                    #@
    print "), inum="                             #@
                                                 #@
    i = parents[3]                               #@
    print i                                      #@
    print " (fit:"                               #@
    fit = engine."indi_fitness"(i)               #@
    print fit                                    #@
    print ")\n"                                  #@

    i = parents[2]
    print "--- --- --- --- --- --- ---\n"        #@
    print "temp source inum="                    #@
    print i                                      #@
    print "\n"                                   #@
    
    engine."copy_to_temp"(i,0)
    i = 0                                        #@
    bsr PRINT_TEMP_I                             #@

    engine."mutate_temp_naive"(0)
    nlen2 = engine."temp_indi_len"(0)

    i = 0                                        #@
    bsr PRINT_TEMP_I                             #@
 
    print "--- --- --- --- --- --- ---\n"        #@
    print "load_temp_indi(0)\n"                  #@
    engine."load_temp_indi"(0)

    print "eval_space\n"                         #@
    nfit2 = eval_space()

    i = parents[0]
    ofit0 = engine."indi_fitness"(i)
    olen0 = engine."indi_len"(i)

    if nfit2 > ofit0 goto F_SKIP_LT1
    if nfit2 < ofit0 goto F_RUN_RW1
    if nlen2 > olen0 goto F_SKIP_LT1

F_RUN_RW1:
    print "inum="                                #@
    print i                                      #@
    print ", new fitness="                       #@
    print nfit2                                  #@
    print ", new len="                           #@
    print nlen2                                  #@
    print "\n"                                   #@

    engine."set_temp_indi_fitness"(0,nfit2)
    engine."rewrite_by_temp"(i,0)

    print "after rewrite inum="                  #@
    print i                                      #@
    print "\n"                                   #@
    bsr PRINT_I                                  #@

    if nfit2 > best_fitness goto F_SKIP_LT1
    if nfit2 < best_fitness goto F_RUN_B1
    if nlen2 >= best_len goto F_SKIP_LT1

F_RUN_B1:
    print "rewriting best inum="                 #@
    print i                                      #@
    print ", fitness="                           #@
    print nfit2                                  #@
    print ", len="                               #@
    print nlen2                                  #@
    print "\n"                                   #@

    best_inum = i
    best_fitness = nfit2
    best_len = nlen2
    print "new "
    bsr PRINT_BEST
F_SKIP_LT1:

    i = parents[3]
    print "--- --- --- --- --- --- ---\n"        #@
    print "temp source inum="                    #@
    print i                                      #@
    print "\n"                                   #@

    engine."copy_to_temp"(i,1)
    i = 1                                        #@
    bsr PRINT_TEMP_I                             #@

    engine."mutate_temp_naive"(1)
    nlen3 = engine."temp_indi_len"(1)

    i = 1                                        #@
    bsr PRINT_TEMP_I                             #@
    print "--- --- --- --- --- --- ---\n"        #@
    print "load_temp_indi(0)\n"                  #@

    engine."load_temp_indi"(1)

    print "eval_space\n"                         #@
    nfit3 = eval_space()

    i = parents[1]
    ofit1 = engine."indi_fitness"(i)

    # less is better
    if nfit3 > ofit1 goto F_SKIP_LT2

    if nfit3 > ofit1 goto F_SKIP_LT2
    if nfit3 < ofit1 goto F_RUN_RW2
    if nlen3 > olen1 goto F_SKIP_LT2

F_RUN_RW2:
    print "inum="                                #@
    print i                                      #@
    print ", new fitness="                       #@
    print nfit3                                  #@
    print ", new len="                           #@
    print nlen3                                  #@
    print "\n"                                   #@

    engine."set_temp_indi_fitness"(1,nfit3)
    engine."rewrite_by_temp"(i,1)

    print "after rewrite inum="                  #@
    print i                                      #@
    print "\n"                                   #@
    bsr PRINT_I                                  #@

    if nfit3 > best_fitness goto F_SKIP_LT2
    if nfit3 < best_fitness goto F_RUN_B2
    if nlen3 >= best_len goto F_SKIP_LT2

F_RUN_B2:
    print "rewriting best inum="                 #@
    print i                                      #@
    print ", fitness="                           #@
    print nfit3                                  #@
    print ", len="                               #@
    print nlen3                                  #@
    print "\n"                                   #@

    best_inum = i
    best_fitness = nfit3
    best_len = nlen3
    print "new "
    bsr PRINT_BEST
F_SKIP_LT2:
    
    print "running "                             #@
    print inum                                   #@
    print " [ok]\n\n"                            #@

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
    # print population                           #@
    i = pop_size * 1                             #@
    i = inum % i                                 #@
    if i != 0 goto SKIP_PRINT_INUM               #@
    bsr PRINT_BEST # debug                       #@
    bsr PRINT_POPULATION # debug                 #@
SKIP_PRINT_INUM:    
    if inum < max_inum goto F_NEXT_RUN
    print "\n"
ret


PRINT_BEST:
    print "best indi: inum="
    print best_inum
    print ", fitness="
    print best_fitness

    print ", real fitness="                      #@
    $I0 = engine."indi_fitness"(best_inum)       #@
    print $I0                                    #@

    print ", len="
    print best_len

    print ", real len="                          #@
    $I0 = engine."indi_len"(best_inum)           #@
    print $I0                                    #@

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

PRINT_TEMP_I:                                    #@
    print "temp_indi: inum="                     #@
    print i                                      #@
    print ", fitness="                           #@
    $I0 = engine."temp_indi_fitness"(i)          #@
    print $I0                                    #@
    print ", len="                               #@
    $I0 = engine."temp_indi_len"(i)              #@
    print $I0                                    #@
    print ", code:\n"                            #@
    engine."temp_indi_code"(i)                   #@
    print "\n"                                   #@
ret                                              #@


# errors
FIND_TYPE_ERR:
    print "find_type for LGP failed\n"
    end
    
COMPILE_ERR:
    print "compilation failed\n"
    end   


# end
END:
    bsr PRINT_POPULATION # debug                 #@
    print "this run "
    bsr PRINT_BEST
    print "done\n"
    end

.end
