exit = False
position = 0
control1 = control2 = control3 = control4 = control5 = control6 = control7 = control8 = control9 = False

row1 = [1, 2, 3]
row2 = [4, 5, 6]
row3 = [7, 8, 9]

def menu():
    print(row1)
    print(row2)
    print(row3)

def control():
    if (row1[0] == row1[1] & row1[0] == row1[2] ):
        if (row1[0] == "x"):
            print(player1, " es el ganador.")
        if (row1[0] == "o"):
            print(player2, " es el ganador.")

    if (row2[0] == row2[1] & row2[0] == row2[2] ):
        if (row2[0] == "x"):
            print(player1, " es el ganador.")
        if (row2[0] == "o"):
            print(player2, " es el ganador.")

    if (row3[0] == row3[1] & row3[0] == row3[2] ):
        if (row3[0] == "x"):
            print(player1, " es el ganador.")
        if (row3[0] == "o"):
            print(player2, " es el ganador.")

    if (row1[0] == row2[0] & row1[0] == row3[0] ):
        if (row1[0] == "x"):
            print(player1, " es el ganador.")
        if (row1[0] == "o"):
            print(player2, " es el ganador.")

    if (row1[1] == row2[1] & row1[1] == row3[1] ):
        if (row1[1] == "x"):
            print(player1, " es el ganador.")
        if (row1[1] == "o"):
            print(player2, " es el ganador.")

    if (row1[2] == row2[2] & row1[2] == row3[2] ):
        if (row1[2] == "x"):
            print(player1, " es el ganador.")
        if (row1[2] == "o"):
            print(player2, " es el ganador.")
        
    if (row1[0] == row2[1] & row1[0] == row3[2] ):
        if (row1[0] == "x"):
            print(player1, " es el ganador.")
        if (row1[0] == "o"):
            print(player2, " es el ganador.")

    if (row3[0] == row2[1] & row3[0] == row1[2] ):
        if (row3[0] == "x"):
            print(player1, " es el ganador.")
        if (row3[0] == "o"):
            print(player2, " es el ganador.")


print("Ingrese el nombre del jugador 1:")
player1 = input()

print("Ingrese el nombre del jugador 2:")
player2 = input()


while exit == False:
    menu()

    print(player1, ", ingrese su posición: ")
    position = int(input())    
   #Incorporar validacion a el ingreso, si es x u o. 
    match position:
        case 1: 
            if control1 == False:
                print("Juegue: ")
                row1[0] = input()
                control1 = True
        case 2: 
            print("Juegue: ")
            row1[1] = input()
        case 3: 
            print("Juegue: ")
            row1[2] = input()
        case 4: 
            print("Juegue: ")
            row2[0] = input()
        case 5: 
            print("Juegue: ")
            row2[1] = input()
        case 6: 
            print("Juegue: ")
            row2[2] = input()
        case 7: 
            print("Juegue: ")
            row3[0] = input()
        case 8: 
            print("Juegue: ")
            row3[1] = input()
        case 9: 
            print("Juegue: ")
            row3[2] = input()
       

    #exit = True    