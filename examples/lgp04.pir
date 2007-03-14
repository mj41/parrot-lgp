.sub main :main
    print "main start\n"
    .const .Sub indi = 'indi'
    indi()
    print "main end\n"
.end

.HLL "Some", "lgp"
.HLL_map .Sub, .LGP

.sub indi
    print "indi start\n"
    I1 = 0
    I0 += 5
    noop
    I1 += 10
    print "indi end\n"
    returncc
.end
