.data
array: .word 3, 1, 4, 5, 2, 9

.text
.globl main

main:
    la x10, array
    addi x11, x0, 6
    jal x1, bubble

    la x8, array
    addi x6, x0, 0
    addi x7, x0, 6

print_loop:
    bge x6, x7, finish

    lw x12, 0(x8)

    addi x10, x0, 1
    add x11, x12, x0
    ecall

    addi x10, x0, 11
    addi x11, x0, 32
    ecall

    addi x8, x8, 4
    addi x6, x6, 1

    beq x0, x0, print_loop

finish:
    addi x10, x0, 10
    ecall

bubble:
    beq x10, x0, bubble_exit
    beq x11, x0, bubble_exit

    addi x5, x0, 0

loop1:
    bgeu x5, x11, bubble_exit
    add x6, x0, x5

loop2:
    bgeu x6, x11, next_i

    slli x7, x5, 2
    add x7, x10, x7
    lw x28, 0(x7)

    slli x29, x6, 2
    add x29, x10, x29
    lw x30, 0(x29)

    bge x28, x30, no_swap

    add x31, x28, x0
    sw x30, 0(x7)
    sw x31, 0(x29)

no_swap:
    addi x6, x6, 1
    beq x0, x0, loop2

next_i:
    addi x5, x5, 1
    beq x0, x0, loop1

bubble_exit:
    jalr x0, 0(x1)