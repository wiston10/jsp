package com.ecodeup.jdbc;
import java.io.BufferedReader;
import java.util.List;
import java.util.Map;
import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/cliente")
public class ejemploJdbc extends HttpServlet {

    private static final String url ="jdbc:mysql://localhost:3306/exampledb";
    private static final String username = "root";
    private static final String password = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Lee el cuerpo de la solicitud y convierte los datos JSON en un objeto Java
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String requestBody = sb.toString();

        // Parsea el cuerpo de la solicitud a un objeto JSON utilizando una biblioteca como Gson
        Gson gson = new Gson();
        Cliente cliente = gson.fromJson(requestBody, Cliente.class); // Suponiendo que tienes una clase Cliente

        // Obtiene los valores de nombre y correo del objeto cliente
        String nombre = cliente.getNombre();
        String correo = cliente.getCorreo();

        // Ahora puedes realizar las operaciones necesarias con los datos del cliente, como almacenarlos en una base de datos, etc.

        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement("INSERT INTO CLIENTES (nombre, correo) VALUES (?, ?)")) {
            statement.setString(1, nombre);
            statement.setString(2, correo);
            statement.executeUpdate();
            response.getWriter().println("Cliente agregado correctamente.");
        } catch (SQLException e) {
            e.printStackTrace(); // Esto imprimirá el error en la consola del servidor
            String errorMessage = "Error al AGREGAR: " + e.getMessage();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println(errorMessage);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection connection = DriverManager.getConnection(url, username, password);
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery("SELECT * FROM CLIENTES")) {

            // Creamos una lista para almacenar los datos de los clientes
            List<Map<String, Object>> clientes = new ArrayList<>();

            // Iteramos sobre el resultado y agregamos cada cliente a la lista
            while (resultSet.next()) {
                Map<String, Object> cliente = new HashMap<>(); // Corregido
                cliente.put("id", resultSet.getInt("id"));
                cliente.put("nombre", resultSet.getString("nombre"));
                cliente.put("correo", resultSet.getString("correo"));
                clientes.add(cliente); // Corregido
            }

            // Convertimos la lista a formato JSON
            Gson gson = new Gson();
            String jsonClientes = gson.toJson(clientes);

            // Enviamos la respuesta al cliente en formato JSON
            response.setContentType("application/json");
            response.getWriter().write(jsonClientes);

        } catch (SQLException e) {
            e.printStackTrace(); // Esto imprimirá el error en la consola del servidor
            String errorMessage = "Error al obtener los clientes: " + e.getMessage();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println(errorMessage);
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Lee el cuerpo de la solicitud y convierte los datos JSON en un objeto Java
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String requestBody = sb.toString();

        // Parsea el cuerpo de la solicitud a un objeto JSON utilizando una biblioteca como Gson
        Gson gson = new Gson();
        Cliente cliente = gson.fromJson(requestBody, Cliente.class); // Suponiendo que tienes una clase Cliente

        // Obtiene los valores de id, nombre y correo del objeto cliente
        int id = cliente.getId();
        String nuevoNombre = cliente.getNombre();
        String nuevoCorreo = cliente.getCorreo();


        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement("UPDATE CLIENTES SET nombre = ?, correo = ? WHERE id = ?")) {
            statement.setString(1, nuevoNombre);
            statement.setString(2, nuevoCorreo);
            statement.setInt(3, id);
            int filasActualizadas = statement.executeUpdate();
            if (filasActualizadas > 0) {
                response.getWriter().println("Cliente actualizado correctamente.");
            } else {
                response.getWriter().println("No se encontró ningún cliente con el ID proporcionado.");
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Esto imprimirá el error en la consola del servidor
            String errorMessage = "Error al ACTUALIZAR: " + e.getMessage();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println(errorMessage);
        }

    }


    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection connection = DriverManager.getConnection(url, username, password);
             PreparedStatement statement = connection.prepareStatement("DELETE FROM CLIENTES WHERE id = ?")) {
            statement.setInt(1, id);
            int filasEliminadas = statement.executeUpdate();
            if (filasEliminadas > 0) {
                response.getWriter().println("Cliente eliminado correctamente.");
            } else {
                response.getWriter().println("No se encontró ningún cliente con el ID proporcionado.");
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Esto imprimirá el error en la consola del servidor
            String errorMessage = "Error al borrar: " + e.getMessage();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println(errorMessage);
        }
    }
}
