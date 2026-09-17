.text
.globl main
main:
addi x1,x0,5
addi x2,x0,0
addi x1,x2,32
add x3,x1,x2
addi x4,x3,-5 #d = a+b - 5
sub x5,x1,x4
sub x6,x2,x1
add x7,x5,x6
add x8,x7,x4
add x9,x3,x4
add x10,x9,x8
end: 
    j end