.data
	str: .asciiz "Hello World!"

.text
# print("Hello World!")
	la $a0, str			# print string
	li $v0, 4
	syscall
	li $v0, 10			# exit program
	syscall