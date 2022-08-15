CREATE DATABASE db_facturacion;

USE db_facturacion;

CREATE TABLE tb_cliente(
  codigo int (2),
  nit int (2),
  nombre varchar (80),
  telefono int (2),
  direccion text,
  
  PRIMARY KEY (codigo)
);

CREATE TABLE tb_proveedor(
  codigo int (2),
  proveedor varchar (60),
  telefono int (2),
  direccion text,
  
  PRIMARY KEY (codigo)
);

CREATE TABLE tb_producto(
  codigo int (2),
  descripcion varchar (100),
  proveedor int (2) UNIQUE,
  precio_costo decimal,
  precio_venta decimal,
  foto text,

  PRIMARY KEY (codigo),
  FOREIGN KEY (proveedor) REFERENCES proveedor (codigo)
);

CREATE TABLE tb_factura(
  numero int (2),
  fecha datetime,
  codigo_cliente int (2) UNIQUE,
  total_factura decimal,
  
  PRIMARY KEY (numero),
  FOREIGN KEY (codigo_cliente) REFERENCES tb_cliente (codigo)
);

CREATE TABLE tb_detalle_factura(
  id int (2) AUTO_INCREMENT,
  numero_factura int (2) UNIQUE,
  codigo_producto int (2) UNIQUE,
  cantidad_pedida decimal,
  precio_total decimal,
  
  PRIMARY KEY (id),
  FOREIGN KEY (numero_factura)  REFERENCES tb_factura  (codigo),
  FOREIGN KEY (codigo_producto) REFERENCES tb_producto (codigo)
);
