li x1, 10
li x2, 0x200
#first Loop: a[i] = i
li x22, 0
loop1:
    bge x22, x1, end

    slli x5, x22, 2
    add x6, x2, x5

    Sw x22, 0(x6)

    addi x22, x22, 1
    j loop1
end:
#second Loop: sum = sum + a[i]
li x22, 0
li x23, 0
loop2:
    bge x22, x1, 2end

    slli x5, x22, 2
    add x6, x2, x5

    1w x8, 0(x6)
    add x23, x23, x8

    addi x22, x22, 1
    j loop2

2end: