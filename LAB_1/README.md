# LAB 1: 32-bit ALU Design and Design Space Exploration

## Project Overview

This project implements a **32-bit Arithmetic Logic Unit (ALU)** with multiple component implementations to explore the design space trade-offs between area and latency. The ALU supports four fundamental operations with configurable hardware implementations.

### Design Requirements

Design a 32-bit ALU with the following 4 base operations:

1. **Adder** - Library options: Ripple Carry Adder (RCA), Carry Look-Ahead (CLA), Serial Adder (SA)
2. **Multiply by 2** - Library options: School-book Multiplier, Left-Shifting Multiplier
3. **Compare 2 numbers** - Comparator with signed/unsigned modes
4. **Subtractor** - Library options: Parallel Subtractor, Serial Subtractor

The project analyzes **5 different ALU configurations** with varying component allocations to plot a 2-D design space showing latency vs. area trade-offs.

---

## Project Structure

```
LAB_1/
├── README.md                          # This file
├── alu_design_space_plot.py          # Python script for design space visualization
│
├── source_codes/                      # RTL source files
│   ├── ALU.v                         # Top-level ALU module with operation selection
│   ├── ALU_config1_wrapper.v         # Config 1: All Fast (CLA, Schoolbook, Parallel, Signed)
│   ├── ALU_config2_wrapper.v         # Config 2: All Slow (Serial, Left-shift, Serial, Unsigned)
│   ├── ALU_config3_wrapper.v         # Config 3: Mixed F-S (CLA, Left-shift, Parallel, Signed)
│   ├── ALU_config4_wrapper.v         # Config 4: Mixed S-F (Serial, Schoolbook, Serial, Unsigned)
│   ├── ALU_config5_wrapper.v         # Config 5: Balanced (RCA, Schoolbook, Parallel, Signed)
│   │
│   ├── Adder.v                       # Adder wrapper with RCA/CLA/SA selection
│   ├── ripple_carry_adder.v          # 32-bit Ripple Carry Adder implementation
│   ├── carry_lookahead_adder.v       # 32-bit Carry Look-Ahead Adder (faster)
│   ├── serial_adder.v                # 32-bit Serial Adder (sequential, area-efficient)
│   │
│   ├── Subtractor.v                  # Subtractor wrapper with Parallel/Serial selection
│   ├── parallel_Subtractor.v         # 32-bit Parallel Subtractor (combinational)
│   ├── Serial_Subtractor.v           # 32-bit Serial Subtractor (sequential)
│   │
│   ├── Multiplier.v                  # Multiplier wrapper with selection logic
│   ├── school_book_multiplier.v      # School-book Multiplier (faster)
│   ├── left_shifting_multiplier.v    # Left-Shifting Multiplier (area-efficient)
│   │
│   └── Comparator.v                  # Comparator with signed/unsigned modes
│
└── sim_codes/                         # Testbench files
    ├── ALU_tb.v                      # Top-level ALU testbench
    ├── Adder_tb.v                    # Adder module testbench
    ├── rca_tb.v                      # Ripple Carry Adder testbench
    ├── cla_tb.v                      # Carry Look-Ahead Adder testbench
    ├── sa_tb.v                       # Serial Adder testbench
    ├── Subtractor_tb.v               # Subtractor module testbench
    ├── ps_tb.v                       # Parallel Subtractor testbench
    ├── ss_tb.v                       # Serial Subtractor testbench
    ├── Multiplier_tb.v               # Multiplier module testbench
    ├── sbm_tb.v                      # School-book Multiplier testbench
    ├── lfm_tb.v                      # Left-shifting Multiplier testbench
    └── Comparator_tb.v               # Comparator testbench
```

---

## ALU Architecture

### Operation Selection
The ALU uses a 2-bit operation selector (`op_sel[1:0]`) to choose between operations:

| `op_sel` | Operation      | Sub-Selection Control    |
|----------|----------------|--------------------------|
| `00`     | Addition       | `adder_sel[1:0]`        |
| `01`     | Subtraction    | `sub_sel`               |
| `10`     | Multiplication | `mult_sel`              |
| `11`     | Comparison     | `comp_mode`             |

### Component Libraries

