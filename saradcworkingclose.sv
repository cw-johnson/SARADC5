// Code your design here
`timescale 1us/100ns
module saradc(
  input clock,reset,
  input nStartCnv,
  input CompOut,
  output reg SH, nEndCnv,
  output reg [7:0] B,
  output reg [7:0] dataOut);
  
  reg [5:0] state;  // You'll need to count your states
  
  // State Encoding -- define your states here
  localparam [5:0]     // Should match above
  // Give states usable names
  sReset = 6'd0,
  sWaitForStart = 6'd1,
  sSample = 6'd2,
  sHold = 6'd3,
  // Add states for other bits
  sB7High = 6'd4,
  sB7Check = 6'd5,  
  sB7Wait = 6'd6,
  sB6High = 6'd7,
  sB6Check = 6'd8,  
  sB6Wait = 6'd9,
  sB5High = 6'd10,
  sB5Check = 6'd11,  
  sB5Wait = 6'd12,
  sB4High = 6'd13,
  sB4Check = 6'd14,  
  sB4Wait = 6'd15,
  sB3High = 6'd16,
  sB3Check = 6'd17,  
  sB3Wait = 6'd18,
  sB2High = 6'd19,
  sB2Check = 6'd20,  
  sB2Wait = 6'd21,
  sB1High = 6'd22,
  sB1Check = 6'd23,  
  sB1Wait = 6'd24,
  sB0High = 6'd25,
  sB0Check = 6'd26,  
  sB0Wait = 6'd27,
  sStore = 6'd28,
  sDone = 6'd29;
  
  // Add additional states
  
  
  // Combine states and register block
  always @(posedge clock or negedge reset)
     begin
       if(reset == 0)
         begin
           state <= sReset;
           nEndCnv <= 1'b0;
           dataOut <= 8'd0;
           SH <= 1'b0;
           B <= 8'd0;
         end 
       else 
         begin
         case(state)
           sReset: //1
             state <= sWaitForStart;
           sWaitForStart: //2
             if(nStartCnv == 0) 
               state <= sSample;
           sSample: //3
             begin
               SH <= 1'b1;
               B <= 8'b11111111;
               nEndCnv <= 1'b1;
               state <= sHold;
             end
           sHold:
             begin
               SH <= 1'b0;
               B <= 8'b00000000;
               state <= sB7High; //The 8th bit          
             end
 //          
           sB7High:
             begin 
               B[7] <= 1'b1;
               state <= sB7Check;
             end
           sB7Check:
             begin
               if(CompOut)
                 B[7] <= 1'b0; 
               state <= sB7Wait;
             end
           sB7Wait:
             state <= sB6High;
//           
           sB6High:
             begin 
               B[6] <= 1'b1;
               state <= sB6Check;
             end
           sB6Check:
             begin
               if(CompOut)
                 B[6] <= 1'b0; 
               state <= sB6Wait;
             end
           sB6Wait:
             state <= sB5High;           	   
//
           sB5High:
             begin 
               B[5] <= 1'b1;
               state <= sB5Check;
             end
           sB5Check:
             begin
               if(CompOut)
                 B[5] <= 1'b0; 
               state <= sB5Wait;
             end
           sB5Wait:
             state <= sB4High;
           
//
           sB4High:
             begin 
               B[4] <= 1'b1;
               state <= sB4Check;
             end
           sB4Check:
             begin
               if(CompOut)
                 B[4] <= 1'b0; 
               state <= sB4Wait;
             end
           sB4Wait:
             state <= sB3High;
           
//
           sB3High:
             begin 
               B[3] <= 1'b1;
               state <= sB3Check;
             end
           sB3Check:
             begin
               if(CompOut)
                 B[3] <= 1'b0; 
               state <= sB3Wait;
             end
           sB3Wait:
             state <= sB2High;
//
           sB2High:
             begin 
               B[2] <= 1'b1;
               state <= sB2Check;
             end
           sB2Check:
             begin
               if(CompOut)
                 B[2] <= 1'b0; 
               state <= sB2Wait;
             end
           sB2Wait:
             state <= sB1High;
 //
           
           sB1High:
             begin 
               B[1] <= 1'b1;
               state <= sB1Check;
             end
           sB1Check:
             begin
               if(CompOut)
                 B[1] <=1'b0;
               state <= sB0Wait;
             end
           sB1Wait:
               state <= sB0High;
           
           sB0High:
             begin 
               B[0] <= 1'b1;
               state <= sB0Check;
             end
           sB0Check:
             begin
               if(CompOut)
                 B[0] <=1'b0;
               state <= sB0Wait;
             end
           sB0Wait:
             state <= sStore; 
           
           sStore:
            begin
             dataOut <= B;
             state <= sDone;
            end  
           sDone:
            begin
             nEndCnv <= 1'b0;
             state <= sWaitForStart;
            end 
         endcase
       	end
 	   end
endmodule 
  
         