use Time::HiRes qw(time); 
use strict;
use Cwd;

my $cwd = cwd();
my $wd = $cwd . '/parrot';

sub sys {
    my ( $cmd, $temp_out_fn ) = @_;

    my $output;
    $temp_out_fn = '.out' unless $temp_out_fn;
    
    open my $oldout, ">&STDOUT"     or die "Can't dup STDOUT: $!";
    open OLDERR,     ">&", \*STDERR or die "Can't dup STDERR: $!";

    open STDOUT, '>', $temp_out_fn or die "Can't redirect STDOUT to '$temp_out_fn': $! $@";
    open STDERR, ">&STDOUT"     or die "Can't dup STDOUT: $!";

    select STDERR; $| = 1;      # make unbuffered
    select STDOUT; $| = 1;      # make unbuffered
    
    select $oldout; $| = 1;
    select OLDERR; $| = 1;
    
    my $status = system($cmd);

    close STDOUT;
    close STDERR;

    open STDOUT, ">&", $oldout or die "Can't dup \$oldout: $!";
    open STDERR, ">&OLDERR"    or die "Can't dup OLDERR: $!";

    unless ( open( FH_STDOUT, "<$temp_out_fn") ) {
        carp("File $temp_out_fn not open!");
        unlink $temp_out_fn;
        next;
    }
    {
        local $/ = undef;
        $output = <FH_STDOUT>;
    }
    close FH_STDOUT;
    print "'$cmd' '$status'\n";
    return ( $status, $output );
}


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

chdir $wd || die;
chdir('./src/dynpmc') || die;
run_cmd( 'mingw32-make' ) || die "make failed\n";
chdir('../..') || die;

my $script = $ARGV[0];
if ( $script ) {
    if ( $script eq '-t' ) {
        $script = $ARGV[1];
        print "parrot trace on\n";
        run_cmd( 'parrot.exe -t ' . $script, 1 );

    } else {
        my $num = ( $ARGV[1] ) ? $ARGV[1] : 5;
        run_cmd( 'parrot.exe ' . $script . ' ' . $num, 1 );
    }
}