#### 1. Adder (`adder_sel[1:0]`)
- `00`: Ripple Carry Adder (RCA) - Moderate speed, moderate area
- `01`: Carry Look-Ahead Adder (CLA) - Fast, larger area
- `10`: Serial Adder (SA) - Slow, smallest area

#### 2. Subtractor (`sub_sel`)
- `0`: Parallel Subtractor - Fast, larger area
- `1`: Serial Subtractor - Slow, smaller area

#### 3. Multiplier (`mult_sel`)
- `0`: School-book Multiplier - Fast, larger area
- `1`: Left-Shifting Multiplier - Slow, smaller area

#### 4. Comparator (`comp_mode`)
- `0`: Unsigned comparison
- `1`: Signed comparison

---

## Design Space Configurations

Five configurations were implemented to explore the area-latency design space:

### Configuration 1: All Fast
- **Adder**: CLA
- **Multiplier**: School-book
- **Subtractor**: Parallel
- **Comparator**: Signed
- **Trade-off**: Maximum speed, maximum area

### Configuration 2: All Slow
- **Adder**: Serial
- **Multiplier**: Left-shift
- **Subtractor**: Serial
- **Comparator**: Unsigned
- **Trade-off**: Minimum area, minimum speed

### Configuration 3: Mixed Fast-Slow
- **Adder**: CLA
- **Multiplier**: Left-shift
- **Subtractor**: Parallel
- **Comparator**: Signed
- **Trade-off**: Balanced approach 1

### Configuration 4: Mixed Slow-Fast
- **Adder**: Serial
- **Multiplier**: School-book
- **Subtractor**: Serial
- **Comparator**: Unsigned
- **Trade-off**: Balanced approach 2

### Configuration 5: Balanced
- **Adder**: RCA
- **Multiplier**: School-book
- **Subtractor**: Parallel
- **Comparator**: Signed
- **Trade-off**: Middle-ground performance

---

## Using Files in Vivado

### 1. Simulation

#### Setting Up Simulation
1. **Create New Project**
   - Open Vivado → Create Project → RTL Project
   - Add all files from `source_codes/` as Design Sources
   - Add desired testbench from `sim_codes/` as Simulation Sources

2. **Run Behavioral Simulation**
   - Flow Navigator → Simulation → Run Simulation → Run Behavioral Simulation
   - Vivado will compile all sources and launch the simulator
   - View waveforms to verify functionality

3. **Testing Individual Modules**
   - To test specific modules (e.g., just the adder):
     - Add the module source file (e.g., `Adder.v`, `ripple_carry_adder.v`)
     - Add its testbench (e.g., `Adder_tb.v`)
     - Run simulation

4. **Testing ALU Configurations**
   - For complete ALU testing, add:
     - All source files from `source_codes/`
     - `ALU_tb.v` from `sim_codes/`
   - For specific configurations, use the appropriate wrapper:
     - Example: `ALU_config1_wrapper.v` for Config 1

#### Simulation Tips
- Default simulation time in Vivado is 1000ns
- To extend: Simulation Settings → Simulation → Simulation Run Time
- Use TCL Console commands:
  ```tcl
  run 1000ns
  run all
  ```

---

### 2. Synthesis

#### Running Synthesis
1. **Add Design Sources**
   - Add all required source files from `source_codes/`
   - For a specific configuration, add:
     - Main ALU module: `ALU.v`
     - Configuration wrapper: `ALU_config1_wrapper.v` (or config2-5)
     - All component modules (Adder, Subtractor, Multiplier, Comparator)
     - All sub-component implementations

2. **Set Top Module**
   - Right-click on the configuration wrapper (e.g., `ALU_config1_wrapper`)
   - Select "Set as Top"

3. **Run Synthesis**
   - Flow Navigator → Synthesis → Run Synthesis
   - Wait for synthesis to complete

4. **View Synthesis Reports**
   - Open Synthesized Design
   - Reports → Report Utilization
   - Reports → Report Timing Summary

#### Getting LUT Count
After synthesis completes:

**Method 1: GUI**
- Open Synthesized Design
- Window → Utilization
- View "Slice Logic" → "Slice LUTs"

**Method 2: TCL Console**
```tcl
report_utilization -file utilization.txt
```
Look for the line:
```
| Slice LUTs        | #### |
```

**Method 3: Reports Window**
- Click "Open Synthesized Design"
- Reports tab → Utilization Report
- Find "Slice LUTs" in the table

