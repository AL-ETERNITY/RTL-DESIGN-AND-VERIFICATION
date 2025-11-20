# PROJECT: Pipelined RISC-V Processor with Hazard Detection and Optimization

## Overview

This project implements a **5-stage pipelined RISC-V processor** with comprehensive **hazard detection, resolution, and formal verification**. It includes Boolean optimization techniques and model checking to ensure correctness and analyze performance trade-offs.

**Complete Architecture and Design Details:** See `Project_Report.pdf`

---

## Project Structure

```
PROJECT/
├── Project_Report.pdf                    # Complete project documentation
│
├── pipeline_processor_codes/             # Main processor implementation
│   ├── source_codes/                     # RTL design files
│   │   ├── pipe_risc_v.v                # Top-level pipelined processor
│   │   ├── hazard_unit.v                # Hazard detection and forwarding
│   │   ├── datapath.v                   # 5-stage pipeline datapath
│   │   └── ... (other modules)
│   ├── testbench_codes/                 # Verification testbenches
│   └── mem_files/                       # Test programs
│       └── hazard_test.mem              # Hazard scenario test program
│
├── espresso_files/                       # Boolean optimization
│   ├── data_hazard.pla                  # Data hazard truth table
│   ├── control_hazard.pla               # Control hazard truth table
│   └── structural_hazard.pla            # Structural hazard truth table
│
├── two_level_vs_multilevel_logic/        # Logic comparison
│   ├── two_level.v                      # Two-level SOP implementation
│   └── Multi_level.v                    # Multi-level factored implementation
│
└── model_checking_codes/                 # Formal verification
    ├── pipe_risc_v_hazards.smv          # NuXmv model
    └── README.md                        # Model checking instructions
```

---

## Project Workflow

### Phase 1: Design Comprehensive Stall Generation Logic

**Location:** `pipeline_processor_codes/source_codes/hazard_unit.v`

**Tasks:**
1. ✅ Identify all hazard types (data, control, structural)
2. ✅ Create comprehensive stall/flush/forward logic
3. ✅ Implement in Verilog with proper pipeline integration

**Key Components:**
- **Data Hazard Detection:** RAW (Read-After-Write) dependencies
- **Control Hazard Detection:** Branch/jump target resolution
- **Structural Hazard Prevention:** Resource conflict avoidance
- **Forwarding Logic:** EX→EX, MEM→EX data bypassing
- **Stall Propagation:** Bubble insertion for load-use hazards

**See:** `pipeline_processor_codes/README.md` for implementation details

---

### Phase 2: Create Truth Tables for Stall Conditions

**Location:** `espresso_files/`

**Tasks:**
1. ✅ Define input signals for each hazard type
2. ✅ Create exhaustive truth tables
3. ✅ Convert to PLA format for ESPRESSO

**Truth Tables:**

**Data Hazard Inputs:**
- `EX_RW`: EX stage writes register
- `EX_MR`: EX stage performs memory read (load)
- `MEM_RW`: MEM stage writes register
- `D_EX`: ID.rs1 depends on EX.rd (register match)
- `T_EX`: ID.rs2 depends on EX.rd
- `D_MEM`: ID.rs1 depends on MEM.rd
- `T_MEM`: ID.rs2 depends on MEM.rd

**Output:** `STALL_data` (1 = stall required)

**Control Hazard Inputs:**
- Branch/jump decision signals
- PC source control

**Output:** `FLUSH` (1 = flush pipeline stages)

**See:** `espresso_files/readme.md` for PLA file usage

---

### Phase 3: Apply Karnaugh Map and ESPRESSO Optimization

**Location:** `espresso_files/` → Online ESPRESSO tool

**Tasks:**
1. ✅ Load PLA files into ESPRESSO
2. ✅ Run minimization algorithm
3. ✅ Obtain minimized Boolean expressions
4. ✅ Analyze reduction in product terms

