/* ============================================================
   BD06 - UD6 - Tarea de evaluación CINE_BD
   Solución propuesta (ins, upd, del, vistas, privilegios y roles)
   ============================================================ */

---------------------------------------------------------------
-- EJERCICIO 1
-- Inserta 3 nuevos intérpretes en la tabla INTERPRETE
---------------------------------------------------------------
INSERT INTO INTERPRETE (dni_interprete, nombre_artistico, edad) VALUES
  ('INT0100A', 'Julia Ríos', 34);   -- Nuevo intérprete
INSERT INTO INTERPRETE (dni_interprete, nombre_artistico, edad) VALUES
  ('INT0101B', 'Pedro Navas', 47);  -- Nuevo intérprete
INSERT INTO INTERPRETE (dni_interprete, nombre_artistico, edad) VALUES
  ('INT0102C', 'Marina Luz', 29);   -- Nuevo intérprete

-- COMMIT opcional al final de todos los ejercicios
-- COMMIT;


---------------------------------------------------------------
-- EJERCICIO 2
-- Modificar el país de la película "Sombras en la nieve"
---------------------------------------------------------------
UPDATE PELICULA
SET pais = 'Estados Unidos'         -- Nuevo país
WHERE titulo = 'Sombras en la nieve';  -- Película a modificar


---------------------------------------------------------------
-- EJERCICIO 3
-- Borrar proyecciones sin ninguna entrada asociada
---------------------------------------------------------------
DELETE FROM PROYECCION p
WHERE NOT EXISTS (
    SELECT 1
    FROM ENTRADA e
    WHERE e.cod_proyeccion = p.cod_proyeccion
);

-- Nota: con los datos iniciales puede que no se borre ninguna fila
-- si todas las proyecciones tienen, al menos, una entrada.


---------------------------------------------------------------
-- EJERCICIO 4
-- Subir un 10% el precio de entradas compradas de la "Sala Oro"
---------------------------------------------------------------
UPDATE ENTRADA_COMPRADA ec
SET precio = precio * 1.10          -- Incremento del 10%
WHERE ec.num_entrada IN (
    SELECT e.num_entrada
    FROM ENTRADA e
        JOIN PROYECCION p ON e.cod_proyeccion = p.cod_proyeccion
        JOIN SALA s       ON p.id_sala        = s.id_sala
    WHERE s.nombre_sala = 'Sala Oro'
);


---------------------------------------------------------------
-- EJERCICIO 5
-- Borrar invitaciones de la proyección con mayor asistencia
---------------------------------------------------------------
DELETE FROM ENTRADA_INVITACION ei
WHERE ei.num_entrada IN (
    SELECT e.num_entrada
    FROM ENTRADA e
    WHERE e.cod_proyeccion = (
        SELECT cod_proyeccion
        FROM PROYECCION
        WHERE asistencia = (
            SELECT MAX(asistencia)
            FROM PROYECCION
        )
    )
);

-- Se eliminan las invitaciones asociadas a la proyección
-- cuyo valor de asistencia es máximo en la tabla PROYECCION.


---------------------------------------------------------------
-- EJERCICIO 6
-- Poner asistencia = 0 para la proyección de
-- "La última luz del día" con menor nº de entradas compradas
---------------------------------------------------------------
UPDATE PROYECCION p
SET asistencia = 0
WHERE p.cod_proyeccion IN (
    SELECT cod_proyeccion
    FROM (
        SELECT p2.cod_proyeccion,
               COUNT(ec.num_entrada) AS entradas_pagadas
        FROM PROYECCION p2
            JOIN PELICULA pe ON pe.cod_pelicula  = p2.cod_pelicula
            JOIN ENTRADA e   ON e.cod_proyeccion = p2.cod_proyeccion
            JOIN ENTRADA_COMPRADA ec ON ec.num_entrada = e.num_entrada
        WHERE pe.titulo = 'La última luz del día'
        GROUP BY p2.cod_proyeccion
    )
    WHERE entradas_pagadas = (
        SELECT MIN(entradas_pagadas)
        FROM (
            SELECT p3.cod_proyeccion,
                   COUNT(ec2.num_entrada) AS entradas_pagadas
            FROM PROYECCION p3
                JOIN PELICULA pe3 ON pe3.cod_pelicula  = p3.cod_pelicula
                JOIN ENTRADA e3   ON e3.cod_proyeccion = p3.cod_proyeccion
                JOIN ENTRADA_COMPRADA ec2 ON ec2.num_entrada = e3.num_entrada
            WHERE pe3.titulo = 'La última luz del día'
            GROUP BY p3.cod_proyeccion
        )
    )
);

---------------------------------------------------------------
-- EJERCICIO 7
-- Crear tabla RESUMEN_PROYECCION e insertar datos
---------------------------------------------------------------

-- 7.1 Creación de la tabla
CREATE TABLE RESUMEN_PROYECCION (
    cod_proyeccion    NUMBER(10)      PRIMARY KEY,  -- Como PROYECCION.cod_proyeccion
    entradas_pagadas  NUMBER(5),                     -- Nº de entradas compradas
    recaudacion_total NUMBER(10,2)                  -- Suma de precios de entradas compradas
);

-- 7.2 Inserción de datos a partir de las tablas de CINE_BD
INSERT INTO RESUMEN_PROYECCION (cod_proyeccion, entradas_pagadas, recaudacion_total)
SELECT p.cod_proyeccion,
       COUNT(ec.num_entrada)        AS entradas_pagadas,
       SUM(ec.precio)               AS recaudacion_total
FROM PROYECCION p
    JOIN ENTRADA e           ON e.cod_proyeccion = p.cod_proyeccion
    JOIN ENTRADA_COMPRADA ec ON ec.num_entrada   = e.num_entrada
