# Pipeline Processor Implementation

## Overview

This folder contains the complete **5-stage pipelined RISC-V processor** implementation with comprehensive hazard detection and resolution mechanisms.

**Pipeline Stages:**
1. **Fetch (F)** - Instruction fetch
2. **Decode (D)** - Instruction decode and register read
3. **Execute (E)** - ALU operations
4. **Memory (M)** - Data memory access
5. **Writeback (W)** - Write results back to register file

**Architecture Details:** See `Project_Report.pdf` for complete architectural diagrams and design specifications.

---

## Folder Structure

```
pipeline_processor_codes/
├── source_codes/          # RTL design files
│   ├── pipe_risc_v.v     # Top-level pipelined processor
│   ├── hazard_unit.v     # Hazard detection and forwarding unit
│   ├── datapath.v        # Pipeline datapath
│   ├── control_unit.v    # Control signal generation
│   ├── alu.v             # Arithmetic Logic Unit
│   ├── reg_file.v        # Register file
│   ├── instr_mem.v       # Instruction memory
│   ├── data_memr.v       # Data memory
│   ├── reg_fd.v          # Fetch-Decode pipeline register
│   ├── reg_de.v          # Decode-Execute pipeline register
│   ├── reg_em.v          # Execute-Memory pipeline register
│   ├── reg_mw.v          # Memory-Writeback pipeline register
│   └── ... (other modules)
│
├── testbench_codes/       # Testbenches for individual modules
│   ├── pipe_risc_v_tb.v  # Top-level processor testbench
│   └── ... (other testbenches)
│
└── mem_files/             # Memory initialization files
    └── hazard_test.mem    # Test program with hazard scenarios
```

---

## Hazard Handling Mechanisms

### 1. Data Hazards
**Handled by:** Forwarding + Stalling

**Forwarding Paths:**
- EX/MEM → EX stage (forward_ae, forward_be = 2'b10)
- MEM/WB → EX stage (forward_ae, forward_be = 2'b01)

**Stall Conditions:**
- Load-use hazard: Load instruction followed by dependent instruction
- Stall signals: `stall_f`, `stall_d`

### 2. Control Hazards
**Handled by:** Flushing

**Flush Conditions:**
- Branch taken (`pcsrc_e = 1`)
- Flush signals: `flush_d`, `flush_e`

### 3. Structural Hazards
**Handled by:** Architecture design (separate instruction/data memories)

---

## Running in Vivado

### Simulation

**Step 1: Create Project**
```
1. Create New Project → RTL Project
2. Add all files from source_codes/
3. Add testbench: pipe_risc_v_tb.v
4. Add memory file: hazard_test.mem (right-click → Add or Create Simulation Sources)
```

**Step 2: Configure Memory File**
```
1. In Vivado, ensure hazard_test.mem is accessible
2. Check instr_mem.v for $readmemh path
3. Update path if needed: $readmemh("hazard_test.mem", mem);
```

**Step 3: Run Simulation**
```
1. Flow Navigator → Run Simulation → Run Behavioral Simulation
2. Add signals to waveform:
   - PC value
   - Instruction at each stage
   - Hazard signals (stall_f, stall_d, flush_d, flush_e)
   - Forwarding signals (forward_ae, forward_be)
   - Register file contents
```

**Step 4: Verify Hazard Resolution**
```
Observe in waveform:
✓ Data hazards detected and forwarded
✓ Load-use hazards cause stalls
✓ Branch instructions cause flushes
✓ No instruction loss or duplication
```

---

### Synthesis & Implementation

**Step 1: Synthesis**
```
1. Set pipe_risc_v.v as top module
2. Flow Navigator → Run Synthesis
3. Wait for completion
```

**Step 2: Get Resource Utilization**
```tcl
# After synthesis completes
report_utilization -file utilization.txt

# Note from report:
- Slice LUTs (combinational logic)
- Slice Registers (flip-flops for pipeline registers)
- Block RAM (for instruction/data memory)
```

**Step 3: Get Critical Path Delay**
```tcl
# Open Synthesized Design
open_run synth_1

# Generate timing report
report_timing -max_paths 1 -nworst 1 -delay_type max -sort_by slack -file timing.txt

# Note:
- Critical path delay (longest combinational path)
- Clock period constraint
- Slack (positive = timing met)
```

**Step 4: Run Implementation**
```
Flow Navigator → Run Implementation
```

**Step 5: Get Power Consumption**
```tcl
# After implementation
open_run impl_1
report_power -file power.txt

# Note:
- Total On-Chip Power
- Dynamic Power (switching activity)
- Static Power (leakage)
```

---

## Performance Metrics

| Metric | Command | Location |
|--------|---------|----------|
| **LUTs** | `report_utilization` | Slice LUTs |
| **Registers** | `report_utilization` | Slice Registers |
| **BRAM** | `report_utilization` | Block RAM Tile |
| **Critical Path Delay** | `report_timing -max_paths 1` | Data Path Delay |
| **Dynamic Power** | `report_power` | Dynamic Power (W) |
| **Clock Frequency** | Calculate from critical path | `1 / (critical_path_delay)` |

---

## Test Program

The `hazard_test.mem` file contains RISC-V instructions designed to test:

1. **Data Hazards:**
   - RAW (Read-After-Write) dependencies
   - Load-use hazards

2. **Control Hazards:**
   - Branch instructions
   - Jump instructions

3. **Forwarding:**
   - EX-to-EX forwarding
   - MEM-to-EX forwarding

**Example Hazard Scenarios:**
```assembly
# Load-use hazard (requires stall)
lw  x1, 0(x2)    # Load from memory
add x3, x1, x4   # Uses x1 immediately (STALL)

# Data hazard (forwarding)
add x5, x6, x7   # Writes x5
sub x8, x5, x9   # Uses x5 (FORWARD from EX/MEM)

# Branch hazard (flush)
beq x10, x11, label  # Branch taken (FLUSH D and E)
```

---

## Key Modules

### hazard_unit.v
- **Purpose:** Detects hazards and generates control signals
- **Inputs:** Register addresses from all pipeline stages
- **Outputs:** `stall_f`, `stall_d`, `flush_d`, `flush_e`, `forward_ae`, `forward_be`
- **Logic:** Implements optimized hazard detection (see ESPRESSO optimization)

### datapath.v
- **Purpose:** Implements the 5-stage pipeline datapath
- **Features:** Pipeline registers, ALU, register file, memory interfaces
- **Control:** Accepts enable/clear signals from hazard unit

### pipe_risc_v.v
- **Purpose:** Top-level module integrating datapath, control, and hazard unit
- **Interfaces:** Clock, reset, debug outputs

---

## Debugging Tips

**Issue: Incorrect hazard detection**
- Check register address comparisons in hazard_unit.v
- Verify x0 is excluded (x0 is always 0 in RISC-V)

**Issue: Stalls not propagating**
- Ensure stall_f and stall_d disable pipeline register updates
- Check enable signals are inverted correctly (~stall)

**Issue: Branch not flushing**
- Verify pcsrc_e signal is connected to flush logic
- Check flush signals clear pipeline registers

**Issue: Forwarding not working**
- Add forwarding muxes in datapath
- Verify forward_ae/forward_be control signals

---

## Quick Commands

```tcl
# Synthesis
synth_design -top pipe_risc_v -part xc7a35tcpg236-1

# Utilization
report_utilization -file util.txt

# Timing
report_timing -max_paths 10 -file timing.txt

# Power
report_power -file power.txt
```

---

**For detailed architecture and design decisions, refer to `Project_Report.pdf`**
