.data
	temp_list: .word 0
	prompt_size: .asciiz "Enter the size of the temperature list: "
	newline: .asciiz "\n"
	i : .word 0

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

    # size = int(input('Enter the size of the temperature list: '))				# takes the size of the list from user
    # temp_list = [0] * size
    # i = 0
    # while i < len(temp_list):
        # temp_list[i] = int(input())							# takes the input of the elements of the list at each index
        # i += 1
    # return temp_list

# def bubbleSort(temp_list):
    # '''
    # This function sorts the temperatures in the list in increasing order and then returns the temperature list.
    # :param: temp_list
    # :precondition: The temp_list must not be empty.
    # :postcondition: The list returned is sorted.
    # :complexity: Best Case O(n), Worst Case O(n^2)
    # '''

   # i = 0
    # while i < len(temp_list) - 1:
        # j = i + 1
        # while j < len(temp_list):
            # if temp_list[i] > temp_list[j]:					# Swapping the elements if the condition is true
                 # tmp = temp_list[i]
                # temp_list[i] = temp_list[j]
                # temp_list[j] = tmp
            # j += 1
        # i += 1
    # return temp_list


# def medianElement(temp_list):
    # '''
    # This function returns the median element in the list, the list being of any size, either even or odd length.
    # :param: temp_list
    # :precondition: The temperature list must not be empty
    # :postcondition: Returns the median element in the list
    # :complexity: Best Case O(n), Worst Case O(1)
    # '''

    # mid = (len(temp_list) + 1) // 2
    # if len(temp_list) % 2 == 0:                                         # if list is of even length, then the average value of the middle two values is the median
        # median = (temp_list[mid] + temp_list[mid - 1]) // 2
    # else:                                                               # else if the list is of odd length, then the middle value in the list is the median
        # median = temp_list[mid - 1]
    # return median

# temp_list = createList()
# bubbleSort(temp_list)
# print(medianElement(temp_list))


main:
	jal createList			# jump and link to createList label
	sw $v0, temp_list		# stores the return temp list created by the createList variable

	addi $sp, $sp, -4		# push argument
	lw $t0, temp_list		# load the list
	sw $t0, 0($sp) 			# stores the list on the stack
	jal bubbleSort			# jump and link to bubbleSort label
	addi $sp, $sp, 4		# deallocate argument

	move $a0, $v0			# use return value in $v0 by moving it to $a0
	addi $sp, $sp, -4		# push argument
	lw $t0, temp_list		# load the list
	sw $t0, ($sp)			# stores the list on the stack
	jal medianElement		# jump and link to medianElement label
	addi $sp, $sp, 4		# deallocate argument
	
	move $a0, $v0			# moves $v0 to $a0
	li $v0, 1			# prints the median
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
	lw $a0, -12($fp)
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
	lw $t2, -8($fp)			# loading the_list
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
	lw $t0, -4($fp)			# loading 'i'
	addi $t0, $t0, 1		# incrementing i by 1 after each item is accessed in the list (i += 1)
	sw $t0, -4($fp)			# storing incremented value of i at -4($fp)
	j whileloop1			# goes back to the start of the loop


endwhileloop1:
	
	lw $v0, -8($fp)			# stores the_list in $v0
	addi $sp, $sp, 12		# Deallocating the local variable the_list
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label
	
	
bubbleSort:

	addi $sp, $sp, -8		# make space for $fp and $ra
	sw $fp, ($sp)			# storing $fp onto the stack
	sw $ra, 4($sp)			# storing $ra onto the stack

	addi $fp, $sp, 0		# copying $sp into $fp
	addi $sp, $sp, -12		# 3 local variables therefore, 3 * 4 = 12 bytes allocated
	
	sw $0, -12($fp) 		# initializing i as 0

outerloop:

	lw $t0, -12($fp)		# loading 'i'
	lw $t2, 8($fp)			# loading the temp_list
	lw $t1, ($t2)			# reads the length of the list
	sub $t1, $t1, 1			# len(temp_list) -1
	bge $t0, $t1, endouterloop	# if i >= size of the list then loop ends
	lw $t3, -12($fp)		# loading 'i'
	addi $t3, $t3, 1		# j = i + 1
	sw $t3, -8($fp) 		# storing j at -8($fp)

