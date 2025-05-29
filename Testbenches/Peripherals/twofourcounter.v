`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 12:43:43 AM
// Design Name: 
// Module Name: twofourcounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module twofourCounter(
    input wire clk,
    input wire rst,
    input wire [23:0] given_value,
    output reg [23:0] count
);

// Reset the counter
always @(posedge clk or posedge rst) begin
    if (rst)
        count <= given_value;
    else if (count > 0)
        count <= count - 1;
end

endmodule
