.text
.globl main

main:
    li   x10, 6              
    jal  x1, fact       
    addi x11, x10, 0            
    li   x10, 1             
    ecall
    li   x10, 10            
    ecall
fact:
    li x5, 1               
while:
    blez x10, end      
    mul  x5, x5, x10        
    addi x10, x10, -1       
    j    while          
end:
    addi x10, x5, 0             
    jalr x0, 0(x1)           