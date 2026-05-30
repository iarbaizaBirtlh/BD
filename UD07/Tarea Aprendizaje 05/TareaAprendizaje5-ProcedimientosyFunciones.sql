--1. Crea un procedimiento que pasándole dos números como parámetro nos diga cual es el mayor o si son iguales.
CREATE OR REPLACE PROCEDURE es_mayor (x NUMBER,y NUMBER) AS
BEGIN
    IF x > y THEN dbms_output.put_line(x || ' es mayor');
    ELSIF x < y THEN dbms_output.put_line(y || ' es mayor');
    ELSE dbms_output.put_line('son iguales');
    END IF;
END;
/
execute es_mayor(5,9);
/


--2. Desarrolla un procedimiento que visualice el apellido y la fecha de alta de todos los empleados ordenados por apellido. No tenemos información de fecha de alta de todos lo empleados. Deberá mostrar los que haya.
CREATE OR REPLACE PROCEDURE emple_alta AS
	CURSOR cur_emp IS 
        SELECT last_name, start_date
		FROM employees E INNER JOIN job_history j ON E.employee_id=j.employee_id	
		ORDER BY last_name;
	apellido VARCHAR2(10);
	fecha DATE;
BEGIN
	OPEN cur_emp;
	FETCH cur_emp INTO apellido, fecha;
	WHILE cur_emp%found LOOP
	  dbms_output.put_line( apellido||' * '||fecha);
	  FETCH cur_emp INTO apellido,fecha; 
	END LOOP;
	CLOSE cur_emp;
END emple_alta;
/
execute emple_alta;
/
--3. Codifica un procedimiento que muestre el nombre de cada departamento y el número de empleados que tiene.
CREATE OR REPLACE PROCEDURE num_emple_dept AS
	CURSOR cur_emp IS 
		SELECT department_name, COUNT(employee_id)
		FROM employees INNER JOIN departments ON employees.department_id = departments.department_id
		GROUP BY department_name;
	nombre_dept departments.department_name%TYPE;
	num_emple PLS_INTEGER;
BEGIN
	OPEN cur_emp;
	FETCH cur_emp INTO nombre_dept, num_emple;
	WHILE cur_emp%found LOOP
	  dbms_output.put_line(nombre_dept||' * '||num_emple);
	  FETCH cur_emp INTO nombre_dept,num_emple;
	END LOOP;
	CLOSE cur_emp;
END num_emple_dept;
/
execute num_emple_dept;
/
--4. Repite el ejercicio anterior pero en esta ocasión el procedimiento recibirá el department_id como parámetro.
CREATE OR REPLACE PROCEDURE num_emple_dept2 (cod_dept departments.department_id%TYPE) AS
	CURSOR cur_emp IS 
		SELECT department_name, COUNT(employee_id)
		FROM employees INNER JOIN departments ON employees.department_id = departments.department_id
        WHERE departments.department_id=cod_dept
		GROUP BY department_name;
	nombre_dept departments.department_name%TYPE;
	num_emple PLS_INTEGER;
BEGIN
	OPEN cur_emp;
	FETCH cur_emp INTO nombre_dept, num_emple;
	WHILE cur_emp%found LOOP
	  dbms_output.put_line(nombre_dept||' * '||num_emple);
	  FETCH cur_emp INTO nombre_dept,num_emple;
	END LOOP;
	CLOSE cur_emp;
END num_emple_dept2;
/
EXECUTE num_emple_dept2(90);
/

--5. Escribe un procedimiento que visualice el apellido y el salario de los cinco empleados que tienen el salario más alto.

CREATE OR REPLACE PROCEDURE emp_5maxsal AS
	CURSOR cur_emp IS
		SELECT last_name, salary FROM employees
		ORDER BY salary  DESC;
	empleado cur_emp%rowtype;
