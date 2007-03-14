    find_global P0, "_the_sub"
    set I2, 10
    invokecc P0
    print "back\n"
    end
.pcc_sub _the_sub:
    print "in sub\n"
    print I2
    print "\n"
    returncc
    