.data
	the_list: .word 0
	prompt_size: .asciiz "Enter the size of the list: "
	newline: .asciiz "\n"

.text

# def createList():
    # '''
    # This function reads in the size of the list, allocates the required amount of space and reads in each value into the temperature list.
    # :param: None
    # :precondition: None
    # :postcondition: Creates a list
    # :complexity: Best Case O(n), Worst Case O(1)
    # '''

    # size = int(input('Enter the size of the list: '))				 # takes the size of the list from user
    # the_list = [0] * size
    # i = 0
    # while i < len(the_list):
        # the_list[i] = int(input())						# takes the input of the elements of the list at each index
        # i += 1
    # return the_list


# def avgValue(the_list):
    # '''
    # This function calculates the summation of all the items in the list and then divides it by the length of the list (total number of items) to give us the average value.
    # :param: the_list
    # :precondition: The list must be already created
    # :postcondition: The average value is printed
    # :complexity: Best Case O(n), Worst Case O(n)
    # '''

    # sum = 0
    # k = 0
    # while k < len(the_list):
        # sum = sum + the_list[k]						 # Finds the sum of the whole list by adding each element one by one
        # k += 1

     # avg_value = sum / len(the_list)

    # return avg_value

# the_list = createList()
# print(avgValue(the_list))


main:

	jal createList			# jump and link to createList label
	sw $v0, the_list		# stores the return list created by the createList variable

	addi $sp, $sp, -4		# push argument
	lw $t0, the_list		# load the list
	sw $t0, 0($sp) 			# stores the list on the stack
	jal avgValue			# jump and link to avgValue label
	
	move $a0, $v0			# use return value in $v0 by moving it to $a0
	li $v0, 1			# prints the return average value
	syscall
	
	la $a0, newline			# prints new line
	li $v0, 4
	syscall

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
	lw $a0, -12($fp)		# loading the size
	li $v0, 4
	syscall				# print prompt_size
	li $v0, 5			# reads integer
	syscall
	sw $v0, -12($fp)		# stores the size of the list inputted by the user
	
	lw $t0, -12($fp)		# load the size
	addi $t1, $0, 4
	mul $t2, $t1, $t0		# (4 * size)
	add $a0, $t2, $t1		# (4 * size) + 4
	li $v0, 9			# allocate memory for the_list
	syscall
		
	sw $v0, -8($fp)			# the_list is now stored in memory
	sw $t0, ($v0)			# stores the length of the list
	
whileloop1:				# this loop reads in all the items in the list

	lw $t0, -4($fp)			# loading 'i'
	lw $t2, -8($fp)			# loading the list
	lw $t1, ($t2)			# loads the length of the list
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
	lw $t0, -4($fp)			# loading i
	addi $t0, $t0, 1		# incrementing i by 1 after each item is accessed in the list (i += 1)
	sw $t0, -4($fp)			# stores the incremented value of 'i' at the pointer -4($fp)
	j whileloop1			# goes back to the start of the loop
	

endwhileloop1:
	
	lw $v0, -8($fp)			# stores the_list in $v0
	addi $sp, $sp, 12		# Deallocating the local variable the_list
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp  & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label
	
	
avgValue:

	addi $sp, $sp, -8		# make space for $fp and $ra
	sw $fp, ($sp)			# allocating space for the frame pointer
	sw $ra, 4($sp)			# storing $ra onto the stack

	addi $fp, $sp, 0		# copying $sp into $fp
	addi $sp, $sp, -12		# 4 local variables therefore, 3 * 4 = 12 bytes of memory allocated
					# initialzing the local variables as follows
	sw $0, -12($fp)			# initializing the sum 
	sw $0, -8($fp)			# initializing 'k'

whileloop2:

	lw $t0, -8($fp)			# loading 'k'
	lw $t2, 8($fp)	 		# loading the list which is at 8($fp), as its an argument
	lw $t3, ($t2)			# stores the length of the list
	bge $t0, $t3, endwhileloop2	# if k >= length of the list, the loop will end.
	
sum1:	
	lw $t1, -12($fp)		# loading the sum
	addi $t4, $0, 4
	lw $t0, -8($fp)			# loading 'k'
	mul $t5, $t4, $t0		# (4 * k)
	add $t5, $t5, $t4		# (4 * k) + 4
	add $t6, $t5, $t2		# points to the next item in the list
	lw $t7, ($t6)			# stores the next item
	lw $t1, -12($fp)		# loading the sum
	add $t8, $t1, $t7		# sum = sum + the_list[k]
	sw $t8, -12($fp)		# storing the total sum calculated at -12($fp)
	lw $t0, -8($fp)			# loading 'k'
	addi $t0, $t0, 1		# incrementing k by 1 after each item is accessed in the list (k += 1)
	sw $t0, -8($fp)			# storing incremented k value at -8($fp)s
	j whileloop2			# goes back to the start of the loop
	
	
endwhileloop2:				# calculates the average of the list and deallocates the local variables
	
	lw $t0, -12($fp)		# loading the sum
	lw $t1, 8($fp)			# loading the list
	lw $t4, ($t1)			# stores the length of the list
	div $t2, $t0, $t4		# sum / length of the list to give average value
	sw $t2, -4($fp)			# storing the average value at -4($fp)
	
	lw $v0, -4($fp)			# stores the average value in $v0
	addi $sp, $sp, 12		# Deallocating the local variable average value
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label

