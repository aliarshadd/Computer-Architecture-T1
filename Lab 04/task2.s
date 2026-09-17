.text
.globl main
main:
    addi x10, x5, 5 #num declared here as num = 5 
    jal x1, ntri
exit: 
    beq x0,x0, exit
ntri:
    addi x5,x0,1
    bge x5,x10,base
    addi x2,x2,-8
    sw x1,4(x2)
    sw x10,0(x2)
    addi x10,x10,-1
    jal x1,ntri
    lw x5,0(x2)
    lw x1,4(x2)
    addi x2,x2,8
    add x10,x5,x10
    jalr x0,0(x1)
base:
    addi x10, x0,1
    jalr x0,0(x1)