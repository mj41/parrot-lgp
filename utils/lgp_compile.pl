use Time::HiRes qw(time); 
use strict;
use Cwd;

use lib 'C:\\usr\\PaP6-testing\\lib\\';
use Watchdog qw(sys);

my $cwd = cwd();
my $wd = 'C:/usr/PaP6-testing/parrot-devcpp';

sub run_cmd {
    my ( $cmd, $print_ok_outut ) = @_;
    
    print "runnig '$cmd'\n";
    my ($st, $out) = sys( $cmd, $wd . '/lgp-' . $cmd . '.out' );
    print "'${cmd}' return code = ${st}\n";
    if ( $st ) {
        print "'$cmd' return: $st\n";
        print $out;
        print "\n";
        return 0;
    }
    
    if ( $out =~ /error/ms ) {
        print "'$cmd' return: $st, but error in output found\n";
        print $out;
        print "\n";
        return 0;
    }
    
    print "$cmd [OK]\n";
    if ( $print_ok_outut ) {
        print "\n";   
        print $out;
    }
    return 1;
}

if ( $cwd ne $wd ) {
    chdir $wd || die;
}
chdir('./src/dynpmc') || die;
run_cmd( 'mingw32-make' ) || die "make failed\n";
chdir('../..') || die;

my $script = @ARGV[0];
if ( $script ) {
    if ( $ARGV[0] eq '-t' ) {
        print "parrot trace on\n";
        run_cmd( 'parrot -t ' . $script, 1 );

    } else {
        my $num = ( $ARGV[1] ) ? $ARGV[1] : 5;
        run_cmd( 'parrot  ' . $script . ' ' . $num, 1 );
    }
}

