#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_LEN 2048

typedef struct {
    char ch;
    const char *morse;
} MorseMap;

MorseMap standard_table[] = {
    {'A', ".-"}, 		{'B', "-..."}, 		{'C', "-.-."},		{'D', "-.."},		{'E', "."},
	{'F', "..-."}, 		{'G', "--."}, 		{'H', "...."},		{'I', ".."},		{'J', ".---"},
	{'K', "-.-"}, 		{'L', ".-.."},		{'M', "--"},		{'N', "-."},		{'O', "---"},
	{'P', ".--."},		{'Q', "--.-"},		{'R', ".-."},		{'S', "..."},		{'T', "-"},
    {'U', "..-"}, 		{'V', "...-"}, 		{'W', ".--"}, 		{'X', "-..-"},		{'Y', "-.--"},
	{'Z', "--.."},		{'0', "-----"},		{'1', ".----"},		{'2', "..---"},		{'3', "...--"},
    {'4', "....-"}, 	{'5', "....."},		{'6', "-...."}, 	{'7', "--..."},		{'8', "---.."},
	{'9', "----."},		{'.', ".-.-.-"},	{',', "--..--"},	{'?', "..--.."},	{'\'', ".----."},
    {'!', "-.-.--"},	{'/', "-..-."},		{'(', "-.--."},		{')', "-.--.-"},	{'&', ".-..."},
	{':', "---..."}, 	{';', "-.-.-."}, 	{'=', "-...-"},		{'+', ".-.-."},		{'-', "-....-"},
	{'_', "..--.-"}, 	{'"', ".-..-."},	{'$', "...-..-"}, 	{'@', ".--.-."}, 	{' ', "/"},
	{'\0', NULL}
};

void ascii_to_morse(int ascii, char *buffer) {
    int i;
    strcpy(buffer, "..--");
    for (i = 6; i >= 0; i--) {
        strcat(buffer, (ascii & (1 << i)) ? "-" : ".");
    }
}

const char* encode_char(char c, char *custom_buf) {
    int i;
    for (i = 0; standard_table[i].morse != NULL; i++) {
        if (standard_table[i].ch == c)
            return standard_table[i].morse;
    }
    ascii_to_morse((unsigned char)c, custom_buf);
    return custom_buf;
}

void encode(const char *text, char *output) {
    int i;
    char temp[16];
    output[0] = '\0';
    for (i = 0; text[i] != '\0'; i++) {
        const char *code = encode_char(text[i], temp);
        strcat(output, code);
        strcat(output, "|");
    }
}

char decode_custom(const char *code) {
    if (strncmp(code, "..--", 4) != 0)
        return '?';
    int val = 0;
    for (int i = 4; i < strlen(code); i++) {
        val <<= 1;
        if (code[i] == '-')
            val |= 1;
    }
    return (char)val;
}

char decode_char(const char *code) {
    int i;
    for (i = 0; standard_table[i].morse != NULL; i++) {
        if (strcmp(standard_table[i].morse, code) == 0)
            return standard_table[i].ch;
    }
    return decode_custom(code);
}

void decode(const char *morse, char *output) {
    char buffer[32];
    int i = 0, j = 0, k = 0;
    while (morse[i] != '\0') {
        if (morse[i] == '|') {
            buffer[k] = '\0';
            output[j++] = decode_char(buffer);
            k = 0;
        } else {
            buffer[k++] = morse[i];
        }
        i++;
    }
    output[j] = '\0';
}

void assert_equal(const char *label, const char *expected, const char *actual) {
    if (strcmp(expected, actual) == 0) {
        printf("[PASS] %s\n", label);
    } else {
        printf("[FAIL] %s\n  Expected: %s\n  Actual:   %s\n", label, expected, actual);
    }
}

void run_tests() {
    char encoded[MAX_LEN];
    char decoded[MAX_LEN];

    // Test 1: Basic encoding
    encode("HELLO", encoded);
    assert_equal("Encode HELLO", "....|.|.-..|.-..|---|", encoded);

    // Test 2: Basic decoding
    decode("....|.|.-..|.-..|---|", decoded);
    assert_equal("Decode Morse HELLO", "HELLO", decoded);

    // Test 3: Round-trip
    encode("Test 123!", encoded);
    decode(encoded, decoded);
    assert_equal("Round-trip Test 123!", "TEST 123!", decoded);

    // Test 4: Unknown character
    encode("\x01", encoded); // ASCII 1
    decode(encoded, decoded);
    assert_equal("Unknown ASCII 1", "\x01", decoded);

    // Test 5: Full sentence
    encode("Address: 154 Pensilville - ON, CA", encoded);
    decode(encoded, decoded);
    assert_equal("Full sentence", "ADDRESS: 154 PENSILVILLE - ON, CA", decoded);
}

int main() {
    run_tests();

    // Optional: interactive mode
    char input[MAX_LEN];
    char encoded[MAX_LEN];
    char decoded[MAX_LEN];

    printf("\nEnter a string to encode in Morse code:\n");
    fgets(input, MAX_LEN, stdin);

    size_t len = strlen(input);
    if (len > 0 && input[len - 1] == '\n')
        input[len - 1] = '\0';

    encode(input, encoded);
    printf("\nEncoded Morse:\n%s\n", encoded);

    decode(encoded, decoded);
    printf("\nDecoded Text:\n%s\n", decoded);

    return 0;
}
