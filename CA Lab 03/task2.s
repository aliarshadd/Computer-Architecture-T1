li x10 ,10  #g
li x11 ,20  #h
li x12 ,30  #i
li x13 ,40  #j 
li x14, 0 
jal x1, leaf_example
add a1, a0, x0        
li a0, 1            
ecall
li a7, 10
ecall 
beq x0,x0,exit
leaf_example:
    addi sp, sp, -16    
    sw s0, 0(sp)        
    sw s1, 4(sp)        
    add x14,x10,x11 #g+h
    add x15, x12, x13 #i+j
    sub x16, x14,x15 # f = (g+h) - (i+j)
    lw s0, 0(sp)        
    lw s1, 4(sp)        
    addi sp, sp, 16 
    jalr x0, 0(x1)
exit:
