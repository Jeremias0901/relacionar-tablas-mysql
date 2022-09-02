/* crear base de datos */
CREATE DATABASE IF NOT EXISTS `db_library`;

/* seleccionar base de datos */
USE `db_library`;

/* crear tabla tb_author */
CREATE TABLE `tb_author`(
  `author_key` INT NOT NULL,
  `name` VARCHAR (50) NOT NULL,
  `surname` VARCHAR (50) NOT NULL,
  `age` INT (3) NOT NULL,

  PRIMARY KEY (`author_key`)
);

/* crear tabla tb_books */
CREATE TABLE `tb_books` (
  `book_key` INT (3) NOT NULL,
  `name` VARCHAR (50) NOT NULL,
  `description` TEXT NOT NULL,
  `pages_number` INT (5) NOT NULL,
  `author_key` INT NOT NULL,

  PRIMARY KEY (`book_key`)
);

/* crear la relacion de las tablas */
ALTER
  TABLE `tb_books`
    ADD
      CONSTRAINT `rl_books_author`
      FOREIGN KEY (`author_key`)
      REFERENCES `tb_author`(`author_key`)
      ON DELETE RESTRICT
      ON UPDATE RESTRICT;

/* limit (a_partir_de_este_sin_contar_este, cantidad) */

INSERT
  INTO `tb_author`
  (`author_key`, `name`   , `surname` , `age`) VALUES
  ( 1          , 'Jorge'  , 'Borges'  ,  86  ),
  ( 2          , 'Julio'  , 'Cortazar',  69  ),
  ( 3          , 'Paulo'  , 'Coelho'  ,  75  ),
  ( 4          , 'Michael', 'Foucault',  58  ),
  ( 5          , 'Ernesto', 'Sabato'  ,  99  );

INSERT
  INTO `tb_books`
  (`book_key`, `name`              , `description`, `pages_number`, `author_key`) VALUES
  ( 1        , 'El sur'            , ''           ,  18           ,   1         ),
  ( 2        , 'El aleph'          , ''           ,  146          ,   1         ),
  ( 3        , 'Rayuela'           , ''           ,  728          ,   2         ),
  ( 4        , 'Casa Tomada'       , ''           ,  5            ,   2         ),
  ( 5        , 'Bestiario'         , ''           ,  165          ,   2         ),
  ( 6        , 'Vigilar y castigar', ''           ,  328          ,   4         );

/* Quiero ver el nombre del libro y el nombre del autor que lo escribio */
SELECT
  `tb_books`.`name` AS 'Nombre del libro',
  `tb_author`.`name` AS 'Nombre del autor'
FROM `tb_books`
  INNER JOIN `tb_author` ON `tb_books`.`author_key` = `tb_author`.`author_key`;

/* Quiero ver el nombre del libro y el nombre del autor que lo escribio, 
incluso aquellos libros no cargados pero si sus autores */
SELECT
  `tb_books`.`name` AS 'Nombre del libro',
  `tb_author`.`name` AS 'Nombre del autor'
FROM `tb_books`
  RIGHT JOIN `tb_author` ON `tb_books`.`author_key` = `tb_author`.`author_key`;

/* Quiero ver los autores y la cantidad de libros que escribio descendientemente */
SELECT
  `tb_author`.`name` AS 'Nombre del autor',
  COUNT(`tb_books`.`book_key`) AS 'Cantidad de libros'
FROM `tb_books`
  RIGHT JOIN `tb_author` ON `tb_books`.`author_key` = `tb_author`.`author_key`
GROUP BY `tb_author`.`name`
ORDER BY COUNT(`tb_books`.`book_key`) DESC;
