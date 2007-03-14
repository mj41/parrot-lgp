/*
 * !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
 *
 * This file is generated automatically
 * by
 *
 * Any changes made here will be lost!
 *
 */

#define MAX_POP_SIZE 100
#define INDI_MAX_LEN 5
#define FIGHT_NUM 2

// typedef INTVAL fitness_t;
// fitness_t is not recognized in method signature

typedef struct lgp_indi {
    INTVAL       	fitness;
    opcode_t		code[INDI_MAX_LEN];
    size_t			len;
} t_lgp_indi;

INTVAL pop_size = MAX_POP_SIZE;
typedef t_lgp_indi t_pop[MAX_POP_SIZE + FIGHT_NUM];
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


INTVAL check_op_count = 1; // lgp_ops[last] =  16, // ret
INTVAL lgp_op_count  = 15;
opcode_t lgp_ops[] = {
	//110, // 0 ... band_i_i: i(io), i(i)
	//112, // 1 ... band_i_i_i: i(o), i(i), i(i)
	//120, // 2 ... bnot_i: i(io)
	//121, // 3 ... bnot_i_i: i(o), i(i)
	//131, // 4 ... bor_i_i: i(io), i(i)
	//133, // 5 ... bor_i_i_i: i(o), i(i), i(i)
	//141, // 6 ... shl_i_i: i(io), i(i)
	//143, // 7 ... shl_i_i_i: i(o), i(i), i(i)
	//146, // 8 ... shr_i_i: i(io), i(i)
	//148, // 9 ... shr_i_i_i: i(o), i(i), i(i)
	//151, // 10 ... lsr_i_i: i(o), i(i)
	//153, // 11 ... lsr_i_i_i: i(o), i(i), i(i)
	//159, // 12 ... bxor_i_i: i(io), i(i)
	//161, // 13 ... bxor_i_i_i: i(o), i(i), i(i)
	//269, // 14 ... cmp_i_i_i: i(o), i(i), i(i)
	//287, // 15 ... and_i_i_i: i(o), i(i), i(i)
	//290, // 16 ... not_i: i(io)
	//291, // 17 ... not_i_i: i(o), i(i)
	//295, // 18 ... or_i_i_i: i(o), i(i), i(i)
	//298, // 19 ... xor_i_i_i: i(o), i(i), i(i)
	487, // 20 ... abs_i: i(io)
	489, // 21 ... abs_i_i: i(o), i(i)
	494, // 22 ... add_i_i: i(io), i(i)
	498, // 23 ... add_i_i_i: i(o), i(i), i(i)
	//504, // 24 ... cmod_i_i_i: i(o), i(i), i(i)
	510, // 25 ... dec_i: i(io)
	//513, // 26 ... div_i_i: i(io), i(i)
	//517, // 27 ... div_i_i_i: i(o), i(i), i(i)
	//523, // 28 ... fdiv_i_i: i(io), i(i)
	//527, // 29 ... fdiv_i_i_i: i(o), i(i), i(i)
	539, // 30 ... inc_i: i(io)
	//542, // 31 ... mod_i_i: i(io), i(i)
	//544, // 32 ... mod_i_i_i: i(o), i(i), i(i)
	552, // 33 ... mul_i_i: i(io), i(i)
	556, // 34 ... mul_i_i_i: i(o), i(i), i(i)
	//562, // 35 ... neg_i: i(io)
	//565, // 36 ... neg_i_i: i(o), i(i)
	572, // 37 ... sub_i_i: i(io), i(i)
	576, // 38 ... sub_i_i_i: i(o), i(i), i(i)
	797, // 39 ... exchange_i_i: i(io), i(io)
	801, // 40 ... set_i_i: i(o), i(i)
	901, // 41 ... null_i: i(o)

	  1, // 27 .. noop
	 16 // 28 .. ret
};
