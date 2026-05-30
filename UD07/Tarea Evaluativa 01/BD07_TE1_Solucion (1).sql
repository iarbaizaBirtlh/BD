//1. Crea un bloque anónimo PL/SQL que introduciendo un número por teclado diga si es multiplo de 3 o no. (Utiliza la función MOD)

SET SERVEROUTPUT ON
DECLARE
  n1 NUMBER := &num1;
BEGIN
  IF MOD(n1,3) = 0 THEN
    DBMS_OUTPUT.PUT_LINE('El número '||n1||' es múltiplo de 3.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('El número '||n1||' NO es múltiplo de 3.');
  END IF;

  DBMS_OUTPUT.PUT_LINE('Done Successfully');
END;
/

//2. Crea un bloque anónimo en PL/SQL que pida un nombre por teclado. Deberemos enmarcar el nombre con asteriscos. Utilizaremos un bucle FOR para ello. 
//Por ejemplo:
//***********
//* Alberto *
//***********

SET SERVEROUTPUT ON
DECLARE
  nombre VARCHAR2(20) := '&nombre';
  linea  VARCHAR2(200) := '';
BEGIN
  -- Construimos la línea de asteriscos: LENGTH(nombre) + 4
  FOR i IN 1 .. (LENGTH(nombre) + 4) LOOP
    linea := linea || '*';
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(linea);
  DBMS_OUTPUT.PUT_LINE('* ' || nombre || ' *');
  DBMS_OUTPUT.PUT_LINE(linea);
END;
/

//3. Crea un bloque anónimo en PL/SQL que analice si un número es primo o no

SET SERVEROUTPUT ON;
DECLARE
  n NUMBER := &num1;
  divisores NUMBER := 0;
BEGIN
  IF n <= 1 THEN
    DBMS_OUTPUT.PUT_LINE('El número '||n||' no es primo.');
  ELSE
    -- Contamos cuántos divisores tiene entre 1 y n
    FOR i IN 1 .. n LOOP
      IF MOD(n, i) = 0 THEN
        divisores := divisores + 1;
      END IF;
    END LOOP;

    IF divisores = 2 THEN
      DBMS_OUTPUT.PUT_LINE('El número '||n||' es primo.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('El número '||n||' no es primo.');
    END IF;
  END IF;
END;
/

//4. Crea un bloque anónimo en PL/SQL que devuelva una cadena de caracteres introducida por teclado, al revés. (Utiliza la función SUBSTR).
SET SERVEROUTPUT ON;
DECLARE
	str1 VARCHAR2(50):='&str';
	str2 VARCHAR2(50);
	len NUMBER;
BEGIN
	len:=LENGTH(str1);
	FOR I IN REVERSE 1..len
	LOOP
		str2:=str2 || substr(str1,I,1);
	END LOOP;
	dbms_output.put_line('La cadena al revés es:'||str2);
END;
/

//5. Crea un bloque anónimo en PL/SQL que introduciendo un un nif_tecnico, devolver nombre y años de experiencia. En caso de que no exista un técnico con el Nif introducido lanzar una excepción predefinida NO_DATA_FOUND con un mensaje 'No existe ningún técnico con ese Nif '.

SET SERVEROUTPUT ON;

ACCEPT nif CHAR PROMPT 'Introduce NIF del técnico: '

DECLARE
  v_nif TECNICO.nif_tecnico%TYPE := '&nif';
  v_nombre TECNICO.nombre%TYPE;
  v_exp TECNICO.anios_experiencia%TYPE;
BEGIN
  SELECT nombre, anios_experiencia
  INTO v_nombre, v_exp
  FROM TECNICO
  WHERE nif_tecnico = v_nif;

  DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre);
  DBMS_OUTPUT.PUT_LINE('Años experiencia: ' || v_exp);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No existe ningún técnico con ese NIF.');
END;
/

//6. Crea un bloque anónimo en PL/SQL que inserte un nuevo departamento en la tabla SALA. Para saber el id_sala  que debemos asignar a la nueva SALA, primero deberemos averiguar el valor máximo que existe en la tabla SALA y sumarle uno para la nueva clave. 
//- NOTA: en PL/SQL debemos usar COMMIT y ROLLBACK de la misma forma que lo hacemos en SQL. Por tanto, para validar definitivamente un cambio debemos usar COMMIT dentro del bloque PL/SQL. 
//- Por si acaso, controlaremos mediante la excepción predefinida DUP_VAL_ON_INDEX que el registro que se introduce no tiene la clave primaria duplicada en la tabla y mostraremos el siguiente mensaje en caso de que se lance la excepción. 'No es posible duplicar la clave primaria'

SET SERVEROUTPUT ON;

DECLARE
  v_new_id SALA.id_sala%TYPE;
BEGIN
  SELECT NVL(MAX(id_sala),0) + 1 INTO v_new_id FROM SALA;

  INSERT INTO SALA (id_sala, nombre_sala, sede, aforo)
  VALUES (v_new_id, 'Sala Negra', 'Cine Centro', 100);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Insertada SALA id=' || v_new_id);

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('No es posible duplicar la clave primaria');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

//7. Crea un bloque anónimo en PL/SQL que modifique el nombre del tecnico TEC005 y añadir un prefijo "Snr_" si tiene mas de 15 años de experiencia y "Jnr_" si tiene menos de 5 años de experiencia (Utiliza la función CASE).

DECLARE
    v_exp NUMBER(2);
    v_prefijo VARCHAR2(4);
BEGIN
    SELECT anios_experiencia INTO v_exp
    FROM TECNICO
    WHERE nif_tecnico = 'TEC005';

    CASE
      WHEN v_exp > 15 THEN v_prefijo := 'Snr_';
      WHEN v_exp < 5  THEN v_prefijo := 'Jnr_';
      ELSE v_prefijo := NULL;
    END CASE;

    IF v_prefijo IS NOT NULL THEN
        UPDATE TECNICO
        SET nombre = v_prefijo || nombre
        WHERE nif_tecnico = 'TEC005';
    END IF;

    COMMIT;
END;
/


