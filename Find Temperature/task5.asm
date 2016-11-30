.data
	temp_list: .word 0
	prompt_temp: .asciiz "Enter the temperature to find: "
	temp: .word 0
	prompt_size: .asciiz "Enter the size of the temperature list: "
	result_notfound: .asciiz "Temperature not found in the list. "
	result_found: .asciiz "Temperature found in the list."
	result: .word 0
	newline: .asciiz "\n"

.text

# '''
# Created By: Bazil Muzaffar Kotriwala
# Student ID : 27012336
# '''
	
# def createList():
    # '''
    # This function reads in the size of the temperature list, allocates the required amount of space and reads in each value into the temperature list.
    # :param: None
    # :precondition: None
    # :postcondition: Creates a list
    # :complexity: Best Case O(n), Worst Case O(1)
    # '''

    # size = int(input('Enter the size of the temperature list: '))			# takes the size of the list from user
    # temp_list = [0] * size
    # i = 0
    # while i < len(temp_list):
        # temp_list[i] = int(input())						# takes the input of the elements of the list at each index
        # i += 1
    # return temp_list

# def linearSearch(temp_list):
    # '''
    # This function implements linear search on the temperature list to check whether the temperature inputted by the user exists in the temperature list.
    # :param: temp_list
    # :precondition: The temp_list must be created and must not be empty.
    # :postcondition: Determines whether the temperature exists in the temp_list or not.
    # :complexity: Best Case O(n), Worst Case O(n)
    # '''

    # k = 0
    # result = 'Temperature not found in the list'
    # while k < len(temp_list):
        # if temp == temp_list[k]:				# Using linear search to find whether a given temperature exists in a list or not
            # result = 'Temperature found in the list.'
            # break
        # else:
            # k += 1
    # print(result)

# temp_list = createList()
# temp = int(input('Enter the temperature to find: '))
# linearSearch(temp_list)


main:

	jal createList			# jump and link to createList label
	sw $v0, temp_list
	
	la $a0, prompt_temp		# print prompt temp
	li $v0, 4
	syscall
	
	li $v0, 5			# read integer
	syscall
	
	sw $v0, temp			# store value into temp

	addi $sp, $sp, -4		# push argument
	lw $t0, temp_list		# load the list
	sw $t0, 0($sp) 			# stores the list on the stack
	jal linearSearch		# jump and link to avgValue label

	li $v0, 10			# exit program
	syscall	


	
createList:
	
	addi $sp, $sp, -8		# make space for $fp and $ra
	sw $fp, ($sp)			# storing $fp onto the stack
	sw $ra, 4($sp)			# storing $ra onto the stack
	
	addi $fp, $sp, 0		# copying $sp into $fp
	addi $sp, $sp, -12		# 3 local variables therefore, 3 * 4 = 12 bytes of memory allocated
					# initializing local variables as follows
	sw $0, -12($fp)			# initializing the size 
	sw $0, -8($fp)			# initializing the_list
	sw $0, -4($fp)			# intializing 'i'
	
	la $t0, prompt_size		
	sw $t0, -12($fp)		# storing size at the pointer -12($fp)
	lw $a0, -12($fp)		# loading size
	li $v0, 4
	syscall				# print prompt_size
	li $v0, 5			# reads integer
	syscall
	sw $v0, -12($fp)		# stores the size of the list
	
	lw $t0, -12($fp)		# loading size
	addi $t1, $0, 4
	mul $t2, $t1, $t0		# (4 * size)
	add $a0, $t2, $t1		# (4 * size) + 4
	li $v0, 9			# allocate memory for the_list
	syscall
		
	sw $v0, -8($fp)			# the_list is now stored in memory
	sw $t0, ($v0)			# stores the length of the list as we store the size from $t0 to $v0
	
whileloop1:				# this loop reads in all the items in the list

	lw $t0, -4($fp)			# loading 'i'
	lw $t2, -8($fp)			# loading the list
	lw $t1, ($t2)			# reads the length of the list
	bge $t0, $t1, endwhileloop1	# if i >= size of the list then loop ends
	li $v0, 5			# read integer
	syscall
	lw $t2, -8($fp)			# loading the_list
	lw $t0, -4($fp)			# loading 'i'
	addi $t3, $0, 4
	mul $t4, $t3, $t0		# (4 * i)
	add $t4, $t4, $t3		# (4 * i) + 4
	add $t4, $t4, $t2		# points to the next item in the list
	sw $v0, ($t4)			# stores the next item
	lw $t0, -4($fp)			# loading 'i'
	addi $t0, $t0, 1		# incrementing i by 1 after each item is accessed in the list (i += 1)
	sw $t0, -4($fp)			# assigning the incremented value to i
	j whileloop1			# goes back to the start of the loop
	

endwhileloop1:
	
	lw $v0, -8($fp)			# stores the_list in $v0
	addi $sp, $sp, 12		# Deallocating the local variable the_list
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label
	
linearSearch:

	addi $sp, $sp, -8		# make space for $fp and $ra
	sw $fp, ($sp)			# storing $fp onto the stack
	sw $ra, 4($sp)			# storing $ra onto the stack
	
	addi $fp, $sp, 0		# copying $sp into $fp
	addi $sp, $sp, -8		# 2 local variables therefore, 2 * 4 = 8 bytes allocated
					# initialzing the local variables as follows
	sw $0, -8($fp)			# initializing 'k' as 0 ( k = 0 )

initialize:

	la $a0, result_notfound		# initializes the result as 'Temperature not found in the list'
	sw $a0, -4($fp)			# storing initial result not found at -4($fp)
	
whileloop2:
	
	lw $t0, -8($fp)			# loading 'k'
	lw $t2, 8($fp)	 		# loading the temperature list
	lw $t3, ($t2)			# stores the length of the list
	bge $t0, $t3, endwhileloop2	# if k >= length of the list, the loop will end.
	addi $t3, $0, 4
	mul $t4, $t3, $t0		# (4 * k)
	add $t4, $t4, $t3		# (4 * k) + 4
	add $t4, $t4, $t2		# points to the next item in the list
	lw $a0, ($t4)			# stores the next item
	lw $t1, temp			# loading temp
	beq $t1, $a0, temp_found	# if temp == temp_list[k]
	lw $t0, -8($fp)			# loading 'k'
	add $t0, $t0, 1			# incrementing k by 1 ( k += 1)
	sw $t0, -8($fp)			# storing the incremented k at -8($fp)
	j whileloop2

		
temp_found:
	
	la $a0, result_found
	sw $a0, -4($fp)			# storing result at -4($fp)
	j endwhileloop2			# break statement results in whileloop2 to end.
	

endwhileloop2:

	lw $a0, -4($fp)			# print result
	li $v0, 4
	syscall	
	
	la $a0, newline			# prints new line
	li $v0, 4
	syscall
	
	lw $v0, -4($fp)			# stores the result in $v0
	addi $sp, $sp, 8		# Deallocating the local variable result
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label

	
