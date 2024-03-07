package com.ecodeup.jdbc;

public class Cliente {
    private String nombre;
    private String correo;
    private int id;
    // Constructor
    public Cliente(String nombre, String correo,int id) {
        this.nombre = nombre;
        this.correo = correo;
        this.id=id;
    }

    // Getters y setters
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCorreo() {
        return correo;
    }
    public int getId(){
        return  id;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }
}
