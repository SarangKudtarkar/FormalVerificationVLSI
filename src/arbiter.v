module arbiter (
    input clk,
    input rst,
    input [1:0] req,
    output reg [1:0] gnt
);

    always @(posedge clk) begin
        if (rst) begin
            gnt <= 2'b00;
        end else begin
            if (req[0]) begin
                gnt <= 2'b11; // BUG: Granting both when req[0] is active!
            end else if (req[1]) begin
                gnt <= 2'b10;
            end else begin
                gnt <= 2'b00;
            end
        end
    end

endmodule
