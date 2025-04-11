exit = False
auth = False
saldo = 0
giro = 0
deposito = 0
pin = 1234
inPin = 0
opcion = 0

while auth == False:
    print("----- Cajero -----\n\nIngrese pin:")
    inPin = int(input())

    if inPin == pin:
        while exit == False:
            print("\nSeleccione una opcion:\n1. Consultar saldo.\n2. Girar.\n3. Deposito\n4. Cambiar pin\n0. Salir.\n")
            opcion = int(input())

            if opcion == 1:
                print (f"\nSu saldo es: {saldo}")
                print ("\nSu saldo es:", saldo)

            if opcion == 2:
                print("Ingrese monto a girar: ")
                giro = int(input())

                if giro <= saldo:
                    saldo = saldo - giro
                    print("Giro realizado con exito.")
                else: 
                    print("Excede el saldo...")    

            if opcion == 3:
                print("Ingrese monto a depositar: ")
                deposito = int(input())

                if deposito <= saldo:
                    saldo = saldo - deposito
                    print("Deposito realizado con exito.")
                else:
                    print("Excede el saldo.")

            if opcion == 4:
                print("Ingrese nuevo pin: ")
                pin = int(input())
                print("Nuevo pin establecido.")

            if opcion == 0:
                print("Hasta luego.")
                exit == True
                auth == True
    else:
        print("\nPin erroneo...\n")