/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.ev3_clnov;

import com.mycompany.ev3_clnov.controller.InterfazController;
import com.mycompany.ev3_clnov.view.Interfaz;

/**
 *
 * @author Cetecom
 */
public class Ev3_clnov {

    public static void main(String[] args) {
        Interfaz interfaz = new Interfaz();
        interfaz.setAlwaysOnTop(true);
        interfaz.setLocationRelativeTo(null);
        interfaz.setVisible(true);
        InterfazController menucontroller = new InterfazController(interfaz);
    }
}
