.data
	str_m: .asciiz "Enter m: "
	str_n: .asciiz "Enter n: "
	str_print: .asciiz "Pythagorian triple: "
	m: .word 0
	n: .word 0
	a: .word 0
	b: .word 0
	c: .word 0
	triple: .word 0

.text

# def create_triple(m,n):
    # a = (m ** 2) - (n ** 2)
    # if a < 0:
        # a = 0 - a
    # b = 2 * m * n
    # c = (m ** 2) + (n ** 2)
    # return(a,b,c)


# if __name__ == "__main__":
    # m = int(input("Enter m: "))
    # n = int(input("Enter n: "))
    # triple = create_triple(m, n)
    # print("Pythagorian triple: " + str(triple))
    
    lw $t0, m
    addi $t1, $0, 2
    mul $t2, $t0, $t1			# To find the value of a
    mul $t3, $t2, $t1
    lw $t4, n
    mul $t5, $t4, $t1
    mul $t6, $t5, $t1
    sub $t7, $t3, $t6
    sw $t7, a
    
    blt $t7, $0, sub
    j endsub			# if condition for a to find absolute value of a
    
sub:    
    sub $t8, $0, $t7
    sw $t8, a

   
endsub: 
    lw $t0, m
    lw $t1, n				# To find the value of b
    lw $t2, b
    addi $t3, $0, 2
    mul $t4, $t3, $t0
    mul $t5, $t4, $t1
    sw $t5, b
  
    lw $t0, m
    addi $t1, $0, 2
    mul $t2, $t0, $t1			# To find the value of c
    mul $t3, $t2, $t1
    lw $t4, n
    mul $t5, $t4, $t1
    mul $t6, $t5, $t1
    add $t7, $t3, $t6
    sw $t7, c
    
    la $a0, str_print			# To print string
    li $v0, 4
    syscall

    lw $a0, triple			# To print triple
    li $v0, 1
    syscall
    
    li $v0, 10				# exit program 
    syscall
	

