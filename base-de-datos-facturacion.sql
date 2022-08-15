CREATE DATABASE db_facturacion;

USE db_facturacion;

CREATE TABLE tb_cliente(
  codigo int,
  nit,
  nombre varchar (80),
  telefono,
  direccion text,
  
  PRIMARY KEY (codigo)
);
