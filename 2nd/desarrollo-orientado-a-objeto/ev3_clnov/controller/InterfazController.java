/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ev3_clnov.controller;

import com.mycompany.ev3_clnov.model.dao.JugadorDAO;
import com.mycompany.ev3_clnov.model.dto.Jugador;
import com.mycompany.ev3_clnov.service.JugadorService;
import com.mycompany.ev3_clnov.view.Interfaz;
import java.util.List;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

public class InterfazController {
    
      private Interfaz vista;

    public InterfazController(Interfaz vista) {
        this.vista = vista;
        escucharEventos();
    }

    private void escucharEventos() {
        vista.btnAgregar.addActionListener(e -> agregar());
        vista.btnLimpiar.addActionListener(e -> limpiar());
        vista.btnCargar.addActionListener(e -> cargar());
        vista.btnSalir.addActionListener(e -> salir());
    }

    private void agregar() {
        String nombre = vista.txtNombre.getText();
        Integer energia =Integer.parseInt(vista.txtEnergia.getText());

        Jugador jugador = new Jugador(nombre, energia);

        try {
            JugadorService js = new JugadorService();
            js.registarAuto(jugador);
            JOptionPane.showMessageDialog(vista, "Jugador agregado con exito");
            limpiar();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(vista, "Se produjo un error: " + e);
        }
    }

    public void limpiar() {
        vista.txtEnergia.setText(null);
        vista.txtNombre.setText(null);
    }

 public void cargar() {
    String[] columnas = {"Nombre", "Energia"};
    DefaultTableModel modelo = new DefaultTableModel(columnas, 0);
    JugadorDAO jd = new JugadorDAO();

    try {
        List<Jugador> listJugadores = jd.listar(); 

        for (Jugador j : listJugadores) {
            Object[] fila = {
                j.getNombre(),
                j.getEnergia()
            };
            modelo.addRow(fila);
        }

        vista.tblListar.setModel(modelo); 

    } catch (Exception e) {
        e.printStackTrace(); 
        JOptionPane.showMessageDialog(null, "Error al cargar datos: " + e.getMessage());
    }
}

    public void salir() {
        vista.dispose();
    }
}
