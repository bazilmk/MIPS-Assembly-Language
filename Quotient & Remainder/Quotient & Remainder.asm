.data
	prompt_a: .asciiz "Enter first integer value"
	prompt_b: .asciiz "Enter second integer value"
	newline: .asciiz "\n"
	a: .word 0
	b: .word 0
	quotient: .word 0
	remainder: .word 0

.text

#a = int(input('Enter first integer value: '))
#b = int(input('Enter second integer value: '))

#quotient = a // b
#remainder = a % b

#print(quotient)
#print(remainder)

	la $a0, prompt_a			# prints first integer
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	sw $v0, a
	
	la $a0, prompt_b			# prints second integer
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	sw $v0, b
	
	lw $t0, a				# finds the quotient
	lw $t1, b
	div $t0, $t1
	mflo $t2
	sw $t2, quotient
	
	lw $t0, a
	lw $t1, b				# finds the remainder
	div $t0, $t1
	mfhi $t2
	sw $t2, remainder
	
	lw $a0, quotient			# prints the quotient
	li $v0, 1
	syscall
	
	la $a0, newline				# Prints remainder in next line to make output readable and neater
	li $v0, 4
	syscall
	
	lw $a0, remainder		        # prints the remainder
	li $v0, 1
	syscall
	
	li $v0, 10				# exit program
	syscall
