import matplotlib.pyplot as plt
import numpy as np

# Data for the 5 ALU configurations with detailed descriptions
configurations = ['Config 1\n(All Fast)', 'Config 2\n(All Slow)', 'Config 3\n(Mixed F-S)', 
                 'Config 4\n(Mixed S-F)', 'Config 5\n(Balanced)']

# Detailed configuration descriptions
config_details = [
    "Config 1 (All Fast):\n• CLA Adder\n• Schoolbook Multiplier\n• Parallel Subtractor\n• Signed Comparator",
    "Config 2 (All Slow):\n• Serial Adder\n• Left-shift Multiplier\n• Serial Subtractor\n• Unsigned Comparator", 
    "Config 3 (Mixed F-S):\n• CLA Adder\n• Left-shift Multiplier\n• Parallel Subtractor\n• Signed Comparator",
    "Config 4 (Mixed S-F):\n• Serial Adder\n• Schoolbook Multiplier\n• Serial Subtractor\n• Unsigned Comparator",
    "Config 5 (Balanced):\n• RCA Adder\n• Schoolbook Multiplier\n• Parallel Subtractor\n• Signed Comparator"
]

# Latency data (x-axis) in ns
latency = [16.593, 7.538, 12.886, 15.995, 16.020]

# LUT count data (y-axis) - representing overall area
area_lut = [1348, 612, 484, 1454, 1342]

# Create the design space plot
plt.figure(figsize=(16, 10))

# Create subplot layout - main plot and configuration details
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(20, 10), gridspec_kw={'width_ratios': [3, 1]})

# Main plot on the left
colors = ['red', 'blue', 'green', 'orange', 'purple']
markers = ['o', 's', '^', 'D', 'v']

for i in range(5):
    ax1.scatter(latency[i], area_lut[i], color=colors[i], marker=markers[i], 
               s=150, label=configurations[i], edgecolors='black', linewidth=2)

# Add configuration labels next to each point
for i in range(5):
    ax1.annotate(f'Config {i+1}', 
                (latency[i], area_lut[i]), 
                xytext=(10, 10), 
                textcoords='offset points',
                fontsize=11,
                fontweight='bold',
                bbox=dict(boxstyle='round,pad=0.3', facecolor=colors[i], alpha=0.3))

# Customize the main plot
ax1.set_xlabel('Latency (ns)', fontsize=14, fontweight='bold')
ax1.set_ylabel('Area (LUT Count)', fontsize=14, fontweight='bold')
ax1.set_title('ALU Design Space Analysis: Latency vs Area Trade-off', fontsize=16, fontweight='bold')
ax1.grid(True, alpha=0.3)

# Set axis limits with some padding
x_margin = (max(latency) - min(latency)) * 0.1
y_margin = (max(area_lut) - min(area_lut)) * 0.1
ax1.set_xlim(min(latency) - x_margin, max(latency) + x_margin)
ax1.set_ylim(min(area_lut) - y_margin, max(area_lut) + y_margin)

# Add a trend line to show the general trade-off
z = np.polyfit(latency, area_lut, 1)
p = np.poly1d(z)
ax1.plot(latency, p(latency), "r--", alpha=0.5, linewidth=2, label='Trend Line')

# Configuration details panel on the right
ax2.axis('off')
ax2.set_title('Configuration Details', fontsize=14, fontweight='bold', pad=20)

# Add detailed configuration descriptions
y_positions = [0.85, 0.68, 0.51, 0.34, 0.17]
for i in range(5):
    # Add colored box for each configuration
    bbox_props = dict(boxstyle='round,pad=0.5', facecolor=colors[i], alpha=0.2, edgecolor=colors[i], linewidth=2)
    ax2.text(0.05, y_positions[i], config_details[i], 
             transform=ax2.transAxes, fontsize=10, fontweight='bold',
             verticalalignment='top', bbox=bbox_props)
    
    # Add performance metrics
    efficiency = area_lut[i] / latency[i]
    metrics_text = f"Latency: {latency[i]:.3f} ns\nArea: {area_lut[i]} LUTs\nEfficiency: {efficiency:.2f} LUTs/ns"
    ax2.text(0.65, y_positions[i], metrics_text, 
             transform=ax2.transAxes, fontsize=9,
             verticalalignment='top', 
             bbox=dict(boxstyle='round,pad=0.3', facecolor='lightgray', alpha=0.5))

plt.tight_layout()

# Display the plot
plt.show()

# Print detailed summary with configuration descriptions
print("="*80)
print("ALU DESIGN SPACE ANALYSIS - DETAILED SUMMARY")
print("="*80)

for i in range(5):
    efficiency = area_lut[i] / latency[i]
    print(f"\nCONFIG {i+1}:")
    print(f"  Implementation Details:")
    if i == 0:  # Config 1
        print(f"    • Adder: CLA (Carry Look-Ahead)")
        print(f"    • Multiplier: Schoolbook")
        print(f"    • Subtractor: Parallel")
        print(f"    • Comparator: Signed")
    elif i == 1:  # Config 2
        print(f"    • Adder: Serial")
        print(f"    • Multiplier: Left-shift")
        print(f"    • Subtractor: Serial")
        print(f"    • Comparator: Unsigned")
    elif i == 2:  # Config 3
        print(f"    • Adder: CLA (Carry Look-Ahead)")
        print(f"    • Multiplier: Left-shift")
        print(f"    • Subtractor: Parallel")
        print(f"    • Comparator: Signed")
    elif i == 3:  # Config 4
        print(f"    • Adder: Serial")
        print(f"    • Multiplier: Schoolbook")
        print(f"    • Subtractor: Serial")
        print(f"    • Comparator: Unsigned")
    elif i == 4:  # Config 5
        print(f"    • Adder: RCA (Ripple Carry)")
        print(f"    • Multiplier: Schoolbook")
        print(f"    • Subtractor: Parallel")
        print(f"    • Comparator: Signed")
    
    print(f"  Performance Metrics:")
    print(f"    • Latency: {latency[i]:.3f} ns")
    print(f"    • Area: {area_lut[i]} LUTs")
    print(f"    • Efficiency: {efficiency:.2f} LUTs/ns")

print("\n" + "="*80)
print("DESIGN SPACE ANALYSIS:")
print("="*80)
best_latency_idx = latency.index(min(latency))
best_area_idx = area_lut.index(min(area_lut))
efficiencies = [area_lut[i]/latency[i] for i in range(5)]
best_efficiency_idx = efficiencies.index(min(efficiencies))

print(f"🏆 BEST LATENCY:    Config {best_latency_idx+1} ({min(latency):.3f} ns)")
print(f"🏆 BEST AREA:       Config {best_area_idx+1} ({min(area_lut)} LUTs)")
print(f"🏆 BEST EFFICIENCY: Config {best_efficiency_idx+1} ({min(efficiencies):.2f} LUTs/ns)")

print(f"\n📊 DESIGN RECOMMENDATIONS:")
print(f"   • For Speed Priority: Choose Config {best_latency_idx+1}")
print(f"   • For Area Priority: Choose Config {best_area_idx+1}")
print(f"   • For Best Balance: Choose Config {best_efficiency_idx+1}")
print("="*80)

# Save the plot
plt.savefig('ALU_Design_Space_Analysis.png', dpi=300, bbox_inches='tight')
print("Plot saved as 'ALU_Design_Space_Analysis.png'")
