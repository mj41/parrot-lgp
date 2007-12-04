use Time::HiRes qw(time);
use strict;

my ( $t_start, $t_stop, $t_diff );
my $t_sum;

my $cmd;
#  -C --CGP-core
#  -f --fast-core
#  -g --computed-goto-core
#  -j --jit-core
#  -S --switched-core

my $pop_size = defined($ARGV[0]) ? $ARGV[0] : 250_000;
$cmd = "parrot\\parrot.exe parrot-lgp\\src\\lgp.pir $pop_size";
print "cmd: '$cmd'\n";

my $num = 50;
for (1..$num) {
    print "run number: $_\n";
    $t_start = time();
    system( $cmd );
    $t_stop = time();
    $t_diff = $t_stop - $t_start;
    $t_sum += $t_diff;
    print "full time: $t_diff\n";
    print "\n";
}

my $t_avr = $t_sum / $num;
print "average sum time: $t_avr";
