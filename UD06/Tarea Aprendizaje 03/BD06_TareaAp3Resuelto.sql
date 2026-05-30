/*EJERCICIO 1 
La empresa quiere recoger en una tabla las actuaciones cuyo tiempo de realización no coincide con
el tiempo estimado. Para ello debes seguir los siguientes pasos:
	Crea una tabla denominada DIFERENCIAS con 3 columnas:
		Referencia.
		Descripción.
		Diferencia.
	Inserta en ella una fila por cada actuación en la que el tiempo estimado de la tabla
ACTUACIONES no coincida con las horas realmente recogidas en la tabla Realizan.
Para las columnas Referencia y Descripción elige los tipos de datos y tamaño coincidentes con las
columnas de la tabla ACTUACIONES y en la columna Diferencia recoge la diferencia entre
Horas y TiempoEstimado.*/
CREATE TABLE DIFERENCIAS (
Referencia varchar2(10) NOT NULL,
Descripcion varchar2(100) default NULL,
Diferencia number(4,2) default NULL,
PRIMARY KEY (Referencia)
);

INSERT INTO diferencias
SELECT actuaciones.referencia, descripcion, horas-tiempoestimado
FROM actuaciones INNER JOIN realizan 
  ON actuaciones.referencia=realizan.referencia
AND tiempoestimado<>horas;

/*EJERCICIO 2
La empresa decide ascender de categoría al trabajador que más horas ha trabajado. La nueva
categoría asignada será Oficial de 1ª mecánico.*/

UPDATE empleados SET categoria = 'Oficial de 1ª, mecánico'
WHERE codempleado = (SELECT * FROM( SELECT codempleado FROM intervienen 
                                    GROUP BY codempleado
                                    ORDER BY SUM(horas)DESC)
                    WHERE ROWNUM =1);

/*EJERCICIO 3
Debido a la crisis del sector, la empresa decide reducir la plantilla. Esta reducción afectará a los
empleados que hayan intervenido en 2 reparaciones o menos y que se hayan dado de alta en la
empresa hace menos de 10 años.
NOTA: Para resolver este ejercicio utiliza funciones de fecha, no utilices fechas como constantes.*/
DELETE FROM empleados WHERE codempleado IN(
SELECT codempleado
FROM intervienen 
GROUP BY codempleado
HAVING COUNT(idreparacion)<=2)
AND add_months(fechaalta, 192)>sysdate;

/*EJERCICIO 4
El cliente Enrique Muriedas nos ha solicitado telefónicamente que le enviemos la factura de la
reparación de referencia IdFactura=12. Los datos que teníamos registrados de esa factura son
distintos. Reemplazar en la tabla FACTURAS los datos anteriores por los nuevos datos que nos ha
suministrado el cliente. Estos datos son:
IdFactura: 12, FechaFactura: '2011-10-03', CodCliente: '00005', IdReparacion:3;
*/
UPDATE facturas SET idfactura= 12, fechafactura= '2011-10-03', codcliente= '00005', idreparacion=3
WHERE idfactura=12;

/*EJERCICIO 5
Uno de los vehículos registrados en nuestra base de datos ha cambiado de propietario. 
· Añadir a la tabla CLIENTES los datos del nuevo propietario:
CodCliente='00011', DNI='112233445F', Apellidos='Campos, Vázquez', Nombre='Miguel
Ángel', Direccion='Calle del Cid, nº 23, 1ºA, Santander', Telefono='345764423';
· Modificar en la tabla VEHICULOS el CodCliente del nuevo propietario del vehículo de
matrícula '1122 ABC'
En medio de ambas modificaciones situar un punto de retorno (SAVEPOINT) para poder deshacer
la transacción hasta ese punto si hay algún error.
Finalmente la venta del vehículo no se confirma, pero decidimos mantener registrado el nuevo
cliente.*/

INSERT INTO clientes VALUES('00011','112233445F','Campos, Vázquez','Miguel Ángel','Calle del Cid, nº23, 1ºA, Santander','345764423');
SAVEPOINT Modificacion;
UPDATE vehiculos SET codcliente='00011' WHERE matricula='1122 ABC';
ROLLBACK TO SAVEPOINT Modificacion;


/*EJERCICIO 6
La empresa decide borrar de la tabla VEHICULOS todos aquéllos vehículos que no hemos
reparado en ninguna ocasión, por tanto no se encuentran referenciados en la tabla
REPARACIONES.*/

DELETE FROM vehiculos 
WHERE matricula NOT IN (SELECT DISTINCT matricula FROM reparaciones); 

