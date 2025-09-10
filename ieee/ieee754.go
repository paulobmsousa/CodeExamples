package main

import (
    "encoding/binary"
    "fmt"
    "math"
    "os"
    "strconv"
    "strings"
)

// Convert float32 to IEEE-754 binary string
func ieee754ToBin(num float32) string {
    // Get the raw bits of the float32
    bits := math.Float32bits(num)
    binStr := make([]byte, 32)

    for i := 31; i >= 0; i-- {
        if (bits>>i)&1 == 1 {
            binStr[31-i] = '1'
        } else {
            binStr[31-i] = '0'
        }
    }
    return string(binStr)
}

// Convert IEEE-754 binary string to float32
func binToIEEE754(binStr string) (float32, error) {
    if len(binStr) != 32 {
        return 0, fmt.Errorf("binary string must be 32 bits")
    }

    var bits uint32
    for i := 0; i < 32; i++ {
        switch binStr[i] {
        case '1':
            bits |= 1 << (31 - i)
        case '0':
            // do nothing
        default:
            return 0, fmt.Errorf("invalid character in binary string")
        }
    }

    return math.Float32frombits(bits), nil
}

func main() {
    if len(os.Args) != 2 {
        fmt.Printf("Usage: %s <float_number>\n", os.Args[0])
        os.Exit(1)
    }

    // Parse input as float32
    input64, err := strconv.ParseFloat(os.Args[1], 32)
    if err != nil {
        fmt.Fprintf(os.Stderr, "Invalid float: %v\n", err)
        os.Exit(1)
    }
    input := float32(input64)

    // Convert float to binary string
    binaryStr := ieee754ToBin(input)
    fmt.Printf("IEEE-754 binary of %.6f: %s\n", input, binaryStr)

    // Convert binary string back to float
    recovered, err := binToIEEE754(binaryStr)
    if err != nil {
        fmt.Fprintf(os.Stderr, "Error: %v\n", err)
        os.Exit(1)
    }
    fmt.Printf("Recovered float from binary: %.6f\n", recovered)
}
