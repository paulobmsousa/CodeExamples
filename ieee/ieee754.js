// Convert float to IEEE-754 binary string (32-bit)
function ieee754ToBin(num) {
    // Create a 4-byte ArrayBuffer and a DataView to access bits
    const buffer = new ArrayBuffer(4);
    const view = new DataView(buffer);

    // Write the float32 into the buffer
    view.setFloat32(0, num, false); // false = big-endian

    // Read as unsigned 32-bit integer
    const bits = view.getUint32(0, false);

    // Build binary string
    let binStr = "";
    for (let i = 31; i >= 0; i--) {
        binStr += ((bits >> i) & 1) ? "1" : "0";
    }
    return binStr;
}

// Convert IEEE-754 binary string to float
function binToIEEE754(binStr) {
    if (binStr.length !== 32) {
        throw new Error("Binary string must be 32 bits.");
    }

    let bits = 0;
    for (let i = 0; i < 32; i++) {
        if (binStr[i] === "1") {
            bits |= (1 << (31 - i)) >>> 0;
        } else if (binStr[i] !== "0") {
            throw new Error("Invalid character in binary string.");
        }
    }

    // Put bits into a buffer and read as float32
    const buffer = new ArrayBuffer(4);
    const view = new DataView(buffer);
    view.setUint32(0, bits, false);
    return view.getFloat32(0, false);
}

// Main-like function
function main() {
    const args = process.argv.slice(2);
    if (args.length !== 1) {
        console.log(`Usage: node ${process.argv[1]} <float_number>`);
        process.exit(1);
    }

    const input = parseFloat(args[0]);
    if (isNaN(input)) {
        console.error("Invalid float number.");
        process.exit(1);
    }

    // Convert float to binary
    const binary = ieee754ToBin(input);
    console.log(`IEEE-754 binary of ${input.toFixed(6)}: ${binary}`);

    // Convert binary back to float
    const recovered = binToIEEE754(binary);
    console.log(`Recovered float from binary: ${recovered.toFixed(6)}`);
}

// Run if executed directly
if (require.main === module) {
    main();
}
