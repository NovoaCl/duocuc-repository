option1, option2 = int, int
moneda, result = float, float
exit = False

while exit == False:
    print("----- Convertidor de Monedas -----\n Seleccione su tipo de moneda:\n1. Peso Chileno\n2. US Dolar\n3. Euro\n4. Bolivar\n0. Salir ")
    option1 = int(input())

    if option1 == 1:
        
        print("Ingrese la cantidad de pesos chilenos: ")
        moneda = int(input())

        print("Seleccione el tipo de moneda a convertir:\n1. US Dolar\n2. Euro\n3. Bolivar")
        option2 = int(input())

        if option2 == 1:
            result = moneda / 917.43
            print("\nEl resultado es: ", round(result)," US Dolares.\n" )

        if option2 == 2:
            result = moneda / 990.10
            print("\nEl resultado es: ", round(result)," Euros.\n" )

        if option2 == 3:
            result = moneda / 13.47
            print("\nEl resultado es: ", round(result)," Bolivares.\n" )

    if option1 == 2:
        
        print("Ingrese la cantidad de dolares estadounidenses: ")
        moneda = int(input())

        print("Seleccione el tipo de moneda a convertir:\n1. Peso Chileno\n2. Euro\n3. Bolivar")
        option2 = int(input())

        if option2 == 1:
            result = moneda / 0.0011
            print("\nEl resultado es: ", round(result)," Pesos Chilenos.\n" )

        if option2 == 2:
            result = moneda / 1.08
            print("\nEl resultado es: ", round(result)," Euros.\n" )

        if option2 == 3:
            result = moneda / 0.015
            print("\nEl resultado es: ", round(result)," Bolivares.\n" )

    if option1 == 3:
        
        print("Ingrese la cantidad de Euros: ")
        moneda = int(input())

        print("Seleccione el tipo de moneda a convertir:\n1. Peso Chileno\n2. US Dolar\n3. Bolivar")
        option2 = int(input())

        if option2 == 1:
            result = moneda / 0.0010
            print("\nEl resultado es: ", round(result)," Pesos Chilenos.\n" )

        if option2 == 2:
            result = moneda / 0.93
            print("\nEl resultado es: ", round(result)," Dolares Estadounidenses.\n" )

        if option2 == 3:
            result = moneda / 0.014
            print("\nEl resultado es: ", round(result)," Bolivares.\n" )
            
          
    if option1 == 4:
        
        print("Ingrese la cantidad de Bolivares: ")
        moneda = int(input())

        print("Seleccione el tipo de moneda a convertir:\n1. Peso Chileno\n2. US Dolar\n3. Euro")
        option2 = int(input())

        if option2 == 1:
            result = moneda / 0.074
            print("\nEl resultado es: ", round(result)," Pesos Chilenos.\n" )

        if option2 == 2:
            result = moneda / 68.31
            print("\nEl resultado es: ", round(result)," Dolares Estadounidenses.\n" )

        if option2 == 3:
            result = moneda / 73.86
            print("\nEl resultado es: ", round(result)," Euros.\n" )

    if option1 == 0:
        print("\nHasta pronto.")
        exit = True