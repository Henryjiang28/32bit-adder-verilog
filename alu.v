
module alu(
    input [31:0] a, b,
    input [1:0] width,
    input saturate,
    output [31:0] c
);
// You can add `reg` keywords in the port definition above if needed.
  wire [7:0] one8;
  wire [7:0] two8;
  wire [7:0] three8;
  wire [7:0] four8;
  wire [7:0] result0, result1, result2, result3;


  wire [3:0] overflow;
  wire [3:0] sign;
  wire [3:0] carry_out;

  wire [3:0] sat_enable;
  wire [3:0] sat_sign;
  wire [3:0] sat_last;
  wire [3:0] carry_in;
  
   assign  c[7:0] =  result0;
   assign   c[15:8] = result1;
   assign  c[23:16] = result2;
   assign   c[31:24] = result3;

  add8 one(.a(a[7:0]),
             .b(b[7:0]),
             .c(one8),
             .carry_out(carry_out[0]),
             .overflow(overflow[0]),
           .sign(sign[0]),
             .carry_in(1'd0)
            );

  add8 two(.a(a[15:8]),
           .b(b[15:8]),
           .c(two8),
           .carry_out(carry_out[1]),
           .overflow(overflow[1]),
           .sign(sign[1]),
           .carry_in(carry_in[1])
            );

  add8 three(.a(a[23:16]),
             .b(b[23:16]),
             .c(three8),
             .carry_out(carry_out[2]),
             .overflow(overflow[2]),
             .sign(sign[2]),
             .carry_in(carry_in[2])
            );

  add8 four(.a(a[31:24]),
            .b(b[31:24]),
            .c(four8),
            .carry_out(carry_out[3]),
            .overflow(overflow[3]),
            .sign(sign[3]),
            .carry_in(carry_in[3])
            );

   saturation oneS(
       .in(one8),
       .sat_enable(sat_enable[0]),
       .sat_sign(sat_sign[0]),
       .sat_last(sat_last[0]),
       .out(result0)
    );

    saturation twoS(
       .in(two8),
       .sat_enable(sat_enable[1]),
       .sat_sign(sat_sign[1]),
       .sat_last(sat_last[1]),
       .out(result1)
    );

    saturation threeS(
       .in(three8),
       .sat_enable(sat_enable[2]),
       .sat_sign(sat_sign[2]),
       .sat_last(sat_last[2]),
       .out(result2)
    );

    saturation fourS(
       .in(four8),
       .sat_enable(sat_enable[3]),
       .sat_sign(sat_sign[3]),
       .sat_last(sat_last[3]),
       .out(result3)
    );


  control oneC(
        .carry_out(carry_out),
        .overflow(overflow),
        .sign(sign),
        .width(width),
        .saturate(saturate),
        .carry_in(carry_in),
        .sat_enable(sat_enable),
        .sat_sign(sat_sign),
        .sat_last(sat_last)
  );

     


endmodule