**Process:**
```
1. Open: https://nudelerde.github.io/Espresso-Wasm-Web/index.html
2. Copy contents from .pla file
3. Paste into ESPRESSO input
4. Click "Run Espresso"
5. Analyze optimized output
```

**Optimization Results:**
- Reduced product terms (e.g., 6 terms → 3 terms)
- Simplified Boolean expressions
- Lower gate count for implementation

**Example:**
```
Original SOP (6 terms):
STALL = (EX_RW & D_EX) | (EX_MR & D_EX) | (EX_RW & T_EX) | 
        (EX_MR & T_EX) | (MEM_RW & D_MEM) | (MEM_RW & T_MEM)

After ESPRESSO (factored):
A = EX_RW | EX_MR
B = D_EX | T_EX
STALL = (A & B) | (MEM_RW & (D_MEM | T_MEM))
```

---

### Phase 4: Compare Two-Level and Multi-Level Logic

**Location:** `two_level_vs_multilevel_logic/`

**Tasks:**
1. ✅ Implement two-level (direct SOP) logic
2. ✅ Implement multi-level (factored) logic
3. ✅ Synthesize both in Vivado
4. ✅ Compare area, delay, and power

**Implementations:**

**Two-Level Logic (`two_level.v`):**
- Direct sum-of-products from ESPRESSO
- 2 logic levels (AND → OR)
- Fast but larger area

**Multi-Level Logic (`Multi_level.v`):**
- Factored form with intermediate terms
- 3-4 logic levels (hierarchical)
- Smaller area but slightly slower

**Comparison Metrics:**
| Metric | Two-Level | Multi-Level |
|--------|-----------|-------------|
| LUTs | Higher | Lower |
| Delay | Lower | Higher |
| Power | Higher | Lower |

**See:** `two_level_vs_multilevel_logic/README.md` for synthesis instructions

---

### Phase 5: Write Temporal Logic Specifications

**Location:** `model_checking_codes/pipe_risc_v_hazards.smv`

**Tasks:**
1. ✅ Model pipeline as Kripke structure
2. ✅ Write CTL properties for hazard behavior
3. ✅ Specify safety and liveness properties

**Key CTL Properties:**

**P1: Stalls Propagate Correctly**
```
AG (load_hazard → (stall_f & stall_d))
"Whenever load hazard detected, Fetch and Decode stages stall"
```

**P2: Instructions Don't Bypass Stalled Stages**
```
AG (stall_d → AX (instr_d = prev_instr_d))
"When Decode stalls, same instruction remains in Decode stage"
```

**P3: Pipeline Flushes Work Correctly**
```
AG (branch_taken → AX (instr_e = NOP))
"When branch taken, Execute stage contains NOP (bubble)"
```

**P4: No Instruction Loss**
```
AG (valid_instr → AF (instr_committed))
"Every valid instruction eventually commits"
```

**P5: Forwarding Prevents Unnecessary Stalls**
```
AG (data_hazard & can_forward → ¬stall)
"Data hazards that can be forwarded don't cause stalls"
```

**See:** `model_checking_codes/README.md` for NuXmv verification steps

---

### Phase 6: Model Checking Verification

**Location:** `model_checking_codes/`

**Tasks:**
1. ✅ Model pipeline behavior in SMV
2. ✅ Run NuXmv model checker
3. ✅ Verify all CTL properties
4. ✅ Analyze counterexamples (if any)

**Verification Process:**
```bash
# Run NuXmv
.\bin\nuXmv.exe -int pipe_risc_v_hazards.smv

# In NuXmv prompt:
nuXmv> go
nuXmv> check_ctlspec
nuXmv> quit
```

**Verified Properties:**
- ✅ Stalls propagate backward correctly
- ✅ No instruction loss during stalls
- ✅ Flushes clear pipeline stages properly
- ✅ Forwarding works without data corruption
- ✅ No deadlocks or livelocks

