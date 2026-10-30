 .text 
        .globl _start 
_start: 
        addi sp, zero, 240           
        addi s0, zero, 256           
        addi s1, zero, 512           
        addi s2, zero, 768          
 
reset_state:                        
        sw   zero, 0(s0)            
        addi s3, zero, 0            
        addi s4, zero, 0             
fsm_loop:                            
        lw   t0, 0(s2)              
        bne  t0, zero, reset_state   
        beq  s3, zero, state_wait    
        jal  zero, state_count       
 
state_wait:                         
        lw   s4, 0(s1)              
        beq  s4, zero, fsm_loop     
        sw   s4, 0(s0)              
        addi s3, zero, 1             
        jal  zero, fsm_loop 
 
state_count:                       
        addi a0, s4, 0              
        jal  ra, countdown           
        jal  zero, reset_state  
countdown: 
        addi sp, sp, -16             
        sw   ra, 12(sp)              
        sw   s5, 8(sp)             
        addi s5, a0, 0              
cd_loop: 
        sw   s5, 0(s0)             
        beq  s5, zero, cd_done      
        jal  ra, delay               
        bne  a0, zero, cd_exit       
        addi s5, s5, -1            
        jal  zero, cd_loop 
cd_done: 
        addi a0, zero, 0            
cd_exit: 
        lw   ra, 12(sp)
        lw   s5, 8(sp)               
        addi sp, sp, 16             
        jalr zero, 0(ra)            
delay: 
        addi sp, sp, -16 
        sw   s6, 12(sp) 
        sw   s7, 8(sp) 
        addi s6, zero, 1000         
dl_outer: 
        addi s7, zero, 1250          
dl_inner: 
        lw   t0, 0(s2)               
        bne  t0, zero, dl_reset 
        addi s7, s7, -1 
        bne  s7, zero, dl_inner 
        addi s6, s6, -1 
        bne  s6, zero, dl_outer 
        addi a0, zero, 0            
        jal  zero, dl_exit 
dl_reset: 
        addi a0, zero, 1             
dl_exit: 
        lw   s6, 12(sp) 
        lw   s7, 8(sp) 
        addi sp, sp, 16 
        jalr zero, 0(ra) 