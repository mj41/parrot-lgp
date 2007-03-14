use Time::HiRes qw(time); 
use strict;

my ( $t_start, $t_stop, $t_diff );
my $t_sum;

my $cmd;
$cmd = 'parrot.exe lgp07.pir 1000'; # 10tis
$cmd = 'parrot.exe lgp07.pir 10000'; # 10tis
$cmd = 'parrot.exe lgp07.pir 100000'; # 100tis
$cmd = 'parrot.exe lgp07.pir 1000000'; # 1mil
#$cmd = 'parrot.exe lgp07.pir 100000000'; # 10mil
#$cmd = 'parrot.exe lgp07.pir 1000000000'; # 100mil
#$cmd = 'parrot.exe lgp07.pir 10000000000'; # 1mld

my $num = 10;
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
