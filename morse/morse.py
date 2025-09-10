# Morse table for standard characters
morse_table = {
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
    '.': ".-.-.-", ',': "--..--", '?': "..--..", "'": ".----.",
    '!': "-.-.--", '/': "-..-.", '(': "-.--.", ')': "-.--.-",
    '&': ".-...", ':': "---...", ';': "-.-.-.", '=': "-...-",
    '+': ".-.-.", '-': "-....-", '_': "..--.-", '"': ".-..-.",
    '$': "...-..-", '@': ".--.-.", ' ': "/"
}

def ascii_to_morse(c):
    bits = "..--"
    val = ord(c)
    for i in range(6, -1, -1):
        bits += "-" if val & (1 << i) else "."
    return bits

def encode_char(c):
    upper = c.upper()
    return morse_table.get(upper, ascii_to_morse(c))

def encode(text):
    return "|".join(encode_char(c) for c in text)

def decode_custom(code):
    if not code.startswith("..--"):
        return '?'
    val = 0
    for c in code[4:]:
        val <<= 1
        if c == '-':
            val |= 1
    return chr(val)

def decode_char(code):
    for char, morse in morse_table.items():
        if morse == code:
            return char
    return decode_custom(code)

def decode(morse):
    return ''.join(decode_char(code) for code in morse.split('|'))

def assert_equal(label, expected, actual):
    if expected == actual:
        print(f"[PASS] {label}")
    else:
        print(f"[FAIL] {label}")
        print(f"  Expected: \"{expected}\"")
        print(f"  Actual:   \"{actual}\"")

def run_tests():
    assert_equal("Encode HELLO", "....|.|.-..|.-..|---", encode("HELLO"))
    assert_equal("Decode HELLO", "HELLO", decode("....|.|.-..|.-..|---"))
    assert_equal("Round-trip Test 123!", "TEST 123!", decode(encode("Test 123!")))
    assert_equal("Unknown ASCII 1", chr(1), decode(encode(chr(1))))
    assert_equal("Full sentence", "ADDRESS: 154 PENSILVILLE - ON, CA", decode(encode("Address: 154 Pensilville - ON, CA")))

if __name__ == "__main__":
    run_tests()
    print("\nEnter a string to encode in Morse code:")
    user_input = input()
    encoded = encode(user_input)
    decoded = decode(encoded)

    print("\nEncoded Morse:\n" + encoded)
    print("\nDecoded Text:\n" + decoded)
