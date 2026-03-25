from random import randint

# Pedimos al usuario que ingrese los límites del rango
while True:
    num1 = int(input("Ingrese limite inferior: "))
    num2 = int(input("Ingrese limite superior: "))
    if num1 < num2:
        break
    print("El límite inferior debe ser menor que el superior. Intenta de nuevo.")

# Generamos el número aleatorio
secreto = randint(num1, num2)

# Juego de adivinanza - hasta 3 intentos
intento1 = int(input("Intente adivinar: "))
if intento1 == secreto:
    print("Felicitaciones, adivinó en el primer intento.")
else:
    print("El número es mayor." if intento1 < secreto else "El número es menor.")
    intento2 = int(input("Intente de nuevo: "))
    if intento2 == secreto:
        print("Felicitaciones, adivinó en su segundo intento.")
    else:
        print("El número es mayor." if intento2 < secreto else "El número es menor.")
        # Pista: decir cuál intento estuvo más cerca
        dist1 = abs(secreto - intento1)
        dist2 = abs(secreto - intento2)
        mas_cerca = intento1 if dist1 < dist2 else intento2
        print("Te daré una pista:")
        print(f"El numero que buscas esta mas cerca de {mas_cerca} que de {intento1 if mas_cerca == intento2 else intento2}")
        intento3 = int(input("Intente la ultima vez: "))
        if intento3 == secreto:
            print("Felicitaciones, pudiste adivinar.")
        else:
            print("Perdiste.")
            print(f"El número era: {secreto}")