/*EJERCICIO 7
Un cliente nuevo nos ha traído su vehículo al taller el día 03/03/2011. En recepción se registran los
siguientes datos:
- Del cliente.- Código: 00012, Nombre y apellidos: Tomás Gómez Calle, DNI: 22334455J
- Del vehículo.- Matrícula: 3131 FGH, Modelo: Renault Scénic, matriculado el 17/03/2009,
105.000 km
- De la reparación.- ID:11, Sustitución de las lámparas delanteras.
Diseñar las consultas necesarias para recoger estos datos en las tablas.*/
INSERT INTO CLIENTES (CodCliente, Apellidos, Nombre, DNI) VALUES ('00012', 'Gómez Calle', 'Tomás', '22334455J' );
INSERT INTO VEHICULOS (matricula, marca, modelo, fechamatriculacion, codcliente)VALUES ('3131 FGH', 'Renault', 'Scénic', '17-03-2009', '00012');
INSERT INTO REPARACIONES VALUES (11, '3131 FGH', '03-03-2011', 105000,
'Sustituir lámparas delanteras', NULL, 0, NULL);



/*EJERCICIO 8
Avisamos al cliente de la reparación anterior para que pase hoy a recoger su vehículo que ya ha sido
reparado.
- Datos del recambio sustituido.- Código: LD_222_777, Unidades: 1 unidad
- Empleado que ha realizado la reparación.- Código: 90000, Horas empleadas: 0,15
- Datos de la actuación: Código: 1110008888, horas: las mismas.
Registrar las operaciones necesarias en todas las tablas afectadas:(REPARACIONES, Incluyen, RECAMBIOS, Intervienen, Realizan)*/
UPDATE reparaciones SET fechasalida=sysdate, reparado=1, observaciones='Sin observaciones'
WHERE  idreparacion = 11;
INSERT INTO incluyen VALUES ('LD_222_777', 11, 1);
UPDATE recambios SET stock=stock-1 WHERE idrecambio='LD_222_777';
INSERT INTO intervienen VALUES ('90000',11, 0.15);
INSERT INTO realizan VALUES (11, '1110008888', 0.15);


/*EJERCICIO 9

Realiza las siguientes dos vistas:

- horas_empleados_vista: Mostrara la suma de horas que los empleados intervienen, junto con su nombre,apellido y categoria.
- mejor_cliente_vista: Mostrará el cóodigo de cliente, nombre y apellidos de cliente con más reparaciones. No se podrán realizar modificaciones.
*/

CREATE VIEW horas_empleados_vista(Empleado,categoria,horas) as
select Nombre||' '||Apellidos,categoria, sum(horas) from empleados e inner join intervienen i on e.codempleado=i.codempleado group by Nombre||' '||Apellidos,categoria;

CREATE VIEW mejor_cliente_vista as
select c.codcliente,nombre||' '||apellidos,count(*)as cant from clientes c inner join facturas f on c.codcliente=f.codcliente group by c.codcliente,nombre,apellidos order by count(*)desc FETCH FIRST 1 ROWS ONLY with read only;

/*EJERCICIO 10
- Conéctate con el usuario SYSTEM y crea dos roles, uno llamado administracion, con todos los privilegios sobre las tablas facturas y clientes del esquema FABER y otro llamado empleado con todos los privilegios sobre la tabla empleados e intervienen del mismo esquema. El rol de empleados estará identificado por contraseña.

- Crea un nuevo usuario Unai en Oracle con las siguientes opciones:  DEFAULT TABLESPACE Users, TEMPORARY TABLESPACE Temp y otórgale el privilegio CREATE SESSION

- Otorga los dos roles creados al usuario Unai y asigna por defecto el rol empleado.

- Conéctate con el usuario Unai, (unai/"contraseña"@//localhost:1521/xepdb1) prueba a ejecutar una consulta sobre la tabla FABER.empleados y otra sobre la tabla FABER.clientes.

- Con el usuario SYSTEM desactiva todos los roles del usuario Unai, incluyendo el rol por defecto.
*/
create role administracion;
grant all privileges on ud6.facturas to administracion;
grant all privileges on ud6.clientes to administracion;

create role empleado identified by empleado;
grant all privileges on ud6.empleados to empleado;
grant all privileges on ud6.intervienen to empleado;

create user unai identified by unai;
alter user unai default tablespace Users TEMPORARY TABLESPACE Temp;
grant create session to unai;

grant empleado,administracion to unai;
----- desde la conexion de unai-----
set role empleado identified by empleado;

select * from FABER.empleados (podremos ver todos los registros)
select * from FABER.facturas (NO podemos ver los registros)

-------desde system-------

drop role empleado;
drop role administracion







