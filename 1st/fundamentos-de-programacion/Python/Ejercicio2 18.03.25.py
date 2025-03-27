numero = 0
cont = 1

while cont == 1:
    print("Ingrese un número a validar: ")
    numero = int(input())

    if numero >= 0:
        print("El número es positivo")
    else:
        print("El número es negativo")

    if numero % 2 == 0:
        print("El número es par")
    else:
        print("El número es impar")

    print("Si desea continuar ingrese 1, si no 0.")
    cont = int(input())


edad = 0
print("Ingrese edad: ")
edad = int(input())

if edad >= 18:
    print("Es mayor de edad.")
    if edad >= 60:
        print("Es adulto mayor")
        if edad >= 100:
            print("Es un dinosaurio.")