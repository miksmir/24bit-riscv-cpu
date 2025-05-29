`timescale 1ns / 1ps

module divider(divisor, dividend, remainder, result);

input [15:0] divisor, dividend;
output reg [15:0] result, remainder;

// Variables
integer i;
reg [15:0] divisor_temp, dividend_temp;
reg [15:0] temp;

always @(divisor or dividend)
begin
	divisor_temp = divisor;
	dividend_temp = dividend;
	temp = 0; 
	for(i = 0;i < 8;i = i + 1)
	begin
		temp = {temp[6:0], dividend_temp[7]};
		dividend_temp[7:1] = dividend_temp[6:0];
		/*
			* Substract the Divisor Register from the Remainder Register and
			* plave the result in remainder register (temp variable here!)
		*/
		temp = temp - divisor_temp;
		// Compare the Sign of Remainder Register (temp)
		if(temp[7] == 1)
		begin
		/*
			* Restore original value by adding the Divisor Register to the
			* Remainder Register and placing the sum in Remainder Register.
			* Shift Quatient by 1 and Add 0 to last bit.
		*/
			dividend_temp[0] = 0;
			temp = temp + divisor_temp;
		end
		else
		begin
		/*
			* Shift Quotient to left.
			* Set right most bit to 1.
		*/
			dividend_temp[0] = 1;
		end
	end
	result = dividend_temp;
	remainder = dividend - (divisor_temp*dividend_temp);
end
endmodule



