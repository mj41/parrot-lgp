use strict;
use warnings;

use Carp qw(carp croak verbose);

use Statistics::Basic::Mean;
use Statistics::Basic::Median;
use Statistics::Basic::StdDev;

my $ifn = $ARGV[0] || 'bench-r44.txt';
my $debug = 0;

print "input file path: '$ifn'\n";
print "\n";

my $fh;
open( $fh, '<' . $ifn ) or croak;
my ( $fit, $len, $time );
my ( $ra_fit, $ra_len, $ra_time );

my ( $rh_fit_len, $rh_len_fit );
while ( my $line = <$fh> ) {
    if ( ( $fit, $len ) = $line =~ /^this\ run\ best\ indi\:\s+inum\=\d+,\s*fitness\=(\d+),\s*len\=(\d+)\s*/ ) {
        push @$ra_fit, $fit;
        push @$ra_len, $len;
        push @{ $rh_fit_len->{$fit} }, $len;
        push @{ $rh_len_fit->{$len} }, $fit;
        print "fit: $fit, len:$len\n" if $debug;
    }
    if ( ( $time ) = $line =~ /^full time\:\s*(\d+\.?\d*)/ ) {
        push @$ra_time, $time;
        print "time: $time\n" if $debug;
        print "\n" if $debug;
    }
}

my ( $fit_m, $len_m, $time_m );

print "num of results found: " . scalar( @$ra_fit ) . "\n";
print "\n";


# fitness
$fit_m = Statistics::Basic::Mean->new( $ra_fit )->query;
printf "fitness mean: %.3f\n", $fit_m;
$fit_m = Statistics::Basic::Median->new( $ra_fit )->query;
printf "fitness median: %.3f\n", $fit_m;
$fit_m = Statistics::Basic::StdDev->new( $ra_fit )->query;
printf "fitness standard deviation: %.3f\n", $fit_m;
print "\n";

my $fit_len_m;
print "statistics of length grouped by indi fitness:\n";
foreach my $key ( sort keys %$rh_fit_len ) {
    my $val = $rh_fit_len->{ $key };
    printf "fitness=%2d ", $key;
    printf "(results:%2d): ", scalar( @$val );
    $fit_len_m = Statistics::Basic::Median->new( $val )->query;
    printf "length median: %.3f, ", $fit_len_m;
    $fit_len_m = Statistics::Basic::Mean->new( $val )->query;
    printf "mean: %.3f, ", $fit_len_m;
    $fit_len_m = Statistics::Basic::StdDev->new( $val )->query;
    printf "standard deviation: %.3f", $fit_len_m;
    print "\n";
}
print "\n";


# length
$len_m = Statistics::Basic::Mean->new( $ra_len )->query;
printf "length mean: %.3f\n", $len_m;
$len_m = Statistics::Basic::Median->new( $ra_len )->query;
printf "length median: %.3f\n", $len_m;
$len_m = Statistics::Basic::StdDev->new( $ra_len )->query;
printf "length standard deviation: %.3f\n", $len_m;
print "\n";

my $len_fit_m;
print "statistics of fitness grouped by indi length:\n";
foreach my $key ( sort keys %$rh_len_fit ) {
    my $val = $rh_len_fit->{ $key };
    printf "length=%2d ", $key;
    printf "(results:%2d): " , scalar(@$val);
    $len_fit_m = Statistics::Basic::Median->new( $val )->query;
    printf "fitness median: %.3f, ", $len_fit_m;
    $len_fit_m = Statistics::Basic::Mean->new( $val )->query;
    printf "mean: %.3f, ", $len_fit_m;
    $len_fit_m = Statistics::Basic::StdDev->new( $val )->query;
    printf "standard deviation: %.3f", $len_fit_m;
    print "\n";
}
print "\n";


# time
$time_m = Statistics::Basic::Mean->new( $ra_time )->query;
printf "time mean: %.3f\n", $time_m;
$time_m = Statistics::Basic::StdDev->new( $ra_time )->query;
printf "time standard deviation: %.3f\n", $time_m;

