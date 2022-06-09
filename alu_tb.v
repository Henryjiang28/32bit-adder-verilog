`timescale 1ns/1ns

module alu_tb;
  reg [31:0] a, b;
  reg [1:0] width;
  reg saturate;
  wire [31:0]c;


alu testb(.a(a),
          .b(b),
          .width(width),
          .saturate(saturate),
          .c(c)
         );
  

// – saturate is 0, width is 2, and the 32-bit addition overflows

initial begin
  a = 32'd2147483647;
  b = 32'd1;
  
  saturate = 1'd0 ;
  width = 2'd2;
  #1;
 
  if(c != a+b) 
    $display("wrong result for overflow 32 bit addition, c = %d", c);
  


// – saturate is 1, width is 2, and the 32-bit addition saturates
  #2;
  a = 32'd2147483647;
  b = 32'd2323;
  saturate = 1'd1;
  width = 2'd2;
  #1;
 
  if( c != 32'h7fffffff) 
    $display("wrong result for saturate 32 bit addition,c = %d", c);
 
  // 16 bit

 // saturate is 0, width is 1, and at least one of the two 16-bit additions overflows
  #2;
  
  saturate = 1'd0;			// saturate is 0
  width = 2'b01;

  a [15:0] = 16'd32767;
  b [15:0] = 16'd1;         // overflows
  a [31:16] = 16'd1023;
  b [31:16] = 16'd1;

  #1;

  if( c[15:0] != (a[15:0] + b[15:0]) )
    $display("wrong result for overflow first 16 bit addition,c = %d", c[15:0]);
  #1;
  if( c[31:16] != (a[31:16] + b[31:16]))
    $display("wrong result for overflow second 16 bit addition,c = %d", c[31:16]);


  
 
// saturate is 1, width is 1, and at least one of the two 16-bit additions saturates

#2;
 
  saturate = 1'd1;    // saturate is 1
  width = 2'b01;	 // width is 1

  a [15:0] = 16'h7fff;
  b [15:0] = 16'd1212;        
  a [31:16] = 16'd4;
  b [31:16] = 16'd1;
  
  #1;
  if( c[15:0] != 16'h7fff)

    $display("wrong result for saturate in first 16 bit addition,c = %d", c[15:0]);
  #1;
  
  if( c[31:16] != a [31:16] + b [31:16])
    $display("wrong result for saturate in second 16 bit addition,c = %d", c[31:16]);
  
 // 8 bit
  
  //– saturate is 0, width is 0, and at least one of the four 8-bit additions overflows
#2;

  a [7:0] = 8'd127;  a [15:8] = 8'd1;  a[23:16] = 8'd1; a[31:24] = 8'h80; // last bit overflows
  b [7:0] = 8'd20;  b [15:8] = 8'd1;  b[23:16] = 8'd1; b[31:24] = 8'hff; // last bit overflows

saturate = 1'd0;
width = 1'd0;
#1;

  if( c[7:0] != a[7:0] + b[7:0] || c[15:8] != 2 || c[23:16] != 2 || c[31:24] != a[31:24] + b[31:24] )
  $display("wrong result for overflow in 8 bit addition");
  
  
  
  

  
  // – saturate is 1, width is 0, and at least one of the four 8-bit additions saturates

#2;

  a [7:0] = 8'h7f;  a [15:8] = 8'd1;  a[23:16] = 8'd1; a[31:24] = 8'h80; //  first 8 bits positive saturate last 8 bits saturates to negative
  b [7:0] = 8'h7f;  b [15:8] = 8'd1;  b[23:16] = 8'd1; b[31:24] = 8'hff;

saturate = 1'd1;
width = 1'd0;
#1;

  if( c[7:0] != 8'h7f || c[15:8] != 2 || c[23:16] != 2 || c[31:24] != 8'h80 )
  $display("wrong result for saturate in 8 bit addition");



end



endmodule