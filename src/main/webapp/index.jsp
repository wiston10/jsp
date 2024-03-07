<%@ page import="java.io.*,java.net.*,java.util.*" %>
<%@ page import="com.google.gson.Gson" %>
<!DOCTYPE html>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*,java.net.*,java.util.*" %>
<%@ page import="com.google.gson.Gson" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Listado de Clientes</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        #clientesTable {
            width: 100%;
            border-collapse: collapse;
        }

        #clientesTable th,
        #clientesTable td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        #clientesTable th {
            background-color: #f2f2f2;
        }

        #clientesTable tbody tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        #addUserButton {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        #addUserButton:hover {
            background-color: #0056b3;
        }

        #addUserModal {
            display: none;
        }

        #addUserModal .modal-content {
            width: 400px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.1);
        }

        #addUserModal h5 {
            text-align: center;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        #addUserModal form {
            padding: 20px;
        }

        #addUserModal label {
            display: block;
            margin-bottom: 10px;
        }

        #addUserModal input[type="text"],
        #addUserModal input[type="email"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        #addUserModal button[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        #addUserModal button[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Listado de Clientes</h2>
        <!-- Botón para agregar usuario -->
        <button id="addUserButton">Agregar Usuario</button>

        <!-- Modal para agregar usuario -->
        <div id="addUserModal" class="modal">
            <div class="modal-content">
                <h5>Agregar Nuevo Usuario</h5>
                <form id="addUserForm">
                    <label for="nombre">Nombre:</label>
                    <input type="text" id="nombre" name="nombre" required>
                    <label for="correo">Correo:</label>
                    <input type="email" id="correo" name="correo" required>
                    <button type="submit">Agregar</button>
                </form>
            </div>
        </div>

        <!-- Tabla para mostrar los clientes -->
        <table id="clientesTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Correo</th>
                    <th>acciones</th>
                </tr>
            </thead>
            <tbody>
                <!-- Los datos de los clientes se cargarán aquí dinámicamente -->
            </tbody>
        </table>
        <div id="editUserModal" class="modal">
            <div class="modal-content">
                <h5>Editar Usuario</h5>
               <form id="editUserForm">
                   <div>
                       <label>ID:</label>
                       <span id="editIdDisplay"></span>
                   </div>
                   <label for="editNombre">Nombre:</label>
                   <input type="text" id="editNombre" name="nombre" required>
                   <label for="editCorreo">Correo:</label>
                   <input type="email" id="editCorreo" name="correo" required>
                   <button type="button" onclick="editclientedata()">Guardar Cambios</button>
               </form>

            </div>
        </div>
    </div>

    <!-- Agregar enlaces a los archivos JavaScript de Bootstrap y tu código personalizado -->
    <script>
        function crearcliente() {
            const formData = new FormData(document.getElementById('addUserForm')); // Obtener los datos del formulario
            var nombre = document.getElementById('nombre').value;
            var correo = document.getElementById('correo').value;
            var clienteData = {
                nombre: nombre,
                correo: correo
            };
            fetch('/jsp/cliente', { // Realizar una solicitud POST al servlet
                method: 'POST',
                body: JSON.stringify(clienteData) // Enviar los datos del formulario en el cuerpo de la solicitud
            })
            .then(response => {
                if (response.ok) {
                    cargarClientes();
                    document.getElementById('nombre').value = '';
                    document.getElementById('correo').value = '';
                } else {
                    throw new Error('Error al agregar el cliente');
                }
            })
            .catch(error => {
                console.error('Error al agregar el cliente:', error);
            });
        }
        function editarcliente(id, nombre, correo){
                    document.getElementById('editIdDisplay').textContent = id;
                       document.getElementById('editNombre').value = nombre;
                       document.getElementById('editCorreo').value = correo;

                       var modal = document.getElementById('editUserModal');
                       modal.style.display = 'block';
        }
        function editclientedata(){
           const formData = new FormData(document.getElementById('editUserForm')); // Obtener los datos del formulario
               var id = parseInt(document.getElementById('editIdDisplay').textContent);
               var nombre = document.getElementById('editNombre').value;
               var correo = document.getElementById('editCorreo').value;
               var clienteData = {
                   id: id, // Utiliza el ID obtenido del span
                   nombre: nombre,
                   correo: correo
               };

               fetch('/jsp/cliente', { // Realizar una solicitud POST al servlet
                   method: 'PUT',
                   body: JSON.stringify(clienteData) // Enviar los datos del formulario en el cuerpo de la solicitud
               })
               .then(response => {
                   if (response.ok) {

                       // Limpiar los campos después de la edición
                      document.getElementById('editNombre').value = '';
                       document.getElementById('editCorreo').value = '';
                       // Cerrar el modal después de la edición
                       var modal = document.getElementById('editUserModal');
                      modal.style.display = 'none';

                        console.log("chido")
                        cargarClientes();
                   } else {
                       throw new Error('Error al editar el cliente');
                   }
               })
               .catch(error => {
                   console.error('Error al editar el cliente:', error);
               });

        }
       function borrarCliente(id) {
           fetch(`/jsp/cliente?id=${id}`, {
               method: 'DELETE'
           })
           .then(response => {
               if (response.ok) {
                   // Si la solicitud es exitosa, volver a cargar los clientes para actualizar la tabla
                   cargarClientes();
               } else {
                   // Si la solicitud falla, mostrar un mensaje de error
                   throw new Error('Error al borrar el cliente');
               }
           })
           .catch(error => {
               console.error('Error al borrar el cliente:', error);
           });
       }
        function cargarClientes() {
            fetch('/jsp/cliente') // Realiza una solicitud GET al servlet
                .then(response => response.json()) // Convierte la respuesta a JSON
                .then(data => {
                    const clientesTable = document.getElementById('clientesTable').getElementsByTagName('tbody')[0];
                    clientesTable.innerHTML = ''; // Limpiar la tabla antes de agregar nuevos datos
                    data.forEach(cliente => {
                        const row = `<tr>
                            <td>${cliente.id}</td>
                            <td>${cliente.nombre}</td>
                            <td>${cliente.correo}</td>
                          <td>
                             <button onclick="borrarCliente(${cliente.id})">Borrar</button>
                            <button onclick="editarcliente(${cliente.id}, '${cliente.nombre}', '${cliente.correo}')">Editar</button>

                          </td>
                        </tr>`;
                        clientesTable.innerHTML += row; // Agrega la fila a la tabla
                    });
                })
                .catch(error => {
                    console.error('Error al cargar los clientes:', error);
                });
        }

        // Ejecutar la función para cargar los clientes al cargar la página
        cargarClientes();

        // JavaScript para mostrar y ocultar el modal de agregar usuario
        var modal = document.getElementById('addUserModal');
        var addUserButton = document.getElementById('addUserButton');
        addUserButton.addEventListener('click', function() {
            modal.style.display = 'block';
        });

        // JavaScript para enviar el formulario de agregar usuario
        var addUserForm = document.getElementById('addUserForm');
        addUserForm.addEventListener('submit', function(event) {
            event.preventDefault(); // Evita que el formulario se envíe automáticamente
            crearcliente();
            modal.style.display = 'none';
        });
    </script>
</body>
</html>
