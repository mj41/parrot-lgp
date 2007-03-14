.sub main :main
    get_params "(0)", P5
    set I29, P5
    ne I29, 2, PARAM_ERROR
    set I29, P5[1]

    .local pmc lib
    lib = loadlib "LGP"
    loadlib P1, "LGP"
    find_type $I0, "LGP"
    new $P1, $I0
    $S0 = typeof $P1
    print "loaded dynpmc: "
    print $S0
    print "\n"
    
    .const .Sub indi = 'indi'
    indi()
    print "indi() done\n"
    $P1."init_indi"()
    print "init_indi done\n"

    set I30, I29
    
NEXT_INDI:
    $P1."new_indi"()
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
    
    
PARAM_ERROR:
    print "param error\n"    

END:
	print "done\n"
	print "Press any key to continue ...\n"
	$P0 = getstdin
   
.end

.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub indi
    returncc
    
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
#    print "-> indi_core\n"
    I3 += I0
    I3 += I1
    I3 += I2
    I3 += I0
    I3 += I1
    I3 += I2
    I3 += I0
    I3 += I1
    I3 += I2
    I3 += I0

    I3 -= I1
    I3 -= I2
    I3 -= I0
    I3 -= I1
    I3 -= I2
    I3 -= I0
    I3 -= I1
    I3 -= I2
    I3 -= I0
    I3 -= I1

    I3 += I2
    I3 += I0
    I3 += I1
    I3 += I2
    I3 += I0
    I3 += I1
    I3 += I2
    I3 += I0
    I3 += I1
    I3 += I2

    I3 *= I2
    I3 *= I0
    I3 *= I1
    I3 *= I2
    I3 *= I0
    I3 *= I1
    I3 *= I2
    I3 *= I0
    I3 *= I1
    I3 *= I2

    I3 /= I2
    I3 /= I0
    I3 /= I1
    I3 /= I2
    I3 /= I0
    I3 /= I1
    I3 /= I2
    I3 /= I0
    I3 /= I1
    I3 /= I2
    ret

.end


