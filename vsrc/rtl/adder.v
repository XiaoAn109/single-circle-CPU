//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/24 14:31:12
// Design Name: 
// Module Name: adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created 
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////
 
 
module adder #(parameter DW = 32) (
	input [DW-1:0] opa,
	input [DW-1:0] opb,
	input cin,
	output [DW-1:0] result,
	output carry,
	output zero,
	output overflow
);
	wire [DW-1:0] opb_bar; //~opb
	wire [DW-1:0] opb_mux;
	wire [DW-1:0] opb_sub; //opb_bar + 1
	//judge overflow
	wire [1:0] flag;
	wire opa_MSB_bar;
	wire opb_mux_MSB_bar;
	wire res_MSB_bar;
	//judge zero
	/* verilator lint_off UNOPTFLAT */
	wire [DW-2:0] tmp_or;

	assign opb_bar = ~opb;
	f_add_Nbit #(DW) i1(opb_bar, 1, 1'b0, opb_sub, ); 
	//opb_mux = sel ? (~opb+1) : opb
	MuxKey #(2, 1, DW) i2(opb_mux, cin, {
		1'b0, opb,
		1'b1, opb_sub
	});
	//{carry, result} = opa + opb_mux
	f_add_Nbit #(DW) i3(opa, opb_mux, 1'b0, result, carry);
	//overflow = (a[DW-1]=b[DW-1]!=result[DW-1])
	not i5(opa_MSB_bar, opa[DW-1]);
	not i6(opb_mux_MSB_bar, opb_mux[DW-1]);
	not i7(res_MSB_bar, result[DW-1]);
	and i8(flag[0], opa[DW-1], opb_mux[DW-1], res_MSB_bar); 
	and i9(flag[1], opa_MSB_bar, opb_mux_MSB_bar, result[DW-1]); 
	or i10(overflow, flag[0], flag[1]);
	//zero = ~(| result)
	generate
		genvar i;
		or i11(tmp_or[0], result[0], result[1]);
		for(i = 1; i < DW - 1; i = i + 1) begin: or_block
			or i12(tmp_or[i], result[i+1], tmp_or[i-1]);
		end
	endgenerate

	not i13(zero, tmp_or[DW-2]);
	
endmodule
