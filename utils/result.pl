use strict;
use warnings;

use Carp qw(carp croak verbose);

use Statistics::Basic::Mean;
use Statistics::Basic::Median;
use Statistics::Basic::StdDev;

my $debug = 0;

if ( $ARGV[0] && $ARGV[0] eq '--help' ) {
print <<"EOHELP";
Usage: 
  perl $0 [--save] FILE1 [FILE2, ...]
  perl $0 [--save] -d DIR_NAME
  perl $0 [--save]
  perl $0 --help

FILE1 [FILE2, ...]  ... use these files
--save ... save stats to files with prefix 'stat-'
-d DIR_NAME .. search DIR_NAME for 'bench*.txt' files and use these
--help ... print help

No params is same as "-d ./".
EOHELP
exit;
}

my $save_stats = 0;
if ( $ARGV[0] && $ARGV[0] eq '--save' ) {
    shift @ARGV;
    $save_stats = 1;
}

my %files = ();
# find all 'bench*.txt' in './' or '-d DIR'
if ( scalar(@ARGV) == 0 || $ARGV[0] eq '-d' ) {
    my $dir_name = './';
    if ( $ARGV[0] && $ARGV[0] eq '-d' ) {
       croak "Second param is not directory." unless -d $ARGV[1];
       $dir_name = $ARGV[1];
    }
    
    if (not opendir(DIR, $dir_name)) {
        croak "Directory '$dir_name' not open for read.\n$!" ;
    }
    my @all_files = readdir(DIR);
    close(DIR);

    foreach my $name (@all_files) {
        next unless $name =~ /^bench.*\.txt$/;
        my $path = $dir_name.$name;
        next unless -f $path;
        $files{$name} = $path;
    }

# files
} else {
    foreach my $name ( @ARGV ) {
        croak "'$name' is not file." unless -f $name;
        my $path = './' . $name;
        $files{$name} = $path;
    }
} 

my $file_sep = '--- --- --- --- --- --- --- --- --- ---';
my $more_than_one = 0;

$more_than_one = 1 if (keys %files) > 1;

local *OUT = \*STDOUT;
foreach my $if_name ( sort keys %files ) {

    if ( $save_stats ) {
        my $of_name = 'stat-' . $if_name;
        open( OUT, '>' . $of_name ) or croak $!;
    }
    
    my $if_path = $files{$if_name};
    print "input file path: '$if_path'\n";
    print "\n";

    my $fh;
    open( $fh, '<' . $if_path ) or croak $!;
    my ( $fit, $len, $time );
    my ( $ra_fit, $ra_len, $ra_time ) = ( [], [], [] );

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

    exit if scalar(@$ra_fit) == 0;

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
    foreach my $key ( sort { $a <=> $b } keys %$rh_fit_len ) {
        my $val = $rh_fit_len->{ $key };
        printf "fitness=%3d ", $key;
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
    foreach my $key ( sort { $a <=> $b } keys %$rh_len_fit ) {
        my $val = $rh_len_fit->{ $key };
        printf "length=%3d ", $key;
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

    print "$file_sep\n" if $more_than_one && !$save_stats;

    close OUT if $save_stats;
}
