/*
Consulta 1: Inserta tres nuevos interpretes en la tabla Interprete, indicando
su dni, nombre artistico y edad.
*/

INSERT INTO interprete (
    dni_interprete,
    nombre_artistico,
    edad
) VALUES (
    '11122233H',
    'Laura Mendez',
    32
);

INSERT INTO interprete (
    dni_interprete,
    nombre_artistico,
    edad
) VALUES (
    '44455566K',
    'Pablo Neruda',
    56
);

INSERT INTO interprete (
    dni_interprete,
    nombre_artistico,
    edad
) VALUES (
    '77788899P',
    'Sofia Vergara',
    22
);

/*
Consulta 2: Modifica el pais de la pelicula con titulo "Sombras en la nieve",
estableciendo a "Estados Unidos".
*/

UPDATE
    pelicula
SET
    pais = 'Estados Unidos'
WHERE
    titulo = 'Sombras en la nieve';

/*
Consulta 3: Elimina las proyecciones que no tengan ninguna entrada asociada en
la tabla Entrada.
*/

DELETE FROM
    proyeccion P
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            entrada E
        WHERE
            E.cod_proyeccion = P.cod_proyeccion
    );

/*
Consulta 4: Incrementa en un 10% el precio de las entradas compradas
correspondientes a proyecciones celebradas en la sala "Sala Oro".
*/

UPDATE
    entrada_comprada EC
SET
    precio = precio * 1.10
WHERE
    num_entrada IN (
        SELECT
            E.num_entrada
        FROM
            entrada E
        JOIN
            proyeccion P
            ON E.cod_proyeccion = P.cod_proyeccion
        JOIN
            sala S
            ON P.id_sala = S.id_sala
        WHERE
            S.nombre_sala = 'Sala Oro'
    );

/*
Consulta 5: Elimina las entradas de invitacion asociadas a la proyeccion que
tenga la mayor asistencia registrada en la tabla Proyeccion.
*/

DELETE FROM
    entrada_invitacion
WHERE
    num_entrada IN (
        SELECT
            E.num_entrada
        FROM
            entrada E
        WHERE
            E.cod_proyeccion = (
                SELECT
                    cod_proyeccion
                FROM
                    proyeccion
                WHERE
                    asistencia = (
                        SELECT
                            MAX(asistencia)
                        FROM
                            proyeccion
                    )
            )
    );

/*
Consulta 6: Establece a 0 la asistencia de la proyeccion de la pelicula "La 
ultima luz del dia" que tenga el menor numero de entradas compradas, siempre que
dicha proyeccion tenga al menos una entrada comprada.
*/

UPDATE
    proyeccion
SET
    asistencia = 0
WHERE
    cod_proyeccion = (
        SELECT
            cod_proyeccion
        FROM (
            SELECT
                P.cod_proyeccion
            FROM
                proyeccion P
            JOIN
                pelicula PE
                ON P.cod_pelicula = PE.cod_pelicula
            JOIN
                entrada E
                ON P.cod_proyeccion = E.cod_proyeccion
            JOIN
                entrada_comprada EC
                ON E.num_entrada = EC.num_entrada
            WHERE
                PE.titulo = 'La última luz del día'
            GROUP BY
                P.cod_proyeccion
            ORDER BY
                COUNT(EC.num_entrada)
        )
        WHERE
            ROWNUM = 1
    );

/*
Consulta 7: Crear la tabla resumen_proyeccion con el codigo de la proyeccion, el
numero de entradas pagadas y la recaudacion total obtenida. Luego insertar los 
datos de aquellas proyecciones que tengan al menos una entrada comprada.
*/

CREATE TABLE RESUMEN_PROYECCION (
    cod_proyeccion NUMBER(10) PRIMARY KEY,
    entradas_pagadas NUMBER,
    recaudacion_total NUMBER(10, 2)
);

INSERT INTO
    resumen_proyeccion
SELECT
    P.cod_proyeccion,
    COUNT(EC.num_entrada) AS entradas_pagadas,
    SUM(EC.precio) AS recaudacion_total
FROM
    proyeccion P
JOIN
    entrada E
    ON P.cod_proyeccion = E.cod_proyeccion
JOIN
    entrada_comprada EC
    ON E.num_entrada = EC.num_entrada
GROUP BY
    P.cod_proyeccion
HAVING
    COUNT(EC.num_entrada) > 0;

/*
Consulta 8: Crea una vista que muestre el codigo y el titulo de cada pelicula,
justo con la recaudacion total obtenida por cada una de ellas, calculada como 
la suma del precio de las entradas compradas.
*/

