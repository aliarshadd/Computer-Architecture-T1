li x7, 0
li x5, 1 #testing value of a = x5 = 1
li x6, 2 #testing value of b = x6 = 2
first_loop:
    li x29, 0
    bge x7, x5, exit
    bge x29, x6, next_iteration

second_loop:
    add x2, x7, x29
    slli x3, x29, 4
    add x3, x3, x10
    sw X2, 0x00(x3)

    addi x29, x29, 1
    blt x29, x6, second_loop

next_iteration:
    addi x7, x7, 1
    beq x0, x0, first_loop

exit:
add x0, x0, x0