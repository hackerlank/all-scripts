#!/usr/bin/python3

#l1 = [1,2,3]
#l2 = []
#for i in range(len(l1)):
#    j = 0
#    while j < len(l1):
#        l1[j] = l1[i]
#        j += 1
#        print(l1) 
def perms(elements):
    if len(elements) <=1:
        yield elements
    else:
        for perm in perms(elements[1:]):
            print(perm)
            for i in range(len(elements)):
                yield perm[:i] + elements[0:1] + perm[i:]
 
for item in list(perms([1, 2, 3])):
    print(item)