CREATE OR REPLACE VIEW v_recaudacion_pelicula AS
SELECT
    PE.cod_pelicula,
    PE.titulo,
    SUM(EC.precio) AS recaudacion_total
FROM
    pelicula PE
JOIN
    proyeccion P
    ON PE.cod_pelicula = P.cod_pelicula
JOIN
    entrada E
    ON P.cod_proyeccion = E.cod_proyeccion
JOIN
    entrada_comprada EC
    ON E.num_entrada = EC.num_entrada
GROUP BY
    PE.cod_pelicula,
    PE.titulo;

/*
Consulta 9: Obtiene la pelicula o peliculas con mayor recaudacion total,
utilizando la vista creada anteriormente.
*/

SELECT
    cod_pelicula,
    titulo,
    recaudacion_total
FROM
    v_recaudacion_pelicula
WHERE
    recaudacion_total = (
        SELECT
            MAX(recaudacion_total)
        FROM
            v_recaudacion_pelicula
    );

/*
Consulta 10.1: Crea dos roles en Oracle para la base de datos CINE:
- 'CARTELERA' con todos los privilegios sobre las tablas Pelicula y Proyeccion.
- 'TAQUILLA' con todos los privilegios sobre las tablas Entrada, Entrada_Comprada 
y Entrada_Invitacion. Rol identificado por contraseña.
*/

--Crear rol cartelera
CREATE ROLE C##CARTELERA;

--Conceder privilegios sobre tablas Pelicula y Proyeccion
GRANT ALL ON cine.pelicula TO C##CARTELERA;
GRANT ALL ON cine.proyeccion TO C##CARTELERA;

--Crear rol taquilla con contraseña
CREATE ROLE C##TAQUILLA IDENTIFIED BY "taquilla2026";

--Conceder privilegios sobre tablas de taquilla
GRANT ALL ON cine.entrada TO C##TAQUILLA;
GRANT ALL ON cine.entrada_comprada TO C##TAQUILLA;
GRANT ALL ON cine.entrada_invitacion TO C##TAQUILLA;

/*
Consulta 10.2: Crear el usuario CLARA con tablespaces especificados y privilegio
CREATE SESSION para poder conectarse a la base de datos.
*/

CREATE USER C##CLARA
IDENTIFIED BY "clara2026"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

--Conceder privilegio de conexion
GRANT CREATE SESSION TO C##CLARA;

/*
Consulta 10.3: Otorga los roles CARTELERA y TAQUILLA al usuario CLARA. Y el rol
por defecto sera CARTELERA.
*/

--Otorgar roles
GRANT C##CARTELERA TO C##CLARA;
GRANT C##TAQUILLA TO C##CLARA;

--Establecer rol por defecto
ALTER USER C##CLARA DEFAULT ROLE C##CARTELERA;

/*
Consulta 10.4: Conectarse como usuario CLARA y probar consultas sobre las tablas
asignadas por los roles.
*/

--Conexion
--sqlplus C##CLARA/clara2026@//localhost:1521/xepdb1

--Consulta de prueba sobre Pelicula (rol Cartelera)
SELECT cod_pelicula, titulo, pais FROM cine.pelicula;

--Consulta de prueba sobre Entrada_Comprada (rol TAQUILLA, aun no activo)
--Esto deberia fallar si no se activa el rol Taquilla
SELECT * FROM cine.entrada_comprada;

/*
Consulta 10.5: Activar el rol TAQUILLA para que el usuario CLARA pueda consultar
las tablas de taquilla.
*/

SET ROLE C##TAQUILLA;

--Ahora la consulta funciona
SELECT * FROM cine.entrada_comprada;

/*
Consulta 10.6: Conectarse como SYSTEM y desactivar todos los roles del usuario
CLARA, incluyendo el rol por defecto.
*/

--Conexion SYSTEM
--sqlplus system/"contraseña"@//localhost:1521/xepdb1

--Desactivar todos los roles
ALTER USER C##CLARA DEFAULT ROLE NONE;

/*
Consulta 10.7: Insertar consultar cine.pelicula con el usuario CLARA tras 
desactivar roles. Deberia poder acceder solo a tablas permitidas sin roles
activos (segun los privilegios individuales otorgados)
*/

-- Conexión CLARA
-- sqlplus C##CLARA/clara2026@//localhost:1521/xepdb1

--Consulta de prueba
SELECT * FROM cine.pelicula;

--Consulta a tabla de taquilla (deberia fallar)
SELECT * FROM cine.entrada_comprada;
