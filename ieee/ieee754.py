import struct
import sys

# Convert float to IEEE-754 binary string (32-bit)
def ieee754_to_bin(num: float) -> str:
    # Pack float into 4 bytes (big-endian)
    packed = struct.pack('>f', num)
    # Unpack as unsigned 32-bit integer
    bits = struct.unpack('>I', packed)[0]
    # Format as 32-bit binary string
    return ''.join('1' if (bits >> i) & 1 else '0' for i in range(31, -1, -1))

# Convert IEEE-754 binary string to float
def bin_to_ieee754(bin_str: str) -> float:
    if len(bin_str) != 32:
        raise ValueError("Binary string must be 32 bits.")
    bits = 0
    for i, ch in enumerate(bin_str):
        if ch == '1':
            bits |= 1 << (31 - i)
        elif ch != '0':
            raise ValueError("Invalid character in binary string.")
    # Pack bits as unsigned int, then unpack as float
    packed = struct.pack('>I', bits)
    return struct.unpack('>f', packed)[0]

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <float_number>")
        sys.exit(1)

    try:
        input_val = float(sys.argv[1])
    except ValueError:
        print("Invalid float number.")
        sys.exit(1)

    # Convert float to binary
    binary = ieee754_to_bin(input_val)
    print(f"IEEE-754 binary of {input_val:.6f}: {binary}")

    # Convert binary back to float
    recovered = bin_to_ieee754(binary)
    print(f"Recovered float from binary: {recovered:.6f}")

if __name__ == "__main__":
    main()
