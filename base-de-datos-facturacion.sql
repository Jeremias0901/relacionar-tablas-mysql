CREATE DATABASE db_facturacion;

USE db_facturacion;

CREATE TABLE tb_cliente(
  codigo int,
  nit int,
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

CREATE TABLE tb_producto(
  codigo int,
  descripcion varchar (100),
  proveedor int UNIQUE,
  precio_costo decimal,
  precio_venta decimal,
  foto text,

  PRIMARY KEY (codigo),
  FOREIGN KEY (proveedor) REFERENCES proveedor (codigo)
);

CREATE TABLE tb_factura(
  numero int,
  fecha datetime,
  codigo_cliente int UNIQUE,
  total_factura decimal,
  
  PRIMARY KEY (numero),
  FOREIGN KEY (codigo_cliente) REFERENCES tb_cliente (codigo)
);

