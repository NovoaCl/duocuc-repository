
package com.mycompany.ev3_clnov.model.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    
        private static final String URL  = "jdbc:mysql://localhost:3307/dsyapp?useSSL=false&serverTimezone=America/Santiago";
    private static final String USER = "root";   // XAMPP por defecto
    private static final String PASS = "";       // normalmente vacío
     
    private static Connection conexion;

    public static Connection getConnection() throws SQLException {
        try {
            // Driver MySQL 8
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            throw new SQLException("No se encontró el driver de MySQL", ex);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
    
    public static void close() throws SQLException {
        conexion.close();
    }

}
