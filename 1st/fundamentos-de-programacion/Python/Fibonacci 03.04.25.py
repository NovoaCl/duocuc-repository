a = 0
b = 1
c = 0

print("Enter the position in Fibonacci's sequenece: ")
position = int(input())

if position == 1:
    print("The number is: 0")

if position == 2:
    print("The number is: 1")

if position >= 3:
    for i in range(position - 2):
        c = a + b
        a = b
        b = c

    print("The number is:", c)


