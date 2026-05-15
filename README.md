# Formal Verification in VLSI: A Practical Guide

This project demonstrates the core concepts of Formal Verification (FV) using a simple hardware Arbiter. Unlike traditional simulation, which tests specific inputs, Formal Verification uses mathematical logic to prove that a design meets its specification for **all** possible input sequences.

## 🛠️ The Example: A Priority Arbiter
The design (`src/arbiter.v`) is a simple block that grants access to a bus.
- **Goal**: If User 0 and User 1 both request the bus, User 0 (priority) should win.
- **Constraint**: Only one user can have the bus at a time (Mutual Exclusion).

## 🧠 Key Formal Verification Concepts

Using this project, we can explore the four pillars of FV:

### 1. Assertions (The "What")
Assertions define what the design **must** do. In `formal/arbiter_formal.sv`, we define:
- `assert(gnt != 2'b11);` -> **Mutual Exclusion**: Proves we never grant the bus to both users.
- `if ($past(req[0])) assert(gnt[0]);` -> **Liveness/Priority**: Proves that if User 0 asks, they *will* get it.

### 2. Assumptions (The "Environment")
Assumptions define the rules the world must follow. The solver won't try inputs that break these rules.
- `assume(rst);` (Initial) -> Tells the tool to start the proof from a valid Reset state.

### 3. Bounded Model Checking (BMC)
This is the engine we used. It explores all possible states up to a certain "depth" (e.g., 10 clock cycles). If any bug can happen within 10 cycles, BMC **guarantees** it will find it.

### 4. Counter-Examples (The "Evidence")
When our verification failed earlier, the tool didn't just say "No." It provided a **trace.vcd**. This is a waveform showing the exact sequence of `req` signals that led to the `assert` failure. It's like a debugger that automatically finds the failing test case for you.

## 🚀 How to Run

1. **Setup**: Ensure the OSS CAD Suite is in your PATH.
2. **Execute**:
   ```bash
   cd formal
   sby -f arbiter.sby
   ```

## 🔍 Why Formal?
| Feature | Simulation (Testing) | Formal Verification |
| :--- | :--- | :--- |
| **Coverage** | Only what you write tests for. | 100% of all possible input combos. |
| **Bugs** | Finds "known" bugs. | Finds "corner-case" bugs you never thought of. |
| **Effort** | Writing complex test vectors. | Writing properties (assertions). |

---
*Created as part of the Formal Verification Learning Path.*
