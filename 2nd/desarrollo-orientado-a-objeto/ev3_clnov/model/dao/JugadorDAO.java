/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ev3_clnov.model.dao;

import com.mycompany.ev3_clnov.model.dto.Jugador;
import com.mycompany.ev3_clnov.model.db.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class JugadorDAO {
    
    public void registrar(Jugador j) throws SQLException {

        String sql = "INSERT INTO jugador (nombre, energia) "
                   + "VALUES (?, ?)";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, j.getNombre());
            ps.setInt(2, j.getEnergia());
       
            ps.executeUpdate();
        }
    }

    public List<Jugador> listar() throws SQLException {
        List<Jugador> lista = new ArrayList<>();

        String sql = "SELECT * FROM jugador";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Jugador j = new Jugador();
                j.setNombre(rs.getString("nombre"));
                j.setEnergia(rs.getInt("energia"));
               

                lista.add(j);
            }
        }
        return lista;
    }


  

}
