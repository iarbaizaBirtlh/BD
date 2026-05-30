--Utilizaremos el esquema HR para los ejercicios del número 2 en adelante. 

--1. En un bloque anónimo, crea un array asociativo que tenga los siguientes valores y visualizalos mediante un bucle FOR
Clave 	Valor
1 		INFORMATICA
2 		MATEMATICAS
3 		BIOLOGIA
4 		LITERATURA

SET SERVEROUTPUT ON

DECLARE
    TYPE array1 IS
        TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    datos array1;
BEGIN
    datos(1) := 'INFORMATICA';
    datos(2) := 'MATEMÁTICAS';
    datos(3) := 'BIOLOGÍA';
    datos(4) := 'LITERATURA';
    FOR I IN 1..4 LOOP dbms_output.put_line(datos(I));
    END LOOP;

END;

--2. Crea un procedimiento donde vamos a cargar en un array asociativo los datos de los empleados de la tabla employees que pertenezcan a un determinado departamento. 
	--El departamento lo pasamos como argumento del procedimiento.
	--La clave será un número desde el 1 hasta el total de empleados cargados.
	--Por último visualizamos el nombre y apellidos de los empleados.

CREATE OR REPLACE PROCEDURE prueba_array1(codigo NUMBER) IS
TYPE v1 IS TABLE OF employees%rowtype INDEX BY PLS_INTEGER;
tabla v1;
indice NUMBER:=1;
CURSOR datos IS SELECT * FROM employees WHERE
department_id=codigo;
BEGIN
FOR I IN datos LOOP
tabla(indice):=I;
indice:=indice+1;
END LOOP;
FOR X IN 1..indice-1 LOOP
dbms_output.put_line(tabla(X).first_name||' '||tabla(X).last_name);
END LOOP;
END;
/
--3. Lo mismo utilizando atributos del cursor (%rowcount) y métodos de los arrays (first, last)
CREATE OR REPLACE PROCEDURE prueba_array1(codigo NUMBER) IS
TYPE v1 IS TABLE OF employees%rowtype INDEX BY PLS_INTEGER;
tabla v1;
CURSOR datos IS SELECT * FROM employees WHERE
department_id=codigo;
BEGIN
FOR I IN datos LOOP
tabla(datos%rowcount):=I;
END LOOP;
FOR X IN tabla.first..tabla.last LOOP
dbms_output.put_line(tabla(X).first_name||' '||tabla(X).last_name);
END LOOP;
END;
/

EXECUTE prueba_array1(100);

--4.Crea una copia del procedimiento anterior, pero en este caso:
	--Hacemos un BULK COLLECT a la hora de cargar los datos
	--Visualizamos también el nombre y apellido de cada empleado para comprobar que está OK. En esta ocasión deberemos usar la función COUNT para saber el tamaño del array.
CREATE OR REPLACE PROCEDURE prueba_array2(codigo NUMBER)
IS
TYPE v1 IS TABLE OF employees%rowtype INDEX BY PLS_INTEGER;
tabla v1;
BEGIN
SELECT * BULK COLLECT INTO tabla FROM employees WHERE department_id=codigo;
FOR X IN 1..tabla.COUNT LOOP
dbms_output.put_line(tabla(X).first_name||' '||tabla(X).last_name);
END LOOP;
END;
/
EXECUTE prueba_array2(100);

--5. Modifica el procedimiento anterior para que visualice
	--El nombre y salario del primer empleado
	--El nombre y salario del ultimo empleado
	--Comprueba si temenos un empleado en el índice 200. Si no es así devuelve un mensaje del tipo “Empleado 200 inexistente”
	--Elimina del ARRAY los empleados que ganen más de 5000 dolares. Visualiza el número de empleados antes y después del proceso.
	--Por ultimo,visualiza el array con los empleados que han quedado. Antes de visualizarlos comprueba que no haya sido eliminado por el delete. 
	
CREATE OR REPLACE PROCEDURE prueba_array2(codigo NUMBER)
IS
TYPE v1 IS TABLE OF employees%rowtype INDEX BY PLS_INTEGER;
tabla v1;
indice NUMBER;
BEGIN
SELECT * BULK COLLECT INTO tabla FROM employees WHERE department_id=codigo;
FOR X IN 1..tabla.COUNT LOOP
dbms_output.put_line(tabla(X).first_name||' '||tabla(X).last_name);
END LOOP;
dbms_output.put_line('PRIMER EMPLEADO');
dbms_output.put_line(tabla(tabla.FIRST()).first_name||' '||tabla(tabla.FIRST()).salary);
dbms_output.put_line('ÚLTIMO EMPLEADO');
dbms_output.put_line(tabla(tabla.LAST()).first_name||' '||tabla(tabla.LAST()).salary);
IF NOT tabla.EXISTS(200) THEN
dbms_output.put_line('EMPLEADO 200 INEXISTENTE');
END IF;
dbms_output.put_line('ANTES DEL BORRADO HAY:'||tabla.COUNT);
indice := tabla.FIRST;
WHILE indice IS NOT NULL LOOP
  IF tabla(indice).salary > 5000 THEN
    tabla.DELETE(indice);
  END IF;
  indice := tabla.NEXT(indice);
END LOOP;
dbms_output.put_line('DESPUES DEL BORRADO HAY:'||tabla.COUNT);
indice := tabla.FIRST;
WHILE indice IS NOT NULL LOOP
  dbms_output.put_line(tabla(indice).first_name||' '||tabla(indice).last_name);
  indice := tabla.NEXT(indice);
END LOOP;
END;
/
EXECUTE prueba_array2(30);