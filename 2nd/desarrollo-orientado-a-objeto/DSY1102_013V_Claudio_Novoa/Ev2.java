/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */
package com.mycompany.ev2;

import java.util.Scanner;

/**
 *
 * @author Cetecom
 */
public class Ev2 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        Catalogo catalogo = new Catalogo();
        int opcMenu = 0, opcTipoExcursion = 0, opcDeporte = 0;

        do {
            System.out.println("--- Bucólico S.A ---\n"
                    + "Ingrese una opcion:\n"
                    + "1. Ingresar Excursión: permite agregar una Excursión de Aventura o Cultural.\n"
                    + "2. Mostrar Información: mostrar toda la información de una excursión.\n"
                    + "3. Aplicar Ajuste de Precio: ejecuta el método aplicarAjusteATodas.\n"
                    + "4. Eliminar excursión.\n"
                    + "5. Salir.");
            System.out.println("Ingrese Opción: ");
            opcMenu = Integer.parseInt(sc.nextLine());

            switch (opcMenu) {
                case 1:

                    String nombre,
                     dificultad;
                    int codigo,
                     duracion,
                     precioBase;

                    System.out.println("Porfavor ingrese el nombre de la excursion: ");
                    nombre = sc.nextLine();

                    do {
                        System.out.println("Porfavor ingrese la difucultad de la excursion(baja/ media/ alta):");
                        dificultad = sc.nextLine();
                    } while (dificultad.compareToIgnoreCase("baja") != 0
                            && dificultad.compareToIgnoreCase("media") != 0
                            && dificultad.compareToIgnoreCase("alta") != 0);

                    System.out.println("Porfavor ingrese el código de la excursion");
                    codigo = Integer.parseInt(sc.nextLine());

                    System.out.println("Porfavor ingrese la duración de la excursion");
                    duracion = Integer.parseInt(sc.nextLine());

                    System.out.println("Porfavor ingrese el precio base de la excursion");
                    precioBase = Integer.parseInt(sc.nextLine());

                    do {
                        System.out.println("Porfavor ingrese el tipo de excursion:\n"
                                + "1. Aventura.\n"
                                + "2. Cultural.");
                        opcTipoExcursion = Integer.parseInt(sc.nextLine());
                    } while (opcTipoExcursion != 1 && opcTipoExcursion != 2);

                    if (opcTipoExcursion == 1) {
                        String deporte, equipamiento;
                        do {
                            System.out.println("Porfavor seleccione el tipo de deporte:\n"
                                    + "1. Rafting.\n"
                                    + "2. Escalada. \n"
                                    + "3. Trekking. ");
                            opcDeporte = Integer.parseInt(sc.nextLine());
                        } while (opcDeporte != 1 && opcDeporte != 2 && opcDeporte != 3);
                        switch (opcDeporte) {
                            case 1:
                                deporte = "Rafting";
                                break;
                            case 2:
                                deporte = "Escalada";
                                break;
                            case 3:
                                deporte = "Trekking";
                                break;
                        }
                        
                        System.out.println("Porfavor ingrese equipamiento: ");
                        equipamiento = sc.nextLine();
                        Aventura av = new Aventura(deporte, equipamiento, nombre, dificultad, codigo, duracion, precioBase);
                        catalogo.agregarExcursion(av);

                    } else {
                        String destinoHistorico, idiomaGuia;

                        System.out.println("Porfavor ingrese destino historico: ");
                        destinoHistorico = sc.nextLine();

                        System.out.println("Porfavor ingrese idioma del guia: ");
                        idiomaGuia = sc.nextLine();

                        Cultural cul = new Cultural(destinoHistorico, idiomaGuia, nombre, dificultad, codigo, duracion, precioBase);
                        catalogo.agregarExcursion(cul);
                    }
                    break;
                case 2:
                    System.out.println("Porfavor ingrese el código de la excursion: ");
                    codigo = Integer.parseInt(sc.nextLine());
                    Excursion excursionBuscada = catalogo.buscarExcursion(codigo);
                    if (excursionBuscada != null) {
                        System.out.println(excursionBuscada.toString());
                    } else {
                        System.out.println("No se encontro la excursion");
                    }
                    break;
                case 3:
                    catalogo.aplicarAjusteATodas();
                    System.out.println("Se ha aplicado el ajuste de precio a todas las excursiones.");

                    break;
                case 4:
                    System.out.println("Porfavor ingrese el codigo de la excursion a eliminar: ");
                    codigo = Integer.parseInt(sc.nextLine());
                    boolean eliminada = catalogo.eliminarExcursion(codigo);
                    if (eliminada) {
                        System.out.println("Excursion eliminada con exito.");
                    } else {
                        System.out.println("No se encontro la excursion");
                    }
                    break;
                case 5:
                    System.out.println("Hasta pronto");
                    break;
                default:
                    System.out.println("Porfavor ingrese una opcion válida...");
            }

        } while (opcMenu != 5);
    }
}
