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
#   I0 + I0 + 5
    save 0

#   set: 0
    set I0, 1
    bsr INDI_CORE
    set I0, 7
    bsr CALC_FITNESS
    save I31

#   set: 1
    set I0, 2
    bsr INDI_CORE
    set I0, 9
    bsr CALC_FITNESS
    set_returns "(0)", I31
    returncc

CALC_FITNESS:
    restore I31
    sub I0, I1, I0
    abs I0
    mul I0, I0, I0
    add I31, I31, I0
    abs I31
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


    .local string pir_code_pi
    # PI prepared individuals
    pir_code_pi = <<'EOC_PI'

.namespace [ "PI" ]

.pcc_sub indi_copy:
    set I1, I0
    ret

.pcc_sub indi_zero:
    set I1, 0
    ret

.pcc_sub indi_double:
    add I1, I0, I0
    ret


.pcc_sub indi_double_plus_one:
    add I1, I0, I0
    add I1, 1
    ret

.pcc_sub indi_double_plus_two:
    add I1, I0, I0
    add I1, 2
    ret

.pcc_sub indi_double_plus_five:
    add I1, I0, I0
    add I1, 5
    ret

.pcc_sub indi_double_and_ret_inside:
    add I1, I0, I0
    ret
    add I1, 1
    ret

EOC_PI

    .local pmc pasm_compiler
    pasm_compiler = compreg "PASM"

    .local pmc eval_code
    push_eh COMPILE_ERR
    eval_code = pasm_compiler(pasm_eval_space)
    clear_eh

    .local pmc eval_space
    eval_space = get_global ['LGP'], 'eval_space'

    .local int tn # test number
    tn = 0

    engine.prepare_eval_space( eval_space )

    engine.set_pop_size(10)
    engine.validate_conf()

    push_eh COMPILE_ERR
    eval_code = pasm_compiler(pir_code_pi)
    clear_eh
    .local pmc prep_indi

    inc tn
    $S0 = 'indi_copy'
    $I0 = 85
    bsr TRY_PI

    inc tn
    $S0 = 'indi_zero'
    $I0 = 130
    bsr TRY_PI

    inc tn
    $S0 = 'indi_double'
    $I0 = 50
    bsr TRY_PI

    inc tn
    $S0 = 'indi_double_plus_one'
    $I0 = 32
    bsr TRY_PI

    inc tn
    $S0 = 'indi_double_plus_two'
    $I0 = 18
    bsr TRY_PI

    inc tn
    $S0 = 'indi_double_plus_five'
    $I0 = 0
    bsr TRY_PI

    inc tn
    $S0 = 'indi_double_and_ret_inside'
    $I0 = 50
    bsr TRY_PI

    end

TRY_PI:
    prep_indi = get_global ['PI'], $S0
    engine.set_ic( prep_indi )
#    engine.ei_cdump()

COMPARE_FITNESS:
    $I1 = eval_space()
    if $I0 == $I1 goto CF_OK
    print "not ok "
    print tn
    print " - "
    print $S0
    print ", fitness: "
    print $I0
    print ' != '
    print $I1
    print "\n"
    ret

CF_OK:
    print "ok "
    print tn
    print " - "
    print $S0
    print ", fitness: "
    print $I0
    print ' == '
    print $I1
    print "\n"
ret


FIND_TYPE_ERR:
    print "find_type for LGP failed\n"
    end
    
COMPILE_ERR:
    print "compilation failed\n"
    end   
.end


