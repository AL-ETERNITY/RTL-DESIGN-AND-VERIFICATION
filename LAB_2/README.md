# LAB 2: Boolean Function Optimization Analysis

## Objective

Implement a 6-variable Boolean function **F(A, B, C, D, E, F)** in two ways and compare area (LUTs), delay, and power consumption:

**Minterms:** F = Σm(0, 4, 8, 10, 12, 16, 20, 24, 26, 28, 40, 42, 44, 46, 56, 58)  
**Don't Cares:** d = Σd(2, 6, 18, 22, 34, 38, 50, 54)

1. **Without optimization** - Direct Sum-of-Products (16 minterms)
2. **With optimization** - K-map/Quine-McCluskey simplified (3 product terms)

---

## Project Structure

```
LAB_2/
├── README.md
├── boolean_function.py                        # Minterm expression generator
├── graph.py                                   # Comparison visualization script
└── source_codes/
    ├── Boolean_func_without_optimization.v    # 16 minterms (unoptimized)
    └── Boolean_func_with_optimization.v       # 3 product terms (optimized)
```

---

## Implementation Details

### Unoptimized Design
- **Logic:** 16 separate AND gates (6 inputs each) ORed together
- **Expression:** Y = A'B'C'D'E'F' + A'B'C'DE'F' + ... (16 terms)
- **Features:** Uses `(* DONT_TOUCH *)` to prevent synthesis optimization

### Optimized Design
- **Logic:** 3 product terms after K-map simplification
- **Expression:** Y = (A'E'F') + (CD'F') + (AB'CD'F')
- **Reduction:** 81% fewer product terms, 90% fewer literals

---

## Using Files in Vivado

### 1. Simulation (Optional)
```
1. Create New Project → RTL Project
2. Add source file (Boolean_func_without_optimization.v or Boolean_func_with_optimization.v)
3. Set as top module
4. Flow Navigator → Run Simulation → Run Behavioral Simulation
```

### 2. Synthesis & Analysis

**For Each Design:**

**Step 1: Synthesis**
```
1. Add design source file
2. Set as top module
3. Flow Navigator → Run Synthesis
```

**Step 2: Get LUT Count (Area)**
```
Method 1 (GUI): Open Synthesized Design → Window → Utilization → Note "Slice LUTs"
Method 2 (TCL): report_utilization -file util.txt
```

**Step 3: Get Delay**
```tcl
# In TCL Console after opening synthesized design
report_timing -max_paths 1 -file timing.txt
# Note the "Data Path Delay" value in ns
```

**Step 4: Get Power**
```
1. Flow Navigator → Run Implementation
2. Open Implemented Design
3. TCL Console: report_power -file power.txt
4. Note: Total On-Chip Power, Dynamic Power, Static Power
```

### 3. Collect Data for Both Designs

| Metric | Without Optimization | With Optimization |
|--------|---------------------|-------------------|
| LUTs | _____ | _____ |
| Delay (ns) | _____ | _____ |
| Total Power (W) | _____ | _____ |

---

## Visualization

Update `graph.py` with your collected data and run:
```bash
python graph.py
```
Generates comparison plots and saves as `optimization_comparison.png`.

---

## Expected Results

- **LUT Reduction:** ~75-80%
- **Delay Improvement:** ~10-15%
- **Power Savings:** ~20-30%

---

## Quick Reference Commands

```tcl
# Utilization
report_utilization -file utilization.txt

# Timing
report_timing -max_paths 1 -file timing.txt

# Power
report_power -file power.txt
```

---

**Last Updated:** November 2025
