from random import randint

print("¡Bienvenidos al juego de la adivinanza! \nPara comenzar se le solicitará ingresar dos números, estos delimitarán un rango de números del cual se seleccionará un número al azar.\nEl objetivo es adivinarlo, para ello, con cada intento se le proporcionará una pista, pero tendrá solamente 3 oportunidades para ganar. \n¡Comencemos!")
while True:
    menor = int(input("Ingrese el número menor: "))
    mayor = int(input("Ingrese el número mayor: "))
    if menor < mayor:
        break
    else:
        print("El primer número debe ser menor que el segundo... \nVamos denuevo.")
        
random = randint(menor, mayor)

primer = int(input(f"Primer intento. Ingrese un número entre {menor} y {mayor}: \n"))

if (primer == random):
    print("Increible, adivinó en el primer intento.")
else:
    if (random < primer):
        print("Ha fallado... El número es menor, vamos denuevo.")   
    else:
        print("Ha fallado... El número es mayor, vamos denuevo.")
    
    segundo = int(input(f"Segundo intento. Ingrese un número entre {menor} y {mayor}: \n"))
    
    if (segundo == random):
        print("Felicidades, adivinó en el segundo intento.")
    else:
        if (random < segundo):
            print("Ha fallado... El número es menor.")   
        else:
            print("Ha fallado... El número es mayor.") 
            
        if (abs(random - primer) < abs(random - segundo)):
            print(f"Le daré una pista, el número está más cerca de {primer} que de {segundo}.")
        else:
            print(f"Le daré una pista, el número está más cerca de {segundo} que de {primer}.")
        
        tercero = int(input(f"Tercer y último intento. Ingrese un número entre {menor} y {mayor}: \n"))   
        
        if (random == tercero):
            print("Felicidades, ha ganado con la última oportunidad.")
        else:
            print(f"Oh no, fin de la partida... El número era {random}.")  
                
            
               