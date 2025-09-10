# Convert Float32 to IEEE-754 binary string
function ieee754_to_bin(num::Float32)::String
    bits = reinterpret(UInt32, num)  # view the float's bits as UInt32
    bin_chars = Vector{Char}(undef, 32)
    for i in 31:-1:0
        bin_chars[32 - i] = ((bits >> i) & 0x1) == 1 ? '1' : '0'
    end
    return String(bin_chars)
end

# Convert IEEE-754 binary string to Float32
function bin_to_ieee754(binstr::AbstractString)::Float32
    if length(binstr) != 32
        error("Binary string must be 32 bits.")
    end
    bits::UInt32 = 0
    for (i, ch) in enumerate(binstr)
        if ch == '1'
            bits |= UInt32(1) << (32 - i)
        elseif ch != '0'
            error("Invalid character in binary string.")
        end
    end
    return reinterpret(Float32, bits)
end

# Main-like function
function main()
    if length(ARGS) != 1
        println("Usage: julia script.jl <float_number>")
        exit(1)
    end

    # Parse input as Float32
    input = parse(Float32, ARGS[1])

    # Convert float to binary string
    binary = ieee754_to_bin(input)
    @printf("IEEE-754 binary of %.6f: %s\n", input, binary)

    # Convert binary string back to float
    recovered = bin_to_ieee754(binary)
    @printf("Recovered float from binary: %.6f\n", recovered)
end

# Run if script is executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
