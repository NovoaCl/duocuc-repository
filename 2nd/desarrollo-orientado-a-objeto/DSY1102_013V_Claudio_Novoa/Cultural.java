/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ev2;

/**
 *
 * @author Cetecom
 */
public class Cultural extends Excursion {

    private String destinoHistorico, idiomaGuia;

    public Cultural() {
    }

    public Cultural(String destinoHistorico, String idiomaGuia) {
        this.destinoHistorico = destinoHistorico;
        this.idiomaGuia = idiomaGuia;
    }

    public Cultural(String destinoHistorico, String idiomaGuia, String nombre, String dificultad, int codigo, int duracion, int precioBase) {
        super(nombre, dificultad, codigo, duracion, precioBase);
        this.destinoHistorico = destinoHistorico;
        this.idiomaGuia = idiomaGuia;
    }

    public String getDestinoHistorico() {
        return destinoHistorico;
    }

    public void setDestinoHistorico(String destinoHistorico) {
        this.destinoHistorico = destinoHistorico;
    }

    public String getIdiomaGuia() {
        return idiomaGuia;
    }

    public void setIdiomaGuia(String idiomaGuia) {
        this.idiomaGuia = idiomaGuia;
    }

    public int calcularCostoAdicional(int x) {

        int adicional = 0;
        if (idiomaGuia.equalsIgnoreCase("inglés")) {
            adicional = (int) (super.getPrecioBase() * (x / 100));
        }
        return adicional;
    }

    @Override
    public String toString() {
        return "Culturales{" + "destinoHistorico=" + destinoHistorico + ", idiomaGuia=" + idiomaGuia + '}';
    }

}
