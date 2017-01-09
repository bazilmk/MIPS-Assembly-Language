.data
	prompt_metres: .asciiz "Enter the data in metres: "
	metres: .word 0
	feet: .word 0
	 
.text

# metres = float(input('Enter the data in metres: '))              # python code

# feet = metres * 32
# feet = feet / 10

# print(feet)

	
	
	la $a0, prompt_metres			# print input in metres
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	sw $v0, metres
	
	lw $t0, metres
	addi $t1, $0, 32			# converts metres into feet
	mult $t0, $t1
	mflo $t0
	addi $t2, $0, 10
	div $t0, $t2
	mflo $t3
	sw $t3, feet
	
	lw $a0, feet				# prints data in feet.
	li $v0, 1
	syscall
	
	li $v0, 10				# exit program
	syscall
	
	
