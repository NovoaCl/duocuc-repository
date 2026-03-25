matricula = 90000
arancel = 1800000

print("Calculadora para finanzas educacionales.")
promedio = float(input("Por favor ingrese su promedio de notas:\n"))
quintil = int(input("Por favor ingrese el quintil al que pertenece:\n"))

if (promedio > 6):
    if (quintil == 1 or quintil == 2):
        arancel = arancel * 0.8

    if (quintil == 3 or quintil == 4):
        arancel = arancel * 0.85
        
if (promedio > 5 and promedio <= 6 ):
    if (quintil == 1 or quintil == 2):
        arancel = arancel * 0.87

    if (quintil == 3 or quintil == 4):
        arancel = arancel * 0.9
        
if (quintil >=1 and quintil <= 3):
    if(promedio >= 5.5):
        matricula = matricula * 0.85
    else:
        matricula = matricula * 0.9
        
        
print(f"El valor de la matrícula es: ${round(matricula)}, y el valor del arancel es: ${round(arancel)}")

        

    
    

