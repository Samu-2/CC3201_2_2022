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
    Las pel´ıculas de los 80s, ordenadas por calificaci´on de mayor a menor.
*/
SELECT * FROM pelicula WHERE 1980 <= anho AND anho < 1990 ORDER BY calificacion;

/*
    Los nombres de los personajes que ha interpretado su actriz/actor favorito en los datos, ordenados por año.
    actriz/actor favorito = 'Zombie, Rob'
*/
SELECT c.personaje FROM personaje c, actor a WHERE a.nombre = 'Zombie, Rob' AND c.a_nombre = a.nombre ORDER BY c.p_anho;

/*
    Las pel´ıculas en las que particip´o su actriz/actor favorito en los datos, ordenadas por calificaci´on de mayor a menor.
    actriz/actor favorito = 'Zombie, Rob'
*/
SELECT * FROM pelicula p, personaje c WHERE c.a_nombre = 'Zombie, Rob' AND c.p_nombre = p.nombre AND c.p_anho = p.anho ORDER BY p.calificacion;

/*
    Los nombres de los personajes interpretados por mujeres, en pel´ıculas de los 90s, con calificaci´on mayor or igual a 8,5.
*/
SELECT c.personaje FROM personaje c, actor a, pelicula p WHERE a.genero = 'F' AND c.a_nombre = a.nombre AND c.p_nombre = p.nombre AND c.p_anho = p.anho AND 1990 <= p.anho AND p.anho < 2000 AND p.calificacion >= 8.5;

/*
    Las pel´ıculas de la saga “The Lord of The Rings” (usando el prefijo de su nombre) ordenadas por calificaci´on y por a˜no.
*/
SELECT * FROM pelicula WHERE nombre LIKE 'The Lord of the Rings%' ORDER BY calificacion DESC, anho;

/*
    Los nombres de los actores que interpretan mas de un personaje en la misma pelıcula
*/
SELECT a.nombre FROM actor a, personaje c1, personaje c2, pelicula p 
WHERE (c1.a_nombre = a.nombre AND c1.p_nombre = p.nombre AND c1.p_anho = p.anho) AND (c2.a_nombre = a.nombre AND c2.p_nombre = p.nombre AND c2.p_anho = p.anho) 
AND c1.personaje != c2.personaje;

/* Mejor version que ese embarrazo de arriba*/
SELECT a.

/*
    Las pel´ıculas en que act´uan juntos Uma Thurman y Samuel L. Jackson.
    Uma Thurman = 'Thurman, Uma'
    Samuel L. Jackson = 'Jackson, Samuel L.'
*/
SELECT p.nombre FROM pelicula p, personaje c1, personaje c2 
WHERE (c1.p_nombre = p.nombre AND c1.p_anho = p.anho) AND (c2.p_nombre = p.nombre AND c2.p_anho = p.anho) 
AND c1.a_nombre = 'Thurman, Uma' AND c2.a_nombre = 'Jackson, Samuel L.';


/* Mejor version que ese embarrazo de arriba*/
SELECT p.nombre FROM pelicula p, personaje c
WHERE (c.p_nombre = p.nombre AND c.p_anho = p.anho) AND c.a_nombre = 'Thurman, Uma'
INTERSECT 
SELECT p.nombre FROM pelicula p, personaje c
WHERE (c.p_nombre = p.nombre AND c.p_anho = p.anho) AND c.a_nombre = 'Jackson, Samuel L.';

/*
    Las pel´ıculas en que act´ua Uma Thurman y no Samuel L. Jackson.
*/

SELECT p.nombre FROM pelicula p, personaje c
WHERE (c.p_nombre = p.nombre AND c.p_anho = p.anho) AND c.a_nombre = 'Thurman, Uma'
INTERSECT 
SELECT p.nombre FROM pelicula p, personaje c
WHERE (c.p_nombre = p.nombre AND c.p_anho = p.anho) AND c.a_nombre != 'Jackson, Samuel L.';

/* 
    Los pares de actores que aparecen juntos en m´as de una pel´ıcula. Cada par debe
aparecer una sola vez, es decir, si (A, B) aparece, no debe aparecer (B, A), pues es el mismo
par. Tampoco se deben incluir pares de la forma (A, A).
    Y si mejor me rajan no mas? :(
*/
/*Malo: da todas las duplas que han trabajado en una pelicula*/
SELECT c1.p_nombre, c1.p_anho, c1.a_nombre, c2.a_nombre
FROM personaje c1 JOIN personaje c2 
ON c1.p_nombre = c2.p_nombre AND c1.p_anho = c2.p_anho AND c1.a_nombre != c2.a_nombre; 

/*Bueno, todas las duplas que han trabajado en peliculas distintas psql*/

SELECT a11n, a12n 
FROM ( SELECT c1.p_nombre AS p1n, c1.p_anho AS p1a, c1.a_nombre AS a11n, c2.a_nombre AS a12n FROM personaje c1 JOIN personaje c2 ON c1.p_nombre = c2.p_nombre AND c1.p_anho = c2.p_anho AND c1.a_nombre != C2.a_nombre ) d1 
JOIN ( SELECT c1.p_nombre AS p2n, c1.p_anho AS p2a, c1.a_nombre AS a21n, c2.a_nombre AS a22n FROM personaje c1 JOIN personaje c2 ON c1.p_nombre = c2.p_nombre AND c1.p_anho = c2.p_anho AND c1.a_nombre != C2.a_nombre ) d2 
ON (p1n != p2n AND p1a != p2a) AND (a11n = a21n AND a12n = a22n) AND (a11n != a22n AND a12n != a21n) LIMIT 10;  
/*
    La(s) pel´ıcula(s) con calificaci´on m´as alta (? Dare el top 5 mas alto
*/
SELECT * FROM pelicula ORDER BY calificacion DESC LIMIT 5;