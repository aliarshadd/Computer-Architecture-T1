main:
    li   x10, 5
    jal  ra, fact_recursive
    li   x17, 1                 # Changed x11 -> x17 (Print Integer)
    ecall

    li   x10, 6
    jal  ra, fact_iterative
    li   x17, 1                 # Changed x11 -> x17 (Print Integer)
    ecall

    li   x17, 10                # Changed x11 -> x17 (Exit Program)
    ecall

fact_recursive:
    addi sp, sp, -8
    sw   x1, 4(sp)
    sw   x10, 0(sp)

    addi x5, x10, -1
    bge  x5, x0, L1

    addi x10, x0, 1
    addi sp, sp, 8
    jalr x0, 0(x1)

L1:
    addi x10, x10, -1
    jal  x1, fact_recursive

    addi x6, x10, 0
    lw   x10, 0(sp)
    lw   x1, 4(sp)
    addi sp, sp, 8

    mul  x10, x10, x6
    jalr x0, 0(x1)

fact_iterative:
    addi x2, x0, 1

loop:
    ble  x10, x0, exit
    mul  x2, x2, x10
    addi x10, x10, -1
    jal  x0, loop

exit:
    addi x10, x2, 0
    jalr x0, 0(x1)