#define MAX_POP_SIZE 250000
#define INDI_MAX_LEN 50
#define FIGHT_NUM 2

// typedef INTVAL fitness_t;
// fitness_t is not recognized in method signature

typedef struct lgp_indi {
    INTVAL       	fitness;
    opcode_t		code[INDI_MAX_LEN];
    size_t			len;
} t_lgp_indi;

INTVAL pop_size = NULL;
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

INTVAL check_op_count = 1; // lgp_ops[last] =  16, // ret
INTVAL lgp_op_count  = 15;
opcode_t lgp_ops[] = {
	488, // 20 ... abs_i: i(io)
	490, // 21 ... abs_i_i: i(o), i(i)
	495, // 22 ... add_i_i: i(io), i(i)
	499, // 23 ... add_i_i_i: i(o), i(i), i(i)
	// 505, // 24 ... cmod_i_i_i: i(o), i(i), i(i)
	511, // 25 ... dec_i: i(io)
	// 514, // 26 ... div_i_i: i(io), i(i)
	// 518, // 27 ... div_i_i_i: i(o), i(i), i(i)
	// 524, // 28 ... fdiv_i_i: i(io), i(i)
	// 528, // 29 ... fdiv_i_i_i: i(o), i(i), i(i)
	540, // 30 ... inc_i: i(io)
	// 543, // 31 ... mod_i_i: i(io), i(i)
	// 545, // 32 ... mod_i_i_i: i(o), i(i), i(i)
	553, // 33 ... mul_i_i: i(io), i(i)
	557, // 34 ... mul_i_i_i: i(o), i(i), i(i)
	// 563, // 35 ... neg_i: i(io)
	// 566, // 36 ... neg_i_i: i(o), i(i)
	573, // 37 ... sub_i_i: i(io), i(i)
	577, // 38 ... sub_i_i_i: i(o), i(i), i(i)
	780, // 39 ... exchange_i_i: i(io), i(io)
	784, // 40 ... set_i_i: i(o), i(i)
	884, // 41 ... null_i: i(o)

	  1, // 27 .. noop
	 16 // 28 .. ret
};

// 34 .. returncc
