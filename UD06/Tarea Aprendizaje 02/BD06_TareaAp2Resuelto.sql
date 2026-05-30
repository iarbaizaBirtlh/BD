--1. Inserta un registro nuevo en la tabla PROFESORADO utilizando la herramienta gráfica Oracle SQL Developer

--2. Inserta varios registros más en la tabla PROFESORADO utilizando sentencias SQL. Los datos deben ser los siguientes:
INSERT INTO profesorado (codigo, nombre, apellidos, dni, especialidad, fecha_nac, antiguedad) VALUES 
(2,'MARIA LUISA','FABRE BERDUN','51083099F','Tecnología','31/03/1975',4);
INSERT INTO profesorado (codigo, nombre, apellidos, especialidad, fecha_nac, antiguedad) VALUES 
(3,'JAVIER','JIMENEZ HERNANDO','Lengua','04/05/1969',10);
INSERT INTO profesorado (codigo, nombre, apellidos, dni, especialidad, fecha_nac, antiguedad) VALUES 
(4,'ESTEFANIA','FERNANDEZ MARTINEZ','19964324W','Inglés','22/06/1973',5);
INSERT INTO profesorado (codigo, nombre, apellidos) VALUES 
(5,'JOSE M.','ANERO PAYAN');
--3. Modifica los registros de la tabla CURSOS para asignar a cada curso un profesor o profesora. Utiliza para ello la herramienta gráfica.

--4. Modifica el registro de la profesora "ESTEFANIA", usando sentencias SQL, y cambia su fecha de nacimiento a "22/06/1974" y la antigüedad a 4.
UPDATE profesorado SET fecha_nac = '22/06/1974', antiguedad = 4 
WHERE codigo = 4;
--5. Modifica las antigüedades de todos los profesores y profesoras incrementándolas en 1 en todos los registros. Debes hacerlo usando un sola sentencia SQL.
UPDATE profesorado SET antiguedad = antiguedad + 1;
--6. Elimina, de la tabla CURSOS, el registro del curso que tiene el código 6. Debes realizar esta acción desde la herramienta gráfica.

--7. Elimina, de la tabla ALUMNADO, aquellos registros asociados al curso con código 3. Debes hacerlo usando un sola sentencia SQL.
DELETE FROM alumnado 
WHERE cod_curso = 3;
--8. Inserta los registros de la tabla ALUMNADO_NUEVO en la tabla ALUMNADO. Debes hacerlo usando un sola sentencia SQL.
INSERT INTO alumnado (nombre, apellidos, sexo, fecha_nac) 
(SELECT nombre, apellidos, sexo, fecha_nac 
 FROM alumnado_nuevo);
--9. En la tabla CURSOS, actualiza el campo Max_Alumn del registro del curso con código 2, asignándole el valor correspondiente al número total de alumnos y alumnas que hay en la tabla ALUMNADO y que tienen asignado ese mismo curso. Debes hacerlo usando un sola sentencia SQL.
UPDATE cursos SET max_alumn = (SELECT COUNT(codigo) 
							   FROM alumnado 
							   WHERE cod_curso = 2) 
WHERE codigo = 2;
--10. Elimina de la tabla ALUMNADO todos los registros asociados a los cursos que imparte la profesora cuyo nombre es "NURIA". Debes hacerlo usando un sola sentencia SQL.
DELETE FROM alumnado WHERE codigo IN (SELECT alumnado.codigo 
										FROM alumnado INNER JOIN cursos
										  ON alumnado.cod_curso = cursos.codigo
										  INNER JOIN profesorado
										    ON cursos.cod_profe = profesorado.codigo 
									  WHERE profesorado.nombre = 'NURIA');