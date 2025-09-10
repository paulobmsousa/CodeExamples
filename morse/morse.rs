use std::collections::HashMap;
use std::io::{self, Write};

fn build_morse_table() -> HashMap<char, &'static str> {
    let mut table = HashMap::new();
    let entries = [
        ('A', ".-"), ('B', "-..."), ('C', "-.-."), ('D', "-.."),
        ('E', "."), ('F', "..-."), ('G', "--."), ('H', "...."),
        ('I', ".."), ('J', ".---"), ('K', "-.-"), ('L', ".-.."),
        ('M', "--"), ('N', "-."), ('O', "---"), ('P', ".--."),
        ('Q', "--.-"), ('R', ".-."), ('S', "..."), ('T', "-"),
        ('U', "..-"), ('V', "...-"), ('W', ".--"), ('X', "-..-"),
        ('Y', "-.--"), ('Z', "--.."),
        ('0', "-----"), ('1', ".----"), ('2', "..---"), ('3', "...--"),
        ('4', "....-"), ('5', "....."), ('6', "-...."), ('7', "--..."),
        ('8', "---.."), ('9', "----."),
        ('.', ".-.-.-"), (',', "--..--"), ('?', "..--.."), ('\'', ".----."),
        ('!', "-.-.--"), ('/', "-..-."), ('(', "-.--."), (')', "-.--.-"),
        ('&', ".-..."), (':', "---..."), (';', "-.-.-."), ('=', "-...-"),
        ('+', ".-.-."), ('-', "-....-"), ('_', "..--.-"), ('"', ".-..-."),
        ('$', "...-..-"), ('@', ".--.-."), (' ', "/"),
    ];
    for (ch, code) in entries {
        table.insert(ch, code);
    }
    table
}

fn ascii_to_morse(c: char) -> String {
    let mut bits = String::from("..--");
    let val = c as u8;
    for i in (0..7).rev() {
        bits.push(if val & (1 << i) != 0 { '-' } else { '.' });
    }
    bits
}

fn encode_char(c: char, table: &HashMap<char, &str>) -> String {
    let upper = c.to_ascii_uppercase();
    table.get(&upper).map(|&s| s.to_string()).unwrap_or_else(|| ascii_to_morse(c))
}

fn encode(text: &str, table: &HashMap<char, &str>) -> String {
    text.chars()
        .map(|c| encode_char(c, table))
        .collect::<Vec<_>>()
        .join("|")
}

fn decode_custom(code: &str) -> char {
    if !code.starts_with("..--") {
        return '?';
    }
    let mut val = 0u8;
    for c in code.chars().skip(4) {
        val <<= 1;
        if c == '-' {
            val |= 1;
        }
    }
    val as char
}

fn decode_char(code: &str, table: &HashMap<char, &str>) -> char {
    for (ch, morse) in table {
        if *morse == code {
            return *ch;
        }
    }
    decode_custom(code)
}

fn decode(morse: &str, table: &HashMap<char, &str>) -> String {
    morse.split('|')
        .map(|code| decode_char(code, table))
        .collect()
}

fn assert_equal(label: &str, expected: &str, actual: &str) {
    if expected == actual {
        println!("[PASS] {}", label);
    } else {
        println!("[FAIL] {}", label);
        println!("  Expected: \"{}\"", expected);
        println!("  Actual:   \"{}\"", actual);
    }
}

fn run_tests(table: &HashMap<char, &str>) {
    assert_equal("Encode HELLO", "....|.|.-..|.-..|---", &encode("HELLO", table));
    assert_equal("Decode HELLO", "HELLO", &decode("....|.|.-..|.-..|---", table));
    assert_equal("Round-trip Test 123!", "TEST 123!", &decode(&encode("Test 123!", table), table));
    assert_equal("Unknown ASCII 1", &String::from_utf8_lossy(&[1]), &decode(&encode(&String::from_utf8_lossy(&[1]), table), table));
    assert_equal("Full sentence", "ADDRESS: 154 PENSILVILLE - ON, CA", &decode(&encode("Address: 154 Pensilville - ON, CA", table), table));
}

fn main() {
    let table = build_morse_table();
    run_tests(&table);

    println!("\nEnter a string to encode in Morse code:");
    let mut input = String::new();
    io::stdout().flush().unwrap();
    io::stdin().read_line(&mut input).unwrap();
    let input = input.trim();

    let encoded = encode(input, &table);
    let decoded = decode(&encoded, &table);

    println!("\nEncoded Morse:\n{}", encoded);
    println!("\nDecoded Text:\n{}", decoded);
}
