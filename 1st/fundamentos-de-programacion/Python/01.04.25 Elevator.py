floor = 0
newFloor = 0
exit = False
confirmation = 0

while exit == False:
    print("----- Elevator -----")
    print("We are on ", floor, " floor, enter the floor you are going to: ")
    newFloor = int(input())

    if newFloor == floor:
        print("We are already on the ", floor, " floor...")

    if newFloor > floor:
        floor= newFloor
        print("Going up to", newFloor, "floor.")

    if newFloor < floor:
        floor= newFloor
        print("Going down to", newFloor, "floor.")

    print("We are on", floor, "floor.\nDo you want to get off the elevator?\n1.Yes \n2.No")
    confirmation = int(input()) 

    if confirmation == 1:
        print("See you...")
        exit = True
        
        