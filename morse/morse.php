<?php

// Morse table for standard characters
$morseTable = [
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
    '.'=>".-.-.-", ','=>"--..--", '?' =>"..--..", "'"=>".----.",
    '!'=>"-.-.--", '/' =>"-..-.", '('=>"-.--.", ')'=>"-.--.-",
    '&'=>".-...", ':'=>"---...", ';'=>"-.-.-.", '='=>"-...-",
    '+'=>".-.-.", '-' =>"-....-", '_' =>"..--.-", '"'=>".-..-.",
    '$'=>"...-..-", '@'=>".--.-.", ' '=>"/"
];

// Convert ASCII value to Morse-style binary
function asciiToMorse($char) {
    $val = ord($char);
    $bits = "..--";
    for ($i = 6; $i >= 0; $i--) {
        $bits .= ($val & (1 << $i)) ? "-" : ".";
    }
    return $bits;
}

// Encode a single character
function encodeChar($char, $table) {
    $upper = strtoupper($char);
    return $table[$upper] ?? asciiToMorse($char);
}

// Encode a full string
function encode($text, $table) {
    $result = [];
    for ($i = 0; $i < strlen($text); $i++) {
        $result[] = encodeChar($text[$i], $table);
    }
    return implode("|", $result);
}

// Decode custom Morse escape
function decodeCustom($code) {
    if (substr($code, 0, 4) !== "..--") return "?";
    $val = 0;
    for ($i = 4; $i < strlen($code); $i++) {
        $val <<= 1;
        if ($code[$i] === "-") $val |= 1;
    }
    return chr($val);
}

// Decode a single Morse symbol
function decodeChar($code, $table) {
    foreach ($table as $char => $morse) {
        if ($morse === $code) return $char;
    }
    return decodeCustom($code);
}

// Decode a full Morse string
function decode($morse, $table) {
    $parts = explode("|", $morse);
    $result = "";
    foreach ($parts as $code) {
        $result .= decodeChar($code, $table);
    }
    return $result;
}

// Simulated unit test
function assertEqual($label, $expected, $actual) {
    if ($expected === $actual) {
        echo "[PASS] $label\n";
    } else {
        echo "[FAIL] $label\n";
        echo "  Expected: \"$expected\"\n";
        echo "  Actual:   \"$actual\"\n";
    }
}

function runTests($table) {
    assertEqual("Encode HELLO", "....|.|.-..|.-..|---", encode("HELLO", $table));
    assertEqual("Decode HELLO", "HELLO", decode("....|.|.-..|.-..|---", $table));
    assertEqual("Round-trip Test 123!", "TEST 123!", decode(encode("Test 123!", $table), $table));
    assertEqual("Unknown ASCII 1", chr(1), decode(encode(chr(1), $table), $table));
    assertEqual("Full sentence", "ADDRESS: 154 PENSILVILLE - ON, CA", decode(encode("Address: 154 Pensilville - ON, CA", $table), $table));
}

// Main program
runTests($morseTable);

echo "\nEnter a string to encode in Morse code:\n";
$input = trim(fgets(STDIN));
$encoded = encode($input, $morseTable);
$decoded = decode($encoded, $morseTable);

echo "\nEncoded Morse:\n$encoded\n";
echo "\nDecoded Text:\n$decoded\n";
