.data
	prompt_year: .asciiz "Enter a year: "
	year: .word 0
	str_leapyear: .asciiz "Is a leap year"
	str_not_leapyear: .asciiz "Is not a leap year"
	newline: .asciiz "\n"
	
.text

# def is_leap_year(year):
    # '''
    # This function tells us whether a certain year is a leap year or not.
    # :param: year
    # :precondition: The year inputted by the user must be a year from 1582 or afterwards.
    # :postcondition: None
    # '''

    # if year % 4 == 0 and year % 100 != 0:			 # Leap year conditions, divisible by 4 but not divisible by 100
        # return True
    # elif year % 400 == 0:					# or if year is divisible by 400
        # return True
    # else:
        # return False

# year = int(input('Enter a year: '))

# if is_leap_year(year):					 # calling the function
    # print('Is a leap year')
# else:
    # print('Is not a leap year')
    
main:
   
    	la $a0, prompt_year			# print prompt_year
    	li $v0, 4
    	syscall
    	li $v0, 5				# read integer
    	syscall
    	sw $v0, year				# assigning the value inputted by user to year
    	lw $t0, year				# first if condition (if year % 4 == 0:)
    	addi $t1, $0, 4
    	div $t0, $t1				# year divided by 4
    	mfhi $t2				# storing the remainder value in $t2
    	bne $t2, $0, elif			# if remainder is not equal to 0, the if loop finishes and goes into elif
    	addi $t3, $0, 100			# first if's and condition (if year % 100 != 0:) 
    	div $t0, $t3				# year divide by 100
    	mfhi $t4				# storing the remainder value in $t4
    	beq $t4, $0, elif			# if remainder is equal to 0, the if loop finishes and goes into elif
    	j is_leapyear				# jumps to print that the year is a leap year if both conditions are truer
    	
    
elif:
	lw $t0, year				# elif condition year % 400 == 0:
	addi $t1, $0, 400
	div $t0, $t1				# year divided by 400
	mfhi $t2				# loading the remainder value in $t2
	bne $t2, $0, not_leapyear		# if remainder is not equal to 0 it jumps to the else statement i.e. not_leapyear	
	
is_leapyear:    
    
    	la $a0, str_leapyear			# print str_leapyear
    	li $v0, 4
    	syscall
    	
    	la $a0, newline				# print new line
	li $v0, 4
	syscall
    	
    	j exit					# jumpt to exit program

not_leapyear:
        
    	la $a0, str_not_leapyear		# print str_not_leapyear
    	li $v0, 4
    	syscall
    	
    	la $a0, newline				# print new line
	li $v0, 4
	syscall
    
exit:
	li $v0, 10				# exit program
	syscall
    
