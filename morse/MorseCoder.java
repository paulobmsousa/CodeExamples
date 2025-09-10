import java.util.*;

public class MorseCoder {
    private static final Map<Character, String> morseTable = new HashMap<>();

    static {
        String[][] base = {
            {"A", ".-"}, {"B", "-..."}, {"C", "-.-."}, {"D", "-.."},
            {"E", "."}, {"F", "..-."}, {"G", "--."}, {"H", "...."},
            {"I", ".."}, {"J", ".---"}, {"K", "-.-"}, {"L", ".-.."},
            {"M", "--"}, {"N", "-."}, {"O", "---"}, {"P", ".--."},
            {"Q", "--.-"}, {"R", ".-."}, {"S", "..."}, {"T", "-"},
            {"U", "..-"}, {"V", "...-"}, {"W", ".--"}, {"X", "-..-"},
            {"Y", "-.--"}, {"Z", "--.."},
            {"0", "-----"}, {"1", ".----"}, {"2", "..---"}, {"3", "...--"},
            {"4", "....-"}, {"5", "....."}, {"6", "-...."}, {"7", "--..."},
            {"8", "---.."}, {"9", "----."},
            {".", ".-.-.-"}, {",", "--..--"}, {"?", "..--.."}, {"'", ".----."},
            {"!", "-.-.--"}, {"/", "-..-."}, {"(", "-.--."}, {")", "-.--.-"},
            {"&", ".-..."}, {":", "---..."}, {";", "-.-.-."}, {"=", "-...-"},
            {"+", ".-.-."}, {"-", "-....-"}, {"_", "..--.-"}, {"\"", ".-..-."},
            {"$", "...-..-"}, {"@", ".--.-."}, {" ", "/"}
        };
        for (String[] pair : base) {
            morseTable.put(pair[0].charAt(0), pair[1]);
        }
    }

    public static String asciiToMorse(int ascii) {
        StringBuilder sb = new StringBuilder("..--");
        for (int i = 6; i >= 0; i--) {
            sb.append((ascii & (1 << i)) != 0 ? "-" : ".");
        }
        return sb.toString();
    }

    public static String encodeChar(char c) {
        char upper = Character.toUpperCase(c);
        return morseTable.getOrDefault(upper, asciiToMorse((int) c));
    }

    public static String encode(String text) {
        StringBuilder sb = new StringBuilder();
        for (char c : text.toCharArray()) {
            sb.append(encodeChar(c)).append("|");
        }
        return sb.toString();
    }

    public static char decodeCustom(String code) {
        if (!code.startsWith("..--")) return '?';
        int val = 0;
        for (int i = 4; i < code.length(); i++) {
            val <<= 1;
            if (code.charAt(i) == '-') val |= 1;
        }
        return (char) val;
    }

    public static char decodeChar(String code) {
        for (Map.Entry<Character, String> entry : morseTable.entrySet()) {
            if (entry.getValue().equals(code)) return entry.getKey();
        }
        return decodeCustom(code);
    }

    public static String decode(String morse) {
        String[] parts = morse.split("\\|");
        StringBuilder sb = new StringBuilder();
        for (String part : parts) {
            sb.append(decodeChar(part));
        }
        return sb.toString();
    }

    public static void assertEqual(String label, String expected, String actual) {
        if (expected.equals(actual)) {
            System.out.println("[PASS] " + label);
        } else {
            System.out.println("[FAIL] " + label);
            System.out.println("  Expected: " + expected);
            System.out.println("  Actual:   " + actual);
        }
    }

    public static void runTests() {
        assertEqual("Encode HELLO", "....|.|.-..|.-..|---|", encode("HELLO"));
        assertEqual("Decode HELLO", "HELLO", decode("....|.|.-..|.-..|---|"));
        assertEqual("Round-trip Test 123!", "TEST 123!", decode(encode("Test 123!")));
        assertEqual("Unknown ASCII 1", String.valueOf((char) 1), decode(encode(String.valueOf((char) 1))));
        assertEqual("Full sentence", "ADDRESS: 154 PENSILVILLE - ON, CA", decode(encode("Address: 154 Pensilville - ON, CA")));
    }

    public static void main(String[] args) {
        runTests();

        Scanner scanner = new Scanner(System.in);
        System.out.println("\nEnter a string to encode in Morse code:");
        String input = scanner.nextLine();

        String encoded = encode(input);
        String decoded = decode(encoded);

        System.out.println("\nEncoded Morse:");
        System.out.println(encoded);
        System.out.println("\nDecoded Text:");
        System.out.println(decoded);
    }
}
