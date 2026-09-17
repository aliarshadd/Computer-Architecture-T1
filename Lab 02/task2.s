li x10, 0
li x1,1
li x2,2
li x3,3
li x4,4
li x9, 2
li x6, 2
li x7,3
beq x10,x1,Case1
beq x10,x2, Case2
beq x10,x3,Case3
beq x10,x4,Case4
beq x0,x0,default

Case1:
    add x5,x6,X7
    beq x0,x0,Exit
Case2:
    sub x5,x6,x7
    beq x0,x0, Exit
Case3:
    add x5,x6,x6
    beq x0,x0,Exit
Case4:
    div x5,x6,x9
    beq x0,x0,Exit
default:
    li x5,0
    beq x0,x0,Exit
Exit: