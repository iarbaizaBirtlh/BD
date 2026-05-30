--EJERCICIO 1
--La empresa quiere recoger en una tabla las actuaciones cuyo tiempo de realización no coincide con el tiempo estimado. Para ello debes seguir los siguientes pasos:
--Crea una tabla denominada DIFERENCIAS con 3 columnas:
--- Referencia.
--- Descripción.
--- Diferencia.
--Inserta en ella una fila por cada actuación en la que el tiempo estimado de la tabla ACTUACIONES no coincida con las horas realmente recogidas en la tabla Realizan.
--Para las columnas Referencia y Descripción elige los tipos de datos y tamaño coincidentes con las columnas de la tabla ACTUACIONES y en la columna Diferencia recoge la diferencia entre Horas y TiempoEstimado.
CREATE TABLE DIFERENCIAS (
    Referencia VARCHAR2(10),
    Descripcion VARCHAR2(100),
    Diferencia NUMBER(4, 2)
);
INSERT INTO DIFERENCIAS(Referencia, Descripcion, Diferencia)
SELECT a.referencia, a.descripcion, r.horas - a.tiempoestimado AS Diferencia
FROM actuaciones a
INNER JOIN realizan r ON a.referencia = r.referencia
WHERE r.horas <> a.tiempoestimado; --<> diferente a 

--EJERCICIO 2
--La empresa decide ascender de categoría al trabajador que más horas ha trabajado. La nueva categoría asignada será Oficial de 1ª mecánico.
UPDATE empleados
SET categoria='Oficial de 1ª mecánico'
WHERE(codempleado=(
    SELECT codempleado 
    FROM Intervienen 
    GROUP BY codempleado 
    HAVING SUM(horas) = (
        SELECT MAX(SUM(horas)) 
        FROM intervienen 
        GROUP BY codempleado
    )
));

--EJERCICIO 3
--Debido a la crisis del sector, la empresa decide reducir la plantilla. Esta reducción afectará a los empleados que hayan intervenido en 2 reparaciones o menos y que se hayan dado de alta en la
--empresa hace menos de 16 años.
--NOTA: Para resolver este ejercicio utiliza funciones de fecha, no utilices fechas como constantes.
DELETE FROM empleados WHERE codempleado IN(
    SELECT codempleado
    FROM intervienen
    GROUP BY codempleado
    HAVING COUNT(idreparacion) <= 2
)
AND add_months(fechaalta, 192) > sysdate;

--EJERCICIO 4
--El cliente Enrique Muriedas nos ha solicitado telefónicamente que le enviemos la factura de la
--reparación de referencia IdFactura=12. Los datos que teníamos registrados de esa factura son
--distintos. Reemplazar en la tabla FACTURAS los datos anteriores por los nuevos datos que nos ha
--suministrado el cliente. Estos datos son:
--IdFactura: 12, FechaFactura: '2011-10-03', CodCliente: '00005', IdReparacion:3;
UPDATE facturas 
SET fechafactura='2011-10-03',
    codcliente='00005',
    idreparacion=3
WHERE idfactura=12;

--EJERCICIO 5
--Uno de los vehículos registrados en nuestra base de datos ha cambiado de propietario. Registrar en
--una transacción ambos cambios:
--· Añadir a la tabla CLIENTES los datos del nuevo propietario: CodCliente='00011', DNI='112233445F', Apellidos='Campos, Vázquez', Nombre='Miguel Ángel', Direccion='Calle del Cid, nº 23, 1ºA, Santander', Telefono='345764423';
--· Modificar en la tabla VEHICULOS el CodCliente del nuevo propietario del vehículo de matrícula '1122 ABC'
--En medio de ambas modificaciones situar un punto de retorno (SAVEPOINT) para poder deshacer la transacción hasta ese punto si hay algún error.
--Finalmente la venta del vehículo no se confirma, pero decidimos mantener registrado el nuevo cliente.
INSERT INTO clientes VALUES('00011', '112233445F', 'Campos, Vázquez', 'Miguel Ángel', 'Calle del Cid, nº 23, 1ºA, Santander', '345764423');
SAVEPOINT modificacion;
UPDATE vehiculos
SET codcliente='0011'
WHERE(matricula='1122 ABC');
ROLLBACK TO SAVEPOINT modificacion;

