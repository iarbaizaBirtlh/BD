--1. Construir un disparador de base de datos que permita auditar las operaciones
--de inserción o borrado de datos que se realicen en la tabla EMPLOYEES según las
--siguientes especificaciones:
--• En primer lugar se creará desde SQL*Plus la tabla AUDITAREMPLE con una única 
--columna col1 de tipo VARCHAR2(200).
--• Cuando se produzca cualquier manipulación se insertará una fila en dicha tabla
--que contendrá concatenada la siguiente información:
--• Fecha y hora.
--• Employee_ID y Last_Name que se han borrado o insertado.
--• La operación de actualización que ha tenido lugar: 'INSERCIÓN' o 'BORRADO'

--2. Crea un disparador BEFORE DELETE sobre la tabla EMPLOYEES que impida borrar
--un registro si su JOB_ID contiene la cadena 'CLERK'.

--3. Crea un disparador para asegurar que el salario de los empleados no se disminuye.

--4. Crea un disparador sobre la tabla EMPLOYEES para que al insertar un empleado
--no se permita que un empleado sea jefe de más de cinco empleados.

--5. Observa el disparador para actualizar la tabla JOB_HISTORY que está creado
--por defecto en el esquema HR y realiza una prueba para comprobar su correcto funcionamiento.
