# Two-Level vs Multi-Level Logic Comparison

## Overview

This folder contains **two implementations** of the same hazard detection logic to compare **two-level (SOP)** and **multi-level (factored)** Boolean logic implementations.

**Purpose:** Analyze the trade-offs between area, delay, and power for different logic synthesis approaches.

---

## Files

```
two_level_vs_multilevel_logic/
├── README.md
├── two_level.v      # Two-level Sum-of-Products implementation
└── Multi_level.v    # Multi-level factored implementation
```

---

## Implementations

### Two-Level Logic (two_level.v)

**Structure:** Direct Sum-of-Products (SOP)
```verilog
STALL_data = (EX_RW & D_EX) | (EX_MR & D_EX) |
             (EX_RW & T_EX) | (EX_MR & T_EX) |
             (MEM_RW & D_MEM) | (MEM_RW & T_MEM);
```

**Characteristics:**
- **Logic Levels:** 2 (AND gates → OR gate)
- **Gate Count:** 6 AND gates + 1 OR gate
- **Delay:** Low (only 2 gate delays)
- **Area:** Higher (more gates)

---

### Multi-Level Logic (Multi_level.v)

**Structure:** Factored form with intermediate terms
```verilog
A = EX_RW | EX_MR;
B = D_EX | T_EX;
C = D_MEM | T_MEM;
D = A & B;
E = MEM_RW & C;
STALL_data = D | E;
```

**Characteristics:**
- **Logic Levels:** 3-4 (factored hierarchy)
- **Gate Count:** Fewer total gates
- **Delay:** Slightly higher (more logic levels)
- **Area:** Lower (shared logic)

---

## Using in Vivado

### Running Synthesis for Each Implementation

**Important:** Only **ONE** implementation should be active at a time.

**Step 1: Select Implementation**
```
In the Verilog file (two_level.v or Multi_level.v):
1. Uncomment the implementation you want to test
2. Comment out the other implementation

Example: To test Two-Level Logic
- Uncomment module two_level { ... }
- Comment out module Multi_level { ... }
```

**Step 2: Create Project**
```
1. Create New Project → RTL Project
2. Add ONLY the file you want to test (two_level.v OR Multi_level.v)
3. Set as top module
```

**Step 3: Run Synthesis**
```
Flow Navigator → Run Synthesis
```

**Step 4: Collect Metrics**

**Resource Utilization:**
```tcl
report_utilization -file util.txt
# Note: Slice LUTs
```

**Critical Path Delay:**
```tcl
report_timing -max_paths 1 -file timing.txt
# Note: Data Path Delay (ns)
```

**Step 5: Run Implementation**
```
Flow Navigator → Run Implementation
```

**Step 6: Get Power**
```tcl
report_power -file power.txt
# Note: Dynamic Power, Total Power
```

**Step 7: Record Results**
```
Fill in the comparison table below
```

---

## Comparison Data Collection

| Metric | Two-Level | Multi-Level | Difference |
|--------|-----------|-------------|------------|
| **Slice LUTs** | _____ | _____ | _____ |
| **Delay (ns)** | _____ | _____ | _____ |
| **Dynamic Power (W)** | _____ | _____ | _____ |
| **Total Power (W)** | _____ | _____ | _____ |
| **Logic Levels** | 2 | 3-4 | - |

---

## Analysis Questions

1. **Which implementation uses fewer LUTs?**
   - Expected: Multi-level (due to factoring and sharing)

2. **Which implementation has lower delay?**
   - Expected: Two-level (fewer logic levels)

3. **Which implementation consumes less power?**
   - Expected: Multi-level (fewer gates, less switching)

4. **When would you prefer two-level logic?**
   - When speed is critical and area is not constrained

5. **When would you prefer multi-level logic?**
   - When area/power is critical and slight delay increase is acceptable

---

## Expected Results

**Two-Level:**
- ✓ Faster (lower delay)
- ✗ More area (more LUTs)
- ✗ More power (more gates)

**Multi-Level:**
- ✓ Less area (fewer LUTs through factoring)
- ✓ Less power (fewer gates switching)
- ✗ Slightly slower (more logic levels)

**Trade-off:** Speed vs Area/Power

---

## Implementation Details

### Two-Level Features
- Direct ESPRESSO output (minimized SOP)
- Flat structure
- Parallel gate evaluation
- Uses `(* DONT_TOUCH *)` to prevent optimization

### Multi-Level Features
- Hierarchical factoring
- Intermediate signal reuse
- Sequential gate evaluation
- Uses `(* KEEP *)` to preserve structure

---

## Switching Between Implementations

**Method 1: Comment/Uncomment**
```verilog
// Test Two-Level:
module two_level(...);
    // implementation
endmodule

// Test Multi-Level (comment this out):
// module Multi_level(...);
//     // implementation
// endmodule
```

**Method 2: Separate Projects**
```
Create two separate Vivado projects:
1. Project_TwoLevel (with two_level.v)
2. Project_MultiLevel (with Multi_level.v)
```

---

## Quick Commands

```tcl
# Utilization
report_utilization -hierarchical -file util.txt

# Timing (combinational path)
report_timing -from [all_inputs] -to [all_outputs] -max_paths 1

# Power
report_power -file power.txt

# Logic levels
report_design_analysis -logic_level_distribution
```

---

**See `Project_Report.pdf` for detailed comparison results and analysis.**