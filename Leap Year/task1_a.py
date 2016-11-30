'''
Created By: Bazil Muzaffar Kotriwala
Student ID : 27012336
'''

def is_leap_year(year):
    '''
    This function tells us whether a certain year is a leap year or not.
    :param: year
    :precondition: The year inputted by the user must be a year from 1582 or afterwards.
    :postcondition: None
    :complexity: Best Case: O(n), Worst case: O(1)
    '''

    if year % 4 == 0 and year % 100 != 0:                       # Leap year conditions, divisible by 4 but not divisible by 100
        return True
    elif year % 400 == 0:                                       # or if year is divisible by 400
        return True
    else:
        return False

year = int(input('Enter a year: '))

if is_leap_year(year):                                          # calling the function
    print('Is a leap year')
else:
    print('Is not a leap year')