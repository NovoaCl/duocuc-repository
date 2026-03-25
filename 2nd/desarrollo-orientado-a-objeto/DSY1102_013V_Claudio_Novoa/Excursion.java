/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ev2;

/**
 *
 * @author Cetecom
 */
public class Excursion implements Promocion {

    private String nombre, dificultad;
    private int codigo, duracion, precioBase;

    public Excursion() {
    }

    public Excursion(String nombre, String dificultad, int codigo, int duracion, int precioBase) {
        this.nombre = nombre;
        this.dificultad = dificultad;
        this.codigo = codigo;
        this.duracion = duracion;
        this.precioBase = precioBase;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDificultad() {
        return dificultad;
    }

    public void setDificultad(String dificultad) {
        this.dificultad = dificultad;
    }

    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }

    public int getDuracion() {
        return duracion;
    }

    public void setDuracion(int duracion) {
        this.duracion = duracion;
    }

    public int getPrecioBase() {
        return precioBase;
    }

    public void setPrecioBase(int precioBase) {
        this.precioBase = precioBase;
    }

    public void disminuirBase() {
        if (dificultad.compareToIgnoreCase("baja") != 0) {
            precioBase -= (int) precioBase * 0.1;
        }
    }

    @Override
    public String toString() {
        return "Excursion{" + "nombre=" + nombre + ", dificultad=" + dificultad + ", codigo=" + codigo + ", duracion=" + duracion + ", precioBase=" + precioBase + '}';
    }

    @Override
    public double aplicarDescuento() {
        int descuento = 0;
        if (duracion > 5 && dificultad.compareToIgnoreCase("alta") == 0) {
            descuento = (int) (precioBase * DTO_TEM);
            precioBase -= descuento;
        }
        return descuento;
    }
}
