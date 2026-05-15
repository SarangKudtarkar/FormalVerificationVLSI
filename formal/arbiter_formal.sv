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
            // 1. Mutual Exclusion
            assert(gnt != 2'b11);

            // 2. [SPURIOUS CHECK]
            // A grant must never appear without a corresponding request in the previous cycle.
            if (gnt[0]) assert($past(req[0]));
            if (gnt[1]) assert($past(req[1]));

            // 3. [FORWARD PROGRESS] (High Priority)
            // If User 0 requests, they MUST receive a grant in the next cycle.
            if ($past(req[0]) && !$past(rst))
                assert(gnt[0] == 1'b1);

            // 4. [FORWARD PROGRESS] (Low Priority)
            // If User 1 requests AND User 0 is idle, User 1 MUST receive a grant.
            if ($past(req[1]) && !$past(req[0]) && !$past(rst))
                assert(gnt[1] == 1'b1);

            // 5. [FAIRNESS / REACHABILITY]
            // We use 'cover' to prove that it is actually POSSIBLE for User 1 to win.
            // If this fails, the design is "unfair" to the point of starvation.
            cover(gnt[1] == 1'b1);
        end
    end

    // Initial reset assumption
    initial begin
        assume(rst);
    end

endmodule
