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

CREATE TABLE tb_proveedor(
  codigo int,
  proveedor varchar (60),
  telefono,
  direccion text,
  
  PRIMARY KEY (codigo)
);