---

### 3. Getting Timing (Delay) Information

#### Using `report_timing` Command

1. **After Synthesis**
   - Open Synthesized Design
   - In TCL Console, run:
     ```tcl
     report_timing -max_paths 1
     ```

2. **Understanding the Output**
   The command shows the critical path with:
   - **Data Path Delay**: Total propagation delay through logic
   - **Clock Path Skew**: Clock network delay
   - **Slack**: Timing margin (positive = meets timing)
   - **Requirement**: Clock period constraint

3. **Example Output Interpretation**
   ```
   Slack (MET) :             X.XXXns  (required time - arrival time)
   Source:                   register/pin
   Destination:              register/pin
   Data Path Delay:          XX.XXXns
   ```
   **The critical delay value is the "Data Path Delay"**

4. **Saving Timing Report**
   ```tcl
   report_timing -max_paths 1 -file timing_report.txt
   ```

#### Alternative: Timing Summary Report
- Reports → Timing → Report Timing Summary
- View "Worst Negative Slack" (WNS) and path delays
- For unconstrained designs, look at "Data Path Delay"

#### For Accurate Timing Analysis
If no clock constraints are defined:
1. Create constraints file (.xdc):
   ```tcl
   create_clock -period 10.000 -name clk [get_ports clk]
   ```
2. Add to project as Constraints file
3. Re-run synthesis
4. Run `report_timing -max_paths 1`

---

### 4. Implementation

#### Running Implementation
1. **Complete Synthesis First**
   - Ensure synthesis completed successfully

2. **Run Implementation**
   - Flow Navigator → Implementation → Run Implementation
   - This performs:
     - Placement (placing logic on FPGA)
     - Routing (connecting placed logic)
     - Timing analysis

3. **View Implementation Results**
   - Open Implemented Design
   - Check routing and placement

#### Post-Implementation Reports

**Resource Utilization:**
```tcl
report_utilization -file post_impl_utilization.txt
```

**Timing (More Accurate):**
```tcl
report_timing -max_paths 1 -file post_impl_timing.txt
```

**Power Analysis:**
```tcl
report_power -file power_report.txt
```

---

### 5. Power Analysis

#### Getting Power Consumption

1. **After Implementation**
   - Implementation must be complete
   - Open Implemented Design

2. **Generate Power Report**
   - Reports → Report Power
   - Or in TCL Console:
     ```tcl
     report_power -file power_analysis.txt
     ```

3. **Understanding Power Report**
   The report shows:
   - **Total On-Chip Power**: Overall power consumption
   - **Dynamic Power**: Power consumed during operation
   - **Static Power**: Leakage power
   - **I/O Power**: Power consumed by I/O pins
   
4. **Power Breakdown**
   ```
   | Total On-Chip Power (W)  | X.XXX |
   | Dynamic (W)              | X.XXX |
   | Device Static (W)        | X.XXX |
   | Confidence Level         | Low/Medium/High |
   ```

5. **Improving Power Estimation Accuracy**
   - Add switching activity file (.saif) from simulation:
     ```tcl
     read_saif -file simulation.saif
     report_power
     ```
   - Or set toggle rates manually for critical signals

#### Power Estimation Tips
- More accurate after Implementation than Synthesis
- Requires realistic activity factors
- Use "Medium" or "High" confidence estimates
- Consider both dynamic and static components

---

## Complete Workflow Example

### Analyzing Configuration 1 (All Fast)

1. **Create New Vivado Project**
   ```
   File → Project → New
   Select RTL Project
   Choose target device (e.g., Artix-7)
   ```

2. **Add Source Files**
   - Add all files from `source_codes/` folder
   - Set `ALU_config1_wrapper.v` as top module

3. **Run Simulation** (Optional)
   - Add `ALU_tb.v` to simulation sources
   - Run Behavioral Simulation
   - Verify functionality

4. **Run Synthesis**
   ```
   Flow Navigator → Run Synthesis
   Wait for completion
   ```

5. **Get LUT Count**
   ```tcl
   report_utilization
   ```
   Note the "Slice LUTs" value

6. **Get Delay (Critical Path)**
   ```tcl
   report_timing -max_paths 1
   ```
   Note the "Data Path Delay" value

7. **Run Implementation**
   ```
   Flow Navigator → Run Implementation
   ```

