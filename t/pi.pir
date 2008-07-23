# load dynclass - src/dynpmc/lgp.pmc
.loadlib "lgp"

.sub main :main
    # find LGP pmc type
    $I0 = find_type "LGP"
    if $I0 == 0 goto FIND_TYPE_ERR

    # create linear genetic programming engine PMC
    .local pmc engine
    new engine, $I0

    # eval space code
    # eval space contain space for individual of max_indi_len length
    .local string pasm_eval_space

    pasm_eval_space = <<'EOC_LGP'

.namespace [ "LGP" ]

.pcc_sub eval_space:

    # function to find: I0 + I0 + 5
    # dataset:
    #  [ [ 1 ], [ 7 ] ],   # I0 + I0 + 5 = 1 + 1 + 5 = 7
    #  [ [ 2 ], [ 9 ] ]    # I0 + I0 + 5 = 2 + 2 + 5 = 9
    #    -----  -----
    #      |      |
    #    input   output
    #    (I0)     (I1)

    # dataset part 0
    set I0, 1               # input dataset part - [ 1 ]
    set I1, 0               # null output register
    bsr INDI_CORE           # run individual code, output is saved to I1
    set I0, 7               # set correct output -  [ 7 ]
    set I2, 0               # set initial fitness
    bsr ADD_PFITNESS        # add this evaluation partial fitness to fitness

    # dataset part 1
    set I0, 2               # input dataset part - [ 2 ]
    set I1, 0               # null output register
    bsr INDI_CORE           # run individual code, output is saved to I1
    set I0, 9               # set correct output -  [ 9 ]
    bsr ADD_PFITNESS        # add this evaluation partial fitness to fitness
    set_returns "(0)", I2   # prepare to return final fitness
    returncc

# I2 += (correct_output-individual_output)^2
ADD_PFITNESS:
    sub I0, I1, I0          # correct_output-individual_output
    abs I0                  # overflow "control"
    mul I0, I0, I0          # ^2
    add I2, I2, I0          # I2 +=
    abs I2                  # overflow "control"
    ret

# end of first part of eval space code
EOC_LGP

    # add individual part to eval space, to fill 'indi_max_len' (maximum individual code length)
    # adding indi core
    pasm_eval_space = concat "INDI_CORE:\n"
    .local int noops_to_add
    noops_to_add = engine.'indi_max_len'()
    noops_to_add -= 3 # number of 'noop' instructions to add ('bsr' -2, 'ret' -1)
ADD_NOOP:
    pasm_eval_space = concat "    noop\n"
    noops_to_add -= 1
    if noops_to_add > 0 goto ADD_NOOP
    # add this two instructions instead of 'noop' ones
    # used by prepare_eval_space() to find first instruction of individual part inside eval space
    pasm_eval_space = concat "    bsr INDI_CORE\n"
    pasm_eval_space = concat "    ret\n"


    # create prepared individuals code
    # use PASM compiler, PASM is prefered instead of PIR
    .local string pir_code_pi
    # PI prepared individuals
    pir_code_pi = <<'EOC_PI'

.namespace [ "PI" ]

# output = I0
.pcc_sub indi_copy:
    set I1, I0
    ret

# output = 0
.pcc_sub indi_zero:
    set I1, 0
    ret

# output = I0 + I0
.pcc_sub indi_double:
    add I1, I0, I0
    ret

# output = I0 + I0 + 1
.pcc_sub indi_double_plus_one:
    add I1, I0, I0
    add I1, 1
    ret

# output = I0 + I0 + 2
.pcc_sub indi_double_plus_two:
    add I1, I0, I0
    add I1, 2
    ret

# output = I0 + I0 + 5
.pcc_sub indi_double_plus_five:
    add I1, I0, I0
    add I1, 5
    ret

# output = I0 + I0
# another (death) instruction after return
.pcc_sub indi_double_and_ret_inside:
    add I1, I0, I0
    ret
    add I1, 1
    ret

EOC_PI

    # create PASM compiler
    .local pmc pasm_compiler
    pasm_compiler = compreg "PASM"

    # compile eval space code
    .local pmc eval_code
    push_eh COMPILE_ERR
    eval_code = pasm_compiler(pasm_eval_space)
    pop_eh

    # get eval space subpmc
    .local pmc eval_space
    eval_space = get_global ['LGP'], 'eval_space'

    .local int tn # test number
    tn = 0

    # eval space preparation
    # find pointers to begins and ends of eval space and
    #   individual part of evals space (inside lgp.pmc)
    engine.prepare_eval_space( eval_space )

    # create small population
    engine.set_pop_size(10)
    # validate configuration
    engine.validate_conf()

    # compile code with prepared individuals
    push_eh COMPILE_ERR
    eval_code = pasm_compiler(pir_code_pi)
    pop_eh

    print "1..7\n"      # print test plan

    .local pmc prep_indi # prepared indi sub

    inc tn              # increase test number
    $S0 = 'indi_copy'   # use first prepared individual
    # correct fitness of individual 'indi_copy'
    # SUM( (correct output - indi_copy output)^2 )
    # (7-1)^2 + (9-2)^2 = 36 + 49 = 85
    $I0 = 85

    bsr TRY_PI

    inc tn
    $S0 = 'indi_zero'
    # (7-0)^2 + (9-0)^2
    $I0 = 130
    bsr TRY_PI

    inc tn
    $S0 = 'indi_double'
    # (7-(1+1))^2 + (9-(2+2))^2  = 5^2 + 5^2
    $I0 = 50
    bsr TRY_PI

    inc tn
    $S0 = 'indi_double_plus_one'
    # (7-(1+1+1)^2 + (9-(2+2+1))^2 = 4^2 + 4^2
    $I0 = 32
    bsr TRY_PI

    inc tn
    $S0 = 'indi_double_plus_two'
    # (7-(1+1+2)^2 + (9-(2+2+2))^2 = 3^2 + 3^2
    $I0 = 18
    bsr TRY_PI

    inc tn
    $S0 = 'indi_double_plus_five'
    # (7-(1+1+5)^2 + (9-(2+2+5))^2 = 0^2 + 0^2
    $I0 = 0
    bsr TRY_PI

    inc tn
    $S0 = 'indi_double_and_ret_inside'
    # same as 'indi_double'
    $I0 = 50
    bsr TRY_PI

    end

# test body
TRY_PI:
    prep_indi = get_global ['PI'], $S0  # get prepared individual sub with name $S0
    engine.set_ic( prep_indi )          # set individual code inside eval space to code prep_indi sub
    # engine.ic_cdump()                 # debug, print eval space individual code

    # evaluate eval space
    $I1 = eval_space()
    # compare fitness and print 'ok' or 'not ok' and some info
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

# exceptin handling
# loading LGP pmc failed
FIND_TYPE_ERR:
    print "find_type for LGP failed\n"
    end

# compilation failed
COMPILE_ERR:
    print "compilation failed\n"
    end
.end
