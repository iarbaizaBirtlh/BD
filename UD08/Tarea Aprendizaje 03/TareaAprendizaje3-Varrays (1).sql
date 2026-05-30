--Utilizaremos el esquema HR para los ejercicios del número 2 en adelante. 

--1. En un bloque anónimo, crea un VARRAY de 10 posiciones que tenga los siguientes valores. Visualízalos mediante un bucle FOR.
Clave 	Valor
1 		INFORMATICA
2 		MATEMATICAS
3 		BIOLOGIA
4 		LITERATURA

SET SERVEROUTPUT ON
DECLARE
TYPE varray1 IS VARRAY(10) OF VARCHAR2(50);
datos varray1:=varray1('INFORMATICA','MATEMÁTICAS','BIOLOGÍA','LITERATURA');
BEGIN
FOR I IN 1..4 LOOP
dbms_output.put_line(datos(I));
END LOOP;
END;

--2. Extiende el VARRAY anterior para que se incluyan las asignaturas FÍSICA e HISTORIA. Vuelve a visualizarlo  con un bucle FOR.

SET SERVEROUTPUT ON
DECLARE
TYPE varray1 IS VARRAY(10) OF VARCHAR2(50);
datos varray1:=varray1('INFORMATICA','MATEMÁTICAS','BIOLOGÍA','LITERATURA');
BEGIN
FOR I IN 1..4 LOOP
dbms_output.put_line(datos(I));
END LOOP;
datos.extend(2);
datos(5):='FISICA';
datos(6):='HISTORIA';
dbms_output.put_line('');
dbms_output.put_line('DESPUES DE EXTENDER');
FOR I IN 1..datos.COUNT LOOP
dbms_output.put_line(datos(I));
END LOOP;
END;
/

--3. Crea un procedimiento que tenga como parámetro un NUMBER, en concreto el salario de los empleados:
	--Crea un VARRAY de 1000 posiciones para almacenar los empleados
	--Mediante un BULK COLLECT carga los empleados que ganen más que el salario que se ha pasado al procedimiento
	--Visualiza el número de empleados cargado
	--Visualiza los empleados mediante un bucle FOR
	
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE ejemplo_varray1(salario NUMBER)
IS
TYPE empleado IS VARRAY(1000) OF employees%rowtype;
empleados empleado;
BEGIN
SELECT * BULK COLLECT INTO empleados FROM employees WHERE salary> salario;
dbms_output.put_line('NUMERO DE EMPLEADOS:'||empleados.COUNT);
FOR I IN 1..empleados.COUNT LOOP
dbms_output.put_line(empleados(I).first_name||' '||empleados(I).salary);
END LOOP;
END;
/

EXECUTE ejemplo_varray1(10000);


--4.Crea un VARRAY a nivel de Base de datos que se denomine NOMBRES y con un tamaño de 200 y de tipo VARCHAR2(100)
	--Utilízalo dentro de un bloque PL/SQL anónimo para cargar los nombres y apellidos de los empleados.
	--Visualízalo
	
CREATE OR REPLACE TYPE nombres IS VARRAY(200) OF VARCHAR2(100);
/
DECLARE
nom_empleados nombres;
BEGIN
SELECT first_name||' '||last_name BULK COLLECT INTO nom_empleados
FROM employees;
FOR I IN 1..nom_empleados.COUNT LOOP
dbms_output.put_line(nom_empleados(I));
END LOOP;
END;
/

--5. Crea una tabla de Base de datos denominada DEPARTAMENTOS que tenga la siguiente estructura

COLUMNA 	TIPO
CODIGO 		NUMBER
FECHA_ALTA 	DATE
DATOS 		NOMBRES (El varray creado en el ejercicio anterior)

CREATE TABLE departamentos
(
codigo NUMBER PRIMARY KEY,
fecha_alta DATE,
datos nombres
);
/

--6. Crea un procedimiento denominado CARGA_DEPARTAMENTOS que hará lo siguiente
	--Por cada departamento de la table DEPARTMENTS insertamos en la tabla DEPARTAMENTOS una fila con los siguientes datos:
		--CODIGO → DEPARTMENT_ID
		--FECHA_ALTA → La fecha de hoy
		--DATOS → El FIRST_NAME, LAST_NAME concatenado de todos los empleados de ese departamento
		
CREATE OR REPLACE PROCEDURE carga_departamentos IS
CURSOR c1 IS SELECT * FROM departments;
empleados nombres;
BEGIN
FOR I IN c1 LOOP
SELECT first_name||' '||last_name BULK COLLECT INTO empleados
FROM employees WHERE department_id=I.department_id;
INSERT INTO departamentos VALUES (I.department_id,sysdate,empleados);
END LOOP;
END;
/
-- 7. Lo ejecutamos
EXECUTE carga_departamentos;
/
-- 8.Una vez cargados los datos lo visualizamos, en primer lugar al completo. Por ejemplo:
SELECT * FROM departamentos;
/
-- 9.Visualizamos los datos del departamento 30. Deben salir en una sola línea
SELECT * FROM departamentos WHERE codigo=30;
/
-- 10. Por último, lo visualizamos con la función TABLE, para ver los datos de forma individual del departamento 30. Por ejemplo
SELECT codigo, T.*
FROM departamentos, TABLE(departamentos.datos) T
WHERE codigo=30;
