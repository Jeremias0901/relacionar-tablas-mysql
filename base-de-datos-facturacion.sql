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

  PRIMARY KEY (codigo)
);

CREATE TABLE tb_factura(
  numero int (2),
  fecha datetime,
  codigo_cliente int (2) UNIQUE,
  total_factura decimal,
  
  PRIMARY KEY (numero)
);

CREATE TABLE tb_detalle_factura(
  id int (2) AUTO_INCREMENT,
  numero_factura int (2) UNIQUE,
  codigo_producto int (2) UNIQUE,
  cantidad_pedida decimal,
  precio_total decimal,
  
  PRIMARY KEY (id)
);

/* ============ RELACION DE LAS TABLAS ============ */

ALTER TABLE tb_factura
  ADD CONSTRAINT rl_factura_cliente
  FOREIGN KEY (codigo_cliente) REFERENCES tb_cliente (codigo)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE tb_producto
  ADD CONSTRAINT rl_producto_proveedor
  FOREIGN KEY (proveedor) REFERENCES tb_proveedor (codigo)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE tb_detalle_factura
  ADD CONSTRAINT rl_detalle_factura_factura
  FOREIGN KEY (numero_factura) REFERENCES tb_factura (numero)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  ADD CONSTRAINT rl_detalle_factura_producto
  FOREIGN KEY (codigo_producto) REFERENCES tb_producto (codigo)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
