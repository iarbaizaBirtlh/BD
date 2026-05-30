SET SERVEROUTPUT ON
DECLARE
	TYPE varray1 IS VARRAY(10) OF VARCHAR2(50);
	datos varray1:=varray1('INFORMATICA','MATEMÁTICAS','BIOLOGÍA','LITERATURA');
BEGIN
	FOR I IN 1..4 LOOP
		dbms_output.put_line(datos(I));
	END LOOP;
END;
/

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

SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE array3(salario NUMBER) IS
    TYPE empleado IS VARRAY(1000) OF employees%rowtype;
    empleados empleado;
BEGIN
    SELECT * BULK COLLECT INTO empleados FROM employees WHERE salary > salario;
    dbms_output.put_line('NUMERO DE EMPLEADOS: ' || empleados.COUNT);
    FOR i IN 1..empleados.COUNT LOOP
        dbms_output.put_line(empleados(i).first_name || ' ' || empleados(i).salary);
    END LOOP;
END;
/
EXECUTE array3(1000);

CREATE OR REPLACE TYPE nombres IS VARRAY(200) OF VARCHAR2(100);
/
DECLARE
    nom_empleados nombres;
BEGIN
    SELECT first_name || ' ' || last_name BULK COLLECT INTO nom_empleados FROM employees;
    FOR i IN 1..nom_empleados.COUNT LOOP
        dbms_output.put_line(nom_empleados(i));
    END LOOP;
END;
/

CREATE TABLE departamentos(
    codigo NUMBER PRIMARY KEY,
    fecha_alta DATE,
    datos nombres
);
/

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

EXECUTE carga_departamentos;
/

SELECT * FROM departamentos;
/

SELECT * FROM departamentos WHERE codigo = 30;
/

SELECT codigo, T.* FROM departamentos, TABLE(departamentos.datos) T WHERE codigo = 30;
