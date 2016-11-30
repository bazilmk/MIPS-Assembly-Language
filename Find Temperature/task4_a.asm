.data
	prompt_size: .asciiz "Enter the size of the list: "
	size: .word 0
	temp_list: .word 0
	i: .word 0
	prompt_temp: .asciiz "Enter the temperature to find: "
	temp: .word 0
	k: .word 0
	result_notfound: .asciiz "Temperature not found in the list. "
	result_found: .asciiz "Temperature found in the list."
	result: .word 0
	newline: .asciiz "\n"
	

.text

# '''
# Created By: Bazil Muzaffar Kotriwala
# Student ID : 27012336
# '''

# size = int(input('Enter the size of the temperature list: '))			# takes the size of the list from user
# temp_list = [0] * size
# i = 0
# while i < len(temp_list):
    # temp_list[i] = int(input())					# takes the input of the elements of the list at each index
    # i += 1

# temp = int(input('Enter the temperature to find: '))

# k = 0
# result = 'Temperature not found in the list'
# while k < len(temp_list):
    # if temp == temp_list[k]:						# Using linear search to find whether a given temperature exists in a list or not
        # result = 'Temperature found in the list.'
        # break
    # else:
        # k += 1

# print(result)


main:
	
	la $a0, prompt_size		# print prompt_size
	li $v0, 4
	syscall
	li $v0, 5			# reads integer
	syscall
	sw $v0, size
	
	lw $t0, size			# finds the_list
	addi $t1, $0, 4
	mul $t2, $t1, $t0		# (4 * size)
	
	add $a0, $t2, $t1		# (4 * size) + 4
	li $v0, 9			# allocate memory for the_list
	syscall
		
	sw $v0, temp_list		# the_list is now stored in memory
	sw $t0, ($v0)			# stores the length of the list as we store the size from $t0 to $v0

	sw $0, i			# initializing i as 0 ( i = 0 )


whileloop1:				# this loop reads in all the items in the list
	
	lw $t0, i			# loading i
	lw $t2, temp_list		# load temp_list
	lw $t1, ($t2)			# reads the length of the list
	bge $t0, $t1, endwhileloop1	# if i >= size of the list then loop ends
	li $v0, 5			# read integer
	syscall
	addi $t3, $0, 4
	mul $t4, $t3, $t0		# (4 * i)
	add $t4, $t4, $t3		# (4 * i) + 4
	add $t4, $t4, $t2		# points to the next item in the list
	sw $v0, ($t4)			# stores the next item
	lw $t0, i			# loading i
	addi $t0, $t0, 1		# incrementing i by 1 after each item is accessed in the list (i += 1)
	sw $t0, i
	j whileloop1			# goes back to the start of the loop
	
	
endwhileloop1:
	
	la $a0, prompt_temp		# print prompt_temp
	li $v0, 4
	syscall
	li $v0, 5			# read integer
	syscall
	sw $v0, temp			# stores the temp
	j initialize
	
	
initialize:
	
	sw $0, k			# initializes k as 0 ( k = 0 )
	la $a0, result_notfound		# initializes the result as 'Temperature not found in the list'
	sw $a0, result
	
whileloop2:
	
	lw $t0, k			# loading k
	lw $t2, temp_list	 	# loading temp_list
	lw $t3, ($t2)			# stores the length of the list
	bge $t0, $t3, endwhileloop2	# if k >= length of the list, the loop will end.
	addi $t3, $0, 4
	mul $t4, $t3, $t0		# (4 * k)
	add $t4, $t4, $t3		# (4 * k) + 4
	add $t4, $t4, $t2		# points to the next item in the list
	lw $a0, ($t4)			# stores the next item
	lw $t1, temp			# loading temp
	beq $t1, $a0, temp_found	# if temp == temp_list[k], jump to temp_found
	lw $t0, k			# loading k
	add $t0, $t0, 1			# incrememnting k by 1 ( k += 1)
	sw $t0, k
	j whileloop2

		
temp_found:
	
	la $a0, result_found
	sw $a0, result			
	j endwhileloop2			# break statement results in whileloop2 to end.
	

endwhileloop2:
	
	lw $a0, result			# print the result i.e. whether the temperature inputted by the user is found in the list or not.
	li $v0, 4
	syscall
	
	la $a0, newline			# print new line
	li $v0, 4
	syscall
	
		
exit:
	
	li $v0, 10			# exit program
	syscall


	
