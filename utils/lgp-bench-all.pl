use strict;
use warnings;

use Carp qw(carp croak verbose);

use lib 'parrot-lgp/lib';
use SVNShell qw(svnversion svnup);

my $rev;

if ( $ARGV[0] ) {
    $rev = $ARGV[0];
    croak "param '$rev' is not revision number\n" unless $rev =~ /^\d+$/;
} else {
    $rev = svnversion('parrot-lgp');
    croak "svnversion for 'parrot-lgp' dir failed." unless $rev;
    chomp($rev);
    $rev =~ s{:}{to}g;
    $rev = 'r' . $rev;
}

my @pop_sizes = ( 10, 50, 250 );
my $run_number = 0;
foreach my $pop_size ( @pop_sizes ) {
    my $bench_output_fn;
    my $pop_size_str = sprintf( "%03d", $pop_size );
    if ( $run_number == 0 ) {
        while ( $run_number == 0 || -e $bench_output_fn ) {
            $run_number++;
            $bench_output_fn = 'results\bench-rn' . $run_number  . '-'. $rev . '-' . $pop_size_str . '.txt';
        }
        print "rev: '$rev'\n";
        print "run number: $run_number\n";
        print "\n";
    } else {
        $bench_output_fn = 'results\bench-rn' . $run_number  . '-'. $rev . '-' . $pop_size_str . '.txt';
    }
    print "benchmark for population size $pop_size\n";
    my $cmd = 'perl parrot-lgp\utils\lgp-bench.pl ' . ($pop_size*1000) .' > ' . $bench_output_fn;
    print "cmd: '$cmd'\n";
    system( $cmd );
    print "\n";
}
