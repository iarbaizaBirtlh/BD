--1.Crea un bloque anónimo en PL/SQL que visualice el identificador de trabajo
--(Job_id) del empleado número 100.
SET SERVEROUTPUT ON;
DECLARE
    --id_trabajo VARCHAR2(10);
    id_trabajo employees.job_id%TYPE;
BEGIN
    SELECT job_id INTO id_trabajo FROM employees WHERE(employee_id = 100);
    dbms_output.put_line('El identificador del trabajador 100 es: ' || id_trabajo);
END;
/

--2.Crea un bloque anónimo en PL/SQL que visualice el titulo del trabajo
--(Job_title) del empleado número 102
SET SERVEROUTPUT ON;
DECLARE
    titulo_trabajo jobs.job_title%TYPE;
BEGIN
    SELECT J.job_title INTO titulo_trabajo FROM employees E
    JOIN jobs J ON E.job_id = J.job_id WHERE(E.employee_id = 102);
    dbms_output.put_line('El titulo del del trabajo del empleado 102 es: ' || titulo_trabajo);
END;
/

--3.Crea un bloque anónimo en PL/SQL que visualice el nombre y el salario del
--empleado número 104. Utiliza una variable %ROWTYPE
SET SERVEROUTPUT ON;
DECLARE
    empleado employees%ROWTYPE;
BEGIN
    SELECT * INTO empleado FROM employees WHERE(employee_id = 104);
    dbms_output.put_line('Nombre emopleado: ' || empleado.first_name);
    dbms_output.put_line('Salario emopleado: ' || empleado.salary);
END;
/

--4.Crea un bloque anónimo en PL/SQL con una variable de tipo DEPARTMENT_ID y
--asígnale algún valor, por ejemplo 10. Visualiza el nombre de ese departamento
--y el número de empleados que tiene, utilizando la variable en la SELECT.
SET SERVEROUTPUT ON;
DECLARE
    cod_departamento departments.department_id%TYPE := 10;
    nom_departamento departments.department_name%TYPE;
    num_empleados NUMBER;
BEGIN
    SELECT department_name INTO nom_departamento FROM departments WHERE(department_id = cod_departamento);
    SELECT COUNT(*) INTO num_empleados FROM employees WHERE(department_id = cod_departamento);
    dbms_output.put_line('El departamento ' || nom_departamento || ' tiene ' || num_empleados || ' empleados.');
END;
/

--5.Escribe un bloque PL/SQL que devuelva el nombre del empleado y el nombre del
--departamento del empleado que es manager del empleado 106.
SET SERVEROUTPUT ON;
DECLARE
    nombre employees.first_name%TYPE;
    nombre_depto departments.department_name%TYPE;
BEGIN
    SELECT E.first_name, D.department_name INTO nombre, nombre_depto FROM employees E
    JOIN employees M ON e.manager_id = M.employee_id
    JOIN departments D ON m.department_id = D.department_id
    WHERE E.employee_id = 106;
    dbms_output.put_line('Nombre del emopleado: ' || nombre);
    dbms_output.put_line('Nombre del departamento: ' || nombre_depto);
END;
/

--6.Escribe un bloque PL/SQL para intercambiar los salarios de los empleados 110 y 112.
DECLARE
    salario_110 employees.salary%TYPE;
    salario_112 employees.salary%TYPE;
BEGIN
    SELECT salary INTO salario_110 FROM employees WHERE(employee_id = 110);
    SELECT salary INTO salario_112 FROM employees WHERE(employee_id = 112);
    UPDATE employees SET salary = salario_112 WHERE(employee_id = 110);
    UPDATE employees SET salary = salario_110 WHERE(employee_id = 112);
    COMMIT;
END;
/

--7.Escribe un bloque PL/SQL para modificar el porcentaje de comisión del empleado
--dependiendo de los siguientes supuestos:
--- Si el salario es superior a 10000 la comisión será de 0.4%.
--- Si el salario es menor de 10000 pero la experiencia es mayor que 20 años la
--comisión será de 0,35%.
--- Si el salario es menor que 3000 la comisión será de 0.25%.
--- En el resto de los casos la comisión será de 0.15 %.


--8.Escribe un bloque PL/SQL con una consulta que devuelva el nombre de un empleado
--introduciendo por teclado el EMPLOYEE_ID.
--- Comprobar en primer lugar que funciona pasando un empleado existente. Por ejemplo el 100
--- Pasar un empleado inexistente y comprobar que genera un error. Por ejemplo el 1000
--- Crear una zona de EXCEPTION para controlar que cuando no se encuentre ningún
--dato NO_DATA_FOUND devuelva un mensaje como 'No existe el empleado.'


--9.Modifica la SELECT del ejercicio anterior para que devuelva más de un empleado,
--por ejemplo poniendo EMPLOYEE_ID> 100. Debe generar un error.
--Controlar la excepción para que genere un mensaje como 'Demasiados empleados en la consulta.'


--10.Modifica la consulta para que devuelva un error de división por CERO,
--por ejemplo, vamos a devolver el salario en vez de el nombre y lo dividimos
--por 0 dentro del bloque. En este caso, en vez de controlar la excepción directamente,
--creamos una sección WHEN OTHERS y escribiremos el error con SQLCODE y SQLERR.


--11.Crea una excepción personalizada denominada CONTROL_REGIONES.
--Debe dispararse cuando al insertar o modificar una región queramos poner una
--clave superior a 200. Por ejemplo usando una variable con el valor 201.
--En ese caso debe generar un texto indicando algo así como 'Codigo no permitido.
--Debe ser inferior a 200'. Utilizaremos RAISE para lanzar la excepción.


--12.Modifica la práctica anterior para disparar un error con RAISE_APPLICATION
--en vez de con PUT_LINE. Este cambio nos permite que una aplicación pueda
--capturar y gestionar el error que devuelve el PL/SQL.


--13.El error -00001 es clave primaria duplicada. Aunque ya existe una predefinida
--(DUP_VAL_ON_INDEX) vamos a crear una excepción no predefinida que haga lo mismo.
--Usaremos la tabla REGIONS. Con PRAGMA EXCEPTION_INIT crearemos una excepción
--denominada 'duplicado' y cuando se genere ese error deberemos escribir el
--mensaje 'Clave duplicada, intente otra'. El error se generará cuando insertemos
--una fila en la tabla REGIONS que esté duplicada.

