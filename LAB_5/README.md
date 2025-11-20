# LAB 5: FSM-Based Sequence Detector (Mealy Machine)

## Objective

Design a **Mealy machine FSM** to detect a specific **5-bit binary sequence** in a serial input stream using the **non-overlapping** approach. The design includes:

1. **Sequence Generation** - Generate 5-bit pattern from last 3 digits of roll number
2. **State Optimization** - Minimize the number of states
3. **State Encoding** - Apply efficient state encoding (Binary/Gray/One-Hot)
4. **D Flip-Flop Implementation** - Use D flip-flops for state registers
5. **Performance Analysis** - Measure delay, power, and resource consumption

**Example:** For sequence `11100` (non-overlapping detection)

---

## Project Structure

```
LAB_5/
├── README.md
├── source_codes/
│   └── FSM.v                      # Mealy FSM sequence detector
└── sim_codes/
    └── FSM_tb.v                   # Testbench for FSM verification
```

---

## Design Specifications

### Mealy Machine
- **Output depends on:** Current state AND current input
- **Advantages:** Fewer states than Moore, faster response
- **Implementation:** Combinational output logic

### Non-Overlapping Detection
- **Behavior:** After detecting sequence, FSM resets to initial state
- **Example:** Input `111001110011100`
  - First `11100` detected at position 5 → output = 1, reset to S0
  - Second `11100` detected at position 10 → output = 1, reset to S0
  - Third `11100` detected at position 15 → output = 1, reset to S0

### Overlapping vs Non-Overlapping
```
Overlapping:    Can reuse part of detected sequence for next detection
Non-Overlapping: Must start fresh after each detection
```

---

## Design Methodology

### Step 1: Generate Your Sequence
```
Use the provided code to generate 5-bit sequence from last 3 digits of roll number
Example: Roll# XXX123 → Enter 123 → Get sequence (e.g., 11100)
```

### Step 2: State Diagram
Create state diagram for your sequence (example for `11100`):
```
S0 --1--> S1  (detected 1st bit: 1)
S1 --1--> S2  (detected 2nd bit: 1)
S2 --1--> S3  (detected 3rd bit: 1)
S3 --0--> S4  (detected 4th bit: 0)
S4 --0--> S0, output=1  (detected 5th bit: 0, sequence complete)

Any mismatch → return to appropriate state
```

### Step 3: State Minimization
- Check for equivalent states
- Merge redundant states
- Minimize total state count

### Step 4: State Encoding
Choose encoding scheme:
- **Binary:** Minimum bits (log₂(n) bits for n states)
- **Gray:** Reduces bit transitions
- **One-Hot:** One bit per state (fast decoding)

**Example (5 states):**
```
Binary:   S0=000, S1=001, S2=010, S3=011, S4=100
Gray:     S0=000, S1=001, S2=011, S3=010, S4=110
One-Hot:  S0=00001, S1=00010, S2=00100, S3=01000, S4=10000
```

### Step 5: State Transition Table
Create table with columns:
- Current State
- Input (x)
- Next State
- Output (y) - Mealy output

### Step 6: D Flip-Flop Excitation
For D flip-flops: **D = Next State**
- Derive Boolean expressions for each D input
- Derive Boolean expression for output y

### Step 7: Verilog Implementation
- State register using D flip-flops (always @(posedge clk))
- Next-state combinational logic
- Output combinational logic (Mealy)

---

## FSM Structure

### Current Implementation (Example: Sequence `11100`)

**States:** 5 states (S0 to S4)  
**Encoding:** Gray code (3 bits)
```verilog
S0 = 3'b000  // Initial state
S1 = 3'b001  // Detected "1"
S2 = 3'b011  // Detected "11"
S3 = 3'b010  // Detected "111"
S4 = 3'b100  // Detected "1110"
```

**State Transitions:**
- S0: Wait for first '1'
- S1: Wait for second '1'
- S2: Wait for third '1'
- S3: Wait for first '0'
- S4: Wait for second '0' → Output y=1, return to S0

---

## Using Files in Vivado

### 1. Simulation (Verify Functionality)

```
1. Create New Project → RTL Project
2. Add file: FSM.v
3. Add simulation source: FSM_tb.v
4. Flow Navigator → Run Simulation
5. Verify:
   - FSM correctly detects your sequence
   - Output y=1 only when complete sequence detected
   - Non-overlapping behavior (resets after detection)
```

**Waveform Analysis:**
- Monitor state transitions
- Verify output y pulses at correct times
- Check reset behavior

