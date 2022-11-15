#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

#define BITMASK(bits) ((1ull << (bits)) - 1)
#define BITS(x, hi, lo) (((x) >> (lo)) & BITMASK((hi) - (lo) + 1)) // similar to x[hi:lo] in verilog
#define SEXT(x, len) ({ struct { int32_t n : len; } __x = { .n = x }; (uint32_t)__x.n; })

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

static Vtop* top;
static uint8_t *pmem = NULL;

void step_and_dump_wave() {
	top->eval();
	contextp->timeInc(1);
	tfp->dump(contextp->time());
}
void single_cycle() {
	top->clk = 0;
	step_and_dump_wave();
	top->clk = 1;
	step_and_dump_wave();
}

void sim_exit() {
	step_and_dump_wave();
	tfp->close();
	delete top;
	delete contextp;
}
void sim_init() {
	contextp = new VerilatedContext;
	tfp = new VerilatedVcdC;
	top = new Vtop{contextp};
	contextp->traceEverOn(true);
	top->trace(tfp, 0);
	tfp->open("dump.vcd");
}

/*
uint32_t check() {
	static uint32_t tmp;
	switch (top->ALUctrl) {
		case 0: tmp = top->opa + top->opb; break;
		case 8: tmp = top->opa - top->opb; break;
		case 1: case 9: tmp = top->opa << BITS(top->opb, 4, 0); break;
		case 2: tmp = ((int32_t)top->opa < (int32_t)top->opb); break;
		case 10: tmp = (top->opa < top->opb); break;
		case 3: case 11: tmp = top->opb; break;
		case 4: case 12: tmp = (top->opa ^ top->opb); break;
		case 5: tmp = (top->opa >>  BITS(top->opb, 4, 0)); break;
		case 13: tmp = ((int32_t)top->opa >> BITS(top->opb, 4, 0)); break;
		case 6: case 14: tmp = (top->opa | top->opb); break;
		case 7: case 15: tmp = (top->opa & top->opb); break;
		default: tmp = 0;
	}
	return tmp;
}
*/

void init_mem() {
	pmem = (uint8_t*)malloc(0x20000);
	assert(pmem);
	// uint32_t *p = (uint32_t *)pmem;
	// int i;
	// for(i = 0; i < (int)(0x20000/sizeof(p[0])); i ++) {
	// 	p[i] = rand();
	// }
	// printf("Randomize the initial mem.\n");
}

static inline void pmem_wrtite(void *addr, int len, uint32_t data) {
	switch (len) {
		case 1: *(uint8_t *)addr = data; return;
		case 2: *(uint16_t *)addr = data; return;
		case 4: *(uint32_t *)addr = data; return;
		default: assert(0);
	}
}

static inline uint32_t pmem_read(void *addr, int len) {
	switch (len) {
		case 1: return *(uint8_t *)addr;
		case 2: return *(uint16_t *)addr;
		case 4: return *(uint32_t *)addr;
		default: assert(0);
	}
}

int main() {
	srand(time(NULL));
	sim_init();

	top->rst = 1;
	single_cycle();
	top->rst = 0;
	printf("Current pc=0x%08x\n", top->pc);
	printf("Instruction is 0x%08x\n", top->inst);
	single_cycle();
	printf("imm is 0x%08x\n", top->imm_out);

	sim_exit();
	free(pmem);
	return 0;
}

	
	

