use strict;
use warnings;

use lib 'lib';
use Carp qw(carp croak verbose);
use Data::Dump qw(dump);

use Parrot::Op;
use Parrot::Oplib::core;

my $ops;
my %names;

$ops->{OPS} = $Parrot::OpLib::core::ops;
# print dump( $ops ); exit;

my $num = 0;
foreach my $op ( @{ $Parrot::OpLib::core::ops } ) {
    my $full_name = $op->full_name;
    my $jump      = $op->jump || 0;
    my $arg_count = $op->size - 1;
    my @arg_types = $op->arg_types;
    my @arg_dirs  = $op->arg_dirs;
    my $flags     = $op->flags;
    my $code      = $op->code;
    
    my $raw_i_type = ( $arg_count > 0 ) ? 1 : 0;
    foreach my $arg_type ( @arg_types ) {
        if ( $arg_type ne 'i' ) {
            $raw_i_type = 0;
            last;
        }
    }
    
    if ( $raw_i_type && !$jump && $flags eq ':base_core'  ) {
        print "$code, // $num ... $full_name: ";
        foreach my $arg_num ( 0..$arg_count-1 ) {
            print ", " if $arg_num > 0;
            print $arg_types[ $arg_num ];
            print "(" . $arg_dirs[ $arg_num ] . ")";
        }
#        print ", arg_count:$arg_count, flags: $flags, jump:$jump";
        print "\n";
#        print dump( $op );
        $num++;
    }

}
