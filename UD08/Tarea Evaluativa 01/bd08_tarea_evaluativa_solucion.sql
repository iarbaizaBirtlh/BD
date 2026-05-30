SET SERVEROUTPUT ON;

/* =========================================================
   SOLUCION - TAREA EVALUATIVA ALTERNATIVA BD08
   ========================================================= */

/* =========================================================
   EJERCICIO 1
   ========================================================= */

CREATE OR REPLACE TYPE lista_puntos_interes AS TABLE OF VARCHAR2(100);
/

CREATE TABLE rutas (
    id              NUMBER(5)      PRIMARY KEY,
    nombre          VARCHAR2(100)  NOT NULL,
    descripcion     VARCHAR2(200)  NOT NULL,
    tipo            VARCHAR2(30)   NOT NULL,
    dificultad      VARCHAR2(20)   NOT NULL,
    duracion        NUMBER(4)      NOT NULL,
    puntos_interes  lista_puntos_interes
)
NESTED TABLE puntos_interes STORE AS nt_puntos_interes;
/

INSERT INTO rutas
VALUES (
    1,
    'Ruta del hayedo',
    'Recorrido circular entre bosque, cascada y miradores',
    'Montaña',
    'Media',
    180,
    lista_puntos_interes('Hayedo', 'Cascada', 'Mirador Norte', 'Ermita')
);

INSERT INTO rutas
VALUES (
    2,
    'Paseo marítimo histórico',
    'Ruta urbana junto al mar y el casco antiguo',
    'Urbana',
    'Baja',
    60,
    lista_puntos_interes('Puerto', 'Faro', 'Plaza Mayor', 'Murallas')
);

COMMIT;

SELECT *
FROM rutas;

SELECT p.COLUMN_VALUE AS punto_interes
FROM rutas r,
     TABLE(r.puntos_interes) p
WHERE r.nombre = 'Ruta del hayedo';

UPDATE rutas
SET puntos_interes = puntos_interes MULTISET UNION lista_puntos_interes('Mercado antiguo')
WHERE nombre = 'Paseo marítimo histórico';

SELECT p.COLUMN_VALUE AS punto_interes
FROM rutas r,
     TABLE(r.puntos_interes) p
WHERE r.nombre = 'Paseo marítimo histórico';

/* =========================================================
   EJERCICIO 2
   ========================================================= */

DECLARE
    CURSOR c_tecnicos IS
        SELECT *
        FROM tecnico
        WHERE anios_experiencia NOT BETWEEN 5 AND 10
        ORDER BY nif_tecnico;

    TYPE t_array_tecnicos IS TABLE OF tecnico%ROWTYPE INDEX BY PLS_INTEGER;

    v_tecnicos  t_array_tecnicos;
    v_indice    PLS_INTEGER := 0;
    i           PLS_INTEGER;
BEGIN
    FOR reg IN c_tecnicos LOOP
        v_indice := v_indice + 1;
        v_tecnicos(v_indice) := reg;
    END LOOP;

    i := v_tecnicos.FIRST;

    WHILE i IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(
            v_tecnicos(i).nif_tecnico || ' - ' ||
            v_tecnicos(i).anios_experiencia
        );

        i := v_tecnicos.NEXT(i);
    END LOOP;
END;
/

/* =========================================================
   EJERCICIO 3
   ========================================================= */

DECLARE
    TYPE r_tecnico IS RECORD (
        nif_tecnico        tecnico.nif_tecnico%TYPE,
        nombre             tecnico.nombre%TYPE,
        anios_experiencia  tecnico.anios_experiencia%TYPE
    );

    TYPE t_varray_tecnicos IS VARRAY(20) OF r_tecnico;

    v_tecnicos  t_varray_tecnicos := t_varray_tecnicos();
BEGIN
    SELECT nif_tecnico, nombre, anios_experiencia
    BULK COLLECT INTO v_tecnicos
    FROM tecnico
    WHERE anios_experiencia NOT BETWEEN 5 AND 10
    ORDER BY nif_tecnico;

    FOR i IN 1 .. v_tecnicos.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            v_tecnicos(i).nif_tecnico || ' - ' ||
            v_tecnicos(i).anios_experiencia
        );
    END LOOP;
END;
/

/* =========================================================
   EJERCICIO 4
   ========================================================= */

DECLARE
    TYPE r_tecnico IS RECORD (
        nif_tecnico        tecnico.nif_tecnico%TYPE,
        nombre             tecnico.nombre%TYPE,
        anios_experiencia  tecnico.anios_experiencia%TYPE
    );

    TYPE t_tabla_tecnicos IS TABLE OF r_tecnico;

    v_tecnicos  t_tabla_tecnicos := t_tabla_tecnicos();
BEGIN
    SELECT nif_tecnico, nombre, anios_experiencia
    BULK COLLECT INTO v_tecnicos
    FROM tecnico
    WHERE anios_experiencia NOT BETWEEN 5 AND 10
    ORDER BY nif_tecnico;

    FOR i IN 1 .. v_tecnicos.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            v_tecnicos(i).nif_tecnico || ' - ' ||
            v_tecnicos(i).anios_experiencia
        );
    END LOOP;
END;
/
