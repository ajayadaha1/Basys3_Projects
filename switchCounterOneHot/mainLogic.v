`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2024 04:30:29 PM
// Design Name: switchCounterOneHot
// Module Name: mainLogic
// Project Name: switchCounterOneHot
// Target Devices: Basys3
// Tool Versions: 2022.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mainLogic(
    input [15:0] sw,
    input clk,
    
    output [15:0] led,
    
    //HEX display
    output [6:0] seg,
    output dp,
    output [3:0] an
    );
    
    assign led = sw;
    //assign seg = 7'b0000000;
 
     
    reg [6:0] seg_reg;
    reg [3:0] an_reg;
    wire [15:0] hex; 
    
    integer i;

    assign an = an_reg;
    assign seg = seg_reg;
    assign hex = sw;
    // activate on any input change
    integer i = 16;
    reg display1, display2;
    parameter DIVISOR = 833333; // Half of the total division factor for toggling

    reg [31:0] counter = 0;  // 32-bit counter to handle large division factor
    reg clk_out;
    always @(posedge clk) begin
            if (counter == DIVISOR - 1) begin
                counter <= 0;
                clk_out <= ~clk_out;  // Toggle the output clock
                //flip the anode
                if(an_reg== 4'b1101) begin
                    an_reg = 4'b1110;
                end
                else begin
                    if (hex < 16'h3ff) begin
                        an_reg = 4'b1110;                 
                    end
                    else begin
                        an_reg = 4'b1101;                
                    end
                end
            end 
            else begin
                counter <= counter + 1;
            end
   
     end
    
    
    always @(posedge clk) begin        
        case(hex)
            16'h0: seg_reg[6:0] = 7'b1000000;    // digit 0
            16'h1: seg_reg[6:0] = 7'b1111001;    // digit 1
            16'h3: seg_reg[6:0] = 7'b0100100;    // digit 2 
            16'h7: seg_reg[6:0] = 7'b0110000;    // digit 3      


            16'hf:seg_reg[6:0] = 7'b0011001;   //digit 4 
            16'h1f:seg_reg[6:0] = 7'b0010010;  //digit 5 
            16'h3f:seg_reg[6:0] = 7'b0000010;  //digit 6 
            16'h7f:seg_reg[6:0] = 7'b1111000;  //digit 7 
            16'hff:seg_reg[6:0] = 7'b0000000;  //digit 8 
            16'h1ff:seg_reg[6:0] = 7'b0010000; //digit 9 
            
            
            16'h3ff:                            //digit 10
                begin
                    if (an_reg == 4'b1110) begin
                        seg_reg[6:0] = 7'b1000000; //digit 0 
                    end
                    else begin
                         seg_reg[6:0] = 7'b1111001; //digit 1
                    end    
                    //an_reg = 4'b1100;
                end
                
            16'h7ff:                             //digit 11
                begin
                    if (an_reg == 4'b1110) begin
                        seg_reg[6:0] = 7'b1111001; //digit 1 
                    end
                    else begin
                         seg_reg[6:0] = 7'b1111001; //digit 1
                    end    
                    //an_reg = 4'b1100;
                end
                
            16'hfff:                            //digit 12
                begin
                    if (an_reg == 4'b1110) begin
                        seg_reg[6:0] = 7'b0100100; //digit 2 
                    end
                    else begin
                         seg_reg[6:0] = 7'b1111001;   //digit 1
                    end    
                    //an_reg = 4'b1100;
                end
            16'h1fff:                            //digit 13
                begin
                    if (an_reg == 4'b1110) begin
                        seg_reg[6:0] = 7'b0110000; //digit 5 
                    end
                    else begin
                         seg_reg[6:0] = 7'b1111001; //digit 1
                    end    
                    //an_reg = 4'b1100;
                end
            16'h3fff:                            //digit 14
                begin
                    if (an_reg == 4'b1110) begin
                        seg_reg[6:0] = 7'b0011001; //digit 5 
                    end
                    else begin
                         seg_reg[6:0] = 7'b1111001; //digit 1
                    end    
                    //an_reg = 4'b1100;
                end
            16'h7fff:                            //digit 15
                begin
                    if (an_reg == 4'b1110) begin
                        seg_reg[6:0] = 7'b0010010; //digit 5 
                    end
                    else begin
                         seg_reg[6:0] = 7'b1111001; //digit 1
                    end    
                    //an_reg = 4'b1100;
                end
            16'hffff:                            //digit 16
                begin
                    if (an_reg == 4'b1110) begin
                        seg_reg[6:0] = 7'b0000010; //digit 5 
                    end
                    else begin
                         seg_reg[6:0] = 7'b1111001; //digit 1
                    end    
                   
                end
                
            default: seg_reg[6:0] = 7'b0000000;
//            4'ha: seg_reg[6:0] = 7'b0001000;    // digit A
//            4'hb: seg_reg[6:0] = 7'b0000011;    // digit B
//            4'hc: seg_reg[6:0] = 7'b1000110;    // digit C
//            4'hd: seg_reg[6:0] = 7'b0100001;    // digit D
//            4'he: seg_reg[6:0] = 7'b0000110;    // digit E
        endcase
    end

    
endmodule
