# Morse table for standard characters
const morse_table = Dict{Char, String}(
    'A'=>".-", 'B'=>"-...", 'C'=>"-.-.", 'D'=>"-..",
    'E'=>".", 'F'=>"..-.", 'G'=>"--.", 'H'=>"....",
    'I'=>"..", 'J'=>".---", 'K'=>"-.-", 'L'=>".-..",
    'M'=>"--", 'N'=>"-.", 'O'=>"---", 'P'=>".--.",
    'Q'=>"--.-", 'R'=>".-.", 'S'=>"...", 'T'=>"-",
    'U'=>"..-", 'V'=>"...-", 'W'=>".--", 'X'=>"-..-",
    'Y'=>"-.--", 'Z'=>"--..",
    '0'=>"-----", '1'=>".----", '2'=>"..---", '3'=>"...--",
    '4'=>"....-", '5'=>".....", '6'=>"-....", '7'=>"--...",
    '8'=>"---..", '9'=>"----.",
    '.'=>".-.-.-", ','=>"--..--", '?'=>"..--..", '\''=>".----.",
    '!'=>"-.-.--", '/'=>"-..-.", '('=>"-.--.", ')'=>"-.--.-",
    '&'=>".-...", ':'=>"---...", ';'=>"-.-.-.", '='=>"-...-",
    '+'=>".-.-.", '-'=>"-....-", '_'=>"..--.-", '"'=>".-..-.",
    '$'=>"...-..-", '@'=>".--.-.", ' '=>"/"
)

# Convert ASCII value to Morse-style binary
function ascii_to_morse(c::Char)
    bits = "..--"
    for i in 6:-1:0
        bits *= (Int(c) & (1 << i)) != 0 ? "-" : "."
    end
    return bits
end

# Encode a single character
function encode_char(c::Char)
    upper = uppercase(c)
    return get(morse_table, upper[1], ascii_to_morse(c))
end

# Encode a full string
function encode(text::String)
    return join([encode_char(c) for c in text], "|")
end

# Decode custom Morse escape
function decode_custom(code::AbstractString)
    if !startswith(code, "..--")
        return '?'
    end
    val = 0
    for c in code[5:end]
        val <<= 1
        val += c == '-' ? 1 : 0
    end
    return Char(val)
end

# Decode a single Morse symbol
function decode_char(code::AbstractString)
    for (k, v) in morse_table
        if v == code
            return k
        end
    end
    return decode_custom(code)
end

# Decode a full Morse string
function decode(morse::String)
    parts = split(morse, "|")
    return join([decode_char(part) for part in parts])
end

# Simulated unit test
function assert_equal(label::String, expected::String, actual::String)
    if expected == actual
        println("[PASS] $label")
    else
        println("[FAIL] $label")
        println("  Expected: \"$expected\"")
        println("  Actual:   \"$actual\"")
    end
end

function run_tests()
    assert_equal("Encode HELLO", "....|.|.-..|.-..|---", encode("HELLO"))
    assert_equal("Decode HELLO", "HELLO", decode("....|.|.-..|.-..|---"))
    assert_equal("Round-trip Test 123!", "TEST 123!", decode(encode("Test 123!")))
    assert_equal("Unknown ASCII 1", string(Char(1)), decode(encode(string(Char(1)))))
    assert_equal("Full sentence", "ADDRESS: 154 PENSILVILLE - ON, CA", decode(encode("Address: 154 Pensilville - ON, CA")))
end

# Main program
function main()
    run_tests()
    println("\nEnter a string to encode in Morse code:")
    input = readline()
    encoded = encode(input)
    decoded = decode(encoded)

    println("\nEncoded Morse:\n$encoded")
    println("\nDecoded Text:\n$decoded")
end

main()
