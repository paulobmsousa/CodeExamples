-- Morse table for standard characters
local morse_table = {
    ['A'] = ".-", ['B'] = "-...", ['C'] = "-.-.", ['D'] = "-..",
    ['E'] = ".", ['F'] = "..-.", ['G'] = "--.", ['H'] = "....",
    ['I'] = "..", ['J'] = ".---", ['K'] = "-.-", ['L'] = ".-..",
    ['M'] = "--", ['N'] = "-.", ['O'] = "---", ['P'] = ".--.",
    ['Q'] = "--.-", ['R'] = ".-.", ['S'] = "...", ['T'] = "-",
    ['U'] = "..-", ['V'] = "...-", ['W'] = ".--", ['X'] = "-..-",
    ['Y'] = "-.--", ['Z'] = "--..",
    ['0'] = "-----", ['1'] = ".----", ['2'] = "..---", ['3'] = "...--",
    ['4'] = "....-", ['5'] = ".....", ['6'] = "-....", ['7'] = "--...",
    ['8'] = "---..", ['9'] = "----.",
    ['.'] = ".-.-.-", [','] = "--..--", ['?'] = "..--..", ["'"] = ".----.",
    ['!'] = "-.-.--", ['/'] = "-..-.", ['('] = "-.--.", [')'] = "-.--.-",
    ['&'] = ".-...", [':'] = "---...", [';'] = "-.-.-.", ['='] = "-...-",
    ['+'] = ".-.-.", ['-'] = "-....-", ['_'] = "..--.-", ['"'] = ".-..-.",
    ['$'] = "...-..-", ['@'] = ".--.-.", [' '] = "/"
}

-- Convert ASCII value to Morse-style binary
local function ascii_to_morse(c)
    local bits = "..--"
    local val = string.byte(c)
    for i = 6, 0, -1 do
        bits = bits .. ((val & (1 << i)) ~= 0 and "-" or ".")
    end
    return bits
end

-- Encode a single character
local function encode_char(c)
    local upper = string.upper(c)
    return morse_table[upper] or ascii_to_morse(c)
end

-- Encode a full string
local function encode(text)
    local result = {}
    for i = 1, #text do
        table.insert(result, encode_char(text:sub(i, i)))
    end
    return table.concat(result, "|")
end

-- Decode custom Morse escape
local function decode_custom(code)
    if not code:find("^%.%.%-%-") then return "?" end
    local val = 0
    for i = 5, #code do
        val = val << 1
        if code:sub(i, i) == "-" then val = val | 1 end
    end
    return string.char(val)
end

-- Decode a single Morse symbol
local function decode_char(code)
    for k, v in pairs(morse_table) do
        if v == code then return k end
    end
    return decode_custom(code)
end

-- Decode a full Morse string
local function decode(morse)
    local result = {}
    for code in morse:gmatch("[^|]+") do
        table.insert(result, decode_char(code))
    end
    return table.concat(result)
end

-- Simulated unit test
local function assert_equal(label, expected, actual)
    if expected == actual then
        print("[PASS] " .. label)
    else
        print("[FAIL] " .. label)
        print("  Expected: \"" .. expected .. "\"")
        print("  Actual:   \"" .. actual .. "\"")
    end
end

local function run_tests()
    assert_equal("Encode HELLO", "....|.|.-..|.-..|---", encode("HELLO"))
    assert_equal("Decode HELLO", "HELLO", decode("....|.|.-..|.-..|---"))
    assert_equal("Round-trip Test 123!", "TEST 123!", decode(encode("Test 123!")))
    assert_equal("Unknown ASCII 1", string.char(1), decode(encode(string.char(1))))
    assert_equal("Full sentence", "ADDRESS: 154 PENSILVILLE - ON, CA", decode(encode("Address: 154 Pensilville - ON, CA")))
end

-- Main program
run_tests()
print("\nEnter a string to encode in Morse code:")
local input = io.read()
local encoded = encode(input)
local decoded = decode(encoded)

print("\nEncoded Morse:\n" .. encoded)
print("\nDecoded Text:\n" .. decoded)
