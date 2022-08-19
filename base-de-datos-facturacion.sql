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

  notar tambien que no existe en tb_supplier.supplier_key algun registro en 1. Aun
  asi si hubiera, el sistema no dejaria insertar los datos por ON UPDATE CASCADE.
*/

/* insertamos datos a tb_supplier (tabla fuerte de tb_product) */
INSERT INTO `tb_supplier`
  (`supplier_key`, `name`      , `telephono`, `direction`                 ) VALUES
  (1             , "serenisima", 1132266763 , "Ministro French 165, Hamps");

INSERT INTO `tb_product`
  (`product_key`, `description`  , `supplier_key`, `price_cost`, `price_sale`, `photo`) VALUES
  (1            , "leche 3% rojo", 1             ,  100.50     , 90.50       ,  ""    );

/* Que pasa si inserto algun dato en tb_product.supplier_key que no exista en tb_supplier.supplier_key? */

INSERT INTO `tb_product`
  (`product_key`, `description`  , `supplier_key`, `price_cost`, `price_sale`, `photo`) VALUES
  (1            , "leche 3% rojo", 2             ,  100.50     , 90.50       ,  ""    );

/*
  ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint
  fails (`db_facturation`.`tb_product`, CONSTRAINT `rl_product_supplier`
  FOREIGN KEY (`supplier_key`) REFERENCES `tb_supplier` (`supplier_key`)
  ON DELETE CASCADE ON UPDATE CASCADE)

  es el mismo error de antes, el sistema no lo discrimino
*/

/*
  Podre registrar en tb_product otro producto con el mismo proveedor?
  seria: 1 proveedor puede tener muchos productos (1:n)
*/

UPDATE `tb_product` SET `description` = "leche 3% rojo" WHERE `tb_product`.`product_key` = 1;
INSERT INTO `tb_product`
  (`product_key`, `description`    , `supplier_key`, `price_cost`, `price_sale`, `photo`) VALUES
  (2            , "yogurt frutiila", 1             ,  100.50     , 90.50       ,  ""    );

/*
  Error retunred:
  ERROR 1062 (23000): Duplicate entry '1' for key 'supplier_key

  El sistema no me permite relacionar mas de 1 registro de tb_product a un mismo registro de tb_supplier
  Es decir, la relacion es de 1 a 1.
  ---> 1 producto tiene un proveedor. Cada proveedor tiene 1 producto.
*/

/* ============ INVENTANDO PROBLEMATICA PARA RELACIONAR TABLAS ============ */

/* 
  Como obtengo, desde la tb_product el nombre del producto y proveedor de un producto cuyo codigo es 1?
  relacionando la tabla tb_product con la tabla tb_supplier mediante las columnas
  tb_product.supplier_key (FK) y tb_supplier.supplier_key (PK)
 */

SELECT
  `tb_product`.`description` AS "descripcion del producto",
  `tb_supplier`.`name` AS "nombre de proveedor"
FROM `tb_product`
  INNER JOIN `tb_supplier`
  ON `tb_product`.`supplier_key` = `tb_supplier`.`supplier_key`
WHERE `tb_product`.`product_key` = 1;

/*
  Relacion al reves, ahora desde la tabla tb_supplier, funciona igual.
*/

SELECT
  `tb_product`.`description` AS "descripcion del producto",
  `tb_supplier`.`name` AS "nombre de proveedor"
FROM `tb_supplier`
  INNER JOIN `tb_product`
  ON `tb_product`.`supplier_key` = `tb_supplier`.`supplier_key`
WHERE `tb_product`.`product_key` = 1;

/*
  Conclusion: esta relacion se puede relacionar en cualquier "direccion"
    tb_supplier -> tb_product
    tb_supplier <- tb_product
*/

INSERT INTO `tb_customer`
  (`customer_key`, `cuil`     , `name` , `telephono`, `direction`) VALUES
  (1             , 27698652314, "Pedro", 1124689548 , "Av. Eva Peron 2145"     ),
  (2             , 27351648681, "Juan" , 1114564974 , "Av. 9 de Julio");

INSERT INTO `tb_invoice`
  (`number_invoice`, `date`      , `customer_key` , `invoice_total`) VALUES
  (1               , "2022-08-03", 2              , 1500           );

/*
  Problema:
    Quiero saber cual es el total pagado del cliente cuyo codigo = 2.
*/

SELECT
  `tb_invoice`.`invoice_total` AS "total pagado",
  `tb_customer`.`name` AS "nombre del cliente"
FROM `tb_customer`
  INNER JOIN `tb_invoice`
  ON `tb_customer`.`customer_key` = `tb_invoice`.`customer_key`
WHERE `tb_customer`.`customer_key` = 2;

INSERT INTO `tb_supplier`
  (`supplier_key`, `name`                    , `telephono`, `direction`      ) VALUES
  (3             , "Distribuidora de Trigo"  , 1162598467 , "Av. Jujuy 132"  ),
  (4             , "Distribuidora de Manteca", 1154263213 , "Av. Molina 1420");

INSERT INTO `tb_product`
  (`product_key`, `description`, `supplier_key`, `price_cost`, `price_sale`, `photo`) VALUES
  (2            , "harina 000"   , 2             ,  60.85      , 90.50       ,  ""    ),
  (3            , "margarina"    , 3             ,  30.20      , 40.50       ,  ""    );

/* 
  En una relacion (1:1) en cascada, con tablas fuertes y debiles, no existe la posibilidad
  de que un registro de tb_product no tenga un proveedor no registrado, pues la carga es en
  cascada, primero se debe cargar la tabla tb_supplier para luego un registro de tb_product
  pueda relacionarse con ese registro tb_supplier. Puede ser que tb_supplier no tenga asociado
  registros en tb_product, pero no al reves. Porque tb_product depende de la carga de datos de
  tb_supplier.
  No hay producto que no venga de un proveedor.
  Pero si hay proveedores sin productos relacionados.
 */
SELECT * FROM tb_product INNER JOIN tb_supplier ON tb_product.supplier_key = tb_supplier.supplier_key;

INSERT INTO `tb_customer`
  (`customer_key`, `cuil`     , `name`     , `telephono`, `direction`            ) VALUES
  (3             , 25635984847, "Guillermo", 1168958472 , "Rivadavia 1552"       ),
  (4             , 25516849657, "Miguel"   , 1168958472 , "Hipolito Yrigoyen 231");

INSERT INTO `tb_invoice`
  (`number_invoice`, `date`      , `customer_key` , `invoice_total`) VALUES
  (2               , "2022-05-24", 1              , 2100           ),
  (3               , "2022-09-13", 3              , 3150           ),
  (4               , "2022-03-28", 4              , 510            );
  
INSERT INTO `tb_detailinvoice`
(`number_invoice`, `product_key`, `quantity_ordered`, `price_total`) VALUES
(1               , 1            , 50                ,  21000),
(2               , 2            , 25                ,  22500),
(3               , 3            , 67                ,  23650);


/* ============= (INNER | LEFT | RIGHT) JOIN ============= [Proximamente] */
