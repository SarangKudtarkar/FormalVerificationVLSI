module arbiter (
    input clk,
    input rst,
    input [1:0] req,
    output reg [1:0] gnt
);

    reg deadlocked;

    always @(posedge clk) begin
        if (rst) begin
            gnt <= 2'b00;
            deadlocked <= 1'b0;
        end else if (deadlocked) begin
            gnt <= 2'b00; // Stuck here forever
        end else begin
            if (req[0] && req[1]) begin
                // DEADLOCK BUG: If both request at once, the system freezes
                deadlocked <= 1'b1;
                gnt <= 2'b00;
            end else if (req[0]) begin
                gnt <= 2'b01;
            end else if (req[1]) begin
                gnt <= 2'b10;
            end else begin
                gnt <= 2'b00;
            end
        end
    end

endmodule
