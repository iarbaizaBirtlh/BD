/*
Consulta 1.1:
Crear tipo colección para puntos_interes
*/

CREATE OR REPLACE TYPE t_puntos_interes AS TABLE OF VARCHAR2(100);
/

/*
Consulta 1.2:
Crear tabla RUTAS
*/

CREATE TABLE RUTAS (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    descripcion VARCHAR2(200),
    tipo VARCHAR2(50),
    dificultad VARCHAR2(20),
    duracion NUMBER,
    puntos_interes t_puntos_interes
)
NESTED TABLE puntos_interes STORE AS nt_puntos_interes;

/*
Consulta 1.3:
Insertar datos en RUTAS
*/

INSERT INTO RUTAS VALUES(
    1,
    'Ruta del hayedo',
    'Recorrido circular entre bosque, cascada y miradores',
    'Montaña',
    'Media',
    180,
    t_puntos_interes(
        'Hayedo',
        'Cascada',
        'Mirador Norte',
        'Ermita'
    )
);
INSERT INTO RUTAS VALUES(
    2,
    'Paseo marítimo histórico',
    'Ruta urbana junto al mar y el casco antiguo',
    'Urbana',
    'Baja',
    60,
    t_puntos_interes(
        'Puerto',
        'Faro',
        'Plaza Mayor',
        'Murallas'
    )
);

/*
Consulta 1.4:
Comprobar datos insertados
*/

SELECT * FROM RUTAS;

/*
Consulta 1.5:
Mostrar puntos de interés de la Ruta del hayedo
*/

SELECT COLUMN_VALUE AS puntos_interes FROM TABLE (
    SELECT puntos_interes FROM RUTAS WHERE nombre = 'Ruta del hayedo'
);

/*
Consulta 1.6:
Añadir nuevo punto de interés
*/

UPDATE RUTAS SET puntos_interes = puntos_interes MULTISET UNION t_puntos_interes('Museo Naval')
WHERE nombre = 'Paseo marítimo histórico';

/*
Consulta 2:
Array asociativo con tecnicos fuera del rango 5-10
*/

SET SERVEROUTPUT ON;
DECLARE
    TYPE t_tecnicos IS TABLE OF TECNICO%ROWTYPE INDEX BY PLS_INTEGER;
    v_tecnicos t_tecnicos;
    CURSOR cur_tec IS SELECT * FROM TECNICO WHERE anios_experiencia NOT BETWEEN 5 AND 10;
    v_indice PLS_INTEGER := 0;
BEGIN
    FOR tec IN cur_tec LOOP
        v_indice := v_indice + 1;
        v_tecnicos(v_indice) := tec;
    END LOOP;
    FOR i IN 1..v_tecnicos.COUNT LOOP
        dbms_output.put_line(v_tecnicos(i).nif_tecnico || ' * ' || v_tecnicos(i).anios_experiencia);
    END LOOP;
END;
/

/*
Consulta 3:
VARRAY con BULK COLLECT
*/

SET SERVEROUTPUT ON;
DECLARE
    TYPE t_array IS VARRAY(20) OF TECNICO%ROWTYPE;
    v_tecnicos t_array;
BEGIN
    SELECT * BULK COLLECT INTO v_tecnicos FROM TECNICO WHERE anios_experiencia NOT BETWEEN 5 AND 10;
    FOR i IN 1..v_tecnicos.COUNT LOOP
        dbms_output.put_line(v_tecnicos(i).nif_tecnico || ' * ' || v_tecnicos(i).anios_experiencia);
    END LOOP;
END;
/

/*
Consulta 4:
Tabla anidada con BULK COLLECT
*/

SET SERVEROUTPUT ON;
DECLARE
    TYPE t_tabla IS TABLE OF TECNICO%ROWTYPE;
    v_tecnicos t_tabla;
BEGIN
    SELECT * BULK COLLECT INTO v_tecnicos FROM TECNICO WHERE anios_experiencia NOT BETWEEN 5 AND 10;
    FOR i IN 1..v_tecnicos.COUNT LOOP
        dbms_output.put_line(v_tecnicos(i).nif_tecnico || ' * ' || v_tecnicos(i).anios_experiencia);
    END LOOP;
END;
/
