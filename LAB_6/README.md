# LAB 6: Traffic Light Controller with Formal Verification

## Objective

Design, formally verify, and implement a simple **asynchronous Traffic Light Controller** using:

1. **FSM Specification** - Define states and transitions
2. **Kripke Structure** - Formal model of system behavior
3. **CTL Verification** - Prove critical safety and liveness properties
4. **Verilog Implementation** - Synthesizable HDL design
5. **Performance Analysis** - Critical path delay, dynamic power, resource consumption

**System:** 2-way traffic light (North-South & East-West)

---

## Project Structure

```
LAB_6/
├── README.md
├── source_codes/
│   └── traffic_light.v            # Traffic light FSM implementation
└── sim_codes/
    └── traffic_light_tb.v         # Testbench for verification
```

---

## System Specification

### Traffic Light Controller

**Directions:**
- **North-South (NS):** Green, Yellow, Red
- **East-West (EW):** Green, Yellow, Red

**Cycle Sequence:**
1. NS Green, EW Red → (GREEN_CYCLES)
2. NS Yellow, EW Red → (YELLOW_CYCLES)
3. NS Red, EW Green → (GREEN_CYCLES)
4. NS Red, EW Yellow → (YELLOW_CYCLES)
5. Repeat from step 1

**Timing Parameters:**
- `GREEN_CYCLES`: Duration of green light (e.g., 50 clock cycles)
- `YELLOW_CYCLES`: Duration of yellow light (e.g., 10 clock cycles)

---

## Design Methodology

### Step 1: FSM Specification

**States (4 states):**
```
S_NS_GREEN: North-South Green, East-West Red
S_NS_YEL:   North-South Yellow, East-West Red
S_EW_GREEN: North-South Red, East-West Green
S_EW_YEL:   North-South Red, East-West Yellow
```

**State Transitions:**
```
S_NS_GREEN --[timer==GREEN_CYCLES-1]--> S_NS_YEL
S_NS_YEL   --[timer==YELLOW_CYCLES-1]--> S_EW_GREEN
S_EW_GREEN --[timer==GREEN_CYCLES-1]--> S_EW_YEL
S_EW_YEL   --[timer==YELLOW_CYCLES-1]--> S_NS_GREEN
```

**State Encoding:**
```verilog
S_NS_GREEN = 2'b00
S_NS_YEL   = 2'b01
S_EW_GREEN = 2'b10
S_EW_YEL   = 2'b11
```

---

### Step 2: Kripke Structure Development

**Definition:** A Kripke structure is a tuple **M = (S, S₀, R, L)** where:
- **S**: Set of states
- **S₀**: Initial state(s)
- **R**: Transition relation (S × S)
- **L**: Labeling function (maps states to atomic propositions)

**For Traffic Light Controller:**

**States (S):**
```
S = {S_NS_GREEN, S_NS_YEL, S_EW_GREEN, S_EW_YEL}
```

**Initial State (S₀):**
```
S₀ = {S_NS_GREEN}
```

**Transition Relation (R):**
```
R = {
    (S_NS_GREEN, S_NS_YEL),
    (S_NS_YEL, S_EW_GREEN),
    (S_EW_GREEN, S_EW_YEL),
    (S_EW_YEL, S_NS_GREEN)
}
```

**Atomic Propositions:**
```
ns_green, ns_yellow, ns_red,
ew_green, ew_yellow, ew_red
```

**Labeling Function (L):**
```
L(S_NS_GREEN) = {ns_green, ew_red}
L(S_NS_YEL)   = {ns_yellow, ew_red}
L(S_EW_GREEN) = {ns_red, ew_green}
L(S_EW_YEL)   = {ns_red, ew_yellow}
```

---

### Step 3: CTL Properties (Temporal Logic)

**Computational Tree Logic (CTL)** formulas to verify:

#### Safety Properties (Nothing bad happens)

**P1: Mutual Exclusion**
```
AG ¬(ns_green ∧ ew_green)
"Always Globally, NS and EW are never both green simultaneously"
```

**P2: No Conflicting Lights**
```
AG ¬(ns_green ∧ ns_red)
AG ¬(ew_green ∧ ew_red)
"A direction never shows green and red at the same time"
```

**P3: Always One Direction Red**
```
AG (ns_red ∨ ew_red)
"At least one direction is always red (safe state)"
```

#### Liveness Properties (Something good eventually happens)

**P4: NS Eventually Gets Green**
```
AG (AF ns_green)
"From any state, NS will eventually get green light"
```

**P5: EW Eventually Gets Green**
```
AG (AF ew_green)
"From any state, EW will eventually get green light"
```

**P6: No Deadlock**
```
AG (EX true)
"From any state, there exists a next state (no deadlock)"
```

#### Fairness Properties

**P7: Fair Access**
```
AG (ns_green → AF ew_green)
"If NS is green, EW will eventually be green"
```

**P8: Yellow Precedes State Change**
```
AG (ns_green → AX (ns_green ∨ ns_yellow))
"Green is always followed by green or yellow (not direct to red)"
```

---

### Step 4: Verilog Implementation

**Moore Machine Design:**
- Outputs depend only on current state
- State register (D flip-flops)
- Timer counter for state duration
- Combinational next-state logic
- Combinational output logic

**Key Features:**
```verilog
- State encoding using parameters
- Timer-based transitions
- Reset to S_NS_GREEN
- Moore outputs (6 signals: ns_g, ns_y, ns_r, ew_g, ew_y, ew_r)
```

---

## Using Files in Vivado

### 1. Simulation (Verify CTL Properties)

