.sub main :main
    .local pmc lib
    lib = loadlib "LGP"
    loadlib P1, "LGP"
    find_type $I0, "LGP"
    new $P1, $I0
    $S0 = typeof $P1
    print "loaded: "
    print $S0
    print "\n"
    
    .const .Sub indi = 'indi'
    indi()
    print "indi() done\n\n"

    $P1."gvdump"()
    print "gvdump() done\n\n"

#    $P1."edump"()
#    print "edump() done\n\n"

    $P1."init_indi"()
    print "init_indi() done\n\n"

    $P1."edump"()
    print "edump() done\n\n"

    $P1."idump"()
    print "\n\n"
    I31 = indi()
    print "error: "
    print I31
    print "\n\n"

    $P1."new_indi"()
    print "new_indi() done\n\n"

    $P1."idump"()
    print "\n\n"
    I31 = indi()
    print "error: "
    print I31
    print "\n\n"

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
#    print "sub error: "
#    print I0
#    print "\n"
    abs I0
    I0 = I0 * I0
    I31 = I31 + I0
    ret

INDI_CORE:
#    print "-> indi_core\n"
    I3 += I0
    I3 += I1
    I3 += I2
    ret 
    
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

    print "test string\n"
    ret

.end


