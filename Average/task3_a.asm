.data
	prompt_size: .asciiz "Enter the size of the list: "
	size: .word 0
	the_list: .word 0
	sum: .word 0
	i: .word 0
	k: .word 0
	avg_value: .word 0


.text
	
# size = int(input('Enter the size of the list: '))			 # takes the size of the list from user
# the_list = [0] * size
# i = 0
# while i < len(the_list):
    # the_list[i] = int(input())					# takes the input of the elements of the list at each index
    # i += 1

# sum = 0
# k = 0
# while k < len(the_list):
    # sum = sum + the_list[k]						# Finds the sum of the whole list by adding each element one by one
    # k += 1

# avg_value = sum / len(the_list)					# Finds the average value

# print(avg_value)

main:
	la $a0, prompt_size		# print prompt_size
	li $v0, 4
	syscall
	li $v0, 5			# reads integer
	syscall
	sw $v0, size			# assigning the value inputted by user to year
	
	lw $t0, size			# loads the size
	addi $t1, $0, 4
	mul $t2, $t1, $t0		# (4 * size)	
	add $a0, $t2, $t1		# (4 * size) + 4		
	
	li $v0, 9			# allocate memory for the_list
	syscall
		
	sw $v0, the_list		# the_list is now stored in memory
	sw $t0, ($v0)			# stores the length of the list

	sw $0, i			# initializing i as 0 ( i = 0 )


whileloop1:				# this loop reads in all the items in the list

	lw $t0, i			# loads 'i'
	lw $t2, the_list		# loads the list
	lw $t1, ($t2)			# loads the length of the list
	bge $t0, $t1, endwhileloop1	# if i >= size of the list then loop ends
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
	j whileloop1			# goes back to the start of the loop
	

endwhileloop1:
	
	sw $0, k			# assigns the value 0 to k
	sw $0, sum			# assigns the value 0 to sum

whileloop2:	
	lw $t0, k			# loading k
	lw $t1, sum			# loading sum
	lw $t2, the_list	 	# loading the list
	lw $t3, ($t2)			# loading the length of the list
	bge $t0, $t3, endwhileloop2	# if k >= length of the list, the loop will end

sum1:	
	lw $t1, sum			# loads the sum
	addi $t4, $0, 4
	mul $t5, $t4, $t0		# (4 * k)
	add $t5, $t5, $t4		# (4 * k) + 4
	add $t6, $t5, $t2		# points to the next item in the list
	lw $t7, ($t6)			# stores the next item
	add $t8, $t1, $t7		# sum = sum + the_list[k]
	sw $t8, sum			# loads the sum
	addi $t0, $t0, 1		# incrementing k by 1 after each item is accessed in the list (k += 1)
	sw $t0, k			# assigns the value in $t0 to k
	j whileloop2			# goes back to the start of the loop
	
	
endwhileloop2:
	
	lw $t0, sum			# loads the sum
	lw $t1, the_list		# loads the list
	lw $t3, ($t1)			# stores the length of the list
	div $t2, $t0, $t3		# sum // len(the_list)
	sw $t2, avg_value		# stores the average value (avg_value = sum // len(the_list))
	
	lw $a0, avg_value		# prints the average value
	li $v0, 1
	syscall

exit:
	li $v0, 10			# exit program
	syscall	
