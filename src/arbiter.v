module arbiter (
    input clk,
    input rst,
    input [1:0] req,
    input [7:0] data0, // Data from User 0
    input [7:0] data1, // Data from User 1
    output reg [1:0] gnt,
    output [7:0] bus_out // Shared Data Bus
);

    // Arbitration Logic (Fixed: No Deadlock, No Dual Grants)
    always @(posedge clk) begin
        if (rst) begin
            gnt <= 2'b00;
        end else begin
            if (req[0]) begin
                gnt <= 2'b01;
            end else if (req[1]) begin
                gnt <= 2'b10;
            end else begin
                gnt <= 2'b00;
            end
        end
    end

    // Data Path Logic
    // If User 0 is granted, they own the bus. If no one is granted, bus is 0.
    assign bus_out = gnt[0] ? data0 : (gnt[1] ? data1 : 8'h00);

endmodule
