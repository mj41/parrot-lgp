.sub main :main
    .const .Sub indi = 'indi'
    indi()
    print "done\n"
.end

.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub indi
    save 0

# error
    I31 = 0
    save I31

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

# print error
    print "error: "
    print I31
    print "\n"

    branch RETURN  

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

    noop
    noop
    noop
    noop
    noop
    print "error: second ERR return\n"
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

    print "error: second INDI_CORE return\n"
    ret

RETURN:
    returncc

.end


