/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ev3_clnov.service;

import com.mycompany.ev3_clnov.model.dao.JugadorDAO;
import com.mycompany.ev3_clnov.model.dto.Jugador;


public class JugadorService {

     private final JugadorDAO jugadordao = new JugadorDAO();
    
    public void registarAuto(Jugador j) throws Exception {
        if (j.getNombre() == null || j.getEnergia() == null) {
            throw new Exception("Los campos son obligatorios...");
        }
        
        jugadordao.registrar(j);
    }
}
   
