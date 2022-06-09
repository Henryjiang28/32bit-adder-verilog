
module saturation(
    input [7:0] in,
    input sat_enable,
    input sat_sign,
    input sat_last,
    output [7:0] out
);

// You can add `reg` keywords in the port definition above if needed.
  reg [7:0] result;

  assign out = result;


always @(*) begin

  if(!sat_enable) begin
    result = in;
  end

  else if(sat_enable && !sat_sign && !sat_last ) begin  // highest positive is all 1
        result = 8'b11111111;
    end

    else if (sat_enable && sat_sign && !sat_last ) begin // unsigned smallest is 0
        result = 8'b00000000;
    end

    else if (sat_enable && !sat_sign && sat_last ) begin //
        result = 8'b01111111;
    end

  	else if (sat_enable && sat_sign && sat_last ) begin
        result = 8'b10000000;
    end

  	else begin
      result = 8'b00000000;
    end


end // end of always



endmodule
