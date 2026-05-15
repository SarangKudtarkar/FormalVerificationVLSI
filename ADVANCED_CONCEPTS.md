# Advanced Formal Verification Concepts

This project demonstrates how to verify complex behavior using Assertions and Cover statements.

## 🧠 Advanced Concepts

### 1. Spurious Checks (No "Ghost" Grants)
Ensures the hardware doesn't "hallucinate" an event. A grant should only exist if a request preceded it.
- **Assertion**: `if (gnt[0]) assert($past(req[0]));`
- **Why?**: In critical systems (like PCIe or DDR controllers), a spurious grant can cause data corruption or bus contention.

### 2. Forward Progress (Liveness)
Ensures that the system doesn't get stuck. If a request is made, the design is *obligated* to respond.
- **In our Arbiter**: 
    - User 0 (Priority) is guaranteed forward progress immediately.
    - User 1 (Low Priority) only has guaranteed progress if User 0 is not hogging the bus.
- **Formal Check**: We prove that if `req[1]` is high and `req[0]` is low, `gnt[1]` **must** happen.

### 3. Fairness vs. Starvation
In a **Priority Arbiter**, the system is technically "unfair" because User 0 can starve User 1 indefinitely by keeping `req[0]` high.
- **Fairness Check**: We use `cover(gnt[1])` to prove that it is *at least possible* for User 1 to get the bus. 
- **Starvation**: If we tried to `assert` that User 1 *always* eventually gets a grant, the formal tool would find a **Counter-Example** where User 0 never stops requesting, proving the design allows starvation.

## 🚀 Running the Advanced Suite
```bash
cd formal
sby -f arbiter.sby
```
You will see `Passed` for all assertions and `Reached` for the cover statement.
