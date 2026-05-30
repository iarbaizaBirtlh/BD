--Utilizaremos el esquema HR para los ejercicios del número 2 en adelante. 

--1. En un bloque anónimo, crea un NESTED TABLE que tenga los siguientes valores. Visualízalos mediante un bucle FOR.
Clave 	Valor
1 		INFORMATICA
2 		MATEMATICAS
3 		BIOLOGIA
4 		LITERATURA

SET SERVEROUTPUT ON
DECLARE
TYPE n_table IS TABLE OF VARCHAR2(50);
datos n_table:=n_table('INFORMATICA','MATEMÁTICAS','BIOLOGÍA','LITERATURA');
BEGIN
FOR I IN 1..4 LOOP
dbms_output.put_line(datos(I));
END LOOP;
END;
/

--2. Incluye las asignaturas FÍSICA e HISTORIA extendiendo la NESTED TABLE. Volver a visualizar el bucle

SET SERVEROUTPUT ON
DECLARE
TYPE n_table IS TABLE OF VARCHAR2(50);
datos n_table:=n_table('INFORMATICA','MATEMÁTICAS','BIOLOGÍA','LITERATURA');
BEGIN
FOR I IN 1..4 LOOP
dbms_output.put_line(datos(I));
END LOOP;
datos.extend(2);
datos(5):='HISTORIA';
datos(6):='FÍSICA';
FOR I IN 1..4 LOOP
dbms_output.put_line(datos(I));
END LOOP;
END;
/

--3. Crea un NESTED_TABLE a nivel de Base de datos, llamada NESTED_EMPLE que tenga como tipo un VARCHAR2(100).
CREATE OR REPLACE TYPE nested_emple IS TABLE OF VARCHAR2(100);

--4. Crea una función llamada NESTED1 que tenga como parámetro un NUMBER, en concreto el departamento de los empleados. Debe devolver una NESTED_TABLE de tipo NESTED_EMPLE (que hemos creado en el punto anterior) con el FIRST_NAME, LAST_NAME y SALARY concatenados.
CREATE OR REPLACE FUNCTION nested1 (departamento NUMBER)
RETURN nested_emple
IS
empleados nested_emple;
BEGIN
SELECT first_name||' '||last_name||' '|| salary BULK COLLECT INTO empleados
FROM employees WHERE department_id=departamento;
RETURN empleados;
END;

--5. Invoca esa función desde un bloque PL/SQL anónimo y visualiza los datos obtenidos. Por ejemplo, del departamento 30:

DECLARE
empleados nested_emple;
BEGIN
empleados:=nested1(30);
FOR I IN 1..empleados.COUNT LOOP
dbms_output.put_line(empleados(I));
END LOOP;
END;
/

--6. Crea una tabla de Base de datos denominada DEPARTAMENTOS1 que tenga la siguiente estructura. A la table auxiliar que debe tener la NESTED TABLE la llamanos NESTED_DATOS

COLUMNA 	TIPO
CODIGO 		NUMBER
FECHA_ALTA 	DATE
DATOS 		NESTED_EMPLE(La nested table creada anteriormente)

CREATE TABLE departamentos1
(
codigo NUMBER PRIMARY KEY,
fecha_alta DATE,
datos nested_emple
)
NESTED TABLE datos STORE AS nested_datos;
/

--7. Crea un bloque anónimo, que usando la función NESTED1 que hemos creado en un punto anterior cargue la tabla DEPARTAMENTOS1 con los datos de los empleados de cada departamento.
	--Por cada departamento de la table DEPARTMENTS inserta en la tabla DEPARTAMENTOS1 una fila con los siguientes datos:
		--CODIGO → DEPARTMENT_ID
		--FECHA_ALTA → La fecha de hoy
		--DATOS → la NESTED_TABLE recuperada de la función NESTED1 que contiene los datos de los empleados de ese departamento
DECLARE
empleados nested_emple;
CURSOR c1 IS SELECT * FROM departments;
BEGIN
FOR I IN c1 LOOP
empleados:=nested1(I.department_id);
INSERT INTO departamentos1 VALUES(I.department_id,sysdate,empleados);
END LOOP;
END;
/

--8. Visualizamos el resultado de la tabla
SELECT * FROM departamentos1;

--9. Lo hacemos también con la función TABLE, por ejemplo para el departamento 30
SELECT codigo,T.* FROM departamentos1, TABLE(departamentos1.datos) T
WHERE codigo=30;