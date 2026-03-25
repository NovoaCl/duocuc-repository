/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ev3_clnov.model.dto;

/**
 *
 * @author Cetecom
 */
public class Jugador {
    
    private String nombre;
    private Integer energia;

    public Jugador() {
    }

    public Jugador(String nombre, Integer energia) {
        this.nombre = nombre;
        this.energia = energia;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Integer getEnergia() {
        return energia;
    }

    public void setEnergia(Integer energia) {
        this.energia = energia;
    }    
}
