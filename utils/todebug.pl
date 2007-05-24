use strict;
use warnings;

use Carp qw(carp croak verbose);
my $ver = 0;

my $in_fp = $ARGV[0] || 'parrot-lgp/src/lgp.pir';

print "input file path: '$in_fp'\n\n" if $ver > 1;

my $fh;
open( $fh, '<' . $in_fp ) or croak $!;

my $d_col_num = 50;
my ( $sp, $n_sp, $o_line, $d_line );
my ( $prev );
while ( my $line = <$fh> ) {
    chomp $line;
    
    if ( ( $sp, $d_line ) = $line =~ /^(\s*)\#\@(.*?)\s*$/ ) {
        if ( $d_line !~ /^\s*$/ ) {
            print $sp;
            print $d_line;
            $sp = ' ' x ( $d_col_num - 2 - length($sp) - length($d_line) );
            print $sp . ' #@';
            $prev = 'right';

        } else {
            if ( $prev eq 'right' ) {
                $n_sp = ( ' ' x 49 );
                print $n_sp . '#@';
                $prev = 'right';
            } else {
                print '#@';
                $prev = 'left';
            }
        }

    } elsif ( ( $sp, $o_line, $d_line ) = $line =~ /^(\s*?)(\S+.*?)\s*\#\@(.*?)$/ ) {
        if ( $d_line !~ /^\s*$/ ) {
            $sp = substr($sp,1) if length($sp) > 0;
            print $sp  . $d_line;
            $n_sp = ' ' x ( $d_col_num - 1 - length($sp) - length($d_line) );
            print $n_sp;
            print '#@ ' . $o_line;
            $prev = 'right';

        } else {
            print '#@' . $sp . $o_line;
            $prev = 'left';
        }

    } else {
        print $line;
    }
    
    print "\n";
}
close $fh;
