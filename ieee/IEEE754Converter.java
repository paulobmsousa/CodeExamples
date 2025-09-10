public class IEEE754Converter {

    // Convert float to IEEE-754 binary string
    public static String ieee754ToBin(float num) {
        int bits = Float.floatToIntBits(num);
        StringBuilder sb = new StringBuilder(32);
        for (int i = 31; i >= 0; i--) {
            sb.append(((bits >> i) & 1) == 1 ? '1' : '0');
        }
        return sb.toString();
    }

    // Convert IEEE-754 binary string to float
    public static float binToIEEE754(String binStr) {
        if (binStr.length() != 32) {
            throw new IllegalArgumentException("Binary string must be 32 bits.");
        }
        int bits = 0;
        for (int i = 0; i < 32; i++) {
            char ch = binStr.charAt(i);
            if (ch == '1') {
                bits |= (1 << (31 - i));
            } else if (ch != '0') {
                throw new IllegalArgumentException("Invalid character in binary string.");
            }
        }
        return Float.intBitsToFloat(bits);
    }

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.printf("Usage: java %s <float_number>%n", IEEE754Converter.class.getSimpleName());
            System.exit(1);
        }

        float input;
        try {
            input = Float.parseFloat(args[0]);
        } catch (NumberFormatException e) {
            System.err.println("Invalid float number.");
            System.exit(1);
            return; // unreachable, but keeps compiler happy
        }

        // Convert float to binary
        String binary = ieee754ToBin(input);
        System.out.printf("IEEE-754 binary of %.6f: %s%n", input, binary);

        // Convert binary back to float
        float recovered = binToIEEE754(binary);
        System.out.printf("Recovered float from binary: %.6f%n", recovered);
    }
}
