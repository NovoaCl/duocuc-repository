
package com.mycompany.autoview;


public class Master {}


//EV2

public class Master {

    Scanner sc = new Scanner(System.in);
    Catalogo ca = new Catalogo();
    int opcMenu = 0, opcTipoTour = 0;

        do {
        System.out.println("Último Viaje S.A – Cementerio General\n"
                + "1. Ingresar Tour: permite agregar un Tour Histórico o Cultural.\n"
                + "2. Mostrar Información: mostrar toda la información de un tour.\n"
                + "3. Aplicar Ajuste de Precio: ejecuta aplicarAjusteATodos().\n"
                + "4. Eliminar Tour.\n"
                + "5. Salir.");
        System.out.println("Ingrese Opción: ");
        opcMenu = Integer.parseInt(sc.nextLine());

        switch (opcMenu) {
            case 1:
                int codigo = 0,
                        precioBase = 0,
                        duracionHoras = 0;

                String nombre,
                        dificultad,
                        tematicaprincipal,
                        equipamiento,
                        tipoRecorrido,
                        sectorPatrimonial,
                        idiomaGuia;

                System.out.println("Creando un Tour, ingrese datos");
                System.out.println("Codigo: ");
                codigo = Integer.parseInt(sc.nextLine());
                ;
                System.out.println("Nombre: ");
                nombre = sc.nextLine();
                do {
                    System.out.println("Dificultad baja/media/alta: ");
                    dificultad = sc.nextLine();
                } while (dificultad.compareToIgnoreCase("baja") != 0
                        && dificultad.compareToIgnoreCase("media") != 0
                        && dificultad.compareToIgnoreCase("alta") != 0);
                System.out.print("Horas que dura el Tour: ");
                duracionHoras = Integer.parseInt(sc.nextLine());
                System.out.println("Precio base: ");
                precioBase = Integer.parseInt(sc.nextLine());

                do {
                    System.out.println("Que Tour ingresará");
                    System.out.println("[1]Historico");
                    System.out.println("[2]Cultural\n");
                    opcTipoTour = Integer.parseInt(sc.nextLine());
                } while (opcTipoTour != 1 && opcTipoTour != 2);
                if (opcTipoTour == 1) {
                    System.out.println("Ingrese tipo de tematica: ");
                    tematicaprincipal = sc.nextLine();
                    System.out.println("Equipamiento: ");
                    equipamiento = sc.nextLine();
                    do {
                        System.out.println("Tipo Recorrido (Diurno/Nocturno): ");
                        tipoRecorrido = sc.nextLine();
                    } while (tipoRecorrido.compareToIgnoreCase("diurno") != 0
                            && tipoRecorrido.compareToIgnoreCase("nocturno") != 0);
                    Historico his = new Historico(tematicaprincipal, equipamiento, tipoRecorrido, codigo, precioBase, duracionHoras, nombre, dificultad);
                    ca.calcularDescuentoTotal(his);
                    ca.agregarTour(his);
                } else {
                    System.out.println("sector Patrimonial: ");
                    sectorPatrimonial = sc.nextLine();
                    System.out.println("Idioma del guia: ");
                    idiomaGuia = sc.nextLine();
                    Cultural cul = new Cultural(sectorPatrimonial, idiomaGuia, codigo, precioBase, duracionHoras, nombre, dificultad);
                    ca.calcularDescuentoTotal(cul);
                    ca.agregarTour(cul);
                }

                break;
            case 2:
                System.out.println("Ingrese Codigo a buscar: ");
                codigo = Integer.parseInt(sc.nextLine());
                Tour tourBuscado = ca.buscarTour(codigo);
                if (tourBuscado != null) {
                    System.out.println(tourBuscado.toString());
                } else {
                    System.out.println("No se encontro tour");
                }
                break;
            case 3:

                break;
            case 4:
                System.out.println("Ingrese Codigo a buscar: ");
                codigo = Integer.parseInt(sc.nextLine());
                boolean eliminado = ca.eliminarTour(codigo);
                if (eliminado) {
                    System.out.println("Tour Eliminado");
                } else {
                    System.out.println("No se encontro tour");
                }
                break;
            case 5:
                System.out.println("Cerrando APP!!!!");
                break;
            default:
                System.out.println("Opcion ingresada no es valida");
        }

    } while (opcMenu != 5);

