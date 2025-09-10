# Convert float (numeric) to IEEE-754 binary string (32-bit)
ieee754_to_bin <- function(num) {
  # Force to single precision (float32)
  raw_bytes <- writeBin(as.single(num), raw(), size = 4, endian = "big")
  # Convert each byte to bits
  bits <- sapply(raw_bytes, function(b) {
    paste0(rev(as.integer(intToBits(as.integer(b)))), collapse = "")
  })
  paste0(bits, collapse = "")
}

# Convert IEEE-754 binary string to float
bin_to_ieee754 <- function(bin_str) {
  if (nchar(bin_str) != 32) {
    stop("Binary string must be 32 bits.")
  }
  if (grepl("[^01]", bin_str)) {
    stop("Invalid character in binary string.")
  }
  # Split into 4 bytes
  bytes <- sapply(0:3, function(i) {
    byte_bits <- substr(bin_str, i*8 + 1, i*8 + 8)
    # Convert bits to integer
    sum(as.integer(strsplit(byte_bits, "")[[1]]) * 2^(7:0))
  })
  raw_bytes <- as.raw(bytes)
  # Read as float32
  readBin(raw_bytes, what = "single", size = 4, endian = "big")
}

# Main-like execution
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1) {
  cat(sprintf("Usage: Rscript %s <float_number>\n", basename(sys.frame(1)$ofile %||% "script.R")))
  quit(status = 1)
}

input <- as.numeric(args[1])

# Convert float to binary
binary <- ieee754_to_bin(input)
cat(sprintf("IEEE-754 binary of %.6f: %s\n", input, binary))

# Convert binary back to float
recovered <- bin_to_ieee754(binary)
cat(sprintf("Recovered float from binary: %.6f\n", recovered))
