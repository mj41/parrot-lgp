.HLL "lgp", "lgp_group"
.HLL_map .Sub, .LGP

.sub lgp_body
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


