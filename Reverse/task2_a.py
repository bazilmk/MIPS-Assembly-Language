'''
Created By: Bazil Muzaffar Kotriwala
Student ID : 27012336
'''

def reverse_list(the_list):
    '''
    This function prints the list in reverse order.
    :param: the_list
    :return: None
    :precondition: the_list must not be empty.
    :postcondition: the_list elements are printed in reverse order.
    :complexity: Best Case O(n), Worst Case O(1)
    '''

    k = len(the_list) - 1
    while k >= 0:
        print(the_list[k])                                      # prints each element of the list in reverse order.
        k -= 1

size = int(input('Enter the size of the list: '))               # takes the size of the list from user
the_list = [None] * size
i = 0
while i < len(the_list):
    the_list[i] = int(input())                              # takes the input of the elements of the list at each index
    i += 1

reverse_list(the_list)