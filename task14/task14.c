#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE 10000000

// Function to calculate sum using standard C
long long sum_c(int* arr, int size) {
    long long sum = 0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return sum;
}

// Function to calculate sum using inline assembly
long long sum_asm(int* arr, int size) {
    long long sum = 0;
    __asm__ __volatile__ (
        "xor %%rax, %%rax\n\t"  // Clear RAX (our sum)
        "xor %%rcx, %%rcx\n\t"  // Clear RCX (our counter)
        "1:\n\t"                // Start of loop
        "add (%1,%%rcx,4), %%eax\n\t"  // Add current array element to sum
        "inc %%rcx\n\t"         // Increment counter
        "cmp %2, %%rcx\n\t"     // Compare counter with size
        "jl 1b\n\t"             // Jump back to start of loop if counter < size
        : "=a" (sum)            // Output: sum in RAX
        : "r" (arr), "r" ((long long)size)  // Inputs: array pointer and size
        : "rcx"                 // Clobbered register
    );
    return sum;
}

int main() {
    // Allocate memory for the array
    int* arr = (int*)malloc(ARRAY_SIZE * sizeof(int));
    if (arr == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }

    // Initialize array with random values
    srand(time(NULL));
    for (int i = 0; i < ARRAY_SIZE; i++) {
        arr[i] = rand() % 100;  // Random values between 0 and 99
    }

    // Measure time for C function
    clock_t start = clock();
    long long sum_result_c = sum_c(arr, ARRAY_SIZE);
    clock_t end = clock();
    double time_c = ((double) (end - start)) / CLOCKS_PER_SEC;

    // Measure time for ASM function
    start = clock();
    long long sum_result_asm = sum_asm(arr, ARRAY_SIZE);
    end = clock();
    double time_asm = ((double) (end - start)) / CLOCKS_PER_SEC;

    // Print results
    printf("Sum (C): %lld\n", sum_result_c);
    printf("Sum (ASM): %lld\n", sum_result_asm);
    printf("Time (C): %f seconds\n", time_c);
    printf("Time (ASM): %f seconds\n", time_asm);
    printf("Speedup: %f%%\n", (time_c - time_asm) / time_c * 100);

    // Free allocated memory
    free(arr);

    return 0;
}