module arbiter_formal (
    input clk,
    input rst,
    input [1:0] req,
    input [7:0] data0,
    input [7:0] data1,
    output [1:0] gnt,
    output [7:0] bus_out
);

    arbiter uut (
        .clk(clk),
        .rst(rst),
        .req(req),
        .data0(data0),
        .data1(data1),
        .gnt(gnt),
        .bus_out(bus_out)
    );

    always @(posedge clk) begin
        if (!rst) begin
            // 1. Safety: Mutual Exclusion
            assert(gnt != 2'b11);

            // 2. Data Integrity: Does the bus actually carry the owner's data?
            if (gnt[0]) assert(bus_out == data0);
            if (gnt[1]) assert(bus_out == data1);
            if (gnt == 2'b00) assert(bus_out == 8'h00);

            // 3. Spurious Check
            if (gnt[0]) assert($past(req[0]));
            if (gnt[1]) assert($past(req[1]));

            // 4. Forward Progress
            if ($past(req[0]) && !$past(rst))
                assert(gnt[0] == 1'b1);
        end
    end

    initial assume(rst);

endmodule