### 2. Synthesis & Analysis

**Step 1: Synthesis**
```
1. Set FSM.v as top module
2. Flow Navigator → Run Synthesis
```

**Step 2: Get Resource Utilization**
```
Method 1: Open Synthesized Design → Window → Utilization
         Note: Slice LUTs, Slice Registers (D Flip-flops)
Method 2 (TCL): report_utilization -file util.txt
```

**Step 3: Get Delay (Clock-to-Output)**
```tcl
# In TCL Console after opening synthesized design
report_timing -from [all_registers] -to [get_ports y] -max_paths 1 -file timing.txt
# Note the "Data Path Delay" value
```

**Step 4: Get Power**
```
1. Flow Navigator → Run Implementation
2. Open Implemented Design
3. TCL Console: report_power -file power.txt
4. Note: Total On-Chip Power, Dynamic Power, Static Power
```

---

## Data Collection Template

| Metric | Value |
|--------|-------|
| **Sequence Detected** | _____ (e.g., 11100) |
| **Number of States** | _____ |
| **State Encoding** | _____ (Binary/Gray/One-Hot) |
| **State Bits** | _____ |
| **Slice LUTs** | _____ |
| **Slice Registers** | _____ |
| **Clock-to-Output Delay (ns)** | _____ |
| **Total Power (W)** | _____ |
| **Dynamic Power (W)** | _____ |
| **Maximum Frequency (MHz)** | _____ |

---

## Modifying for Your Sequence

### Example: Change from `11100` to `10110`

1. **Update State Diagram:**
```
S0 --1--> S1  (detected "1")
S1 --0--> S2  (detected "10")
S2 --1--> S3  (detected "101")
S3 --1--> S4  (detected "1011")
S4 --0--> S0, y=1  (detected "10110", non-overlapping)
```

2. **Update FSM.v:**
```verilog
case (state)
    S0: next_state = (x) ? S1 : S0;
    S1: next_state = (x) ? S0 : S2;  // Changed: need 0
    S2: next_state = (x) ? S3 : S0;
    S3: next_state = (x) ? S4 : S0;  // Changed: need 1
    S4: begin
        if (!x) begin                // Changed: need 0
            y = 1;
            next_state = S0;
        end else
            next_state = S1;         // Possible restart
    end
endcase
```

---

## Analysis Questions

1. **How many states are required for your sequence?**
2. **Can any states be minimized/merged?**
3. **Which state encoding minimizes LUT usage?**
4. **What is the critical path in your design?**
5. **How does state encoding affect power consumption?**
6. **What is the maximum clock frequency your FSM can operate at?**

---

## Expected Observations

**Resource Usage:**
- LUTs: Depends on state encoding and sequence complexity
- Flip-flops: Equal to number of state encoding bits
- Example: 5 states → 3 FFs (binary/gray) or 5 FFs (one-hot)

**Timing:**
- Critical path: State register → Combinational logic → Output
- Mealy machines typically faster than Moore (no output register)

**Power:**
- Dynamic power: Proportional to state transitions
- Gray encoding may reduce power (fewer bit flips)
- One-hot may increase power (more flip-flops)

---

## Common Design Patterns

### Reset Behavior
```verilog
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= S0;  // Return to initial state
    else
        state <= next_state;
end
```

### Mealy Output Logic
```verilog
always @(*) begin
    y = 0;  // Default output
    case (state)
        // Output depends on state AND input
        S4: y = (x == 0) ? 1 : 0;
        default: y = 0;
    endcase
end
```

---

## Quick Reference Commands

```tcl
# Resource Utilization
report_utilization -file utilization.txt

# Timing Analysis (Register to Output)
report_timing -from [all_registers] -to [all_outputs] -max_paths 1 -file timing.txt

# Maximum Frequency
report_clock_interaction -file clock.txt

# Power Consumption
report_power -file power.txt

# View State Diagram (after synthesis)
show_schematic [get_cells -hier *state*]
```

---

## Debugging Tips

**Simulation Issues:**
- Verify state transitions match state diagram
- Check reset initializes to S0
- Ensure non-overlapping: output resets FSM

**Synthesis Issues:**
- Use explicit state encoding with `parameter`
- Avoid latches: assign all outputs in all cases
- Check for unreachable states

**Timing Issues:**
- If delay too high, simplify next-state logic
- Consider pipelining for complex sequences
- Check for long combinational paths

---

**Last Updated:** November 2025
