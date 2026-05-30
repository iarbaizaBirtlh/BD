--1. Crea un bloque anónimo PL/SQL con un cursor que vaya visualizando los
--salarios de los empleados. Si en el cursor aparece el jefe (Steven King) se
--debe mostrar  un mensaje indicando que el sueldo del jefe no se puede ver.
--Utilizaremos el bucle FOR para recorrer el cursor.
SET SERVEROUTPUT ON;
DECLARE
    CURSOR cur_emp IS SELECT * FROM employees;
BEGIN
    FOR i IN cur_emp LOOP
        IF i.first_name = 'Steven' AND i.last_name = 'King' THEN
            dbms_output.put_line('El sueldo del jefe no se puede ver');
        ELSE
            dbms_output.put_line('El salario de ' || i.first_name || ' ' || i.last_name || ' es: ' || i.salary || '€.');
        END IF;
    END LOOP;
END;
/

--2. Crea un bloque anónimo en PL/SQL que contenga un cursor con los datos de la
--tabla empleados (id, first_name, salario) y muestra el salario de los empleados
--que tienen un sueldo superior a 8000. Si el sueldo es inferior muestra un mensaje
--diciendo que su salario es menor que 8000. Al final devuelve también el número
--de empleados cuyo sueldo es menor que 8000.
SET SERVEROUTPUT ON;
DECLARE
    CURSOR cur_emp IS SELECT * FROM employees;
    contador NUMBER := 0;
BEGIN
    FOR i IN cur_emp LOOP
        IF i.salary > 8000 THEN
            dbms_output.put_line('El salario de ' || i.first_name || ' ' || i.last_name || ' es superior a 8000€.');
        ELSE
            contador := contador + 1;
            dbms_output.put_line('El salario de ' || i.first_name || ' ' || i.last_name || ' es menor a 8000€.');
        END IF;
    END LOOP;
    dbms_output.put_line('El número de empleados cuyo sueldo es menor que 8000 es de: ' || contador);
END;
/

--3. Crea un bloque anónimo en PL/SQL que contenga un cursor de la tabla empleados.
--Debemos crearlo con FOR UPDATE. Por cada fila recuperada, si el salario es
--mayor que 8000 incrementaremos el salario un 2%. Si es menor lo hacemos en un
--3%. Deberemos realizar la modificación con la cláusula CURRENT OF. Mostraremos
--también en pantalla el número de empleados con salario menor que 8000 a los
--que hemos aumentado el salario.
SET SERVEROUTPUT ON;
DECLARE
    CURSOR cur_emp IS SELECT * FROM employees;
    contador NUMBER := 0;
BEGIN
    FOR i IN cur_emp LOOP
        IF i.salary > 8000 THEN
            UPDATE employees SET salary = salary * 1.02 WHERE();
        ELSE
            contador := contador + 1;
            UPDATE employees SET salary = salary * 1.03 WHERE();
        END IF;
    END LOOP;
END;
/

--4. Crea un bloque anónimo en PL/SQL que contenga un cursor que muestre los
--empleados que tienen un salario superior a la media del salario de su departamento.


--5. Crea un bloque anónimo en PL/SQL que contenga un cursor y visualice los
--nombres de los departamentos y sus jefes (manager).

