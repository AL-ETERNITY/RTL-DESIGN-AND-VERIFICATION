import matplotlib.pyplot as plt
import numpy as np

# Data for comparison
designs = ['Without Optimization', 'With Optimization']

# Area (LUTs)
luts = [19, 4]

# Delay (Latency in ns)
latency = [7.159, 6.377]

# Power data (in Watts)
total_power = [0.614, 0.47]
dynamic_power = [0.516, 0.374]
static_power = [0.098, 0.096]

# Set up the plotting style
plt.style.use('default')
fig = plt.figure(figsize=(15, 12))

# Create a 2x3 subplot layout
# Plot 1: LUT Comparison (Bar Chart)
plt.subplot(2, 3, 1)
colors_lut = ['#FF6B6B', '#4ECDC4']
bars1 = plt.bar(designs, luts, color=colors_lut, alpha=0.8, edgecolor='black', linewidth=1.5)
plt.title('Area Comparison (LUTs)', fontsize=14, fontweight='bold')
plt.ylabel('Number of LUTs', fontsize=12)
plt.grid(axis='y', alpha=0.3)
# Add value labels on bars
for bar, value in zip(bars1, luts):
    plt.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.3, 
             str(value), ha='center', va='bottom', fontweight='bold')

# Plot 2: Latency Comparison (Bar Chart)
plt.subplot(2, 3, 2)
colors_delay = ['#FF9F43', '#00D2D3']
bars2 = plt.bar(designs, latency, color=colors_delay, alpha=0.8, edgecolor='black', linewidth=1.5)
plt.title('Delay Comparison (Latency)', fontsize=14, fontweight='bold')
plt.ylabel('Latency (ns)', fontsize=12)
plt.grid(axis='y', alpha=0.3)
# Add value labels on bars
for bar, value in zip(bars2, latency):
    plt.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.05, 
             f'{value:.3f}', ha='center', va='bottom', fontweight='bold')

# Plot 3: Total Power Comparison (Bar Chart)
plt.subplot(2, 3, 3)
colors_power = ['#A55EEA', '#26DE81']
bars3 = plt.bar(designs, total_power, color=colors_power, alpha=0.8, edgecolor='black', linewidth=1.5)
plt.title('Total Power Comparison', fontsize=14, fontweight='bold')
plt.ylabel('Power (W)', fontsize=12)
plt.grid(axis='y', alpha=0.3)
# Add value labels on bars
for bar, value in zip(bars3, total_power):
    plt.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.01, 
             f'{value:.3f}W', ha='center', va='bottom', fontweight='bold')

# Plot 4: Power Breakdown (Stacked Bar Chart)
plt.subplot(2, 3, 4)
width = 0.6
x_pos = np.arange(len(designs))
p1 = plt.bar(x_pos, dynamic_power, width, label='Dynamic Power', color='#FF6B6B', alpha=0.8)
p2 = plt.bar(x_pos, static_power, width, bottom=dynamic_power, label='Static Power', color='#4ECDC4', alpha=0.8)
plt.title('Power Breakdown', fontsize=14, fontweight='bold')
plt.ylabel('Power (W)', fontsize=12)
plt.xticks(x_pos, designs)
plt.legend()
plt.grid(axis='y', alpha=0.3)

# Plot 5: Area-Delay Product (ADP)
plt.subplot(2, 3, 5)
adp = [luts[i] * latency[i] for i in range(len(designs))]
colors_adp = ['#F39C12', '#8E44AD']
bars5 = plt.bar(designs, adp, color=colors_adp, alpha=0.8, edgecolor='black', linewidth=1.5)
plt.title('Area-Delay Product (ADP)', fontsize=14, fontweight='bold')
plt.ylabel('LUTs × ns', fontsize=12)
plt.grid(axis='y', alpha=0.3)
# Add value labels on bars
for bar, value in zip(bars5, adp):
    plt.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 1, 
             f'{value:.1f}', ha='center', va='bottom', fontweight='bold')

# Plot 6: Improvement Percentages
plt.subplot(2, 3, 6)
# Calculate improvements (reduction in values)
lut_improvement = ((luts[0] - luts[1]) / luts[0]) * 100
latency_improvement = ((latency[0] - latency[1]) / latency[0]) * 100
power_improvement = ((total_power[0] - total_power[1]) / total_power[0]) * 100

metrics = ['LUTs', 'Latency', 'Total Power']
improvements = [lut_improvement, latency_improvement, power_improvement]
colors_imp = ['#E74C3C', '#3498DB', '#2ECC71']

bars6 = plt.bar(metrics, improvements, color=colors_imp, alpha=0.8, edgecolor='black', linewidth=1.5)
plt.title('Optimization Improvements', fontsize=14, fontweight='bold')
plt.ylabel('Improvement (%)', fontsize=12)
plt.grid(axis='y', alpha=0.3)
# Add value labels on bars
for bar, value in zip(bars6, improvements):
    plt.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.5, 
             f'{value:.1f}%', ha='center', va='bottom', fontweight='bold')

# Adjust layout and add main title
plt.tight_layout()
plt.suptitle('Boolean Function Optimization Analysis\n(Without vs With Optimization)', 
             fontsize=16, fontweight='bold', y=0.98)

# Save the plot
plt.savefig('optimization_comparison.png', dpi=300, bbox_inches='tight')
plt.show()

# Print summary statistics
print("="*60)
print("OPTIMIZATION ANALYSIS SUMMARY")
print("="*60)
print(f"LUT Reduction: {luts[0]} → {luts[1]} ({lut_improvement:.1f}% improvement)")
print(f"Latency Reduction: {latency[0]:.3f}ns → {latency[1]:.3f}ns ({latency_improvement:.1f}% improvement)")
print(f"Total Power Reduction: {total_power[0]:.3f}W → {total_power[1]:.3f}W ({power_improvement:.1f}% improvement)")
print(f"Dynamic Power Reduction: {dynamic_power[0]:.3f}W → {dynamic_power[1]:.3f}W ({((dynamic_power[0] - dynamic_power[1]) / dynamic_power[0]) * 100:.1f}% improvement)")
print(f"Static Power Reduction: {static_power[0]:.3f}W → {static_power[1]:.3f}W ({((static_power[0] - static_power[1]) / static_power[0]) * 100:.1f}% improvement)")
print(f"Area-Delay Product: {adp[0]:.1f} → {adp[1]:.1f} ({((adp[0] - adp[1]) / adp[0]) * 100:.1f}% improvement)")
print("="*60)
