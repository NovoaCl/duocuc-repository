/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ev2;

import static com.mycompany.ev2.Promocion.DTO_TEM;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Cetecom
 */
public class Catalogo {

    private List<Excursion> excursiones = new ArrayList();

    public Catalogo() {
    }

    public List<Excursion> getExcursiones() {
        return excursiones;
    }

    public void setExcursiones(List<Excursion> excursiones) {
        this.excursiones = excursiones;
    }

    public void agregarExcursion(Excursion excursion) {
        this.excursiones.add(excursion);
    }

    public Excursion buscarExcursion(int codigo) {
        for (Excursion excursion : excursiones) {
            if (excursion.getCodigo() == codigo) {
                return excursion;
            }
        }
        return null;
    }

    public void aplicarAjusteATodas() {
        for (Excursion excursion : excursiones) {
            excursion.disminuirBase();
        }
    }

    public void calcularDescuentoTotal() {
        
        int totalDescuento = 0;
        for (Excursion excursion : excursiones) {
            
            if (excursion.getDuracion() > 5 && excursion.getDificultad().compareToIgnoreCase("alta") == 0) {
                totalDescuento += (int)(excursion.getPrecioBase() * DTO_TEM);
            }
            System.out.println("El total del dinero ahorrado por una dificultad alta o una duración mayor a 5 horas es de: " + totalDescuento);
        }
    }

    public boolean eliminarExcursion(int codigo) {
        for (Excursion excursion : excursiones) {
            if (excursion.getCodigo() == codigo) {
                excursiones.remove(excursion);
                return true;
            }
        }
        return false;
    }
}