--EJERCICIO 6
--La empresa decide borrar de la tabla VEHICULOS todos aquéllos vehículos que no hemos
--reparado en ninguna ocasión, por tanto no se encuentran referenciados en la tabla REPARACIONES.
DELETE FROM vehiculos
WHERE matricula NOT IN(
    SELECT matricula
    FROM reparaciones
);

--EJERCICIO 7
--Un cliente nuevo nos ha traído su vehículo al taller el día 03/03/2011. En recepción se registran los siguientes datos:
--- Del cliente.- Código: 00012, Nombre y apellidos: Tomás Gómez Calle, DNI: 22334455J
--- Del vehículo.- Matrícula: 3131 FGH, Modelo: Renault Scénic, matriculado el 17/03/2009, 105.000 km
--- De la reparación.- ID:11, Sustitución de las lámparas delanteras.
--Diseñar las consultas necesarias para recoger estos datos en las tablas.
INSERT INTO CLIENTES(CodCliente, Apellidos, Nombre, DNI) VALUES('00012', '22334455J', 'Tomás', 'Gómez Calle');
INSERT INTO VEHICULOS(Matricula, Modelo, FechaMatriculacion, Km, CodCliente) VALUES('3131 FGH', 'Renault Scénic', '17/03/2009', 105000,'00012');
INSERT INTO REPARACION VALUES(11, '3131 FGH', '03/03/2011', 105000, 'Sustitución de las lámparas delanteras', NULL, 0, NULL);

--EJERCICIO 8
--Avisamos al cliente de la reparación anterior para que pase hoy a recoger su vehículo que ya ha sido reparado.
--- Datos del recambio sustituido.- Código: LD_222_777, Unidades: 1 unidad
--- Empleado que ha realizado la reparación.- Código: 90000, Horas empleadas: 0,15
--- Datos de la actuación: Código: 1110008888, horas: las mismas.
--Registrar las operaciones necesarias en todas las tablas afectadas, recogidas en una transacción (REPARACIONES, Incluyen, RECAMBIOS, Intervienen, Realizan)


--EJERCICIO 9
--Realiza las siguientes dos vistas:
--- horas_empleados_vista: Mostrará la suma de horas que los empleados intervienen, junto con su nombre,apellido y categoria.
--- mejor_cliente_vista: Mostrará el cóodigo de cliente, nombre y apellidos de cliente con más reparaciones. No se podrán realizar modificaciones.


--EJERCICIO 10
--
--Este ejercicio se realizará en SQL*PLUS. Para ello os recuerdo que debéis ejecutar en una ventana de Símbolo del sistema:  sqlplus system/"contraseña"@//localhost:1521/xepdb1
--A partir de la versión 12 de Oracle es posible que sea necesaria la ejecución de la siguiente sentencia antes de realizar el ejercicio ya que Oracle exige que los nombres los nombres comunes de usuarios y roles comiencen por C##:
--
--alter session set "_ORACLE_SCRIPT"=true;
--
--- Conéctate con el usuario SYSTEM y crea dos roles, uno llamado administracion, con todos los privilegios sobre las tablas facturas y clientes del esquema FABER y otro llamado empleado con todos los privilegios sobre la tabla empleados e intervienen del mismo esquema. El rol de empleados estará identificado por contraseña.
--- Crea un nuevo usuario Unai en Oracle con las siguientes opciones:  DEFAULT TABLESPACE Users, TEMPORARY TABLESPACE Temp y otórgale el privilegio CREATE SESSION
--- Otorga los dos roles creados al usuario Unai y asigna por defecto el rol empleado.
--- Conéctate con el usuario Unai, (unai/"contraseña"@//localhost:1521/xepdb1) prueba a ejecutar una consulta sobre la tabla FABER.empleados y otra sobre la tabla FABER.clientes.
--- Con el usuario SYSTEM desactiva todos los roles del usuario Unai, incluyendo el rol por defecto.
