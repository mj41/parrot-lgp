# C:\usr\mj>perl -e "for (1..1000) { system('perl gp08.pl'); print \"\n\"; }" > vysl3.txt

use strict;
use warnings;

use Carp qw(carp croak verbose);

use Statistics::Basic::Mean;
use Statistics::Basic::Median;
use Statistics::Basic::StdDev;

my $ifn = $ARGV[0] || 'bench-r44.txt';
my $debug = 0;

print "iput file path: '$ifn'\n";
print "\n";

my $fh;
open( $fh, '<' . $ifn ) or croak;
my ( $fit, $len, $time );
my ( $ra_fit, $ra_len, $ra_time );

my ( $rh_fit_len );
while ( my $line = <$fh> ) {
    if ( ( $fit, $len ) = $line =~ /^this\ run\ best\ indi\:\s+inum\=\d+,\s*fitness\=(\d+),\s*len\=(\d+)\s*/ ) {
        push @$ra_fit, $fit;
        push @$ra_len, $len;
        push @{ $rh_fit_len->{$fit} }, $len;
        print "fit: $fit, len:$len\n" if $debug;
    }
    if ( ( $time ) = $line =~ /^full time\:\s*(\d+\.?\d*)/ ) {
        push @$ra_time, $time;
        print "time: $time\n" if $debug;
        print "\n" if $debug;
    }
}

my ( $fit_m, $fit_len_m, $len_m, $time_m );
$fit_m = Statistics::Basic::Median->new( $ra_fit )->query;
print "fitness median: $fit_m\n";
$fit_m = Statistics::Basic::Mean->new( $ra_fit )->query;
print "fitness mean: $fit_m\n";
$fit_m = Statistics::Basic::StdDev->new( $ra_fit )->query;
print "fitness standard deviation: $fit_m\n";
print "\n";

foreach my $key ( sort keys %$rh_fit_len ) {
    my $val = $rh_fit_len->{ $key };
    print "fitness $key: ";
    print "num of results=" . scalar( @$val ) . ", ";
    $fit_len_m = Statistics::Basic::Median->new( $val )->query;
    print "length median: $fit_len_m, ";
    $fit_len_m = Statistics::Basic::Mean->new( $val )->query;
    print "length mean: $fit_len_m, ";
    $fit_len_m = Statistics::Basic::StdDev->new( $val )->query;
    print "length standard deviation: $fit_len_m";
    print "\n";
}

print "\n";

$len_m = Statistics::Basic::Mean->new( $ra_len )->query;
print "length mean: $len_m\n";
$len_m = Statistics::Basic::Median->new( $ra_len )->query;
print "length median: $len_m\n";
$len_m = Statistics::Basic::StdDev->new( $ra_len )->query;
print "length standard deviation: $len_m\n";
print "\n";

$time_m = Statistics::Basic::Mean->new( $ra_time )->query;
print "time mean: $time_m\n";
$time_m = Statistics::Basic::StdDev->new( $ra_time )->query;
print "time standard deviation: $time_m\n";

