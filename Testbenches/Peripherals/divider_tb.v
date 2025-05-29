`timescale 1ns / 1ps

module divider_tb;

	// Inputs
	reg [15:0] divisor;
	reg [15:0] dividend;

	// Outputs
	wire [15:0] remainder;
	wire [15:0] result;

	divider dut (
		.divisor(divisor), 
		.dividend(dividend), 
		.remainder(remainder), 
		.result(result)
	);

	initial begin
		divisor = 11;
		dividend = 28;
		
		#100;
		
        divisor = 6;
		dividend = 36;
		
		#100
		divisor = 6;
		dividend = 37;
	end
      
	initial begin
		$monitor("Divisor: %d, Dividend: %d, Remainder: %d, Result: %d\n", divisor, dividend,remainder, result);
	end
endmodule





