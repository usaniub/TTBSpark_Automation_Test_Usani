def check_dupItem_between2list (list1,list2):
    dup_item_list = []

    for i in list1 :
        for j in list2 :
            if j == i :
                dup_item_list.append(j)

    print("New list contain duplicate item from 2 list =", dup_item_list)

    return dup_item_list
                


# Call function check_dupItem_between2list 
A = [1,2,3,5,6,8,9]
B = [3,2,1,5,6,0]

check_dupItem_between2list(A,B)
