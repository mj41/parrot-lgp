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
  
#$cmd = 'parrot.exe -C lgp12.pir 100000'; # 10 x 100tis
#$cmd = 'parrot.exe -f lgp12.pir 100000'; # 10 x 100tis
#$cmd = 'parrot.exe -g lgp12.pir 100000'; # 10 x 100tis
#$cmd = 'parrot.exe -j lgp12.pir 100000'; # 10 x 100tis
#$cmd = 'parrot.exe -S lgp12.pir 100000'; # 10 x 100tis
$cmd = 'parrot.exe lgp13.pir'; # 10 x 100tis + 900tis


my $num = 100;
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
print "average sum time: $t_avr"
