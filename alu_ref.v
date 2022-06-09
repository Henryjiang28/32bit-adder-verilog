
module alu(
    input [31:0] a, b,
    input [1:0] width,
    input saturate,
    output reg [31:0] c
);

reg [31:0] x, y, z;
reg [2:0] i;

always @(*) begin

    if (width == 2'b00) begin // 8-bit mode
        for (i = 0; i < 4; i = i + 1) begin
            x = a[8*i +: 8]; // = a[8*i+7:8*i]
            y = b[8*i +: 8];
            z = x + y;
            if (saturate && x[7] && y[7] && !z[7]) // negative saturation
                z = 8'h80;
            if (saturate && !x[7] && !y[7] && z[7]) // positive saturation
                z = 8'h7f;
            c[8*i +: 8] = z;
        end
    end else if (width == 2'b01) begin // 16-bit mode
        for (i = 0; i < 2; i = i + 1) begin
            x = a[16*i +: 16]; // = a[16*i+15:16*i]
            y = b[16*i +: 16];
            z = x + y;
            if (saturate && x[15] && y[15] && !z[15])
                z = 16'h8000;
            if (saturate && !x[15] && !y[15] && z[15])
                z = 16'h7fff;
            c[16*i +: 16] = z;
        end
    end else begin // 32-bit mode
        x = a;
        y = b;
        z = x + y;
        if (saturate && x[31] && y[31] && !z[31])
            z = 32'h80000000;
        if (saturate && !x[31] && !y[31] && z[31])
            z = 32'h7fffffff;
        c = z;
    end

end

endmodule

