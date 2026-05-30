/*
Consulta 1: Lista los intérpretes mayores de 40 años, mostrando dni, nombre artístico y edad.
Ordenados de mayor a menor edad.
*/

SELECT
    I.dni_interprete,
    I.nombre_artistico,
    I.edad
FROM
    interprete I
WHERE
    I.edad > 40
ORDER BY
    I.edad DESC;

/*
Consulta 2: Obtiene las películas proyectadas en la sala "Sala Roja",
mostrando el título de la película, el código de la proyección y la fecha y hora.
Ordenadas cronológicamente.
*/

SELECT
    P.titulo,
    PR.cod_proyeccion,
    PR.fecha_hora
FROM
    pelicula P
JOIN
    proyeccion PR
    ON P.cod_pelicula = PR.cod_pelicula
JOIN
    sala S
    ON PR.id_sala = S.id_sala
WHERE
    S.nombre_sala = 'Sala Roja'
ORDER BY
    PR.fecha_hora;

/*
Consulta 3: Obtiene los intérpretes que han actuado en al menos una película 
cuyo país sea "Japón", mostrando el nombre artístico y el DNI de los intérpretes.
*/

SELECT DISTINCT
    I.dni_interprete,
    I.nombre_artistico
FROM
    interprete I
JOIN
    actua_en A
    ON I.dni_interprete = A.dni_interprete
JOIN
    pelicula P
    ON A.cod_pelicula = P.cod_pelicula
WHERE
    P.pais = 'Japón';

/*
Consulta 4: Cuántas proyecciones realizadas en cada sala, ordenado de mayor a menor, 
mostrando id y nombre de la sala, y numero de proyecciones.
*/

SELECT 
    S.id_sala, 
    S.nombre_sala, 
    COUNT(PR.cod_proyeccion) AS num_proyecciones
FROM
    sala S
JOIN
    proyeccion PR
    ON S.id_sala = PR.id_sala
GROUP BY
    S.id_sala,
    S.nombre_sala
ORDER BY
    num_proyecciones DESC;
    
/*
Consulta 5: Lista las salas cuya asistencia total es superior a 100 personas, 
mostrando id y nombre de la sala y asistencia total, ordenadas de mayor a menor asistencia total.
*/

SELECT
    S.id_sala,
    S.nombre_sala,
    SUM(PR.asistencia) AS asistencia_total
FROM
    sala S
JOIN
    proyeccion PR
    ON S.id_sala = PR.id_sala 
GROUP BY 
    S.id_sala, 
    S.nombre_sala
HAVING
    SUM(PR.asistencia) > 100
ORDER BY
    asistencia_total DESC;
    
/*
Consulta 6: Calcula para cada proyección el precio medio de las entradas vendidas 
y el número total de entradas compradas, ordenando por código de proyección.
*/

SELECT
    PR.cod_proyeccion,
    AVG(EC.precio),
    COUNT(EC.num_entrada)
FROM
    proyeccion PR
JOIN
    entrada E
    ON PR.cod_proyeccion = E.cod_proyeccion
JOIN
    entrada_comprada EC
    ON EC.num_entrada = E.num_entrada
GROUP BY
    PR.cod_proyeccion
ORDER BY
    PR.cod_proyeccion;

/*
Consulta 7: Cuántos intérpretes distintos han participado en cada película, 
mostrando código y título de la película y el número de interpretes,
ordenando primero las películas con más intérpretes.
*/

SELECT
    P.cod_pelicula,
    P.titulo,
    COUNT(DISTINCT A.dni_interprete) AS num_interpretes
FROM
    pelicula P
LEFT JOIN
    actua_en A
    ON P.cod_pelicula = A.cod_pelicula
GROUP BY
    P.cod_pelicula,
    P.titulo
ORDER BY
    num_interpretes DESC;

/*
Consulta 8: Obtiene los intérpretes cuya edad está entre 30 y 50 años, ordenados de menor a mayor edad.
*/

SELECT
    I.dni_interprete,
    I.nombre_artistico,
    I.edad
FROM
    interprete I
WHERE
    I.edad BETWEEN 30 AND 50
ORDER BY
    I.edad;

/*
Consulta 9: Muestra todas las suplencias mostrando NIF y nombre del técnico titular, NIF 
y el nombre del técnico suplente y el intervalo de fechas en que se produjo la suplencia, 
ordenadas por fecha de inicio.
*/

SELECT
    S.nif_titular,
    T1.nombre AS nombre_titular,
    S.nif_suplente,
    T2.nombre AS nombre_suplente,
    S.fecha_inicio,
    S.fecha_fin
FROM
    suplencia S
JOIN
    tecnico T1
    ON S.nif_titular = T1.nif_tecnico
JOIN
    tecnico T2
    ON S.nif_suplente = T2.nif_tecnico
ORDER BY
    S.fecha_inicio;

/*
Consulta 10: Lista los técnicos que nunca han actuado como suplentes, mostrando NIF y nombre.
*/

SELECT
    T.nif_tecnico,
    T.nombre
FROM
    tecnico T
WHERE
    T.nif_tecnico NOT IN (
        SELECT
            S.nif_suplente
        FROM
            suplencia S
    );

/*
Consulta 11: Obtiene los directores cuya duración media de las proyecciones de sus películas 
es superior a 120 minutos, ordenados de mayor a menor duración media.
*/

SELECT
    P.director,
    AVG(PR.duracion_min) AS duracion_media
FROM
    pelicula P
JOIN
    proyeccion PR
    ON P.cod_pelicula = PR.cod_pelicula
GROUP BY
    P.director
HAVING
    AVG(PR.duracion_min) > 120
ORDER BY
    duracion_media DESC;

/*
Consulta 12: Obtiene la proyección de la sala "Sala Oro" que registró el menor número de asistentes.
*/

SELECT
    PR.cod_proyeccion
FROM
    proyeccion PR
JOIN
    sala S
    ON PR.id_sala = S.id_sala
WHERE
    S.nombre_sala = 'Sala Oro'
    AND PR.asistencia = (
        SELECT
            MIN(PR2.asistencia)
        FROM
            proyeccion PR2
        JOIN
            sala S2
            ON PR2.id_sala = S2.id_sala
        WHERE
            S2.nombre_sala = 'Sala Oro'
    );
