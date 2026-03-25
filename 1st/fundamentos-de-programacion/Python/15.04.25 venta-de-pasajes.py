cant_pasajes = 0
precio_pasaje = 0
suma_pasajes = 0
suma_exitosa = True

try: 
    print ("----- Venta de pasajes -----")
    print ("Cuantos pasajes desea vender?")
    cant_pasajes = int(input())


    for i in range(cant_pasajes):
        try:
            print("Ingrese precio del pasaje:", i)
            precio_pasaje = int(input())
            suma_pasajes = suma_pasajes + precio_pasaje
        except ValueError:
            print("Error, debe ingresar un numero entero...")
            suma_exitosa = False
            break

    if suma_exitosa == True:
        print("El monto a cobrar es:", suma_pasajes)    
    
except ValueError:
    print("Error, debe ingresar un numero entero...")