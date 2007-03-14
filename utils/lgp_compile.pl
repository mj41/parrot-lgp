use Time::HiRes qw(time); 
use strict;
use Cwd;

use lib 'C:\\usr\\PaP6-testing\\lib\\';
use Watchdog qw(sys);

my $cwd = cwd();
my $wd = 'C:/usr/PaP6-testing/parrot-devcpp';

sub run_cmd {
    my ( $cmd, $print_ok_outut ) = @_;
    
    my ($st, $out) = sys( $cmd, $wd . '/lgp-' . $cmd . '.out' );
    if ( $st ) {
        print "'$cmd' return: $st\n";
        print $out;
        print "\n";
        return 0;
    }
    print "$cmd [OK]\n";
    print $out if $print_ok_outut;
    return 1;
}

if ( $cwd ne $wd ) {
    chdir $wd || die;
}
chdir('./src/dynpmc') || die;
run_cmd( 'mingw32-make' ) || die;
chdir('../..') || die;

if ( $ARGV[0] eq '-t' ) {
    print "parrot trace on\n";
    run_cmd( 'parrot -S -t lgp13.pir', 1 );
    
} else {
    my $num = ( $ARGV[0] ) ? $ARGV[0] : 5;
    run_cmd( "parrot lgp13.pir $num", 1 );
}