        // Tour

    @Override
    public double aplicarDescuento()
    {
        int descuento=0;
        if(duracionHoras>5 && dificultad.compareToIgnoreCase("alta")==0)
        {
            descuento=(int)(precioBase*DTO_TEM);
            precioBase -= descuento;
        }
        return descuento;
    }

    public abstract int calcularCostoAdicional(int x);


    //Historico

    @Override
    public int calcularCostoAdicional(int x) {

        int adicional=0;
        if(tipoRecorrido.equalsIgnoreCase("nocturno"))
        {
            adicional=(int)(super.getPrecioBase()*(x/100.0));
        }
        return adicional;

    }

    //Cultural

    @Override
    public int calcularCostoAdicional(int x) {

        int adicional=0;
        if(idiomaGuia.equalsIgnoreCase("inglés"))
        {
            adicional=(int)(super.getPrecioBase()*(x/100));
        }
        return adicional;
    }


    //Catalogo
    public class Catalogo {

        private List<Tour> tours = new ArrayList<Tour>();

        public Catalogo() {
        }

        public List<Tour> getTours() {
            return tours;
        }

        public void setTours(List<Tour> tours) {
            this.tours = tours;
        }

        //Metodos:
        public void agregarTour(Tour t) {
            this.tours.add(t);
        }

        public Tour buscarTour(int codigo) {
            for (Tour tour : tours) {
                if (tour.getCodigo() == codigo) {
                    return tour;
                }
            }
            return null;
        }

        public void aplicarAjusteATodos() {
            for (Tour tour : tours) {
                tour.disminuirBase();
            }
        }

        public void calcularDescuentoTotal(Tour t) {
            int porecioFinal = 0;
            t.setPrecioBase(t.getPrecioBase() + t.calcularCostoAdicional(25));
            t.setPrecioBase(t.getPrecioBase() - (int) t.aplicarDescuento());
        }

        public boolean eliminarTour(int codigo) {
            for (Tour tour : tours) {
                if (tour.getCodigo() == codigo) {
                    tours.remove(tour);
                    return true;
                }
            }
            return false;
        }

    }

    //Promocion
    public interface Promocion {
        public final double DTO_TEM=0.15;
        public abstract double aplicarDescuento();

    }

}


//EV3


//----------------------------- CONTROLLER -----------------------------

public class MenuController {

    private Menu vista;

    public MenuController(Menu vista) {
        this.vista = vista;
        escucharEventos();
    }

    private void escucharEventos() {
        vista.btnGuardar.addActionListener(e -> guardar());
        vista.btnLimpiar.addActionListener(e -> limpiar());
        vista.btnCargar.addActionListener(e -> cargar());
        vista.btnSalir.addActionListener(e -> salir());
    }

    private void guardar() {
        String marca = vista.txtMarca.getText();
        String color = vista.txtColor.getText();

        Auto auto = new Auto(marca, color);

        try {
            AutoService as = new AutoService();
            as.registarAuto(auto);
            JOptionPane.showMessageDialog(vista, "Auto agregado con exito");
            limpiar();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(vista, "Se produjo un error: " + e);
        }
    }

    public void limpiar() {
        vista.txtMarca.setText(null);
        vista.txtColor.setText(null);
    }

 public void cargar() {
    String[] columnas = {"Marca", "Color"};
    DefaultTableModel modelo = new DefaultTableModel(columnas, 0);
    AutoDAO as = new AutoDAO();

    try {
        List<Auto> listAutos = as.listar(); // ✅ nombre correcto del método

        for (Auto a : listAutos) {
            Object[] fila = {
                a.getMarca(),
                a.getColor()
            };
            modelo.addRow(fila);
        }

        vista.tblListar.setModel(modelo); // ✅ solo una vez

    } catch (Exception e) {
        e.printStackTrace(); // ✅ muestra el error real
        JOptionPane.showMessageDialog(null, "Error al cargar datos: " + e.getMessage());
    }
}

