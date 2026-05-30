--1.Crea un bloque anónimo que visualice el identificador de trabajo (Job_id) del empleado número 100.
SET SERVEROUTPUT ON
DECLARE
id_trabajo employees.job_id%TYPE;
BEGIN
SELECT job_id INTO id_trabajo FROM employees
WHERE employee_id=100;
dbms_output.put_line('El tipo de trabajo del empleado 100 es: '||id_trabajo);
END;

--2.Crea un bloque anónimo que visualice el titulo del trabajo (Job_title) del empleado número 102
SET SERVEROUTPUT ON
DECLARE
titulo_trabajo jobs.job_title%TYPE;
BEGIN
SELECT j.job_title INTO titulo_trabajo 
FROM employees E INNER JOIN jobs j ON E.job_id=j.job_id
WHERE employee_id=102;
dbms_output.put_line('El titulo del trabajo del empleado 102 es: '||titulo_trabajo);
END;

--3.Crea un bloque anónimo que visualice el nombre y el salario del empleado número 104. Utiliza una variable %ROWTYPE
SET SERVEROUTPUT ON
DECLARE
    empleado employees%rowtype;
BEGIN
    SELECT * INTO empleado
    FROM    employees
    WHERE employee_id = 104;
	dbms_output.put_line(empleado.first_name);
    dbms_output.put_line(empleado.salary);
END;
/
--4.Crea un bloque anónimo en PL/SQL con una variable de tipo DEPARTMENT_ID y asígnale algún valor, por ejemplo 10. Visualiza el nombre de ese departamento y el número de empleados que tiene, utilizando la variable en la SELECT.
SET SERVEROUTPUT ON
DECLARE
cod_departamento departments.department_id%TYPE:=10;
nom_departamento departments.department_name%TYPE;
num_emple NUMBER;
BEGIN
SELECT department_name INTO nom_departamento FROM departments WHERE department_id=cod_departamento;--Obtenemos el nombre del departamento.
SELECT COUNT(*) INTO num_emple FROM employees WHERE department_id=cod_departamento;--Obtenemos el numero de empleados.
dbms_output.put_line('EL DEPARTAMENTO '||nom_departamento||' TIENE '||num_emple||' EMPLEADOS');
END;

--5.Escribe un bloque PL/SQL que devuelva el nombre del empleado y el nombre del departamento del empleado que es manager del empleado 106.
SET SERVEROUTPUT ON
DECLARE
    nombre     employees.first_name%TYPE;
    nombre_depto departments.department_name%TYPE;
BEGIN
    SELECT  e.first_name , d.department_name INTO nombre, nombre_depto
    FROM  employees e INNER JOIN departments d ON e.department_id=d.department_id
    WHERE employee_id = ( SELECT manager_id FROM employees    WHERE employee_id = 106);
    dbms_output.put_line('Nombre del empleado: '||nombre);
    dbms_output.put_line('Nombre del departamento: '||nombre_depto);
END;
/

--6.Escribe un bloque PL/SQL para intercambiar los salarios de los empleados 110 y 112
DECLARE
   salario_110   employees.salary%TYPE;
BEGIN
  SELECT  salary INTO salario_110
  FROM employees 
  WHERE  employee_id = 110;
  UPDATE employees SET salary = (SELECT salary FROM employees WHERE employee_id = 112) WHERE employee_id = 110;
  UPDATE employees SET salary = salario_110  WHERE employee_id = 112;
  COMMIT;
END;
/*7.Escribe un bloque PL/SQL para modificar el porcentaje de comisión del empleado dependiendo de los siguientes supuestos:
Si el salario es superior a 10000 la comisión será de 0.4%.
Si el salario es menor de 10000 pero la experiencia es mayor que 20 años la comisión será de 0,35%
Si el salario es menor que 3000 la comisión será de 0.25%
En el resto de los casos la comisión será de 0.15 % */

DECLARE
    salario  employees.salary%TYPE;
    experiencia     NUMBER(2);
    comision     NUMBER(5,2);
BEGIN
    SELECT  salary,  floor ( (sysdate-hire_date)/365) INTO salario, experiencia
    FROM  employees
    WHERE employee_id = 150;
    IF salario > 10000 THEN comision := 0.4;
    ELSIF  experiencia > 20 THEN comision := 0.35;
    ELSIF  salario < 3000 THEN comision := 0.25;
    ELSE  comision := 0.15;
    END IF;
    UPDATE employees SET commission_pct = comision WHERE employee_id = 150;
END;
/

