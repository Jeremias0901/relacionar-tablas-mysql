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
  ADD CONSTRAINT `rl_invoice_customer`
  FOREIGN KEY (`number_invoice`) REFERENCES `tb_customer` (`customer_key`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE `tb_product`
  ADD CONSTRAINT `rl_product_supplier`
  FOREIGN KEY (`product_key`) REFERENCES `tb_supplier` (`supplier_key`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE `tb_detailinvoice`
  ADD CONSTRAINT `rl_detailinvoice_invoice`
  FOREIGN KEY (`detailinvoice_key`) REFERENCES `tb_invoice` (`number_invoice`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  ADD CONSTRAINT `rl_detailinvoice_product`
  FOREIGN KEY (`detailinvoice_key`) REFERENCES `tb_product` (`product_key`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
