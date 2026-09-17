.data
marks:
    .word 70, 85, 40, 92, 55
.text
.globl main
main:
    la x10, marks
    li x11, 5
    jal x1, analyzeMarks
    li x17, 10
    ecall
analyzeMarks:
    addi x2, x2, -16
    sw x1, 12(x2)      
    sw x8, 8(x2)       
    sw x9, 4(x2)       
    sw x18, 0(x2)      
    mv x8, x10         
    mv x9, x11         
    mv x10, x8
    mv x11, x9
    jal x1, calculateSum
    mv x18, x10       
    mv x10, x8
    mv x11, x9
    jal x1, findMaximum
    mv x19, x10       
    mv x10, x8
    mv x11, x9
    li x12, 50         
    jal x1, countPassing
    mv x12, x10      
    mv x10, x18        
    mv x11, x19        
    lw x18, 0(x2)
    lw x9, 4(x2)
    lw x8, 8(x2)
    lw x1, 12(x2)
    addi x2, x2, 16
    jalr x0, 0(x1)
calculateSum:
    li x5, 0          
    li x6, 0          
sum_loop:
    bge x5, x11, sum_done
    slli x7, x5, 2     
    add x28, x10, x7   
    lw x29, 0(x28)     
    add x6, x6, x29
    addi x5, x5, 1
    j sum_loop
sum_done:
    mv x10, x6
    jalr x0, 0(x1)
findMaximum:
    lw x6, 0(x10)
    li x5, 1           
max_loop:
    bge x5, x11, max_done
    slli x7, x5, 2
    add x28, x10, x7
    lw x29, 0(x28)
    bge x6, x29, max_skip
    mv x6, x29
max_skip:
    addi x5, x5, 1
    j max_loop
max_done:
    mv x10, x6
    jalr x0, 0(x1)
countPassing:
    li x5, 0           
    li x6, 0           
passing_loop:
    bge x5, x11, passing_done
    slli x7, x5, 2
    add x28, x10, x7
    lw x29, 0(x28)
    blt x29, x12, not_pass
    addi x6, x6, 1
not_pass:
    addi x5, x5, 1
    j passing_loop
passing_done:
    mv x10, x6
    jalr x0, 0(x1)