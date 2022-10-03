/*
La base de datos tiene las siguientes tablas
m. pelicula(nombre, anho, calificacion)
    key: nombre and anho
a. actor(nombre, genero)
    key: nombre
c. personaje(p_nombre, p_anho, a_nombre, personaje)
    key: p_nombre, p_anho, a_nombre

y queremos hacer unas consultas
*/ 

/*
    1 La cantidad de peliculas
*/
SELECT COUNT(*) FROM pelicula;

/*
    2 La cantidad de a˜nos distintos de estreno de las pel´ıculas.
*/
-- Todos los anhos distintos
-- SELECT anho, COUNT(*) FROM pelicula GROUP BY anho
SELECT COUNT(*) FROM 
    (
        SELECT COUNT(*) FROM pelicula 
        GROUP BY anho
    ) x
;

/*
    3 Los nombres, años y calificaciones de las 10 peliculas mejor calificadas, ordenadasSELECT

por calificacion descendente, luego por nombre ascendente y luego por año ascendente (solo
hay que devolver 10 tuplas, incluso si hay empates de calificacion).
*/ 
-- Top 10 peliculas
-- SELECT * FROM pelicula ORDER BY calificacion DESC LIMIT 10;

-- Por calificacion descendente
SELECT * FROM pelicula 
ORDER BY calificacion DESC 
LIMIT 10
;

-- Por nombre ascendente
SELECT * FROM
    (
        SELECT * FROM pelicula 
        ORDER BY calificacion DESC 
        LIMIT 10
    ) x 
ORDER BY nombre ASC
;

-- Por año ascendente
SELECT * FROM 
    (
        SELECT * FROM pelicula 
        ORDER BY calificacion DESC 
        LIMIT 10
    ) x 
ORDER BY anho ASC
;

/*
    4 Los nombres de los actores y las actrices que aparecen en las pelIculas de la P3.
Cada actor/actriz solo debe aparecer en los resultados una vez.
*/
SELECT a_nombre FROM 
    (
        SELECT * FROM pelicula 
        ORDER BY calificacion DESC 
        LIMIT 10
    ) x, 
    personaje 
WHERE x.nombre = p_nombre AND x.anho = p_anho 
GROUP BY a_nombre
;

/*
    5 Los nombres de solo las actrices de las peliculas de la P4. Cada actriz debe
aparecer en los resultados solo una vez.
*/
-- En la anterior tenemos las llaves >:D

SELECT a2.nombre FROM 
    (
        SELECT a_nombre FROM 
            (
                SELECT * FROM pelicula 
                ORDER BY calificacion 
                DESC LIMIT 10
            ) x, 
            personaje
        WHERE x.nombre = p_nombre AND x.anho = p_anho 
        GROUP BY a_nombre
    ) a1, 
    actor a2
WHERE a1.a_nombre = a2.nombre AND a2.genero = 'F'
;

/*
    6  Las distintas decadas de las peliculas en las cuales aparecio Steve Buscemi. (Tiene
dos resultados; uno es 1990)
    nombre = 'Buscemi, Steve'
*/
-- Peliculas donde aparece un tal 'Buscemi, Steve'
-- SELECT p_nombre FROM personaje WHERE a_nombre = 'Buscemi, Steve';

-- Las decadas de estas peliculas
SELECT
    p.p_anho/10*10 AS decada, 
    COUNT(*) AS n_peliculas
FROM 
    (
        SELECT p_nombre, p_anho 
        FROM personaje 
        WHERE a_nombre = 'Buscemi, Steve'
    ) p
GROUP BY p.p_anho/10*10
ORDER BY p.p_anho/10*10 DESC
;

/*
    7 El conteo de peliculas distintas por año (para cada año en la tabla pelicula,
devolver su conteo de peliculas).
*/
SELECT anho, COUNT(*) FROM pelicula
GROUP BY anho
ORDER BY anho DESC
;

/*
    8 Devuelva los mismos resultados como en la P7, pero ordenados por conteo descendente y borrando los años cuyo conteo sea menor que 2.
    -- Somos programadores, Work Smarter > Work Harder
*/
SELECT * FROM 
    (
        SELECT anho, COUNT(*) FROM pelicula
        GROUP BY anho
    ) x
WHERE x.count > 2
ORDER BY count ASC
;

/*
    9 Sea una buena pelicula una pelicula con una calificacion ≥ 8,6. Para cada actor/actriz, cuente sus distintas buenas peliculas. Si un actor/una actriz no tiene una buena
    pelicula, se puede omitirlo/la de los resultados. Ordene los resultados por conteo descendente.
*/

SELECT a_nombre, COUNT(DISTINCT p_nombre) FROM personaje, pelicula
WHERE p_nombre = nombre AND p_anho = anho AND calificacion >= 8.6
GROUP BY a_nombre
ORDER BY count
;

/*
    10 Cuente el n´umero de actrices distintas por pel´ıcula. De haber una pel´ıcula sin
    actrices, deje un conteo de 0 (en vez de omitir la pel´ıcula).
*/
SELECT p_nombre, COUNT(DISTINCT a_nombre WHERE genero = 'F') FROM personaje c, pelicula m, actor a
WHERE c.p_nombre = m.nombre AND c.p_anho = m.anho AND c.a_nombre = a.nombre 
GROUP BY p_nombre
ORDER BY count
; 

SELECT m.p_nombre, a.genero, count(DISTINCT a_nombre) FROM personaje c, pelicula m, actor a
WHERE c.p_nombre = m.nombre AND c.p_anho = m.anho AND c.a_nombre = a.nombre
GROUP BY p_nombre, a.genero 
;

SELECT * FROM pelicula m, personaje c, actor a
WHERE c.p_nombre = m.nombre AND c.p_anho = m.anho AND c.a_nombre = a.nombre;

SELECT c.p_nombre, c.a_nombre, c.personaje FROM personaje c, pelicula m, actor a
WHERE c.p_nombre = m.nombre AND c.p_anho = m.anho AND c.a_nombre = a.nombre
ORDER BY C.a_nombre;

SELECT c.p_nombre, a.genero, FROM personaje c, pelicula m, actor a
WHERE c.p_nombre = m.nombre AND c.p_anho = m.anho AND c.a_nombre = a.nombre
GROUP BY c.p_nombre, a.genero;


SELECT y.nombre FROM 
    (
        SELECT p_nombre FROM personaje c, pelicula m, actor a
        WHERE c.p_nombre = m.nombre AND c.p_anho = m.anho AND c.a_nombre = a.nombre
        GROUP BY p_nombre
        ORDER BY p_nombre
    ) x,
    (
        SELECT nombre FROM pelicula
    ) y
WHERE y.nombre NOT IN x.nombre;