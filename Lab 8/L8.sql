CREATE TABLE lab8_p.fxs2_estado (
    nombre varchar (255) primary key,
	voto_electoral smallint,
	cierre time,
	num_candidatos smallint
);

INSERT INTO fxs2_estado SELECT * FROM estado;

CREATE TABLE lab8_p.fxs2_condado (
    nombre varchar (255),
	estado varchar (255),
	reportado float,
    primary key (nombre, estado),
    foreign key (estado) references lab8_p.fxs2_estado (nombre),
    unique (nombre, estado),
    check (reportado >= 0 and reportado <= 1)
);

INSERT INTO fxs2_condado SELECT * FROM condado;

CREATE TABLE lab8_p.fxs2_candidato (
    nombre varchar (255) primary key,
	partido varchar (255)
);

INSERT INTO fxs2_candidato SELECT * FROM candidato;

CREATE TABLE lab8_p.fxs2_votosPorCondado (
    candidato varchar (255),
	condado varchar (255),
	estado varchar (255),
    votos int,
    primary key (candidato, condado, estado),
    foreign key (candidato) references lab8_p.fxs2_candidato (nombre),
    foreign key (condado, estado) references lab8_p.fxs2_condado (nombre, estado),
    unique (candidato, condado, estado)
);

INSERT INTO fxs2_votosPorCondado SELECT * FROM votosPorCondado;

-- DROP TABLE lab8_p.fxs2_estado, lab8_p.fxs2_condado, lab8_p.fxs2_candidato, lab8_p.fxs2_votosPorCondado CASCADE;

/*
P2 - Ahora queremos ir actualizando los datos sobre las votaciones en su copia de las tablas,
comenzando con la primera hora de eleccion. Revise los contenidos de la tabla votosPorCondado1.
Construya una consulta UPDATE en SQL para actualizar su tabla grupo votosPorCondado para cada
tupla en votosPorCondado1 segun corresponda (basada en la llave primaria). Ejecute su instruccion.
*/

UPDATE lab8_p.fxs2_votosPorCondado AS x SET votos = upd.votos FROM 
(
    SELECT * FROM lab8_b.votosPorCondado1
) upd 
WHERE x.candidato = upd.candidato 
AND x.condado = upd.condado 
AND x.estado = upd.estado;

/*
P3 - Haremos lo mismo con la fraccion de votos reportados durante la primera hora. Revise
los contenidos de la tabla condado1; sigue la misma idea que la tabla votosPorCondado1. Escriba
las instrucciones para actualizar grupo condado con los datos de condado1.
*/

UPDATE lab8_p.fxs2_condado AS x SET reportado = upd.reportado FROM 
(
    SELECT * FROM lab8_b.condado1
) upd 
WHERE x.nombre = upd.nombre AND x.estado = upd.estado;

/*
P4 - Piense en lo que pasarıa si actualizamos grupo votosPorCondado y luego intentamos
actualizar grupo condado y ocurriera un problema. ¿Los datos estarıan bien? No, pues tendrıamos
votos contados en el condado, pero la fraccion de datos escrutados seguirıa siendo desactualizada. Por
lo tanto, use una transaccion para actualizar ambas tablas atomicamente, pero esta vez usando los
datos de la segunda hora de votacion.
*/

START TRANSACTION;
    UPDATE lab8_p.fxs2_votosPorCondado AS x SET votos = upd.votos FROM 
    (
        SELECT * FROM lab8_b.votosPorCondado2
    ) upd 
    WHERE x.candidato = upd.candidato
    AND x.condado = upd.condado
    AND x.estado = upd.estado;

    UPDATE lab8_p.fxs2_condado AS x SET reportado = upd.reportado FROM 
    (
        SELECT * FROM lab8_b.condado2
    ) upd 
    WHERE x.nombre = upd.nombre AND x.estado = upd.estado;
COMMIT;

/*
P5 - Modifique su transaccion para actualizar las horas siguientes (sı, puede seguir copypasteando hasta 
completar todas las horas; puede usar una transaccion por hora).
*/

-- 3:00

START TRANSACTION;
    UPDATE lab8_p.fxs2_votosPorCondado AS x SET votos = upd.votos FROM 
    (
        SELECT * FROM lab8_b.votosPorCondado3
    ) upd 
    WHERE x.candidato = upd.candidato
    AND x.condado = upd.condado
    AND x.estado = upd.estado;

    UPDATE lab8_p.fxs2_condado AS x SET reportado = upd.reportado FROM 
    (
        SELECT * FROM lab8_b.condado3
    ) upd 
    WHERE x.nombre = upd.nombre AND x.estado = upd.estado;
COMMIT;

-- 4:00

START TRANSACTION;
    UPDATE lab8_p.fxs2_votosPorCondado AS x SET votos = upd.votos FROM 
    (
        SELECT * FROM lab8_b.votosPorCondado4
    ) upd 
    WHERE x.candidato = upd.candidato
    AND x.condado = upd.condado
    AND x.estado = upd.estado;

    UPDATE lab8_p.fxs2_condado AS x SET reportado = upd.reportado FROM 
    (
        SELECT * FROM lab8_b.condado4
    ) upd 
    WHERE x.nombre = upd.nombre AND x.estado = upd.estado;
COMMIT;

-- 5:00

