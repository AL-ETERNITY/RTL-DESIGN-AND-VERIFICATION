# LAB 3: Multi-Level Logic Optimization using ESPRESSO

## Objective

Implement three 4-variable Boolean functions using ESPRESSO-based multi-level optimization and compare resource utilization (LUTs), critical path delay, and power consumption for different implementation strategies:

**Functions:**
- **F1** = Σm(1, 2, 5, 8, 11, 12, 13)
- **F2** = Σm(2, 5, 8, 13, 14, 15)
- **F3** = Σm(0, 1, 10, 11, 12, 13)

**Implementation Strategies:**
1. Separate F1 + Separate F2 + Separate F3
2. Combined F1&F2 + Separate F3
3. Separate F1 + Combined F2&F3
4. Combined F1&F2&F3

---

## Project Structure

```
LAB_3/
├── README.md
└── source_codes/
    ├── func1.v                    # F1 only (separate implementation)
    ├── func2.v                    # F2 only (separate implementation)
    ├── func3.v                    # F3 only (separate implementation)
    ├── func1func2.v               # Combined F1 & F2
    ├── func2_func3.v              # Combined F2 & F3
    └── func1_func2_func3.v        # Combined F1 & F2 & F3
```

---

## Implementation Details

### Separate Functions
- **func1.v**: F1 implemented with optimized product terms
- **func2.v**: F2 implemented with optimized product terms
- **func3.v**: F3 implemented with optimized product terms
- Each uses `(* DONT_TOUCH *)` to preserve optimization structure

### Combined Functions
- **func1func2.v**: Shared logic between F1 and F2 (common subexpressions)
- **func2_func3.v**: Shared logic between F2 and F3
- **func1_func2_func3.v**: Shared logic among all three functions
- Multi-level optimization exploits common terms to reduce area

---

## Using Files in Vivado

### Strategy 1: Separate F1 + Separate F2 + Separate F3

**Step 1: Create Project**
```
1. Create New Project → RTL Project
2. Add files: func1.v, func2.v, func3.v
3. Create a top module that instantiates all three:
```

```verilog
module top_separate(
    input [3:0] in,
    output F1, F2, F3
);
    func1 u1(.a(in[3]), .b(in[2]), .c(in[1]), .d(in[0]), .F1(F1));
    func2 u2(.a(in[3]), .b(in[2]), .c(in[1]), .d(in[0]), .F2(F2));
    func3 u3(.A(in[3]), .B(in[2]), .C(in[1]), .F(F3));
endmodule
```

**Step 2: Synthesis & Analysis**
```
1. Set top_separate as top module
2. Run Synthesis
3. Collect metrics
```

### Strategy 2: Combined F1&F2 + Separate F3

**Files to Add:**
```
1. Add files: func1func2.v, func3.v
2. Create top module:
```

```verilog
module top_f12_f3(
    input [3:0] in,
    output F12, F3
);
    func1func2 u12(.a(in[3]), .b(in[2]), .c(in[1]), .d(in[0]), .F12(F12));
    func3 u3(.A(in[3]), .B(in[2]), .C(in[1]), .F(F3));
endmodule
```

### Strategy 3: Separate F1 + Combined F2&F3

**Files to Add:**
```
1. Add files: func1.v, func2_func3.v
2. Create top module:
```

```verilog
module top_f1_f23(
    input [3:0] in,
    output F1, F23
);
    func1 u1(.a(in[3]), .b(in[2]), .c(in[1]), .d(in[0]), .F1(F1));
    func2_func3 u23(.a(in[3]), .b(in[2]), .c(in[1]), .d(in[0]), .F23(F23));
endmodule
```

### Strategy 4: Combined F1&F2&F3

**Files to Add:**
```
1. Add file: func1_func2_func3.v
2. Set as top module (or wrap in top module)
```

---

## Vivado Workflow

**For Each Strategy:**

### 1. Synthesis
```
Flow Navigator → Run Synthesis
```

### 2. Get LUT Count (Resource Utilization)
```
Method 1: Open Synthesized Design → Window → Utilization → Note "Slice LUTs"
Method 2 (TCL): report_utilization -file util.txt
```

### 3. Get Delay (Critical Path)
```tcl
# In TCL Console after opening synthesized design
report_timing -max_paths 1 -file timing.txt
# Note the "Data Path Delay" value in ns
```

### 4. Get Power
```
1. Flow Navigator → Run Implementation
2. Open Implemented Design
3. TCL Console: report_power -file power.txt
4. Note: Total On-Chip Power, Dynamic Power, Static Power
```

---

## Data Collection

| Strategy | LUTs | Delay (ns) | Total Power (W) |
|----------|------|------------|-----------------|
| 1. Sep F1 + Sep F2 + Sep F3 | _____ | _____ | _____ |
| 2. Combined F1&F2 + Sep F3 | _____ | _____ | _____ |
| 3. Sep F1 + Combined F2&F3 | _____ | _____ | _____ |
| 4. Combined F1&F2&F3 | _____ | _____ | _____ |

---

## Analysis Questions

1. **Which strategy uses the least LUTs?** (Best area efficiency)
2. **Which strategy has the shortest delay?** (Best performance)
3. **Which strategy consumes the least power?** (Best power efficiency)
4. **What is the trade-off between area and delay?**
5. **How does logic sharing affect the metrics?**

---

## Expected Observations

- **Combined implementations** typically use fewer LUTs due to shared logic
- **Separate implementations** may have simpler routing and potentially lower delay
- **More sharing** generally reduces power consumption (fewer gates switching)
- **Optimal strategy** depends on design constraints (area vs. speed vs. power)

---

## Quick Reference Commands

```tcl
# Resource Utilization
report_utilization -file utilization.txt

# Critical Path Delay
report_timing -max_paths 1 -file timing.txt

# Power Consumption
report_power -file power.txt
```

---

**Last Updated:** November 2025
