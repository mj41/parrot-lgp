/*
 * !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
 *
 * This file is generated automatically
 * by
 *
 * Any changes made here will be lost!
 *
 */

#define POP_SIZE 100000
#define INDI_MAX_LEN 5
#define FIGHT_NUM 2

typedef struct lgp_indi {
    double          fitness;
    opcode_t		code[INDI_MAX_LEN];
    size_t			len;
} t_lgp_indi;

typedef t_lgp_indi t_pop[POP_SIZE+FIGHT_NUM];
t_pop pop;

INTVAL lgp_in_reg_count  = 3;
INTVAL lgp_in_regs[] = {
	1, 2, 3
};

INTVAL lgp_out_reg_count  = 1;
INTVAL lgp_out_regs[] = {
	4
};

INTVAL lgp_used_reg_max_count = 4;
typedef struct lgp_used_regs {
	INTVAL count;
	INTVAL regs[4];
} t_lgp_used_regs;


INTVAL lgp_op_count  = 29 - 7;
opcode_t lgp_ops[] = {
	287, //  0 .. and_i_i_i: i(o), i(i), i(i)
	290, //  1 .. not_i: i(io)
	291, //  2 .. not_i_i: i(o), i(i)
	295, //  3 .. or_i_i_i: i(o), i(i), i(i)
	298, //  4 .. xor_i_i_i: i(o), i(i), i(i)
	510, //  5 .. abs_i: i(io)
	512, //  6 .. abs_i_i: i(o), i(i)
	517, //  7 .. add_i_i: i(io), i(i)
	521, //  8 .. add_i_i_i: i(o), i(i), i(i)
	//527, //  9 .. cmod_i_i_i: i(o), i(i), i(i)
	533, // 10 .. dec_i: i(io)
	//536, // 11 .. div_i_i: i(io), i(i)
	//540, // 12 .. div_i_i_i: i(o), i(i), i(i)
	//546, // 13 .. fdiv_i_i: i(io), i(i)
	//550, // 14 .. fdiv_i_i_i: i(o), i(i), i(i)
	562, // 15 .. inc_i: i(io)
	//565, // 16 .. mod_i_i: i(io), i(i)
	//567, // 17 .. mod_i_i_i: i(o), i(i), i(i)
	575, // 18 .. mul_i_i: i(io), i(i)
	579, // 19 .. mul_i_i_i: i(o), i(i), i(i)
	585, // 20 .. neg_i: i(io)
	588, // 21 .. neg_i_i: i(o), i(i)
	595, // 22 .. sub_i_i: i(io), i(i)
	599, // 23 .. sub_i_i_i: i(o), i(i), i(i)
	820, // 24 .. exchange_i_i: i(io), i(io)
	824, // 25 .. set_i_i: i(o), i(i)
	924, // 26 .. null_i: i(o)
	  1, // 27 .. noop
	 16, // 28 .. ret
};
