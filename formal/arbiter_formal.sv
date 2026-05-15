module arbiter_formal (
    input clk,
    input rst,
    input [1:0] req,
    output [1:0] gnt
);

    arbiter uut (
        .clk(clk),
        .rst(rst),
        .req(req),
        .gnt(gnt)
    );

    // After reset, we check properties
    always @(posedge clk) begin
        if (!rst) begin
            // 1. Mutual Exclusion: Only one grant at a time
            assert(gnt != 2'b11);

            // 2. Priority: If req[0] is high, gnt[0] must be high next cycle
            if ($past(req[0]) && !$past(rst))
                assert(gnt[0] == 1'b1);

            // 3. No Spurious Grants: If a grant exists, there must have been a request in the previous cycle
            if (gnt[0] && !$past(rst)) assert($past(req[0]));
            if (gnt[1] && !$past(rst)) assert($past(req[1]));
        end
    end

    // Initial reset assumption
    initial begin
        assume(rst);
    end

endmodule