    public void salir() {
        vista.dispose();
    }
}

//----------------------------- DAO -----------------------------

public class AutoDAO {

    public void registro(Auto a) throws SQLException {
        String sql = "INSERT INTO auto (marca, color)"
                + "VALUES (?, ?)";
        try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, a.getMarca());
            ps.setString(2, a.getColor());

            ps.executeUpdate();
        }
    }

    public List<Auto> listar() throws SQLException {
        List<Auto> lista = new ArrayList();

        String sql = "SELECT * FROM auto";

        try (Connection conn = ConexionDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Auto a = new Auto();
                a.setMarca(rs.getString("marca"));
                a.setColor(rs.getString("color"));

                lista.add(a);
            }
        }
        return lista;
    }
}

//----------------------------- DB -----------------------------

public class ConexionDB {

    private static final String URL = "jdbc:mysql://localhost:3306/auto?useSSL=false&serverTimezone=America/Santiago";
    private static final String USER = "root";   // XAMPP por defecto
    private static final String PASS = "";       // normalmente vacío

    public static Connection getConnection() throws SQLException {
        try {
            // Driver MySQL 8
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            throw new SQLException("No se encontró el driver de MySQL", ex);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }

}

//----------------------------- SERVICE -----------------------------

public class AutoService {
    
     private final AutoDAO autodao = new AutoDAO();
    
    public void registarAuto(Auto u) throws Exception {
        if (u.getMarca() == null || u.getMarca().isBlank()) {
            throw new Exception("La marca es obigatoria");
        }
        
        autodao.registro(u);
    }
}

//Propuesta Chat

package com.mycompany.autoview;

import java.util.ArrayList;
import java.util.List;


//----------------------------- DAO -----------------------------

public class AutoDAO {

    // Simula la tabla "auto"
    private static final List<Auto> autos = new ArrayList<>();

    public void registro(Auto a) {
        autos.add(a);
    }

    public List<Auto> listar() {
        return new ArrayList<>(autos); // copia para evitar modificaciones externas
    }
}

//----------------------------- SERVICE -----------------------------


package com.mycompany.autoview;

public class AutoService {

    private final AutoDAO autodao = new AutoDAO();

    public void registarAuto(Auto u) throws Exception {
        if (u.getMarca() == null || u.getMarca().isBlank()) {
            throw new Exception("La marca es obligatoria");
        }

        autodao.registro(u);
    }
}


//----------------------------- CONTROLLER ------------

package com.mycompany.autoview;

import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
import java.util.List;

public class MenuController {

    private Menu vista;

    public MenuController(Menu vista) {
        this.vista = vista;
        escucharEventos();
    }

    private void escucharEventos() {
        vista.btnGuardar.addActionListener(e -> guardar());
        vista.btnLimpiar.addActionListener(e -> limpiar());
        vista.btnCargar.addActionListener(e -> cargar());
        vista.btnSalir.addActionListener(e -> salir());
    }

    private void guardar() {
        String marca = vista.txtMarca.getText();
        String color = vista.txtColor.getText();

        Auto auto = new Auto(marca, color);

        try {
            AutoService as = new AutoService();
            as.registarAuto(auto);
            JOptionPane.showMessageDialog(vista, "Auto agregado con éxito");
            limpiar();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(vista, "Error: " + e.getMessage());
        }
    }

    public void limpiar() {
        vista.txtMarca.setText(null);
        vista.txtColor.setText(null);
    }

    public void cargar() {
        String[] columnas = {"Marca", "Color"};
        DefaultTableModel modelo = new DefaultTableModel(columnas, 0);
        AutoDAO as = new AutoDAO();

        try {
            List<Auto> listAutos = as.listar();

            for (Auto a : listAutos) {
                Object[] fila = {
                    a.getMarca(),
                    a.getColor()
                };
                modelo.addRow(fila);
            }

            vista.tblListar.setModel(modelo);

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error al cargar datos");
        }
    }

    public void salir() {
        vista.dispose();
    }
}
