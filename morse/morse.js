const morseTable = {
  'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..',
  'E': '.', 'F': '..-.', 'G': '--.', 'H': '....',
  'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..',
  'M': '--', 'N': '-.', 'O': '---', 'P': '.--.',
  'Q': '--.-', 'R': '.-.', 'S': '...', 'T': '-',
  'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
  'Y': '-.--', 'Z': '--..',
  '0': '-----', '1': '.----', '2': '..---', '3': '...--',
  '4': '....-', '5': '.....', '6': '-....', '7': '--...',
  '8': '---..', '9': '----.',
  '.': '.-.-.-', ',': '--..--', '?': '..--..', "'": '.----.',
  '!': '-.-.--', '/': '-..-.', '(': '-.--.', ')': '-.--.-',
  '&': '.-...', ':': '---...', ';': '-.-.-.', '=': '-...-',
  '+': '.-.-.', '-': '-....-', '_': '..--.-', '"': '.-..-.',
  '$': '...-..-', '@': '.--.-.', ' ': '/'
};

function asciiToMorse(charCode) {
  let binary = '..--';
  for (let i = 6; i >= 0; i--) {
    binary += (charCode & (1 << i)) ? '-' : '.';
  }
  return binary;
}

function encodeChar(c) {
  const upper = c.toUpperCase();
  return morseTable[upper] || asciiToMorse(c.charCodeAt(0));
}

function encode(text) {
  return Array.from(text).map(encodeChar).join('|');
}

function decodeCustom(code) {
  if (!code.startsWith('..--')) return '?';
  let val = 0;
  for (let i = 4; i < code.length; i++) {
    val <<= 1;
    if (code[i] === '-') val |= 1;
  }
  return String.fromCharCode(val);
}

function decodeChar(code) {
  for (const [char, morse] of Object.entries(morseTable)) {
    if (morse === code) return char;
  }
  return decodeCustom(code);
}

function decode(morse) {
  return morse.split('|').map(decodeChar).join('');
}

function assertEqual(label, expected, actual) {
  if (expected === actual) {
    console.log(`[PASS] ${label}`);
  } else {
    console.log(`[FAIL] ${label}`);
    console.log(`  Expected: "${expected}"`);
    console.log(`  Actual:   "${actual}"`);
  }
}

function runTests() {
  assertEqual("Encode HELLO", "....|.|.-..|.-..|---", encode("HELLO"));
  assertEqual("Decode HELLO", "HELLO", decode("....|.|.-..|.-..|---"));
  assertEqual("Round-trip Test 123!", "TEST 123!", decode(encode("Test 123!")));
  assertEqual("Unknown ASCII 1", String.fromCharCode(1), decode(encode(String.fromCharCode(1))));
  assertEqual("Full sentence", "ADDRESS: 154 PENSILVILLE - ON, CA", decode(encode("Address: 154 Pensilville - ON, CA")));
}

// Run tests
runTests();

// Interactive input (Node.js)
const readline = require('readline').createInterface({
  input: process.stdin,
  output: process.stdout
});

readline.question("\nEnter a string to encode in Morse code:\n", input => {
  const encoded = encode(input);
  const decoded = decode(encoded);

  console.log("\nEncoded Morse:\n" + encoded);
  console.log("\nDecoded Text:\n" + decoded);

  readline.close();
});
