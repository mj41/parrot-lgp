cls
@perl parrot-lgp\utils\lgp_compile.pl && echo --- && perl parrot-lgp\t\lgp.t && echo --- && parrot\parrot.exe parrot-lgp\t\pi.pir && echo --- && echo done ok
