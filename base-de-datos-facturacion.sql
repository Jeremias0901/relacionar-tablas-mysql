CREATE DATABASE IF NOT EXISTS `db_facturation`;

USE `db_facturation`;

CREATE TABLE `tb_customer`(
  `customer_key` INT (2),
  `cuil` INT (2),
  `name` VARCHAR (80),
  `telephono` INT (2),
  `direction` TEXT,
  
  PRIMARY KEY (`customer_key`)
);

CREATE TABLE `tb_supplier`(
  `supplier_key` INT (2),
  `name` VARCHAR (60),
  `telephono` INT (2),
  `direction` TEXT,
  
  PRIMARY KEY (`supplier_key`)
);

CREATE TABLE `tb_product`(
  `product_key` INT (2),
  `description` VARCHAR (100),
  `supplier_key` INT (2) UNIQUE,
  `price_cost` DECIMAL,
  `price_sale` DECIMAL,
  `photo` TEXT,

  PRIMARY KEY (`product_key`)
);

CREATE TABLE `tb_invoice`(
  `number_invoice` INT (2),
  `date` datetime,
  `customer_key` INT (2) UNIQUE,
  `invoice_total` DECIMAL,
  
  PRIMARY KEY (`number_invoice`)
);

CREATE TABLE `tb_detailinvoice`(
  `detailinvoice_key` INT (2) AUTO_INCREMENT,
  `number_invoice` INT (2) UNIQUE,
  `product_key` INT (2) UNIQUE,
  `quantity_ordered` DECIMAL,
  `price_total` DECIMAL,
  
  PRIMARY KEY (`detailinvoice_key`)
);

/* ============ RELACION DE LAS TABLAS ============ */

ALTER TABLE `tb_invoice`
  DROP FOREIGN KEY `rl_invoice_customer`;
ALTER TABLE `tb_invoice`
  ADD CONSTRAINT `rl_invoice_customer`
  FOREIGN KEY (`customer_key`) REFERENCES `tb_customer` (`customer_key`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE `tb_product`
  DROP FOREIGN KEY `rl_product_supplier`;
ALTER TABLE `tb_product`
  ADD CONSTRAINT `rl_product_supplier`
  FOREIGN KEY (`supplier_key`) REFERENCES `tb_supplier` (`supplier_key`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE `tb_detailinvoice`
  DROP FOREIGN KEY `rl_detailinvoice_invoice`,
  DROP FOREIGN KEY `rl_detailinvoice_product`;
ALTER TABLE `tb_detailinvoice`
  ADD CONSTRAINT `rl_detailinvoice_invoice`
  FOREIGN KEY (`number_invoice`) REFERENCES `tb_invoice` (`number_invoice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  ADD CONSTRAINT `rl_detailinvoice_product`
  FOREIGN KEY (`product_key`) REFERENCES `tb_product` (`product_key`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

/* ============ PRUEBAS ============ */

/* 
  tabla fuerte: tabla que no depende de otras tablas. no posee claves foraneas.
  tabla debil : tabla que si depende de otras tablas. si posee claves foraneas.
*/

/* 
  sí pruebo insertar datos en una tabla debil, el sistema no me dejara,
  porque indicamos que los UPDATE seran en cascada, es decir:
  el orden de la insercion de los datos es:
    1ero las tablas fuertes.
    2do las tablas debiles dependientes de las tablas fuertes previamente cargadas.
*/

/* hagamos al prueba de insertar datos en tb_product */
 
INSERT INTO `tb_product`
  (`product_key`, `description` , `supplier_key`, `price_cost`, `price_sale`, `photo`) VALUES
  (1            , "black, small", 1             ,  100.50     , 90.50       ,  ""    );

/*
  Error retunred:
  ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint
  fails (`db_facturation`.`tb_product`, CONSTRAINT `rl_product_supplier`
  FOREIGN KEY (`supplier_key`) REFERENCES `tb_supplier` (`supplier_key`)
  ON DELETE CASCADE ON UPDATE CASCADE)
*/

INSERT INTO `tb_customer`
  (`customer_key`, `cuil`     , `name` , `telephono`, `direction`) VALUES
  (1             , 27698652314, "Pedro", 1124689548 , "Av. False");
