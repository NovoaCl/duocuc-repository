/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ev2;

/**
 *
 * @author Cetecom
 */
public class Aventura extends Excursion {

    private String deporte, equipamiento;

    

    public Aventura(String deporte, String equipamiento) {
        this.deporte = deporte;
        this.equipamiento = equipamiento;
    }

    public Aventura(String deporte, String equipamiento, String nombre, String dificultad, int codigo, int duracion, int precioBase) {
        super(nombre, dificultad, codigo, duracion, precioBase);
        this.deporte = deporte;
        this.equipamiento = equipamiento;
    }

    public String getDeporte() {
        return deporte;
    }

    public void setDeporte(String deporte) {
        this.deporte = deporte;
    }

    public String getEquipamiento() {
        return equipamiento;
    }

    public void setEquipamiento(String equipamiento) {
        this.equipamiento = equipamiento;
    }

    public int calcularCostoAdicional(int x) {

        int adicional = 0;
        if (deporte.equalsIgnoreCase("rafting")) {
            adicional = (int) (super.getPrecioBase() * (x / 100));
        }
        return adicional;
    }

    @Override
    public String toString() {
        return "Aventuras{" + "deporte=" + deporte + ", equipamiento=" + equipamiento + '}';
    }
}
