
module add8(
    input carry_in,
    input [7:0] a, b,
    output [7:0] c,
    output carry_out,
    output sign,
    output overflow
);

wire [8:0] tmp = a + b + carry_in;
  reg o,s;

  assign c = tmp[7:0];
  assign carry_out = tmp[8];
  assign overflow = o;
  assign sign = s;
 
always @(*) begin
   if( a[7] && b[7] && !c[7] ) begin  // negative add negative, sign is 1, overflow if different sign
         o = 1;
         s = 1;
  end else if(!a[7] && !b[7] && c[7]) begin
         o = 1;
         s = 0;
  
  end else begin
          o = 0;
          s = c[7];
  end
  
end// end of always 


endmodule
