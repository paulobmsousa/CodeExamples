package main

import (
    "bufio"
    "fmt"
    "os"
    "strings"
    "unicode"
)

var morseTable = map[rune]string{
    'A': ".-", 'B': "-...", 'C': "-.-.", 'D': "-..",
    'E': ".", 'F': "..-.", 'G': "--.", 'H': "....",
    'I': "..", 'J': ".---", 'K': "-.-", 'L': ".-..",
    'M': "--", 'N': "-.", 'O': "---", 'P': ".--.",
    'Q': "--.-", 'R': ".-.", 'S': "...", 'T': "-",
    'U': "..-", 'V': "...-", 'W': ".--", 'X': "-..-",
    'Y': "-.--", 'Z': "--..",
    '0': "-----", '1': ".----", '2': "..---", '3': "...--",
    '4': "....-", '5': ".....", '6': "-....", '7': "--...",
    '8': "---..", '9': "----.",
    '.': ".-.-.-", ',': "--..--", '?': "..--..", '\'': ".----.",
    '!': "-.-.--", '/': "-..-.", '(': "-.--.", ')': "-.--.-",
    '&': ".-...", ':': "---...", ';': "-.-.-.", '=': "-...-",
    '+': ".-.-.", '-': "-....-", '_': "..--.-", '"': ".-..-.",
    '$': "...-..-", '@': ".--.-.", ' ': "/",
}

func asciiToMorse(r rune) string {
    bits := "..--"
    for i := 6; i >= 0; i-- {
        if r&(1<<i) != 0 {
            bits += "-"
        } else {
            bits += "."
        }
    }
    return bits
}

func encodeChar(r rune) string {
    upper := unicode.ToUpper(r)
    if code, ok := morseTable[upper]; ok {
        return code
    }
    return asciiToMorse(r)
}

func encode(text string) string {
    var encoded []string
    for _, r := range text {
        encoded = append(encoded, encodeChar(r))
    }
    return strings.Join(encoded, "|")
}

func decodeCustom(code string) rune {
    if !strings.HasPrefix(code, "..--") {
        return '?'
    }
    bits := code[4:]
    var val rune
    for _, c := range bits {
        val <<= 1
        if c == '-' {
            val |= 1
        }
    }
    return val
}

func decodeChar(code string) rune {
    for r, morse := range morseTable {
        if morse == code {
            return r
        }
    }
    return decodeCustom(code)
}

func decode(morse string) string {
    parts := strings.Split(morse, "|")
    var decoded []rune
    for _, part := range parts {
        decoded = append(decoded, decodeChar(part))
    }
    return string(decoded)
}

func assertEqual(label, expected, actual string) {
    if expected == actual {
        fmt.Printf("[PASS] %s\n", label)
    } else {
        fmt.Printf("[FAIL] %s\n  Expected: %q\n  Actual:   %q\n", label, expected, actual)
    }
}

func runTests() {
    assertEqual("Encode HELLO", "....|.|.-..|.-..|---", encode("HELLO"))
    assertEqual("Decode HELLO", "HELLO", decode("....|.|.-..|.-..|---"))
    assertEqual("Round-trip Test 123!", "TEST 123!", decode(encode("Test 123!")))
    assertEqual("Unknown ASCII 1", string(rune(1)), decode(encode(string(rune(1)))))
    assertEqual("Full sentence", "ADDRESS: 154 PENSILVILLE - ON, CA", decode(encode("Address: 154 Pensilville - ON, CA")))
}

func main() {
    runTests()

    fmt.Println("\nEnter a string to encode in Morse code:")
    scanner := bufio.NewScanner(os.Stdin)
    if scanner.Scan() {
        input := scanner.Text()
        encoded := encode(input)
        decoded := decode(encoded)

        fmt.Println("\nEncoded Morse:")
        fmt.Println(encoded)
        fmt.Println("\nDecoded Text:")
        fmt.Println(decoded)
    }
}
