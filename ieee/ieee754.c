#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// Convert float to IEEE-754 binary string
char* ieee754tobin(float num) {
    // Allocate space for 33 characters (32 bits + null terminator)
    char* binStr = (char*)malloc(33);
    if (!binStr) return NULL;

    // Use a union to access float bits
    union {
        float f;
        uint32_t u;
    } converter;

    converter.f = num;
	int i = 0;
    for (i = 31; i >= 0; i--) {
        binStr[31 - i] = ((converter.u >> i) & 1) ? '1' : '0';
    }
    binStr[32] = '\0';
    return binStr;
}

// Convert IEEE-754 binary string to float
float bintoieee754(const char* binStr) {
    if (strlen(binStr) != 32) {
        fprintf(stderr, "Error: Binary string must be 32 bits.\n");
        return 0.0f;
    }

    union {
        uint32_t u;
        float f;
    } converter;

    converter.u = 0;
	int i = 0;
    for (i = 0; i < 32; i++) {
        if (binStr[i] == '1') {
            converter.u |= (1U << (31 - i));
        } else if (binStr[i] != '0') {
            fprintf(stderr, "Error: Invalid character in binary string.\n");
            return 0.0f;
        }
    }

    return converter.f;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <float_number>\n", argv[0]);
        return 1;
    }

    float input = atof(argv[1]);

    // Convert float to binary string
    char* binary = ieee754tobin(input);
    if (!binary) {
        fprintf(stderr, "Memory allocation failed.\n");
        return 1;
    }

    printf("IEEE-754 binary of %.6f: %s\n", input, binary);

    // Convert binary string back to float
    float recovered = bintoieee754(binary);
    printf("Recovered float from binary: %.6f\n", recovered);

    free(binary);
    return 0;
}
