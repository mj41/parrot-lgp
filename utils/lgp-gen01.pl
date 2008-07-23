use strict;
use warnings;

use lib 'parrot/lib';
use Carp qw(carp croak verbose);
use Data::Dumper;

use Parrot::Op;
use Parrot::Oplib::core;

my $to_c = $ARGV[0];

my $ops;
my %names;

$ops->{OPS} = $Parrot::OpLib::core::ops;
# print Dumper( $ops ); exit;

my $allowed_ops = {
    abs_i => 1,
    abs_i_i => 1,
    add_i_i => 1,
    add_i_i_i => 1,
    dec_i => 1,
    div_i_i => 1,
    div_i_i_i => 1,
    inc_i => 1,
    mul_i_i => 1,
    mul_i_i_i => 1,
    sub_i_i => 1,
    sub_i_i_i => 1,
    exchange_i_i => 1,
    set_i_i => 1,
    null_i => 1,
};

my $num = 0;
foreach my $op ( @{ $Parrot::OpLib::core::ops } ) {
    #print Dumper( $op );
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

    if ( $raw_i_type && !$jump && (exists $flags->{base_core})  ) {
        if ( $to_c ) {
            print "    ";
            # TODO, output/input args
            print "// " unless exists $allowed_ops->{$full_name};
        }
        print "$code, // $num ... $full_name: ";
        foreach my $arg_num ( 0..$arg_count-1 ) {
            print ", " if $arg_num > 0;
            print $arg_types[ $arg_num ];
            print "(" . $arg_dirs[ $arg_num ] . ")";
        }
#        print ", arg_count:$arg_count, flags: $flags, jump:$jump";
        print "\n";
#        print Dumper( $op );
        $num++;
    }

}
