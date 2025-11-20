# ESPRESSO Optimization for Hazard Logic

## Overview

This folder contains **PLA (Programmable Logic Array)** files representing truth tables for different pipeline hazard conditions. These files are used with the **ESPRESSO** logic minimizer to optimize Boolean expressions for hazard detection logic.

**Purpose:** Apply Karnaugh map and ESPRESSO minimization to reduce hardware complexity in the hazard unit.

---

## Files

```
espresso_files/
├── readme.md
├── data_hazard.pla       # Truth table for data hazard detection
├── control_hazard.pla    # Truth table for control hazard detection
└── structural_hazard.pla # Truth table for structural hazard detection
```

---

## PLA File Format

Each `.pla` file contains:
- **Inputs:** Hazard condition signals
- **Outputs:** Stall/flush/forward signals
- **Truth table:** Input combinations and corresponding outputs

**Example Structure:**
```
.i 7          # Number of inputs
.o 1          # Number of outputs
.ilb EX_RW EX_MR MEM_RW D_EX T_EX D_MEM T_MEM
.ob STALL_data
.p 6          # Number of product terms
# Truth table rows
.e            # End
```

---

## Using ESPRESSO Online

**Step 1: Open ESPRESSO Tool**
- Go to: https://nudelerde.github.io/Espresso-Wasm-Web/index.html

**Step 2: Load PLA File**
```
1. Open one of the .pla files (e.g., data_hazard.pla)
2. Copy the entire contents
3. Paste into the ESPRESSO web tool input area
```

**Step 3: Run Optimization**
```
1. Click "Run Espresso" button
2. Wait for optimization to complete
```

**Step 4: Analyze Output**
```
The output shows:
- Minimized Boolean expression
- Reduced number of product terms
- Optimized logic implementation

Example:
Original: 6 product terms
Optimized: 3 product terms (50% reduction)
```

**Step 5: Compare Results**
```
- Note the input/output relationship
- Count reduced terms
- Use for Verilog implementation (see two_level_vs_multilevel_logic/)
```

---

## Hazard Types

### 1. Data Hazard (data_hazard.pla)
**Inputs:**
- `EX_RW`: EX stage writes register
- `EX_MR`: EX stage performs memory read
- `MEM_RW`: MEM stage writes register  
- `D_EX`: ID.rs1 depends on EX.rd
- `T_EX`: ID.rs2 depends on EX.rd
- `D_MEM`: ID.rs1 depends on MEM.rd
- `T_MEM`: ID.rs2 depends on MEM.rd

**Output:**
- `STALL_data`: Stall signal for data hazard

### 2. Control Hazard (control_hazard.pla)
**Inputs:**
- Branch/jump conditions
- PC source signals

**Output:**
- `FLUSH`: Flush signal for control hazard

### 3. Structural Hazard (structural_hazard.pla)
**Inputs:**
- Resource usage conflicts

**Output:**
- `STALL_struct`: Stall signal for structural hazard

---

## Optimization Results

After running ESPRESSO, you get:
- **Minimized SOP (Sum of Products)** form
- **Reduced gate count**
- **Lower delay** (fewer logic levels)
- **Lower power** (fewer switching gates)

These optimized expressions are then implemented in:
- `two_level_vs_multilevel_logic/two_level.v` (direct SOP)
- `two_level_vs_multilevel_logic/Multi_level.v` (factored form)

---

## Quick Reference

| Task | Action |
|------|--------|
| View truth table | Open .pla file in text editor |
| Optimize logic | Paste in ESPRESSO web tool |
| Get minimized form | Click "Run Espresso" |
| Implement in Verilog | Use output in two_level.v or Multi_level.v |

---

**See `Project_Report.pdf` for detailed truth tables and optimization analysis.**