/*8.Escribe un bloque PL/SQL con una consulta que devuelva el nombre de un empleado introduciendo por teclado el EMPLOYEE_ID.
- Comprobar en primer lugar que funciona pasando un empleado existente. Por ejemplo el 100
- Pasar un empleado inexistente y comprobar que genera un error. Por ejemplo el 1000
- Crear una zona de EXCEPTION para controlar que cuando no se encuentre ningún dato NO_DATA_FOUND devuelva un mensaje como 'No existe el empleado.'*/
SET SERVEROUTPUT ON
SET VERIFY OFF --Opcional 
DECLARE
nombre_empleado employees.first_name%TYPE;
codigoempleado employees.employee_id%TYPE:=&codigoempleado;
BEGIN
SELECT first_name INTO nombre_empleado FROM employees
WHERE employee_id=codigoempleado;
dbms_output.put_line(nombre_empleado);
EXCEPTION
WHEN no_data_found THEN
dbms_output.put_line('No existe el empleado.');
END;
/

/*9. Modifica la SELECT del ejercicio anterior para que devuelva más de un empleado, por ejemplo poniendo EMPLOYEE_ID> 100. Debe generar un error. Controlar la excepción para que genere un mensaje como 'Demasiados empleados en la consulta.'*/
SET SERVEROUTPUT ON
DECLARE
nombre_empleado employees.first_name%TYPE;
BEGIN
SELECT first_name INTO nombre_empleado FROM employees
WHERE employee_id>100;
dbms_output.put_line(nombre_empleado);
EXCEPTION
WHEN no_data_found THEN
dbms_output.put_line('No existe el empleado.');
WHEN too_many_rows THEN
dbms_output.put_line('Demasiados empleados en la consulta.');
END;
/

/*10. Modifica la consulta para que devuelva un error de división por CERO, por ejemplo, vamos a devolver el salario en vez de el nombre y lo dividimos por 0 dentro del bloque. En este caso, en vez de controlar la excepción directamente, creamos una sección WHEN OTHERS y escribiremos el error con SQLCODE y SQLERR*/

SET SERVEROUTPUT ON
DECLARE
nombre_empleado employees.first_name%TYPE;
salario NUMBER;
BEGIN
SELECT salary INTO salario
FROM
employees
WHERE
employee_id = 100;
salario:=salario/0;
dbms_output.put_line(salario);
EXCEPTION
WHEN no_data_found THEN
dbms_output.put_line('No existe el empleado.');
WHEN too_many_rows THEN
dbms_output.put_line('Empleado duplicado.');
WHEN OTHERS THEN
dbms_output.put_line('CODIGO:'||SQLCODE);
dbms_output.put_line('MENSAJE:'||sqlerrm);
END;
/
/*11.Crea una excepción personalizada denominada CONTROL_REGIONES.
 Debe dispararse cuando al insertar o modificar una región queramos poner una clave superior a 200. Por ejemplo usando una variable con el valor 201. En ese caso debe generar un texto indicando algo así como 'Codigo no permitido. Debe ser inferior a 200' Utilizaremos RAISE para lanzar la excepción*/

SET SERVEROUTPUT ON
DECLARE
control_regiones EXCEPTION;
codigo NUMBER:=201;
BEGIN
IF codigo > 200 THEN RAISE control_regiones;
ELSE INSERT INTO regions VALUES (codigo,'PRUEBA');
END IF;
EXCEPTION
WHEN control_regiones THEN
dbms_output.put_line('El codigo debe ser inferior a 200');
END;
/

/*12.Modifica la práctica anterior para disparar un error con RAISE_APPLICATION en vez de con PUT_LINE. Este cambio nos permite que una aplicación pueda capturar y gestionar el error que devuelve el PL/SQL.*/

SET SERVEROUTPUT ON
DECLARE
codigo NUMBER:=201;
BEGIN
IF codigo > 200 THEN
raise_application_error(-20001,'El codigo debe ser inferior a 200');
ELSE
INSERT INTO regions VALUES (codigo,'PRUEBA');
END IF;
END;

/*13.El error -00001 es clave primaria duplicada. Aunque ya existe una predefinida (DUP_VAL_ON_INDEX) vamos a crear una excepción no predefinida que haga lo mismo. Usaremos la tabla REGIONS. Con PRAGMA EXCEPTION_INIT crearemos una excepción denominada 'duplicado' y cuando se genere ese error deberemos escribir el mensaje 'Clave duplicada, intente otra'. El error se generará cuando insertemos una fila en la tabla REGIONS que esté duplicada.*/
SET SERVEROUTPUT ON
DECLARE
duplicado EXCEPTION;
PRAGMA exception_init(duplicado,-00001);
BEGIN
INSERT INTO regions VALUES (1,'PRUEBA');
COMMIT;
EXCEPTION
WHEN duplicado THEN
dbms_output.put_line('Clave duplicada, intente otra');
END;

