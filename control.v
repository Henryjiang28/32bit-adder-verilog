
module control(
    input [1:0] width,
    input [3:0] carry_out,
    input [3:0] sign,
    input [3:0] overflow,
    input saturate,
    output reg [3:0] carry_in,
    output reg [3:0] sat_enable,
    output reg [3:0] sat_sign,
    output reg [3:0] sat_last
);

// You can add `reg` keywords in the port definition above if needed.


always @(*) begin

    sat_enable = 4'b0000;
    sat_last = 4'b0000;
    sat_sign = 4'b0000;
    carry_in[0] = 1'b0;
    carry_in[1] = carry_out[0];
    carry_in[2] = carry_out[1];
    carry_in[3] = carry_out[2];


    if(saturate) begin

        if(width == 2'b00) begin  // 8 bit mode
            sat_enable = overflow;
            sat_last= 4'b1111;                   // all last bits should be treated as sign bit
            sat_sign = sign;
            carry_in = 4'b0000;                  // no carry in for all module

        end
        else if (width == 2'b01) begin           // 16 bit mode
            sat_enable[1:0] = {2{overflow[1]}};
            sat_enable[3:2] = {2{overflow[3]}};

            sat_last = 4'b1010;                 // second and fourth bit as sign bit
            carry_in[1] = carry_out[0];
            carry_in[3] = carry_out[2];
            sat_sign[1:0] = {2{sign[1]}};
            sat_sign[3:2] = {2{sign[3]}};
        end else begin                          // 32 bit mode
           sat_last = 4'b1000;
          sat_enable[3:0] = {4{overflow[3]}};
          sat_sign[3:0] = {4{sign[3]}};
           carry_in[1]=carry_out[0];
            carry_in[2]=carry_out[1];
            carry_in[3]=carry_out[2];
        end


    end  // saturate end

end


endmodule


