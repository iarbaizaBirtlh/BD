/*EJERCICIOS de disparadores PL/SQL esquema HR*/

/*1. Construir un disparador de base de datos que permita auditar las operaciones de inserción o borrado de datos que se realicen en la tabla employees según las siguientes especificaciones:
•	En primer lugar se creará desde SQL*Plus la tabla auditaremple con una única columna col1 de tipo VARCHAR2(200).
•	Cuando se produzca cualquier manipulación se insertará una fila en dicha tabla que contendrá concatenada la siguiente información: 
•	Fecha y hora.
•	Employee_ID y Last_Name que se han borrado o insertado.
•	La operación de actualización que ha tenido lugar: 'INSERCIÓN' o 'BORRADO'*/
CREATE OR REPLACE TRIGGER auditar_act_emp
   BEFORE INSERT OR DELETE
   ON employees
   FOR EACH ROW
BEGIN
   IF deleting THEN 
      INSERT INTO auditaremple VALUES(to_char(sysdate,'DD/MM/YY*HH24:MI*') || :OLD.employee_id|| '*' || :OLD.last_name || '* BORRADO ');
   ELSIF inserting THEN
      INSERT INTO auditaremple VALUES(to_char(sysdate,'DD/MM/YY*HH24:MI*') || :NEW.employee_id || '*' || :NEW.last_name||'* INSERCION ');
   END IF;
END ;
/
--Prueba:
INSERT INTO EMPLOYEES VALUES (300,'Pepe','Perez','p@p','3123121','10/10/05','SA_MAN','','','','');
/

--2. Crea un disparador BEFORE DELETE sobre la tabla EMPLOYEES que impida borrar un registro si su JOB_ID contiene la cadena 'CLERK'.
CREATE OR REPLACE TRIGGER no_borrar_clerk BEFORE
DELETE ON employees FOR EACH ROW
BEGIN
IF :OLD.job_id LIKE '%CLERK%' THEN
    raise_application_error(-20320,'No se puede borrar nada que contenga CLERK en el JOB_ID');
END IF;
END;
/
--Prueba:
DELETE FROM employees WHERE job_id LIKE ('%CLERK');
/

--3. Crea un disparador para asegurar que el salario de los empleados no se disminuye.
CREATE OR REPLACE TRIGGER  chequeo_salario_empleados
BEFORE UPDATE
ON employees
FOR EACH ROW
BEGIN
   IF  :OLD.salary > :NEW.salary THEN
         raise_application_error(-20112,'¡Disculpa! No es posible disminuir el salario');
   END IF;
END;
/
--Prueba:
UPDATE employees SET salary=1 WHERE job_id LIKE ('%FI%');
/

--4. Crea un disparador sobre la tabla EMPLOYEES para que al insertar un empleado no se permita que un empleado sea jefe de más de cinco empleados.
CREATE OR REPLACE TRIGGER jefe_max_5
BEFORE INSERT ON employees
FOR EACH ROW
DECLARE
supervisa PLS_INTEGER;
BEGIN
SELECT count(*) INTO supervisa
FROM employees WHERE manager_id = :new.manager_id;
IF (supervisa > 4) THEN raise_application_error (-20607,:new.manager_id||': No se pueden supervisar más de 5 empleados');
END IF;
END;
/
--Prueba:
INSERT INTO EMPLOYEES VALUES (302,'Sonia','Garcia','s@g','3123121','10/10/05','SA_MAN','','','121','');
/

--5.Observa el disparador para actualizar la tabla JOB_HISTORY que está creado por defecto en el esquema HR y realiza una prueba para comprobar su correcto funcionamiento. Su código es el siguiente:
CREATE OR REPLACE TRIGGER update_job_history
  AFTER UPDATE OF job_id, department_id ON employees
  FOR EACH ROW
BEGIN
  add_job_history(:OLD.employee_id, :OLD.hire_date, sysdate,
                  :OLD.job_id, :OLD.department_id);
END;
/
CREATE OR REPLACE PROCEDURE add_job_history
  (  p_emp_id          job_history.employee_id%TYPE
   , p_start_date      job_history.start_date%TYPE
   , p_end_date        job_history.end_date%TYPE
   , p_job_id          job_history.job_id%TYPE
   , p_department_id   job_history.department_id%TYPE
   ) IS
BEGIN
  INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id) VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END add_job_history;
/
--Prueba: Actualiza JOB_ID e y comprueba el contenido de la tabla JOB_HISTORY
UPDATE  employees set JOB_ID='SA_MAN' WHERE employee_id=144;
/
