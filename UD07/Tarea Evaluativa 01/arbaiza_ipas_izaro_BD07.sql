/*
Consulta 1: Crea un bloque anónimo en PL/SQL que solicite un número por teclado
y determine si es múltiplo de 3 utilizando la función MOD.
*/
SET SERVEROUTPUT ON;
SET VERIFY OFF;
ACCEPT num1 PROMPT 'Introduce un número: '
DECLARE
    num1 NUMBER := '&num1';
BEGIN
    IF(MOD(num1, 3) = 0) THEN
        dbms_output.put_line('El número ' || num1 || ' ES múltiplo de 3');
    ELSE
        dbms_output.put_line('El número ' || num1 || ' NO es múltiplo de 3');
    END IF;
END;
/

/*
Consulta 2: Crea un bloque anónimo en PL/SQL que solicite un nombre por teclado
y lo muestre enmarcado con asteriscos utilizando un bucle FOR y la función LENGTH.
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;
ACCEPT nombre PROMPT 'Introduce un nombre: '
DECLARE
    nombre VARCHAR2(50) := '&nombre';
    longitud NUMBER := LENGTH(nombre) + 4;
BEGIN
    FOR i IN 1..longitud LOOP
        dbms_output.put('*');
    END LOOP;
    dbms_output.new_line;
    dbms_output.put_line('* ' || nombre || ' *');
    FOR i IN 1..longitud LOOP
        dbms_output.put('*');
    END LOOP;
    dbms_output.new_line;
END;
/

/*
Consulta 3: Crea un bloque anónimo en PL/SQL que determine si un número
introducido por teclado es primo o no.
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;
ACCEPT num1 PROMPT 'Introduce un número: '
DECLARE
    num1 NUMBER := '&num1';
    es_primo BOOLEAN := TRUE;
BEGIN
    FOR i IN 2..num1-1 LOOP
        IF (MOD(num1, i) = 0) THEN
            es_primo := FALSE;
        END IF;
    END LOOP;
    IF (es_primo AND num1 > 1) THEN
        dbms_output.put_line('El número ' || num1 || ' ES primo');
    ELSE
        dbms_output.put_line('El número ' || num1 || ' NO es primo');
    END IF;
END;
/

/*
Consulta 4: Crea un bloque anónimo en PL/SQL que solicite una cadena
de caracteres por teclado y la muestre al revés utilizando la función SUBSTR.
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;
ACCEPT texto PROMPT 'Introduce una cadena de caracteres: '
DECLARE
    texto VARCHAR2(100) := '&texto';
    resultado VARCHAR2(100) := '';
BEGIN
    FOR i IN REVERSE 1..LENGTH(texto) LOOP
        resultado := resultado || SUBSTR(texto, i, 1);
    END LOOP;
    dbms_output.put_line('Cadena invertida: ' || resultado);
END;
/

/*
Consulta 5: Crea un bloque anónimo en PL/SQL que solicite el NIF de un técnico
y devuelva su nombre y años de experiencia. En caso de no existir el técnico,
se lanzará la excepción NO_DATA_FOUND mostrando un mensaje.
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;
ACCEPT nif PROMPT 'Introduce el NIF del técnico: '
DECLARE
    nif tecnico.nif_tecnico%TYPE := '&nif';
    nombre tecnico.nombre%TYPE;
    experiencia tecnico.anios_experiencia%TYPE;
BEGIN
    SELECT
        nombre,
        anios_experiencia
    INTO
        nombre,
        experiencia
    FROM
        tecnico
    WHERE
        nif_tecnico = nif;
    dbms_output.put_line('Nombre ' || nombre);
    dbms_output.put_line('Años de experiencia: ' || experiencia);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No existe ningún técnico con ese NIF.');
END;
/

/*
Consulta 6: Crea un bloque anónimo en PL/SQL que inserte una nueva sala
en la tabla SALA. El id_sala se calculará obteniendo el valor máximo
de la tabla y sumándole uno. Se controlará la excepción DUP_VAL_ON_INDEX.
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;
ACCEPT nombre PROMPT 'Introduce el nombre de la sala: '
ACCEPT sede PROMPT 'Introduce la sede: '
ACCEPT aforo PROMPT 'Introduce el aforo: '
DECLARE
    nuevo_id NUMBER;
    nombre_sala sala.nombre_sala%TYPE := '&nombre';
    sede_sala sala.sede%TYPE := '&sede';
    aforo_sala sala.aforo%TYPE := '&aforo';
BEGIN
    SELECT
        MAX(id_sala)
    INTO
    nuevo_id
    FROM
        sala;
    nuevo_id := nuevo_id + 1;
    INSERT INTO sala (
        id_sala,
        nombre_sala,
        sede,
        aforo
    ) VALUES (
        nuevo_id,
        nombre_sala,
        sede_sala,
        aforo_sala
    );
    dbms_output.put_line('Sala insertada correctamente.');
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('No es posible duplicar la clave primaria.');
        ROLLBACK;
END;
/

/*
Consulta 7: Crea un bloque anónimo en PL/SQL que modifique el nombre del
técnico TEC005 añadiendo un prefijo dependiendo de sus años de experiencia.
Se añadirá "Snr_" si tiene más de 15 años y "Jnr_" si tiene menos de 5 años
utilizando la expresión CASE.
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    
BEGIN
    UPDATE
        tecnico
    SET
        nombre =
            CASE
                WHEN anios_experiencia > 15 THEN
                    'Snr_' || nombre
                WHEN anios_experiencia < 5 THEN
                    'Jnr_' || nombre
                ELSE
                    nombre
            END
    WHERE
        nif_tecnico = 'TEC005';
    dbms_output.put_line('Nombre del técnico actualizado');
END;
/
