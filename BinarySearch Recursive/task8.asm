.data
	temp_list: .word 0
	prompt_size: .asciiz "Enter the size of the temperature list: "
	newline: .asciiz "\n"
	prompt_target: .asciiz "Enter the target value to find in the temperature list: "
	target: .word 0
	temp_found: .asciiz "Temperature found"
	temp_notfound: .asciiz "Temperature not found"

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

    
# def binarySearch(temp_list, target, startindex, endindex):
    # '''
    # This function implements binary search recursively to find the target value in the temperature list.
    # :param: Temperature list, target value, startindex and endindex inputted by the user
    # :return: True or False depending upon whether the target was found or not in the list.
    # :precondition: The list must be sorted in ascending order
    # :postcondition: None.
    # :complexity: Best Case O(1), Worst Case O(n), where n is the length of the list
    # '''


    # if startindex == endindex:                                      # Base case, if the startindex equals endindex it will return False as the list would be empty
        # return False
    # mid =(startindex + endindex) // 2                              # Used to calculate the position of the middle element
    # if temp_list[mid] == target:                                    # if the middle value equals the target value then it returns true
        # return True
    # elif temp_list[mid] > target:                                   # if the middle value in the temperature list is greater than the target value then we search the left half of the list
        # return binarySearch(temp_list, target, startindex, mid)     # This is done by calling the binarySearch function with the parameter from start to the mid value
                                                                    # which is now the high, basically high = mid - 1  (i.e. the left half of the list)
    # else:
         # return binarySearch(temp_list, target, mid + 1, endindex)   # else the middle value in the temperature list is less than the target value then we search the right half of the list
                                                                    # This is done by calling the binarySearch function with the parameter from low to the end value
                                                                    # however now the low value is basically low = mid + 1  (i.e. the right half of the list)
                                                                    
# temp_list = createList()
# bubbleSort(temp_list)
# target = int(input('Enter the target value to find in the temperature list: '))

# if binarySearch(temp_list, target, 0, len(temp_list)):
    # print('Temperature found')
# else:
    # print('Temperature not found')



main:
	jal createList			# jump and link to createList label
	sw $v0, temp_list		# stores the return temp list created by the createList variable
	
	la $a0, prompt_target		# print prompt target
	li $v0, 4
	syscall
	
	li $v0, 5			# read integer
	syscall
	
	sw $v0, target			# store value into target
	
	addi $sp, $sp, -4		# push argument
	lw $t0, temp_list		# load the list
	sw $t0, 0($sp) 			# stores the list on the stack
	jal bubbleSort			# jump and link to bubbleSort label
	addi $sp, $sp, 4		# deallocate argument
	
	addi $sp, $sp, -16		# push argument
	lw $t0, temp_list		# load the list
	sw $t0, ($sp)			# stores the list on the stack
	lw $t1, target			# load the target
	sw $t1, 4($sp)			# stores the target on the stack
	sw $0, 8($sp)			# load the start index as 0 
	lw $t0, temp_list		# load the temp_list
	lw $t2, ($t0)			# load the length of the temp_list
	sw $t2, 12($sp)			# store the length of the temp list at 12($sp)
	jal binarySearch		# jump and link to binarySearch labell
	addi $sp, $sp, 16		# Deallocate argument
	beq $v0, $0, temp_false		# if the return value is a 0, its false hence temp not found in list
	
	la $a0, temp_found		# print temp_found
	li $v0, 4
	syscall
	
	la $a0, newline			# prints new line
	li $v0, 4
	syscall
	
	li $v0, 10			# exit program
	syscall

temp_false:
	
	la $a0, temp_notfound		# print temp_not found
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
	
binarySearch:
	
	addi $sp, $sp, -8		# make space for $fp and $ra
	sw $fp, ($sp)			# storing $fp onto the stack
	sw $ra, 4($sp)			# storing $ra onto the stack
	
	addi $fp, $sp, 0		# copying $sp into $fp
	addi $sp, $sp, -4		# 1 local variables therefore, 1 * 4 = 4 bytes of memory allocated
					# initializing local variables as follows
	
baseCase:
	
	lw $t1, 16($fp)			# loading the startindex
	lw $t2, 20($fp)			# loading the endindex
	beq $t1, $t2, endBinarySearchFalse	# if startindex == endindex, ends binary search by returining false
	lw $t1, 16($fp)			# loading startindex
	lw $t2, 20($fp)			# loading endindex
	addi $t3, $0, 2
	lw $t6, -4($fp)			# loading mid
	add $t4, $t1, $t2		# startindex + endindex
	div $t4, $t3			# (startindex + endindex) // 2
	mflo $t5			# stores the quotient in $t5
	sw $t5, -4($fp)			# mid = (startindex + endindex) // 2
	lw $t2, 8($fp)			# loading the temp_list
	lw $t5, -4($fp)			# loading mid
	addi $t6, $0, 4
	mul $t5, $t5, $t6		# (4 * mid)
	add $t5, $t5, $t6		# (4 * mid) + 4
	add $t2, $t2, $t5		# points to the next item in the list
	lw $t2, ($t2)			# stores the next item
	lw $t8, 12($fp)			# loading target value
	beq $t2, $t8, endBinarySearchTrue	# if temp_list[mid] == target, returns true and binary search ends
	ble $t2, $t8, else		# temp_list[mid] < target then this fulfills the else statement hence jumps to else label

leftlist:

	lw $t1, 16($fp)			# loading the startindex
	lw $t2, -4($fp)			# loading the endindex i.e mid
	lw $t3, 8($fp)			# loading the temp_list
	lw $t4, 12($fp)			# loading the target value
	
	addi $sp, $sp, -16		# push argument
	sw $t3, 0($sp) 			# stores the temp_list on the stack
	sw $t4, 4($sp)			# stores the target value on the stack
	sw $t1, 8($sp)			# stores the startindex on the stack
	sw $t2, 12($sp)			# stores the endindex on the stack
	jal binarySearch		# jump and link to binarySearch label
	addi $sp, $sp, 16		# Deallocating arguments
	
	addi $sp, $sp, 4		# Deallocating the local variable mid
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label

else:
	lw $t1, -4($fp)			# loading the startindex 
	addi $t1, $t1, 1		# i.e. mid + 1
	sw $t1, -4($fp)			# stores mid + 1 at -4($fp)
	lw $t2, 20($fp)			# loading the endindex
	lw $t3, 8($fp)			# loading the temp_list
	lw $t4, 12($fp)			# loading the target value
	
	addi $sp, $sp, -16		# push argument
	sw $t3, 0($sp) 			# storing the temp_list on the stack
	sw $t4, 4($sp)			# storing the target value
	sw $t1, 8($sp)			# storing mid + 1
	sw $t2, 12($sp)			# storing the endindex
	jal binarySearch		# jump and link binarySearch
	addi $sp, $sp, 16		# Deallocating arguments
	
	addi $sp, $sp, 4		# Deallocating the local variable mid
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label		
				
endBinarySearchFalse:
	
	li $v0, 0			# stores the result in $v0, 0 for false
	addi $sp, $sp, 4		# Deallocating the local variable result
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label

endBinarySearchTrue:
	
	li $v0, 1			# stores the result in $v0, 1 for true
	addi $sp, $sp, 4		# Deallocating the local variable result
	lw $fp, 0($sp)			# Restoring stack to the original state
	lw $ra, 4 ($sp)			# restore $fp & restore $ra
	addi $sp, $sp, 8		# restoring the stack frame (as ra and fp take 8 bytes)
	jr $ra				# return to main label
