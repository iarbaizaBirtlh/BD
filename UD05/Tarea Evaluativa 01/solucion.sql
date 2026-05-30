/*
Consulta 1: Listar los int�rpretes mayores de 40 a�os, ordenados de mayor a menor edad.
Mostrar: DNI del int�rprete, nombre art�stico y edad.
*/
SELECT
    dni_interprete,
    nombre_artistico,
    edad
FROM
    INTERPRETE
WHERE
    edad > 40
ORDER BY
    edad DESC;

/*
Consulta 2: Obtener las pel�culas que se han proyectado en la sala "Sala Roja",
indicando el c�digo de la proyecci�n y la fecha y hora en que tuvo lugar, ordenadas cronol�gicamente.
Mostrar: t�tulo de la pel�cula, c�digo de la proyecci�n, fecha y hora.
*/
SELECT
    p.titulo,
    pr.cod_proyeccion,
    pr.fecha_hora
FROM
    PELICULA p
JOIN
    PROYECCION pr
    ON p.cod_pelicula = pr.cod_pelicula
JOIN
    SALA s
    ON pr.id_sala = s.id_sala
WHERE
    s.nombre_sala = 'Sala Roja'
ORDER BY
    pr.fecha_hora;

/*
Consulta 3: Obtener los int�rpretes que han actuado en al menos una pel�cula cuyo pa�s sea "Jap�n".
Mostrar: DNI del int�rprete y nombre art�stico.
*/
SELECT
    i.dni_interprete,
    i.nombre_artistico
FROM
    INTERPRETE i
WHERE
    i.dni_interprete IN (
        -- Subconsulta: obtiene los int�rpretes que act�an en pel�culas de Jap�n.
        SELECT
            a.dni_interprete
        FROM
            ACTUA_EN a
        JOIN
            PELICULA p
            ON a.cod_pelicula = p.cod_pelicula
        WHERE
            p.pais = 'Jap�n'
    );

/*
Consulta 4: Calcular cu�ntas proyecciones se han realizado en cada sala,
mostrando primero las salas con mayor n�mero de proyecciones.
Mostrar: id de la sala, nombre de la sala y n�mero de proyecciones.
*/
SELECT
    s.id_sala,
    s.nombre_sala,
    COUNT(*) AS num_proyecciones
FROM
    SALA s
JOIN
    PROYECCION pr
    ON s.id_sala = pr.id_sala
GROUP BY
    s.id_sala,
    s.nombre_sala
ORDER BY
    num_proyecciones DESC;

/*
Consulta 5: Listar las salas cuya asistencia total (suma de asistentes de todas sus proyecciones)
sea superior a 100 personas, ordenadas de mayor a menor asistencia total.
Mostrar: id de la sala, nombre de la sala y asistencia total.
*/
SELECT
    s.id_sala,
    s.nombre_sala,
    SUM(pr.asistencia) AS asistencia_total
FROM
    SALA s
JOIN
    PROYECCION pr
    ON s.id_sala = pr.id_sala
GROUP BY
    s.id_sala,
    s.nombre_sala
HAVING
    SUM(pr.asistencia) > 100
ORDER BY
    asistencia_total DESC;

/*
Consulta 6: Calcular para cada proyecci�n el precio medio de las entradas vendidas
y el n�mero total de entradas compradas, ordenando por c�digo de proyecci�n.
Mostrar: c�digo de la proyecci�n, precio medio y n�mero de entradas vendidas.
*/
SELECT
    e.cod_proyeccion,
    ROUND(AVG(ec.precio), 2) AS precio_medio,
    COUNT(*) AS entradas_vendidas
FROM
    ENTRADA_COMPRADA ec
JOIN
    ENTRADA e
    ON ec.num_entrada = e.num_entrada
GROUP BY
    e.cod_proyeccion
ORDER BY
    e.cod_proyeccion;

/*
Consulta 7: Contar cu�ntos int�rpretes distintos han participado en cada pel�cula,
mostrando primero las pel�culas con m�s int�rpretes (incluyendo las que no tienen ninguno).
Mostrar: c�digo de la pel�cula, t�tulo de la pel�cula y n�mero de int�rpretes.
*/
SELECT
    p.cod_pelicula,
    p.titulo,
    COUNT(DISTINCT a.dni_interprete) AS num_interpretes
FROM
    PELICULA p
LEFT JOIN
    ACTUA_EN a
    ON p.cod_pelicula = a.cod_pelicula
GROUP BY
    p.cod_pelicula,
    p.titulo
ORDER BY
    num_interpretes DESC;

/*
Consulta 8: Obtener los int�rpretes cuya edad est� comprendida entre 30 y 50 a�os (ambos inclusive),
ordenados de menor a mayor edad.
Mostrar: DNI del int�rprete, nombre art�stico y edad.
*/
SELECT
    dni_interprete,
    nombre_artistico,
    edad
FROM
    INTERPRETE
WHERE
    edad BETWEEN 30 AND 50
ORDER BY
    edad;

/*
Consulta 9: Mostrar todas las suplencias ordenadas por fecha de inicio.
Mostrar: NIF y nombre del t�cnico titular, NIF y nombre del t�cnico suplente,
fecha de inicio y fecha de fin de la suplencia.
*/
SELECT
    st.nif_titular,
    t1.nombre AS titular,
    st.nif_suplente,
    t2.nombre AS suplente,
    st.fecha_inicio,
    st.fecha_fin
FROM
    SUPLENCIA st
JOIN
    TECNICO t1
    ON st.nif_titular = t1.nif_tecnico
JOIN
    TECNICO t2
    ON st.nif_suplente = t2.nif_tecnico
ORDER BY
    st.fecha_inicio;

/*
Consulta 10: Listar los t�cnicos que nunca han actuado como suplentes.
Mostrar: NIF y nombre del t�cnico.
*/
SELECT
    t.nif_tecnico,
    t.nombre
FROM
    TECNICO t
WHERE NOT EXISTS (
    -- Subconsulta: comprueba si el t�cnico aparece como suplente en alguna suplencia.
    SELECT
        1
    FROM
        SUPLENCIA s
    WHERE
        s.nif_suplente = t.nif_tecnico
);

/*
Consulta 11: Obtener los directores cuya duraci�n media de las proyecciones de sus pel�culas
sea superior a 120 minutos, ordenados de mayor a menor duraci�n media.
Mostrar: director y duraci�n media.
*/
SELECT
    p.director,
    AVG(pr.duracion_min) AS duracion_media
FROM
    PELICULA p
JOIN
    PROYECCION pr
    ON p.cod_pelicula = pr.cod_pelicula
GROUP BY
    p.director
HAVING
    AVG(pr.duracion_min) > 120
ORDER BY
    duracion_media DESC;

/*
Consulta 12: Obtener la proyecci�n de la sala "Sala Oro" que haya registrado el menor n�mero de asistentes.
Si existe m�s de una proyecci�n con la misma asistencia m�nima, deber�n mostrarse todas.
Mostrar: c�digo de la proyecci�n.
*/
SELECT
    pr.cod_proyeccion
FROM
    PROYECCION pr
JOIN
    SALA s
    ON pr.id_sala = s.id_sala
WHERE
    s.nombre_sala = 'Sala Oro'
    AND pr.asistencia = (
        -- Subconsulta: calcula la asistencia m�nima en la sala "Sala Oro".
        SELECT
            MIN(pr2.asistencia)
        FROM
            PROYECCION pr2
        JOIN
            SALA s2
            ON pr2.id_sala = s2.id_sala
        WHERE
            s2.nombre_sala = 'Sala Oro'
    );