BEGIN
	OPEN cur_emp;
	FETCH cur_emp INTO empleado;
	WHILE cur_emp%found AND cur_emp%rowcount<=5 LOOP	
	  dbms_output.put_line(empleado.last_name ||' * '|| empleado.salary);	    
	  FETCH cur_emp INTO empleado;
	END LOOP;
	CLOSE cur_emp;
END emp_5maxsal;
/
EXECUTE emp_5maxsal;
/

--6. Codifica un procedimiento que visualice los dos empleados que ganan menos en cada tipo de trabajo (JOB_ID).
CREATE OR REPLACE PROCEDURE emp_2minsal AS
	CURSOR cur_emp IS
	SELECT last_name, job_id, salary FROM employees
		ORDER BY job_id, salary;
	empleado cur_emp%rowtype;
	job_ant employees.job_id%TYPE:='*';--Debemos inicializar la variable para luego poder usarla en el IF.
	I NUMBER;
BEGIN
	OPEN cur_emp;
	FETCH cur_emp INTO empleado;
	WHILE cur_emp%found LOOP	
	  IF job_ant <> empleado.job_id THEN
	    job_ant := empleado.job_id;
	    I := 1;
	  END IF;
	  IF I <= 2 THEN
	    dbms_output.put_line(empleado.job_id||' * '||empleado.last_name||' * '||empleado.salary);	    
	  END IF;
	  FETCH cur_emp INTO empleado;
	  I:=I+1;
	END LOOP;
	CLOSE cur_emp;
END emp_2minsal;
/
EXECUTE emp_2minsal;
/

--7. Crea un procedimiento que suba el sueldo un 10% a los empledos que cobran más de 10000 y un 6% a los que cobran más de 6000. Utilizaremos el bucle FOR.
CREATE OR REPLACE PROCEDURE subida_sueldo AS 
CURSOR cur_sal IS SELECT salary FROM employees FOR UPDATE OF salary;
BEGIN
    FOR I IN cur_sal LOOP
        IF I.salary>10000 THEN
        UPDATE employees SET salary=salary*1.10 WHERE CURRENT OF cur_sal;
        ELSIF I.salary BETWEEN 6000 AND 10000 THEN
        UPDATE employees SET salary=salary*1.10 WHERE CURRENT OF cur_sal;
        END IF;
    END LOOP;
COMMIT;
END;
/
EXECUTE subida_sueldo;
/

--8. Codifica un procedimiento que reciba como parámetros un número de departamento, un importe y un porcentaje; y suba el salario a todos los empleados del departamento indicado en la llamada. La subida será el porcentaje o el importe indicado en la llamada (el que sea más beneficioso para el empleado en cada caso).

CREATE OR REPLACE PROCEDURE subida_sal1(num_depar employees.department_id%TYPE,	importe NUMBER,	porcentaje NUMBER) AS
	CURSOR cur_sal IS 
      SELECT salary
	  FROM employees  
      WHERE department_id = num_depar
      FOR UPDATE OF salary;
	salario cur_sal%rowtype;
	imp_pct NUMBER(10);
BEGIN
	OPEN cur_sal;
   	FETCH cur_sal INTO salario;
    IF cur_sal%notfound THEN RAISE no_data_found;
    END IF;
	WHILE cur_sal%found LOOP
        imp_pct :=  greatest((salario.salary/100)*porcentaje, importe);--Guardamos en imp_pct el importe mayor.   
        UPDATE employees SET salary=salary + imp_pct WHERE CURRENT OF cur_sal;
        FETCH cur_sal INTO salario;	 
	END LOOP;
	CLOSE cur_sal;
    COMMIT;
EXCEPTION
	WHEN no_data_found THEN
	  dbms_output.put_line('Error. Ninguna fila actualizada');
END subida_sal1;
/
EXECUTE subida_sal1(60,1000,20);
/

/*9. Crea una función para el cálculo del IVA con las siguientes características: 
	A la función se le pasará la cantidad y el tipo de IVA a aplicar que podrá ser:
		- 1 Tipo General 21%
		- 2 Tipo Reducido 10%
		- 3 Tipo Superreducido 4%
	
	La función devolverá el importe total (Cantidad + % de IVA aplicado)*/