innerloop:
	
	lw $t3, -8($fp)			# loading 'j'
	lw $t2, 8($fp)			# loading the list
	lw $t1, ($t2)			# loading the length of the list
	bge $t3, $t1, incrementi	# if j >= size of the list then loop ends
	
	lw $t0, -12($fp)		# loading 'i'
	addi $t4, $0, 4
	mul $t5, $t4, $t0		# (4 * i)
	add $t5, $t5, $t4		# # (4 * i) + 4
	lw $t2, 8($fp)			# loading the temp_list
	add $t5, $t5, $t2		# points to the next item in the list
	lw $t8, ($t5)			# stores the next item
	
	lw $t3, -8($fp)			# loading 'j'
	addi $t4, $0, 4
	mul $t6, $t4, $t3		# (4 * j)
	add $t6, $t6, $t4		# (4 * j) + 4
	lw $t2, 8($fp)			# loading the temp list
	add $t6, $t6, $t2		# points to the next item in the list
	lw $t7, ($t6)			# stores the next item
	
	ble $t8, $t7, incrementj	# if temp_list[i] > temp_list[j], then the values are swapped
	
	lw $t2, 8($fp)			# loading the list
	addi $t4, $0, 4
	lw $t0, -12($fp)		# loading 'i'
	mul $t5, $t4, $t0		# (4 * i)
	add $t5, $t5, $t4		# # (4 * i) + 4
	add $t5, $t5, $t2		# points to the next item in the list
	lw $t8, ($t5)			# stores the next item
	sw $t8, -4($fp)			# tmp = temp_list[i]
	
	lw $t2, 8($fp)			# loading the list
	addi $t4, $0, 4
	lw $t0, -12($fp)		# loading 'i'
	mul $t5, $t4, $t0		# (4 * i)
	add $t5, $t5, $t4		# # (4 * i) + 4
	add $t5, $t5, $t2		# points to the next item in the list

	lw $t2, 8($fp)			# loading the list
	addi $t4, $0, 4
	lw $t3, -8($fp)			# loading j
	mul $t6, $t4, $t3		# (4 * j)
	add $t6, $t6, $t4		# # (4 * j) + 4
	add $t6, $t6, $t2		# points to the next item in the list
	lw $t8, ($t6)			# stores the next item
	sw $t8, ($t5)			# temp_list[i] = temp_list[j]
	
	lw $t2, 8($fp)			# loading the list
	addi $t4, $0, 4
	lw $t3, -8($fp)			# loading j
	mul $t6, $t4, $t3		# (4 * j)
	add $t6, $t6, $t4		# # (4 * j) + 4
	add $t6, $t6, $t2		# points to the next item in the list
	lw $t7, -4($fp)			# loading tmp
	sw $t7, ($t6)			# temp_list[j] = tmp
	j incrementj

incrementi:
	
	lw $t0, -12($fp)		# loading i
	addi $t0, $t0, 1		# incrementing i by 1 after each item is accessed in the list (i += 1)
	sw $t0, -12($fp)		# storing the incremented value of 'i' at -12($fp)
	j outerloop			# goes back to the start of the loop
		
incrementj:	

	lw $t3, -8($fp)			# loading j
	addi $t0, $t3, 1		# incrementing j by 1 (j += 1)
	sw $t0, -8($fp)			# storing the incremented value of j at -8($fp)	
	j innerloop

endouterloop:
	
	lw $v0, 8($fp)			# stores temp_list in $v0
	addi $sp, $sp, 12		# Deallocating the local variable temp_list
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label

	
medianElement:

	addi $sp, $sp, -8		# make space for $fp and $ra
	sw $fp, ($sp)			# storing $fp onto the stack
	sw $ra, 4($sp)			# storing $ra onto the stack
	
	addi $fp, $sp, 0		# copying $sp into $fp
	addi $sp, $sp, -8		# 3 local variables therefore, 2 * 4 = 8 bytes of memory allocated
	
	lw $t2, 8($fp)			# loading the temp_list
	lw $t1, ($t2)			# loads the length of the list
	addi $t1, $t1, 1		# len(temp_list) + 1
	addi $t3, $0, 2
	div $t1, $t3			# (len(temp_list) + 1) // 2
	mflo $t4			# stores quotient into $t4
	sw $t4, -8($fp)			# mid = (len(temp_list) + 1)  // 2
	
	lw $t2, 8($fp)			# loading the temp_list
	lw $t1, ($t2)			# loads the length of the list
	addi $t3, $0, 2
	div $t1, $t3			# len(temp_list) // 2
	mfhi $t6			# stores remainder in $t6
	bne $t6, $0, else		# if the len(list) % 2 != 0, it jumps to the else label
	lw $t2, 8($fp)			# loading the list
	lw $t4, -8($fp)			# loading mid
	addi $t5, $0, 4
	mul $t4, $t4, $t5		# (4 * mid)
	add $t4, $t4, $t5		# (4 * mid) + 4
	add $t7, $t2, $t4		# points to the next item in the list
	lw $t7, ($t7)			# stores the next item
	lw $t4, -8($fp)			# loading mid
	sub $t4, $t4, 1			# [mid - 1]
	addi $t5, $0, 4
	mul $t4, $t4, $t5		# (4 * (mid-1))
	add $t4, $t4, $t5		# (4 * (mid-1)) + 4
	lw $t2, 8($fp)			# loading the temp_list
	add $t8, $t2, $t4		# points to the next item in the list
	lw $t8, ($t8)			# stores the next item
	add $t0, $t7, $t8		# temp_list[mid] + temp_list[mid-1]
	add $t3, $0, 2
	div  $t0, $t3			# temp_list[mid] + temp_list[mid-1] // 2
	mflo $t0			# stores the quotient in $t0
	sw $t0, -4($fp)			# storing median at -4($fp)
	j endloop
		
else:
	lw $t2, 8($fp)			# loading temp_list
	lw $t4, -8($fp)			# loading mid
	sub $t4, $t4, 1			# mid - 1	
	mul $t4, $t4, 4			# (4 * (mid - 1))
	addi $t4, $t4, 4		# (4 * (mid - 1)) + 4
	add $t3, $t2, $t4		# points to the next item in the list
	lw $t3, ($t3)			# stores the next item
	sw $t3, -4($fp)			# median = temp_list[mid - 1]
	
endloop:
	lw $v0, -4($fp)			# stores the result in $v0
	addi $sp, $sp, 8		# Deallocating the local variable result
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label
	