```
1. Create New Project → RTL Project
2. Add file: traffic_light.v
3. Add simulation source: traffic_light_tb.v
4. Flow Navigator → Run Simulation
5. Verify in waveform:
   ✓ Only one direction green at a time (P1)
   ✓ Proper state sequence (S_NS_GREEN → S_NS_YEL → S_EW_GREEN → S_EW_YEL)
   ✓ Correct timing (GREEN_CYCLES, YELLOW_CYCLES)
   ✓ All states reachable (P4, P5)
```

**Simulation Parameters:**
```verilog
// Testbench uses short cycles for fast simulation
.GREEN_CYCLES(5)    // 5 clock cycles
.YELLOW_CYCLES(2)   // 2 clock cycles
```

**Expected Output Pattern:**
```
NS: G=1 Y=0 R=0 || EW: G=0 Y=0 R=1  (5 cycles)
NS: G=0 Y=1 R=0 || EW: G=0 Y=0 R=1  (2 cycles)
NS: G=0 Y=0 R=1 || EW: G=1 Y=0 R=0  (5 cycles)
NS: G=0 Y=0 R=1 || EW: G=0 Y=1 R=0  (2 cycles)
(Repeat)
```

---

### 2. Synthesis & Analysis

**Step 1: Synthesis**
```
1. Set traffic_light.v as top module
2. Flow Navigator → Run Synthesis
```

**Step 2: Get Resource Utilization**
```
Method 1: Open Synthesized Design → Window → Utilization
         Note: Slice LUTs, Slice Registers
Method 2 (TCL): report_utilization -file util.txt
```

**Step 3: Get Critical Path Delay**
```tcl
# In TCL Console after opening synthesized design
report_timing -from [all_registers] -to [all_outputs] -max_paths 1 -file timing.txt
# Note the "Data Path Delay" value
```

**Step 4: Get Dynamic Power**
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
| **States** | 4 |
| **State Encoding** | Binary (2 bits) |
| **Slice LUTs** | _____ |
| **Slice Registers (FFs)** | _____ |
| **Critical Path Delay (ns)** | _____ |
| **Total Power (W)** | _____ |
| **Dynamic Power (W)** | _____ |
| **Static Power (W)** | _____ |
| **Maximum Frequency (MHz)** | _____ |

---

## CTL Verification Checklist

Verify each property during simulation:

- [ ] **P1:** NS and EW never both green ✓
- [ ] **P2:** No conflicting lights within same direction ✓
- [ ] **P3:** At least one direction always red ✓
- [ ] **P4:** NS eventually gets green ✓
- [ ] **P5:** EW eventually gets green ✓
- [ ] **P6:** System never deadlocks ✓
- [ ] **P7:** Fair alternation between directions ✓
- [ ] **P8:** Yellow always between green and red ✓

---

## Formal Verification Notes

### Manual CTL Verification

**Method 1: State-by-State Check**
```
For each state, verify atomic propositions:
- S_NS_GREEN: {ns_g=1, ew_r=1} → P1 holds (no conflict)
- S_NS_YEL:   {ns_y=1, ew_r=1} → P1 holds
- S_EW_GREEN: {ns_r=1, ew_g=1} → P1 holds
- S_EW_YEL:   {ns_r=1, ew_y=1} → P1 holds
```

**Method 2: Transition Graph Analysis**
```
Draw Kripke structure as directed graph
Trace all possible paths
Verify CTL formulas using path quantifiers (A, E, G, F, X)
```

### Tool-Based Verification (Optional)

Use model checkers like:
- **NuSMV**: Symbolic model checker for CTL
- **SPIN**: Linear Temporal Logic (LTL) verification
- **Formal verification tools in Vivado** (if available)

---

## Design Extensions

### Adding Sensor Input
```verilog
input wire ns_sensor,  // Vehicle detected on NS
input wire ew_sensor   // Vehicle detected on EW
```
Modify next-state logic to prioritize direction with waiting vehicles.

### Adding Pedestrian Crossing
```verilog
Add state: S_PED_CROSS
All-red state for safe pedestrian crossing
```

### Emergency Vehicle Priority
```verilog
input wire emergency
Override normal cycle, force green in emergency direction
```

---

## Analysis Questions

1. **Is the system safe?** (Verify P1, P2, P3)
2. **Is the system live?** (Verify P4, P5, P6)
3. **Is the system fair?** (Verify P7, P8)
4. **What is the cycle time?** `2*(GREEN_CYCLES + YELLOW_CYCLES) clock cycles`
5. **How does timer width affect resource usage?**
6. **What happens if timer overflows?** (Consider in design)

---

## Quick Reference Commands

```tcl
# Resource Utilization
report_utilization -file utilization.txt

# Critical Path Delay
report_timing -from [all_registers] -to [all_outputs] -max_paths 1 -file timing.txt

# Clock Analysis
report_clock_interaction -file clock.txt

# Dynamic Power
report_power -file power.txt

# View State Machine
show_schematic [get_cells -hier *state*]
```

---

## Common Issues & Solutions

**Issue 1: Multiple lights active simultaneously**
- **Cause:** Incomplete case statement in output logic
- **Solution:** Assign all 6 outputs in every case branch

**Issue 2: Timer doesn't reset**
- **Cause:** Missing timer reset on state change
- **Solution:** Reset timer when `state != next_state`

**Issue 3: System stuck in one state**
- **Cause:** Timer comparison incorrect
- **Solution:** Use `timer == CYCLES-1` for transition

---

## Deliverables

1. ✅ FSM state diagram
2. ✅ Kripke structure (S, S₀, R, L)
3. ✅ CTL properties (at least 5)
4. ✅ Verilog implementation
5. ✅ Simulation waveforms showing CTL verification
6. ✅ Synthesis reports (LUTs, delay, power)

---

**Last Updated:** November 2025
