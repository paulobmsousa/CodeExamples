# Morse table for standard characters
morse_table <- list(
  A = ".-", B = "-...", C = "-.-.", D = "-..",
  E = ".", F = "..-.", G = "--.", H = "....",
  I = "..", J = ".---", K = "-.-", L = ".-..",
  M = "--", N = "-.", O = "---", P = ".--.",
  Q = "--.-", R = ".-.", S = "...", T = "-",
  U = "..-", V = "...-", W = ".--", X = "-..-",
  Y = "-.--", Z = "--..",
  `0` = "-----", `1` = ".----", `2` = "..---", `3` = "...--",
  `4` = "....-", `5` = ".....", `6` = "-....", `7` = "--...",
  `8` = "---..", `9` = "----.",
  `.` = ".-.-.-", `,` = "--..--", `?` = "..--..", `'` = ".----.",
  `!` = "-.-.--", `/` = "-..-.", `(` = "-.--.", `)` = "-.--.-",
  `&` = ".-...", `:` = "---...", `;` = "-.-.-.", `=` = "-...-",
  `+` = ".-.-.", `-` = "-....-", `_` = "..--.-", `"` = ".-..-.",
  `$` = "...-..-", `@` = ".--.-.", ` ` = "/"
)

# Convert ASCII value to Morse-style binary
ascii_to_morse <- function(char) {
  val <- as.integer(charToRaw(char))
  bits <- "..--"
  for (i in 6:0) {
    bits <- paste0(bits, ifelse(bitwAnd(val, bitwShiftL(1, i)) != 0, "-", "."))
  }
  bits
}

# Encode a single character
encode_char <- function(char) {
  upper <- toupper(char)
  if (!is.null(morse_table[[upper]])) {
    return(morse_table[[upper]])
  } else {
    return(ascii_to_morse(char))
  }
}

# Encode a full string
encode <- function(text) {
  chars <- strsplit(text, "")[[1]]
  paste(sapply(chars, encode_char), collapse = "|")
}

# Decode custom Morse escape
decode_custom <- function(code) {
  if (!startsWith(code, "..--")) return("?")
  val <- 0
  for (c in strsplit(substr(code, 5, nchar(code)), "")[[1]]) {
    val <- bitwShiftL(val, 1)
    if (c == "-") val <- bitwOr(val, 1)
  }
  rawToChar(as.raw(val))
}

# Decode a single Morse symbol
decode_char <- function(code) {
  for (key in names(morse_table)) {
    if (morse_table[[key]] == code) return(key)
  }
  decode_custom(code)
}

# Decode a full Morse string
decode <- function(morse) {
  codes <- strsplit(morse, "\\|")[[1]]
  paste(sapply(codes, decode_char), collapse = "")
}

# Simulated unit test
assert_equal <- function(label, expected, actual) {
  if (expected == actual) {
    cat("[PASS]", label, "\n")
  } else {
    cat("[FAIL]", label, "\n")
    cat("  Expected:", expected, "\n")
    cat("  Actual:  ", actual, "\n")
  }
}

run_tests <- function() {
  assert_equal("Encode HELLO", "....|.|.-..|.-..|---", encode("HELLO"))
  assert_equal("Decode HELLO", "HELLO", decode("....|.|.-..|.-..|---"))
  assert_equal("Round-trip Test 123!", "TEST 123!", decode(encode("Test 123!")))
  assert_equal("Unknown ASCII 1", rawToChar(as.raw(1)), decode(encode(rawToChar(as.raw(1)))))
  assert_equal("Full sentence", "ADDRESS: 154 PENSILVILLE - ON, CA", decode(encode("Address: 154 Pensilville - ON, CA")))
}

# Main program
run_tests()
cat("\nEnter a string to encode in Morse code:\n")
input <- readline()
encoded <- encode(input)
decoded <- decode(encoded)

cat("\nEncoded Morse:\n", encoded, "\n")
cat("\nDecoded Text:\n", decoded, "\n")
