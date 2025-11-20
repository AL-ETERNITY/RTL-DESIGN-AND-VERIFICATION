# LAB 4: Mod-10 Down Counter with Different State Encodings

## Objective

Design a **mod-10 down counter** (counts from 9 to 0) using **JK flip-flops** with three different state encoding schemes and compare their delay, power consumption, and resource utilization (LUTs/FFs):

**State Encoding Schemes:**
1. **Binary State Encoding** (4 bits: 0000 to 1001)
2. **Gray State Encoding** (4 bits: Gray code sequence)
3. **One-Hot Encoding** (10 bits: one bit active per state)

**Counter Sequence:** 9 → 8 → 7 → 6 → 5 → 4 → 3 → 2 → 1 → 0 → 9 (repeats)

---

## Project Structure

```
LAB_4/
├── README.md
├── source_codes/
│   ├── Binary_State.v              # Binary encoding (4 JK flip-flops)
│   ├── One_Hot.v                   # One-hot encoding (10 JK flip-flops)
│   ├── JK_FlipFlop.v               # JK flip-flop module (for Binary/Gray)
│   └── JK_FlipFlop_One_hot.v       # JK flip-flop with preset/clear (for One-hot)
└── sim_codes/
    ├── Binary_State_tb.v           # Testbench for Binary encoding
    └── One_Hot_tb.v                # Testbench for One-hot encoding
```

**Note:** Gray encoding implementation would be similar to Binary_State.v but with different JK excitation logic based on Gray code transitions.

---

## State Encoding Details

### 1. Binary State Encoding
- **States:** 9 (1001) → 8 (1000) → ... → 1 (0001) → 0 (0000) → 9
- **Flip-flops:** 4 JK flip-flops (Q3, Q2, Q1, Q0)
- **Next-state logic:** Derived from state transition table and JK excitation table
- **Trade-off:** Minimal flip-flops, complex combinational logic

### 2. Gray State Encoding
- **States:** Gray code sequence for 0-9
- **Flip-flops:** 4 JK flip-flops
- **Benefit:** Only one bit changes per transition (reduced power/glitches)
- **Trade-off:** More complex state assignment, similar resources to binary

### 3. One-Hot Encoding
- **States:** 10 bits, only one bit is '1' at a time
  - State 9: `10_0000_0000`
  - State 8: `01_0000_0000`
  - ...
  - State 0: `00_0000_0001`
- **Flip-flops:** 10 JK flip-flops
- **Next-state logic:** Simple (J[i] = Q[i+1], K[i] = Q[i])
- **Trade-off:** More flip-flops, simpler combinational logic

---

## Design Methodology

### Step 1: State Transition Table
Create down counter sequence for each encoding:
```
Current State → Next State
    9         →     8
    8         →     7
    ...
    1         →     0
    0         →     9
```

### Step 2: JK Excitation Table
For each flip-flop transition (Q → Q+), determine J and K values:
```
Q → Q+ | J  K
-------|------
0 → 0  | 0  X
0 → 1  | 1  X
1 → 0  | X  1
1 → 1  | X  0
```

### Step 3: Derive JK Logic Equations
- Use K-maps or Boolean algebra to derive J and K inputs for each flip-flop
- Minimize logic where possible

### Step 4: Implement in Verilog
- Instantiate JK flip-flops structurally
- Implement combinational logic for J and K inputs
- Use `(* DONT_TOUCH *)` to preserve structure for fair comparison

---

## Using Files in Vivado

### 1. Simulation (Verify Functionality)

**Test Binary Encoding:**
```
1. Create New Project → RTL Project
2. Add files: Binary_State.v, JK_FlipFlop.v
3. Add simulation source: Binary_State_tb.v
4. Flow Navigator → Run Simulation
5. Verify counter counts: 9 → 8 → 7 → ... → 0 → 9
```

**Test One-Hot Encoding:**
```
1. Add files: One_Hot.v, JK_FlipFlop_One_hot.v
2. Add simulation source: One_Hot_tb.v
3. Run Simulation
4. Verify one-hot pattern shifts correctly
```

### 2. Synthesis & Analysis

**For Each Encoding:**

**Step 1: Synthesis**
```
1. Set design as top module (e.g., Binary_State)
2. Flow Navigator → Run Synthesis
```

**Step 2: Get Resource Utilization**
```
Method 1: Open Synthesized Design → Window → Utilization
         Note: Slice LUTs, Slice Registers (Flip-flops)
Method 2 (TCL): report_utilization -file util.txt
```

**Step 3: Get Delay (Clock-to-Q + Logic Delay)**
```tcl
# In TCL Console after opening synthesized design
report_timing -from [all_registers] -to [all_registers] -max_paths 1 -file timing.txt
# Note the "Data Path Delay" or "Slack" value
```

**Step 4: Get Power**
```
1. Flow Navigator → Run Implementation
2. Open Implemented Design
3. TCL Console: report_power -file power.txt
4. Note: Total On-Chip Power, Dynamic Power, Static Power
```

---

## Data Collection

| Encoding | LUTs | Flip-Flops | Delay (ns) | Total Power (W) | Dynamic Power (W) |
|----------|------|------------|------------|-----------------|-------------------|
| Binary   | _____ | 4 | _____ | _____ | _____ |
| Gray     | _____ | 4 | _____ | _____ | _____ |
| One-Hot  | _____ | 10 | _____ | _____ | _____ |

---

## Analysis Questions

1. **Which encoding uses the most LUTs?** Why?
2. **Which encoding has the shortest delay?** Why?
3. **Which encoding consumes the least power?** Why?
4. **What is the trade-off between flip-flops and combinational logic?**
5. **When would you choose one-hot encoding over binary?**
6. **How does Gray encoding affect power consumption?**

---

## Expected Observations

**Binary Encoding:**
- Minimal flip-flops (4)
- More complex combinational logic for next-state
- Moderate delay and power

**Gray Encoding:**
- Minimal flip-flops (4)
- Similar LUT usage to binary
- Potentially lower dynamic power (fewer bit transitions)
- Good for reducing glitches

**One-Hot Encoding:**
- Maximum flip-flops (10)
- Simplest combinational logic (minimal LUTs)
- Fast state decoding (no decoder needed)
- Higher static power (more flip-flops)
- Lower combinational delay
- Preferred in FPGAs when speed is critical and flip-flops are abundant

---

## Implementation Notes

### Binary/Gray Encoding
- Uses standard JK flip-flop with asynchronous reset
- Reset initializes counter to state 9 (1001 in binary)
- Combinational logic derived from excitation equations

### One-Hot Encoding
- Uses JK flip-flop with preset/clear for initialization
- Reset sets Q[9]=1, all others=0 (state 9)
- Simple ring counter structure: J[i] = Q[i+1], K[i] = Q[i]

---

## Quick Reference Commands

```tcl
# Resource Utilization (LUTs and Flip-flops)
report_utilization -file utilization.txt

# Critical Path Delay (Register-to-Register)
report_timing -from [all_registers] -to [all_registers] -max_paths 1 -file timing.txt

# Power Consumption
report_power -file power.txt

# Clock Frequency Analysis
report_clock_interaction -file clock_report.txt
```

---

## Additional Analysis

### Area-Delay Product (ADP)
```
ADP = (LUTs + Flip-flops) × Delay
```
Lower is better for overall efficiency.

### Power-Delay Product (PDP)
```
PDP = Power × Delay
```
Measures energy efficiency per operation.

---

**Last Updated:** November 2025
