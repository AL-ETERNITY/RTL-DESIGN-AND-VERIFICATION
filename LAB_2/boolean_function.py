def decimal_to_boolean_expressions(decimal_numbers, bit_size=6):
    variables = ["A", "B", "C", "D", "E", "F"]  # MSB → LSB
    expressions = []
    for num in decimal_numbers:
        if num >= (1 << bit_size):
            expressions.append(f"{num} cannot fit in {bit_size} bits")
            continue
        binary = format(num, f"0{bit_size}b")
        expr = "".join(var if bit == "1" else var + "'" for var, bit in zip(variables, binary))
        expressions.append(expr)
    return expressions

decimal_numbers = [0, 4, 8, 10, 12, 16, 20, 24, 26, 28, 40, 42, 44, 46, 56, 58]
results = decimal_to_boolean_expressions(decimal_numbers)

for dec, expr in zip(decimal_numbers, results):
    print(f"{dec:3} → {expr}")