8. **Get Power Consumption**
   ```tcl
   report_power -file config1_power.txt
   ```
   Note the "Total On-Chip Power" value

9. **Record Results**
   - Configuration: Config 1 (All Fast)
   - LUTs: [value from step 5]
   - Delay: [value from step 6] ns
   - Power: [value from step 8] W

10. **Repeat for Other Configurations**
    - Use `ALU_config2_wrapper.v` through `ALU_config5_wrapper.v`
    - Record LUT, Delay, and Power for each

---

## Design Space Plotting

After collecting data from all 5 configurations:

1. **Update Python Script**
   - Edit `alu_design_space_plot.py`
   - Update the data arrays with your results:
     ```python
     latency = [config1_delay, config2_delay, config3_delay, config4_delay, config5_delay]
     area_lut = [config1_luts, config2_luts, config3_luts, config4_luts, config5_luts]
     ```

2. **Run Visualization**
   ```bash
   python alu_design_space_plot.py
   ```

3. **Output**
   - Interactive plot showing latency (x-axis) vs. area (y-axis)
   - Saved as `ALU_Design_Space_Analysis.png`
   - Console output with detailed analysis and recommendations

---

## Key Metrics to Collect

For each configuration, record:

| Metric | How to Obtain | Command/Location |
|--------|---------------|------------------|
| **LUT Count** | Post-synthesis utilization | `report_utilization` → Slice LUTs |
| **Delay (ns)** | Critical path timing | `report_timing -max_paths 1` → Data Path Delay |
| **Power (W)** | Post-implementation power | `report_power` → Total On-Chip Power |

---

## Expected Results Pattern

Based on component choices, expect:

- **Config 1 (All Fast)**: Highest LUT count, lowest latency
- **Config 2 (All Slow)**: Lowest LUT count, highest latency
- **Config 3-5**: Various trade-off points between area and speed

The design space plot will visualize these trade-offs, helping identify:
- Optimal configurations for speed-critical applications
- Optimal configurations for area-constrained designs
- Balanced designs for general-purpose use

---

## Troubleshooting

### Common Issues

**Simulation doesn't run:**
- Verify all module dependencies are included
- Check for syntax errors in RTL files
- Ensure testbench has correct module instantiation

**Synthesis fails:**
- Check for missing source files
- Verify top module is set correctly
- Review synthesis log for specific errors

**Timing report shows no paths:**
- Add clock constraint in XDC file
- Ensure design has sequential elements
- Check if paths exist between registers

**Power report shows "Low Confidence":**
- Run implementation before power analysis
- Add switching activity from simulation
- Set realistic toggle rates for inputs

---

## Additional Notes

### File Naming Convention
- `_tb.v`: Testbench files for simulation
- `_wrapper.v`: Configuration-specific top-level modules
- Base module names: Core functional blocks

### Module Hierarchy
```
ALU_configX_wrapper
    └── ALU
        ├── Adder
        │   ├── ripple_carry_adder
        │   ├── carry_lookahead_adder
        │   └── serial_adder
        ├── Subtractor
        │   ├── parallel_Subtractor
        │   └── Serial_Subtractor
        ├── Multiplier
        │   ├── school_book_multiplier
        │   └── left_shifting_multiplier
        └── Comparator
```

### Simulation vs. Synthesis
- **Simulation**: Verifies functional correctness (behavioral)
- **Synthesis**: Converts RTL to gate-level netlist, provides resource estimates
- **Implementation**: Maps design to physical FPGA, provides accurate timing/power

---

## Quick Reference Commands

```tcl
# Synthesis
synth_design -top ALU_config1_wrapper

# Utilization
report_utilization -file util.txt

# Timing
report_timing -max_paths 1 -file timing.txt

# Implementation
opt_design
place_design
route_design

# Power
report_power -file power.txt

# Save results
write_checkpoint -force design.dcp
```

---

## Authors & Course Information

**Lab**: RTL Design and Verification - LAB 1  
**Topic**: ALU Design Space Exploration  
**Objective**: Understanding area-latency trade-offs in digital design

---

## References

- Vivado Design Suite User Guide (UG910)
- Vivado Design Suite Tcl Command Reference Guide (UG835)
- FPGA Design Flow Documentation

---

**Last Updated**: November 2025
