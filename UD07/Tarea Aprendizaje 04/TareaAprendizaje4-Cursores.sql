/*EJERCICIOS de cursores PL/SQL esquema HR*/
--1. Crea un bloque anónimo PL/SQL con un cursor que vaya visualizando los salarios de los empleados. Si en el cursor aparece el jefe (Steven King) se debe mostrar  un mensaje indicando que el sueldo del jefe no se puede ver. Utilizaremos el bucle FOR para recorrer el cursor.
SET SERVEROUTPUT ON
DECLARE
CURSOR cur_emp IS 
   SELECT first_name,last_name,salary FROM employees;
BEGIN
FOR I IN cur_emp LOOP
IF I.first_name='Steven' AND I.last_name='King'
THEN
dbms_output.put_line('El salario del jefe no puede ser visto');
ELSE
dbms_output.put_line(I.first_name ||' ' || I.last_name || ': '|| I.salary || 'USD');
END IF;
END LOOP;
END;
/

--2. Crea un bloque anónimo en PL/SQL que contenga un cursor con los datos de la tabla empleados (id, first_name, salario) y muestra el salario de los empleados que tienen un sueldo superior a 8000. Si el sueldo es inferior muestra un mensaje diciendo que su salario es menor que 8000. Al final devuelve también el número de empleados cuyo sueldo es menor que 8000.
SET SERVEROUTPUT ON
DECLARE
  empid employees.employee_id%TYPE;
  nombre employees.first_name%TYPE;
  salario employees.salary%TYPE;
  contadorsalariobajo PLS_INTEGER :=0;
  CURSOR cur_emp IS 
    SELECT employee_id,first_name,salary
    FROM   employees;
BEGIN
  OPEN cur_emp;   
  LOOP
    FETCH cur_emp 
    INTO  empid, nombre, salario;
    EXIT
  WHEN cur_emp%NOTFOUND;
    IF (salario> 8000) THEN
      dbms_output.Put_line(empid|| ' '|| nombre|| ' '|| salario);
    ELSE
      dbms_output.Put_line(empid|| ' '|| nombre|| ': Su salario es menor que 8000');
	  contadorsalariobajo:=contadorsalariobajo+1;
    END IF;
  END LOOP;
  CLOSE cur_emp; 
   dbms_output.Put_line('El numero de empleados con el salario menor que 8000 es: '||contadorsalariobajo);
END;
/

--3. Crea un bloque anónimo en PL/SQL que contenga un cursor de la tabla empleados. Debemos crearlo con FOR UPDATE. Por cada fila recuperada, si el salario es mayor que 8000 incrementaremos el salario un 2%. Si es menor lo hacemos en un 3%. Deberemos realizar la modificación con la cláusula CURRENT OF. Mostraremos también en pantalla el número de empleados con salario menor que 8000 a los que hemos aumentado el salario.
SET SERVEROUTPUT ON
DECLARE
CURSOR cur_emp IS SELECT * FROM employees FOR UPDATE;
contadorsalariobajo number:=0;
BEGIN
FOR empleado IN cur_emp LOOP
IF empleado.salary > 8000 THEN
UPDATE employees SET salary=salary*1.02 WHERE CURRENT OF cur_emp;
ELSE
UPDATE employees SET salary=salary*1.03 WHERE CURRENT OF cur_emp;
contadorsalariobajo:=contadorsalariobajo+1;
END IF;
END LOOP;
COMMIT;
dbms_output.Put_line('El numero de empleados con el salario menor que 8000 es: '||contadorsalariobajo);
END ;
/

--4. Crea un bloque anónimo en PL/SQL que contenga un cursor que muestre los empleados que tienen un salario superior a la media del salario de su departamento.
SET SERVEROUTPUT ON
DECLARE
  CURSOR cur_emp IS
    SELECT department_id, first_name,last_name, salary
    FROM employees e
    WHERE salary > ( SELECT avg(salary)
                     FROM employees
                     WHERE e.department_id = department_id
                   )
    ORDER BY department_id, last_name;
BEGIN
  FOR empleado IN cur_emp
  LOOP
    DBMS_OUTPUT.PUT_LINE(empleado.first_name||empleado.last_name||' tiene un salario superior al salario medio del departamento '||empleado.department_id);
  END LOOP;
END;
/

--5. Crea un bloque anónimo en PL/SQL que contenga un cursor y visualice los nombres de los departamentos y sus jefes (manager)
SET SERVEROUTPUT ON
DECLARE
  CURSOR cur_jefe IS
      SELECT first_name, last_name, department_name
      FROM employees e
      INNER JOIN departments d ON d.manager_id = e.employee_id;
   jefe cur_jefe%ROWTYPE;
BEGIN
  OPEN cur_jefe;
  LOOP
    FETCH cur_jefe INTO jefe;
    EXIT WHEN cur_jefe%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(jefe.department_name || ': ' ||jefe.first_name || ' ' ||jefe.last_name);
  END LOOP;
  CLOSE cur_jefe;
END;
/