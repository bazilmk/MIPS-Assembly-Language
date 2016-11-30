.data
	prompt_size: .asciiz "Enter the size of the list: "
	size: .word 0
	the_list: .word 0
	i: .word 0
	k: .word 0
	newline: .asciiz "\n"
	
.text

# def reverse_list(the_list):
    # '''
    # This function prints the list in reverse order.
    # :param: the_list
    # :precondition: the_list must not be empty.
    # :postcondition: the_list is printed in reverse order.
    # '''

    # k = len(the_list) - 1
    # while k >= 0:
        # print(the_list[k])					# prints each element of the list in reverse order.
        # k -= 1

# size = int(input('Enter the size of the list: '))		# takes the size of the list from user
# the_list = [0] * size
# i = 0
# while i < len(the_list):
    # the_list[i] = int(input())				 # takes the input of the elements of the list at each index
    # i += 1

# reverse_list(the_list)


main:
	la $a0, prompt_size		# print prompt_size
	li $v0, 4
	syscall
	li $v0, 5			# reads integer
	syscall
	sw $v0, size			# stores the size
	
	lw $t0, size			# loads the size
	addi $t1, $0, 4			
	mul $t2, $t1, $t0		# 4 * size
	add $a0, $t2, $t1		# (4 * size) + 4
	li $v0, 9			# allocate memory for the_list
	syscall
		
	sw $v0, the_list		# the_list is now stored in memory
	sw $t0, ($v0)			# stores the length of the list

	sw $0, i			# initializing i as 0 ( i = 0 )

whileloop:				# this loop reads in all the items in the list
				
	lw $t0, i			# loads 'i'
	lw $t2, the_list		# loads the_list
	lw $t1, ($t2)			# loads the length of the list
	bge $t0, $t1, endwhileloop	# if i >= size of the list then loop ends
	li $v0, 5			# read integer
	syscall
	addi $t3, $0, 4			
	mul $t4, $t3, $t0		# (4 * i)
	add $t4, $t4, $t3		# (4 * i) + 4
	add $t4, $t4, $t2		# points to the next item in the list
	sw $v0, ($t4)			# stores the next item
	lw $t0, i			# loads 'i'
	addi $t0, $t0, 1		# incrementing i by 1 after each item is accessed in the list (i += 1)
	sw $t0, i			# assigns the value in $t0 to i
	j whileloop			# goes back to the start of the while loop
	
endwhileloop:

	lw $t1, the_list		# loads the list
	lw $t2, ($t1)			# stores the length of the list
	sub $t3, $t2, 1 		# len(the_list) - 1
	sw $t3, k			# k = len(the_list) - 1

revlistwhileloop:
	
	lw $t0, k			# loading k
	blt $t0, $0, endwhile		# if k is less than 0, then the while loop ends
	lw $t0, k			# loading k
	lw $t2, the_list		# loading the list
	addi $t3, $0, 4
	mul $t4, $t3, $t0		# (4 * k)
	add $t4, $t4, $t3		# (4 * k) + 4
	add $t4, $t4, $t2		# points to the next item in the list
	lw $a0, ($t4)			# stores the next item
	li $v0, 1			# print(the_list[k])
	syscall
	
	la $a0, newline			# prints a new line
	li $v0, 4
	syscall
	
	lw $t0, k			# loading k
	sub $t0, $t0, 1			# decrementing k by 1 after each item is accessed in the list (k += 1)
	sw $t0, k			# assigning the value in $t0 to k 
	j revlistwhileloop		# goes back to the start of the loop
	
endwhile:
	
	li $v0, 10			# exit program
	syscall
	
	
	
