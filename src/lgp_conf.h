/*
 * !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
 *
 * This file is generated automatically
 * by
 *
 * Any changes made here will be lost!
 *
 */


#define LGP_OPS_NUM 27

opcode_t lgp_ops[LGP_OPS_NUM] = {
	287, // and_i_i_i: i(o), i(i), i(i)
	290, // not_i: i(io)
	291, // not_i_i: i(o), i(i)
	295, // or_i_i_i: i(o), i(i), i(i)
	298, // xor_i_i_i: i(o), i(i), i(i)
	510, // abs_i: i(io)
	512, // abs_i_i: i(o), i(i)
	517, // add_i_i: i(io), i(i)
	521, // add_i_i_i: i(o), i(i), i(i)
	527, // cmod_i_i_i: i(o), i(i), i(i)
	533, // dec_i: i(io)
	536, // div_i_i: i(io), i(i)
	540, // div_i_i_i: i(o), i(i), i(i)
	546, // fdiv_i_i: i(io), i(i)
	550, // fdiv_i_i_i: i(o), i(i), i(i)
	562, // inc_i: i(io)
	565, // mod_i_i: i(io), i(i)
	567, // mod_i_i_i: i(o), i(i), i(i)
	575, // mul_i_i: i(io), i(i)
	579, // mul_i_i_i: i(o), i(i), i(i)
	585, // neg_i: i(io)
	588, // neg_i_i: i(o), i(i)
	595, // sub_i_i: i(io), i(i)
	599, // sub_i_i_i: i(o), i(i), i(i)
	820, // exchange_i_i: i(io), i(io)
	824, // set_i_i: i(o), i(i)
	924, // null_i: i(o)
};
