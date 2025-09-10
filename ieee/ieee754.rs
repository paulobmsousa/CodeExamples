use std::env;
use std::process;

// Convert f32 to IEEE-754 binary string
fn ieee754_to_bin(num: f32) -> String {
    let bits = num.to_bits(); // u32 representation
    let mut bin_str = String::with_capacity(32);
    for i in (0..32).rev() {
        if (bits >> i) & 1 == 1 {
            bin_str.push('1');
        } else {
            bin_str.push('0');
        }
    }
    bin_str
}

// Convert IEEE-754 binary string to f32
fn bin_to_ieee754(bin_str: &str) -> Result<f32, String> {
    if bin_str.len() != 32 {
        return Err("Binary string must be 32 bits.".to_string());
    }

    let mut bits: u32 = 0;
    for (i, ch) in bin_str.chars().enumerate() {
        match ch {
            '1' => bits |= 1 << (31 - i),
            '0' => {}
            _ => return Err("Invalid character in binary string.".to_string()),
        }
    }

    Ok(f32::from_bits(bits))
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: {} <float_number>", args[0]);
        process::exit(1);
    }

    let input: f32 = match args[1].parse() {
        Ok(num) => num,
        Err(_) => {
            eprintln!("Invalid float number.");
            process::exit(1);
        }
    };

    // Convert float to binary
    let binary = ieee754_to_bin(input);
    println!("IEEE-754 binary of {:.6}: {}", input, binary);

    // Convert binary back to float
    match bin_to_ieee754(&binary) {
        Ok(recovered) => println!("Recovered float from binary: {:.6}", recovered),
        Err(err) => {
            eprintln!("Error: {}", err);
            process::exit(1);
        }
    }
}