GROUP BY p.cod_proyeccion;

-- Solo se insertan proyecciones que tengan al menos una ENTRADA_COMPRADA
-- (debido al JOIN con ENTRADA_COMPRADA).


/* ============================================================
   VISTAS
   ============================================================ */

---------------------------------------------------------------
-- EJERCICIO 8
-- Vista con la recaudación total por película
---------------------------------------------------------------
CREATE OR REPLACE VIEW VW_RECAUDACION_PELICULA AS
SELECT pe.cod_pelicula,
       pe.titulo,
       SUM(ec.precio) AS recaudacion_total
FROM PELICULA pe
    JOIN PROYECCION p ON p.cod_pelicula   = pe.cod_pelicula
    JOIN ENTRADA e    ON e.cod_proyeccion = p.cod_proyeccion
    JOIN ENTRADA_COMPRADA ec
         ON ec.num_entrada = e.num_entrada
GROUP BY pe.cod_pelicula, pe.titulo;

-- La vista almacena por cada película su recaudación total
-- a partir de las entradas compradas.


---------------------------------------------------------------
-- EJERCICIO 9
-- Obtener la(s) película(s) con mayor recaudación
---------------------------------------------------------------
SELECT cod_pelicula, titulo, recaudacion_total
FROM VW_RECAUDACION_PELICULA
WHERE recaudacion_total = (
    SELECT MAX(recaudacion_total)
    FROM VW_RECAUDACION_PELICULA
);

-- Si hubiera empate, se mostrarían todas las películas
-- que compartan la recaudación máxima.


/* ============================================================
   PRIVILEGIOS Y ROLES (Ejercicio 10)
   Nota: estas sentencias se ejecutan en SQL*Plus.
   - 10.1, 10.2, 10.3, 10.6 como SYSTEM.
   - 10.4, 10.5, 10.7 como usuario CLARA.
   ============================================================ */

---------------------------------------------------------------
-- EJERCICIO 10.1 (SYSTEM)
-- Crear roles cartelera y taquilla y otorgar privilegios
---------------------------------------------------------------
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;  -- Necesario en algunas versiones

CREATE ROLE cartelera;                      -- Rol sin contraseña
CREATE ROLE taquilla IDENTIFIED BY taquilla_pwd;  -- Rol con contraseña

-- Privilegios sobre las tablas de películas y proyecciones
GRANT SELECT, INSERT, UPDATE, DELETE ON CINE.PELICULA   TO cartelera;
GRANT SELECT, INSERT, UPDATE, DELETE ON CINE.PROYECCION TO cartelera;

-- Privilegios sobre las tablas de entradas
GRANT SELECT, INSERT, UPDATE, DELETE ON CINE.ENTRADA            TO taquilla;
GRANT SELECT, INSERT, UPDATE, DELETE ON CINE.ENTRADA_COMPRADA   TO taquilla;
GRANT SELECT, INSERT, UPDATE, DELETE ON CINE.ENTRADA_INVITACION TO taquilla;


---------------------------------------------------------------
-- EJERCICIO 10.2 (SYSTEM)
-- Crear usuario Clara con CREATE SESSION
---------------------------------------------------------------
CREATE USER CLARA IDENTIFIED BY clara_pwd
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;         -- Para poder crear objetos si fuera necesario

GRANT CREATE SESSION TO CLARA;      -- Permite iniciar sesión en la BD


---------------------------------------------------------------
-- EJERCICIO 10.3 (SYSTEM)
-- Otorgar roles a Clara y establecer rol por defecto
---------------------------------------------------------------
GRANT cartelera TO CLARA;
GRANT taquilla  TO CLARA;

ALTER USER CLARA DEFAULT ROLE cartelera;   -- Rol por defecto: cartelera


---------------------------------------------------------------
-- EJERCICIO 10.4 (CLARA)
-- Probar consultas sobre CINE.PELICULA y CINE.ENTRADA_COMPRADA
---------------------------------------------------------------
-- (Estas sentencias se ejecutan tras conectarse como CLARA)
-- sqlplus clara/clara_pwd@//localhost:1521/xepdb1

-- Tiene privilegios sobre PELICULA (por rol cartelera)
SELECT * FROM CINE.PELICULA;

-- Esta consulta puede fallar inicialmente si el rol taquilla
-- no está activo por defecto
SELECT * FROM CINE.ENTRADA_COMPRADA;


---------------------------------------------------------------
-- EJERCICIO 10.5 (CLARA)
-- Activar rol taquilla y repetir la consulta
---------------------------------------------------------------
SET ROLE taquilla IDENTIFIED BY taquilla_pwd;

SELECT * FROM CINE.ENTRADA_COMPRADA;


---------------------------------------------------------------
-- EJERCICIO 10.6 (SYSTEM)
-- Desactivar todos los roles de Clara, incluido el rol por defecto
---------------------------------------------------------------
-- Opción 1: quitarle todos los roles
REVOKE cartelera FROM CLARA;
REVOKE taquilla  FROM CLARA;

ALTER USER CLARA DEFAULT ROLE NONE;

-- (Con esto, Clara ya no tendrá permisos a través de dichos roles)


---------------------------------------------------------------
-- EJERCICIO 10.7 (CLARA)
-- Probar a consultar de nuevo CINE.PELICULA
---------------------------------------------------------------
-- Después de reconectarse como CLARA:
-- sqlplus clara/clara_pwd@//localhost:1521/xepdb1

SELECT * FROM CINE.PELICULA;

-- Debería producir un error de falta de privilegios
-- tras haber revocado los roles en el ejercicio 10.6.

/* Fin del script */