<?php
// Convert float to IEEE-754 binary string (32-bit)
function ieee754ToBin(float $num): string {
    // Pack the float into 4 bytes (big-endian)
    $packed = pack("G", $num); // "G" = float (big-endian, 32-bit)
    // Unpack as unsigned 32-bit integer
    $bits = unpack("N", $packed)[1]; // "N" = unsigned long (big-endian)

    $binStr = '';
    for ($i = 31; $i >= 0; $i--) {
        $binStr .= (($bits >> $i) & 1) ? '1' : '0';
    }
    return $binStr;
}

// Convert IEEE-754 binary string to float
function binToIEEE754(string $binStr): float {
    if (strlen($binStr) !== 32) {
        throw new InvalidArgumentException("Binary string must be 32 bits.");
    }

    $bits = 0;
    for ($i = 0; $i < 32; $i++) {
        $ch = $binStr[$i];
        if ($ch === '1') {
            $bits |= (1 << (31 - $i));
        } elseif ($ch !== '0') {
            throw new InvalidArgumentException("Invalid character in binary string.");
        }
    }

    // Pack bits as unsigned int, then unpack as float
    $packed = pack("N", $bits);
    return unpack("G", $packed)[1];
}

// Main-like execution
if ($argc !== 2) {
    echo "Usage: php {$argv[0]} <float_number>\n";
    exit(1);
}

$input = floatval($argv[1]);

// Convert float to binary
$binary = ieee754ToBin($input);
printf("IEEE-754 binary of %.6f: %s\n", $input, $binary);

// Convert binary back to float
$recovered = binToIEEE754($binary);
printf("Recovered float from binary: %.6f\n", $recovered);