CREATE OR REPLACE FUNCTION suma_iva (tipo PLS_INTEGER,cantidad NUMBER) RETURN NUMBER AS
    total   NUMBER := 0;
BEGIN
    CASE
        WHEN tipo = 1 THEN total := cantidad * 1.21;
        WHEN tipo = 2 THEN total := cantidad * 1.10;
        WHEN tipo = 3 THEN total := cantidad * 1.04;
    END CASE;
    RETURN total;
END;
/
SET SERVEROUTPUT ON
BEGIN
    dbms_output.put_line(suma_iva(1,1000));
END;
/

--10. Crea un función que dado un código de ciudad (location_id) devuelva el nombre de la ciudad. Tabla Locations. Si la ciudad no existe usaremos la excepción NO_DATA_FOUND para mostrar dicho mensaje.

CREATE OR REPLACE FUNCTION nombreciudad (cod locations.location_id%TYPE)RETURN locations.city%TYPE AS 
nombre locations.city%TYPE;
BEGIN
	SELECT city INTO nombre FROM locations
        WHERE location_id=cod;
	RETURN nombre;
EXCEPTION 
    WHEN no_data_found THEN
    dbms_output.put_line ('No existe ninguna ciudad con ese código');
    RETURN NULL;
END;
/

SET SERVEROUTPUT ON
BEGIN
    dbms_output.put_line(nombreciudad(12000));
END;
/

--11. Crea una función que tenga como parámetro un número de departamento y que devuelva la suma de los salarios de dicho departamento. Probaremos que funciona correctamente imprimiendo por pantalla el resultado devuelto. Si el departamento no existe debemos generar una excepción con dicho mensaje.
CREATE OR REPLACE FUNCTION salarios_dept(dep_id NUMBER) RETURN NUMBER AS
    total_sal NUMBER;
    dept departments.department_id%TYPE;
BEGIN
    SELECT SUM(salary) INTO total_sal FROM employees WHERE department_id=dep_id; 
    RETURN total_sal;
EXCEPTION
    WHEN no_data_found THEN
    raise_application_error(-20001,'Error, el departamento '||dep_id|| ' no existe');--si el departamento no existe devuelve error
END;
/
SET SERVEROUTPUT ON
DECLARE
    sal NUMBER;
    dept NUMBER:=100;
BEGIN
    sal:=salarios_dept(dept);
    dbms_output.put_line('El salario total del departamento ' || dept || ' es: ' || sal);
END;
/

--12. Crea una función almacenada que tenga como argumento una frase y devuelva el número de 'blancos' que tiene.
CREATE OR REPLACE FUNCTION contarblancos (F VARCHAR2) RETURN NUMBER AS
	cuentablancos 	NUMBER(2);
BEGIN
    cuentablancos := 0;
    FOR I IN 1..LENGTH(F) LOOP
        IF substr(F, I, 1) = ' '  THEN cuentablancos := cuentablancos + 1;
        END IF;
    END LOOP;
    RETURN cuentablancos;
END;
/
SET SERVEROUTPUT ON
BEGIN
dbms_output.put_line(contarblancos('hola mundo'));
END;
/

--13. Realiza un programa que, utilizando un cursor y la función para contarblancos del ejercicio anterior, cuente, para cada una de las direcciones de la tabla locations situadas en Italia (IT), el número de 'blancos' que tiene su street_address.

SET SERVEROUTPUT ON
DECLARE
	 CURSOR  cur_dir  IS
		SELECT street_address FROM locations
		WHERE  country_id = 'IT';
 	 dir	 cur_dir%rowtype;
BEGIN
	OPEN  cur_dir;
	LOOP
        FETCH  cur_dir  INTO  dir;
        EXIT  WHEN  cur_dir%notfound;
        dbms_output.put_line (dir.street_address||'   '|| contarblancos(dir.street_address));
	END LOOP;
	CLOSE  cur_dir;
END;
/

