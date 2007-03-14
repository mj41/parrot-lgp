.sub main :main
    .const .Sub indi = 'indi'
    indi()
    print "done\n"
.end

.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub indi
    I1 = 0
    print "in sub1\n"
    I0 += 5
    I1 += 10

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

    returncc
.end
