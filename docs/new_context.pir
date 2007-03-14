.sub _main :main
   	print "in main\n"
   	print "setting I0 to 10\n"
   	I0 = 10
    print "I0 = "
    print I0
    print "\n"
   	print "running indi()\n"
   	indi()
   	print "back in main\n"
    print "I0 = "
    print I0
    print "\n"
.end

.sub indi
    print "in sub indi()\n"
    print "I0 = "
    print I0
    print "\n"
   	print "setting I0 to 20\n"
    I0 = 20
    print "I0 = "
    print I0
    print "\n"
.end