**See:** `model_checking_codes/README.md` (already complete)

---

## Performance Analysis

### Synthesis and Implementation

**Run for:** `pipeline_processor_codes/source_codes/pipe_risc_v.v`

**Steps:**
```
1. Vivado → Create Project → Add all source files
2. Run Synthesis
3. Run Implementation
4. Generate Reports
```

**Metrics to Collect:**

| Metric | Command | Value |
|--------|---------|-------|
| **Slice LUTs** | `report_utilization` | _____ |
| **Slice Registers** | `report_utilization` | _____ |
| **BRAM** | `report_utilization` | _____ |
| **Critical Path Delay** | `report_timing -max_paths 1` | _____ ns |
| **Max Frequency** | Calculate from delay | _____ MHz |
| **Dynamic Power** | `report_power` | _____ W |
| **Total Power** | `report_power` | _____ W |

**Critical Path:** Typically register → ALU → register (Execute stage)

---

## Key Features

### 1. Complete Pipeline Implementation
- 5-stage RISC-V pipeline
- Support for R-type, I-type, load/store, branch instructions
- Proper hazard handling

### 2. Hazard Detection & Resolution
- **Data Hazards:** Forwarding + stalling
- **Control Hazards:** Branch prediction + flushing
- **Structural Hazards:** Prevented by design

### 3. Boolean Optimization
- ESPRESSO-based logic minimization
- Two-level vs multi-level comparison
- Area-delay-power trade-off analysis

### 4. Formal Verification
- CTL temporal logic specifications
- NuXmv model checking
- Proof of correctness for hazard scenarios

---

## Quick Start Guide

### 1. Simulate Pipeline Processor
```
cd pipeline_processor_codes/
Follow README.md for simulation steps
Observe hazard detection in waveform
```

### 2. Optimize Hazard Logic
```
cd espresso_files/
Open .pla file → ESPRESSO web tool
Get minimized Boolean expressions
```

### 3. Compare Logic Implementations
```
cd two_level_vs_multilevel_logic/
Synthesize two_level.v → record metrics
Synthesize Multi_level.v → record metrics
Compare results
```

### 4. Verify with Model Checker
```
cd model_checking_codes/
Run NuXmv verification
Check all CTL properties pass
```

---

## Deliverables

1. ✅ **RTL Implementation:** Complete pipelined processor with hazard unit
2. ✅ **Truth Tables:** PLA files for all hazard types
3. ✅ **Boolean Optimization:** ESPRESSO minimization results
4. ✅ **Logic Comparison:** Two-level vs multi-level synthesis reports
5. ✅ **Temporal Logic:** CTL specifications in SMV format
6. ✅ **Model Checking:** NuXmv verification results
7. ✅ **Performance Analysis:** Area, delay, power metrics
8. ✅ **Documentation:** `Project_Report.pdf` with complete analysis

---

## Tools Required

- **Vivado Design Suite** (2019.1 or later) - HDL synthesis and simulation
- **ESPRESSO** - Boolean logic minimization (web-based)
- **NuXmv** - CTL model checker (download from https://nuxmv.fbk.eu/)
- **Text Editor** - For viewing PLA files and SMV models

---

## References

- `Project_Report.pdf` - Complete project documentation
- Each subfolder has its own `README.md` with detailed instructions
- RISC-V ISA Specification
- Patterson & Hennessy: Computer Organization and Design
- NuXmv User Manual

---

## Project Highlights

✨ **Complete 5-stage pipeline** with all hazard types handled  
✨ **Formal verification** using model checking (CTL properties)  
✨ **Boolean optimization** with ESPRESSO and K-maps  
✨ **Performance comparison** of different logic implementations  
✨ **Synthesizable design** tested in Vivado  
✨ **Comprehensive testing** with hazard-specific test programs  

---

**For complete architecture diagrams, state machines, timing analysis, and detailed results, see `Project_Report.pdf`**

**Last Updated:** November 2025
