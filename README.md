# RTL Design and Verification

Complete collection of RTL design projects and labs focusing on digital design optimization, Boolean logic minimization, pipeline architectures, FSM design, and formal verification using Verilog HDL and model checking techniques.

---

## Repository Structure

```
RTL-DESIGN-AND-VERIFICATION/
├── LAB_1/    # 32-bit ALU with Design Space Exploration
├── LAB_2/    # Boolean Function Optimization (K-map, ESPRESSO)
├── LAB_3/    # Multi-Level Logic Optimization (ESPRESSO)
├── LAB_4/    # Mod-10 Down Counter (State Encoding Comparison)
├── LAB_5/    # FSM Sequence Detector (Mealy Machine)
├── LAB_6/    # Traffic Light Controller (CTL Verification)
└── PROJECT/  # Pipelined RISC-V Processor with Hazard Detection
```

---

## Labs Overview

### LAB 1: ALU Design Space Analysis
32-bit ALU with multiple component implementations (RCA, CLA, Serial Adder, etc.). Compares 5 configurations to plot latency vs. area trade-offs.

### LAB 2: Boolean Optimization
6-variable Boolean function implemented with and without optimization. Demonstrates 75-80% LUT reduction through K-map/Quine-McCluskey minimization.

### LAB 3: Multi-Level Logic
Comparison of separate vs. combined function implementations using ESPRESSO. Analyzes resource sharing and logic factorization benefits.

### LAB 4: State Encoding Comparison
Mod-10 down counter with Binary, Gray, and One-Hot encoding using JK flip-flops. Compares area, delay, and power for different encoding schemes.

### LAB 5: FSM Sequence Detector
Mealy machine for non-overlapping sequence detection. Implements state optimization and D flip-flop based design.

### LAB 6: Formal Verification
Traffic light controller with Kripke structure modeling and CTL property verification. Demonstrates safety and liveness proofs.

---

## Project: Pipelined RISC-V Processor

**5-stage pipeline** with comprehensive hazard detection and resolution:
- ✅ Data hazards (forwarding + stalling)
- ✅ Control hazards (branch flushing)
- ✅ Boolean optimization (ESPRESSO, two-level vs multi-level)
- ✅ Formal verification (NuXmv model checking)
- ✅ Complete performance analysis (LUTs, delay, power)

**Components:**
- `pipeline_processor_codes/` - Complete RTL implementation
- `espresso_files/` - Truth tables and PLA optimization
- `two_level_vs_multilevel_logic/` - Logic comparison
- `model_checking_codes/` - CTL specifications and verification

---

## Tools & Technologies

- **HDL:** Verilog
- **Synthesis:** Xilinx Vivado Design Suite
- **Simulation:** Vivado Simulator
- **Optimization:** ESPRESSO (Boolean minimizer)
- **Verification:** NuXmv (CTL model checker)
- **Analysis:** Python (matplotlib for visualization)

---

## Key Concepts Covered

🔹 **Digital Design:** ALU, counters, FSMs, pipelined processors  
🔹 **Optimization:** K-maps, ESPRESSO, two-level vs multi-level logic  
🔹 **State Encoding:** Binary, Gray, One-Hot comparison  
🔹 **Hazard Handling:** Data/control/structural hazards in pipelines  
🔹 **Formal Methods:** Kripke structures, CTL, model checking  
🔹 **Performance:** Area-delay-power trade-off analysis  

---

## Quick Start

Each folder contains its own `README.md` with:
- Design specifications
- Vivado workflow (simulation, synthesis, implementation)
- Commands for getting LUTs, delay, and power metrics
- Expected results and analysis

**Example:**
```bash
cd LAB_1
# Follow README.md for synthesis instructions
# Collect LUT count, delay (report_timing -max_paths 1), power
```

---

## Metrics Collection

All labs/project analyze:
- **Area:** Slice LUTs, Registers, BRAM
- **Delay:** Critical path using `report_timing -max_paths 1`
- **Power:** Dynamic and static power using `report_power`

---

## Documentation

Each lab and the project includes:
- 📄 README with complete instructions
- 🔬 Source code (Verilog RTL)
- 🧪 Testbenches for verification
- 📊 Python scripts for visualization (where applicable)

**PROJECT** includes `Project_Report.pdf` with detailed architecture and analysis.

---

## Author

**Course:** RTL Design and Verification  
**Focus:** Digital design, optimization, and formal verification

---

## License

Educational project - for learning and reference purposes.
