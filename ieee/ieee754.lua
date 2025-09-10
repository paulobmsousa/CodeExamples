-- Convert float (number) to IEEE-754 binary string (32-bit)
function ieee754_to_bin(num)
    -- Pack the float into 4 bytes (big-endian)
    local packed = string.pack(">f", num)
    -- Unpack those bytes as an unsigned 32-bit integer
    local bits = string.unpack(">I4", packed)

    local bin = {}
    for i = 31, 0, -1 do
        table.insert(bin, ((bits >> i) & 1) == 1 and "1" or "0")
    end
    return table.concat(bin)
end

-- Convert IEEE-754 binary string to float
function bin_to_ieee754(binstr)
    if #binstr ~= 32 then
        error("Binary string must be 32 bits.")
    end

    local bits = 0
    for i = 1, 32 do
        local ch = binstr:sub(i, i)
        if ch == "1" then
            bits = bits | (1 << (32 - i))
        elseif ch ~= "0" then
            error("Invalid character in binary string.")
        end
    end

    -- Pack bits as unsigned int, then unpack as float
    local packed = string.pack(">I4", bits)
    return string.unpack(">f", packed)
end

-- Main-like function
local function main()
    if #arg ~= 1 then
        print(string.format("Usage: lua %s <float_number>", arg[0]))
        os.exit(1)
    end

    local input = tonumber(arg[1])
    if not input then
        io.stderr:write("Invalid float number.\n")
        os.exit(1)
    end

    -- Convert float to binary
    local binary = ieee754_to_bin(input)
    print(string.format("IEEE-754 binary of %.6f: %s", input, binary))

    -- Convert binary back to float
    local recovered = bin_to_ieee754(binary)
    print(string.format("Recovered float from binary: %.6f", recovered))
end

main()
