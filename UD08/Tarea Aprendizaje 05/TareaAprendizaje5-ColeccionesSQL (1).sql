--1. En primer lugar crea un varray llamado colec_hijos que conste de 10 valores como máximo de 30 caracteres cada uno. 
CREATE TYPE colec_hijos AS VARRAY(10) OF VARCHAR2(30);

--2. A continuación crea la tabla EMPLEADOS con los campos que se indican y para la columna hijos utiliza el varray creado.
CREATE TABLE empleados (
  ID NUMBER PRIMARY KEY,
  nombre VARCHAR2(30),
  apellido VARCHAR2(30),
  hijos colec_hijos);

--3. Inserta los datos en la tabla mediante dos sentencias INSERT. 
INSERT INTO empleados VALUES (1, 'Pepe', 'Navarro', colec_hijos('Pepito','Pepita'));
INSERT INTO empleados VALUES (2, 'Ana', 'Etxeberria', colec_hijos('Mario','Marina'));

--4. Actualiza la primera fila añadiendo un nuevo hijo a Pepe llamado Pepin.(No es posible usar MULTISET en Varrays)
UPDATE empleados SET hijos = colec_hijos ('Pepito', 'Pepita', 'Pepin') WHERE ID= 1;

--5. Realiza una consulta a toda la tabla para comprobar que las inserciones se han realizado correctamente.
SELECT * FROM empleados;

--6. Realiza la misma consulta utilizando la función TABLE y visualiza los hijos de manera separada.
SELECT nombre, H.*
FROM empleados, TABLE(empleados.hijos) H 

--7. Para no limitar la cantidad de valores dentro del atributo multivaluado, define un tipo tabla en el que se especifica el tipo de datos de la tabla. En este caso varchar2(30).
CREATE TYPE tabla_hijos AS TABLE OF VARCHAR2(30);

--8. Al igual que en el ejemplo anterior crea ahora la tabla EMPLEADOS2 basándola en el tipo tabla_hijos.
CREATE TABLE empleados2(
ID NUMBER,
nombre VARCHAR2(30),
apellido VARCHAR2(30),
hijos tabla_hijos)
NESTED TABLE hijos STORE AS t_hijos

--9. Realiza las inserciones necesarias. 
INSERT INTO empleados2 VALUES (1, 'Pepe', 'Navarro', tabla_hijos('Pepito','Pepita'));
INSERT INTO empleados2 VALUES (2, 'Ana', 'Etxeberria', tabla_hijos('Mario','Marina'));

--10. Actualiza la primera fila añadiendo un nuevo hijo a Pepe llamado Pepin (utiliza MULTISET UNION)
UPDATE empleados2 SET hijos = hijos
                 MULTISET UNION ALL 
                 tabla_hijos('Pepin')
WHERE nombre = 'Pepe'

--11. Elimina el hijo Pepito a Pepe (utiliza MULTISET EXCEPT)
UPDATE empleados2 SET hijos = hijos
                 MULTISET EXCEPT 
                 tabla_hijos('Pepito')
WHERE nombre = 'Pepe'

--12. Realiza de nuevo una consulta a toda la tabla para comprobar que las inserciones se han realizado correctamente.
SELECT * FROM empleados2;

--13. Realiza la misma consulta utilizando la función TABLE y visualiza los hijos de manera separada.

SELECT nombre, H.*
FROM empleados2, TABLE(empleados2.hijos) H