START TRANSACTION;
    UPDATE lab8_p.fxs2_votosPorCondado AS x SET votos = upd.votos FROM 
    (
        SELECT * FROM lab8_b.votosPorCondado5
    ) upd 
    WHERE x.candidato = upd.candidato
    AND x.condado = upd.condado
    AND x.estado = upd.estado;

    UPDATE lab8_p.fxs2_condado AS x SET reportado = upd.reportado FROM 
    (
        SELECT * FROM lab8_b.condado5
    ) upd 
    WHERE x.nombre = upd.nombre AND x.estado = upd.estado;
COMMIT;

-- 6:00

START TRANSACTION;
    UPDATE lab8_p.fxs2_votosPorCondado AS x SET votos = upd.votos FROM 
    (
        SELECT * FROM lab8_b.votosPorCondado6
    ) upd 
    WHERE x.candidato = upd.candidato
    AND x.condado = upd.condado
    AND x.estado = upd.estado;

    UPDATE lab8_p.fxs2_condado AS x SET reportado = upd.reportado FROM 
    (
        SELECT * FROM lab8_b.condado6
    ) upd 
    WHERE x.nombre = upd.nombre AND x.estado = upd.estado;
COMMIT;

-- 7:00

START TRANSACTION;
    UPDATE lab8_p.fxs2_votosPorCondado AS x SET votos = upd.votos FROM 
    (
        SELECT * FROM lab8_b.votosPorCondado7
    ) upd 
    WHERE x.candidato = upd.candidato
    AND x.condado = upd.condado
    AND x.estado = upd.estado;

    UPDATE lab8_p.fxs2_condado AS x SET reportado = upd.reportado FROM 
    (
        SELECT * FROM lab8_b.condado7
    ) upd 
    WHERE x.nombre = upd.nombre AND x.estado = upd.estado;
COMMIT;

-- 8:00

START TRANSACTION;
    UPDATE lab8_p.fxs2_votosPorCondado AS x SET votos = upd.votos FROM 
    (
        SELECT * FROM lab8_b.votosPorCondado8
    ) upd 
    WHERE x.candidato = upd.candidato
    AND x.condado = upd.condado
    AND x.estado = upd.estado;

    UPDATE lab8_p.fxs2_condado AS x SET reportado = upd.reportado FROM 
    (
        SELECT * FROM lab8_b.condado8
    ) upd 
    WHERE x.nombre = upd.nombre AND x.estado = upd.estado;
COMMIT;

-- 9:00

START TRANSACTION;
    UPDATE lab8_p.fxs2_votosPorCondado AS x SET votos = upd.votos FROM 
    (
        SELECT * FROM lab8_b.votosPorCondado9
    ) upd 
    WHERE x.candidato = upd.candidato
    AND x.condado = upd.condado
    AND x.estado = upd.estado;

    UPDATE lab8_p.fxs2_condado AS x SET reportado = upd.reportado FROM 
    (
        SELECT * FROM lab8_b.condado9
    ) upd 
    WHERE x.nombre = upd.nombre AND x.estado = upd.estado;
COMMIT;

/*
P6 - Putin envıa sus hackers a cargar datos maliciosos a su base de datos para lograr la victoria de Clinton.1 
Es decir, envıa como actualizaciones las tablas votosPorCondadoX y condadoX. Lamentablemente para Vladimir (y para 
Hillary), los hackers creyeron que la columna reportado correspondıa a un porcentaje y no a una fraccion. 
Cree una transaccion para cargar votosPorCondadoX
y condadoX en sus tablas atomicamente. Vea cuidadosamente la salida de Postgres. Realice una
consulta para verificar el condado y candidato que trataron de hackear. ¿Putin lo logro?
*/

START TRANSACTION;
    UPDATE lab8_p.fxs2_votosPorCondado AS x SET votos = upd.votos FROM 
    (
        SELECT * FROM lab8_b.votosPorCondado9
    ) upd 
    WHERE x.candidato = upd.candidato
    AND x.condado = upd.condado
    AND x.estado = upd.estado;

    UPDATE lab8_p.fxs2_condado AS x SET reportado = upd.reportado FROM 
    (
        SELECT * FROM lab8_b.condado9
    ) upd 
    WHERE x.nombre = upd.nombre AND x.estado = upd.estado;
COMMIT;

-- Putin no logró hackear la base de datos, intenta cambiar Real County:
select * from lab8_b.condadoX; 
/*
   nombre    | estado | reportado
-------------+--------+-----------
 Real County | Texas  |       100
(1 row)
*/
-- Y tambien intenta cambiar
select * from lab8_b.votosPorCondadoX;
/*
 candidato  |   condado   | estado |   votos
------------+-------------+--------+-----------
 H. Clinton | Real County | Texas  | 999999999
(1 row)
*/

-- Pero no lo logra, ya que la columna reportado es una fracción y no un porcentaje:
select * from lab8_p.fxs2_condado where nombre = 'Real County' and estado = 'Texas';

/*
   nombre    | estado | reportado
-------------+--------+-----------
 Real County | Texas  |         0
(1 row)
*/

-- Tampoco cambio nada aqui
select * from lab8_p.fxs2_votosPorCondado where condado = 'Real County' and estado = 'Texas' and candidato = 'H. Clinton';
/*
 candidato  |   condado   | estado | votos
------------+-------------+--------+-------
 H. Clinton | Real County | Texas  |     0
(1 rows)
*/