--1.¿Cuántos clientes tiene cada país?
SELECT pais, COUNT(*)
FROM clientes
GROUP BY pais;
--2.¿Cuál fue el pago medio en 2009? Muéstralo solamente con 2 decimales.
SELECT round (AVG(cantidad),2)
FROM pagos
WHERE EXTRACT( YEAR FROM fechapago) = 2009;

SELECT TO_CHAR(AVG(cantidad), '9G999G999G999G999D99') "Pago medio en 2009" 
FROM pagos WHERE fechapago >= '01/01/2009' AND fechapago <= '31/12/2009';

SELECT round(AVG (cantidad),2) 
FROM pagos
WHERE to_char(fechapago, 'YYYY')= '2009';
--3.¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.
SELECT estado, COUNT(*)
FROM pedidos
GROUP BY estado
ORDER BY COUNT(*) DESC;
--4.Calcula el precio de venta del producto más caro y más barato en una misma consulta.
SELECT MAX(precioventa), MIN(precioventa)
FROM productos;
--5.Devuelve el nombre, los apellidos y el email de los empleados a cargo de Alberto Soria.
SELECT *
FROM empleados
WHERE codigojefe = (SELECT codigoempleado 
                     FROM empleados 
                     WHERE nombre = 'Alberto' AND apellido1 = 'Soria');
					 
SELECT e.nombre, e.apellido1, e.apellido2, e.email FROM empleados e
INNER JOIN empleados emp ON e.codigojefe = emp.codigoempleado 
WHERE emp.nombre = 'Alberto' AND emp.apellido1= 'Soria';

--6.Devuelve el nombre, apellidos y puesto de aquellos que no sean representantes de ventas.
SELECT nombre, apellido1, apellido2, puesto
FROM empleados
WHERE puesto != 'Representante Ventas';
--7.¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
SELECT ciudad, COUNT(*)
FROM clientes
WHERE ciudad LIKE 'M%'
GROUP BY ciudad;
--8.Devuelve el código de empleado y el número de clientes al que atiende cada representante de ventas.
SELECT codigoempleadorepventas, COUNT(*)
FROM clientes
GROUP BY codigoempleadorepventas;

SELECT c.codigoempleadorepventas, COUNT(c.codigocliente) FROM clientes c 
INNER JOIN empleados e ON c.codigoempleadorepventas = e.codigoempleado
WHERE e.puesto = 'Representante Ventas' GROUP BY c.codigoempleadorepventas;

--9.Calcula la fecha del primer y último pago realizado por cada uno de los clientes.
SELECT codigocliente, MIN(fechapago), MAX(fechapago)
FROM pagos
GROUP BY codigocliente;;
--10.Devuelve el código de cliente de aquellos clientes que hicieron pagos en 2008.
SELECT codigocliente
FROM pagos
WHERE EXTRACT (YEAR FROM fechapago) = '2008';

SELECT codigocliente FROM pagos WHERE fechapago BETWEEN '01/01/08' AND '31/12/08' GROUP BY codigocliente;
--11.Devuelve un listado de los 20 códigos de productos más vendidos y el número total de unidades que se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.
SELECT * 
FROM (SELECT codigoproducto, SUM(cantidad) AS unidadesvendidas
	  FROM detallepedidos
	  GROUP BY codigoproducto
	  ORDER BY unidadesvendidas DESC)
WHERE ROWNUM <= 20;
https://blogs.oracle.com/oraclemagazine/on-rownum-and-limiting-results

SELECT codigoproducto, SUM(cantidad) AS unidadesvendidas
	  FROM detallepedidos
	  GROUP BY codigoproducto
	  ORDER BY unidadesvendidas DESC
      FETCH FIRST 20 ROWS ONLY;
--12.El código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada. 
SELECT codigopedido, codigocliente, fechaesperada, fechaentrega
FROM pedidos
WHERE fechaentrega <= fechaesperada-2;
--13.La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el número de unidades vendidas de la tabla  detalle_pedido. El IVA es el 21 % de la base imponible, y el total la suma de los dos campos anteriores.
SELECT SUM(cantidad * preciounidad) AS base_imponible,
       SUM(cantidad * preciounidad) * 0.21 AS iva,
       SUM(cantidad * preciounidad) + SUM(cantidad * preciounidad) * 0.21 AS total
FROM detallepedidos;
--14.Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT nombrecliente, nombre, apellido1
FROM clientes INNER JOIN empleados
  ON clientes.codigoempleadorepventas = empleados.codigoempleado
WHERE codigocliente NOT IN (SELECT codigocliente FROM pagos);
--opcional GROUP BY nombrecliente, nombre, apellido1;

SELECT c.nombrecliente, e.nombre FROM clientes c 
INNER JOIN empleados e ON c.codigoempleadorepventas = e.codigoempleado MINUS
SELECT c.nombrecliente, e.nombre FROM pagos p
INNER JOIN clientes c ON c.codigocliente = p.codigocliente
INNER JOIN empleados e ON c.codigoempleadorepventas = e.codigoempleado;

SELECT nombrecliente, nombre AS nombreresponsableventas
FROM clientes LEFT JOIN pagos on clientes.codigocliente=pagos.codigocliente
    INNER JOIN empleados ON clientes.codigoempleadorepventas=empleados.codigoempleado
WHERE formapago IS NULL;
--15.El producto que más unidades tiene en stock y el que menos unidades tiene.
/*Opción 1*/
SELECT nombre, cantidadenstock
FROM productos
WHERE cantidadenstock = (
  SELECT MAX(cantidadenstock)
  FROM productos
  )
UNION
SELECT nombre, cantidadenstock
FROM productos
WHERE cantidadenstock = (
  SELECT MIN(cantidadenstock)
  FROM productos
  );
 /*Opción 2*/
 SELECT nombre, cantidadenstock
FROM productos
WHERE cantidadenstock = (
  SELECT MAX(cantidadenstock)
  FROM productos
  )
OR
 cantidadenstock = (
  SELECT MIN(cantidadenstock)
  FROM productos
  );
--16.Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. Ten en cuenta que pueden existir clientes que no han realizado ningún pago. En este caso se indicará "No ha realizado ningún pago"
SELECT clientes.nombrecliente, NVL(to_char(SUM(pagos.cantidad)),'No se ha realizado ningún pago') AS total_pagado
FROM clientes LEFT OUTER JOIN pagos
  ON clientes.codigocliente = pagos.codigocliente
GROUP BY clientes.nombrecliente;
--17.Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados alfabéticamente de menor a mayor.
--Opción 1 (distinct)
SELECT DISTINCT clientes.nombrecliente
FROM clientes INNER JOIN pedidos
  ON clientes.codigocliente = pedidos.codigocliente
WHERE EXTRACT (YEAR FROM pedidos.fechapedido) = 2008
ORDER BY clientes.nombrecliente ASC;
--Opción 2 (group by)
SELECT clientes.nombrecliente
FROM clientes INNER JOIN pedidos
  ON clientes.codigocliente = pedidos.codigocliente
WHERE EXTRACT (YEAR FROM pedidos.fechapedido) = 2008
GROUP BY clientes.nombrecliente
ORDER BY clientes.nombrecliente ASC;
--18.Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas y el número de teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago.
/* Solución con subconsultas */
SELECT clientes.nombrecliente, empleados.nombre, empleados.apellido1, oficinas.telefono
FROM clientes INNER JOIN empleados
  ON clientes.codigoempleadorepventas = empleados.codigoempleado
  INNER JOIN oficinas 
    ON empleados.codigooficina = oficinas.codigooficina
WHERE codigocliente NOT IN (SELECT codigocliente FROM pagos);
/* Solución con LEFT OUTER JOIN */
SELECT clientes.nombrecliente, empleados.nombre, empleados.apellido1, oficinas.telefono
FROM clientes INNER JOIN empleados
  ON clientes.codigoempleadorepventas = empleados.codigoempleado
  INNER JOIN oficinas 
    ON empleados.codigooficina = oficinas.codigooficina
    LEFT OUTER JOIN pagos
      ON clientes.codigocliente = pagos.codigocliente
WHERE pagos.codigocliente IS NULL;

--19.Nombre de los clientes que hayan hecho un pago en 2007
SELECT DISTINCT c.nombrecliente 
FROM clientes c INNER JOIN pagos p 
  ON c.codigocliente=p.codigocliente 
WHERE P.fechapago LIKE '%/07';
--WHERE P.fechapago BETWEEN'01/01/07' AND '31/12/07';

--20. Muestra el número de pedido, el nombre del cliente, la fecha de entrega y la fecha requerida  de los pedidos que no han sido entregados a tiempo.
SELECT p.codigopedido, c.nombrecliente, p.fechaentrega, p.fechaesperada 
FROM clientes c INNER JOIN pedidos p 
  ON c.codigocliente = p.codigocliente 
WHERE p.fechaesperada < p.fechaentrega;
--21. Muestra el código, nombre y gama de los productos que nunca se han pedido (detalle pedidos).
SELECT p.codigoproducto, p.nombre, p.gama 
FROM productos p
WHERE p.codigoproducto NOT IN (SELECT d.codigoproducto FROM detallepedidos d);

SELECT pro.codigoproducto, pro.nombre, pro.gama 
FROM productos pro LEFT OUTER JOIN detallepedidos det 
ON pro.codigoproducto = det.codigoproducto
WHERE det.codigoproducto IS NULL;

--22. Muestra el nombre y apellidos de los empleados que trabajan en Barcelona.
SELECT e.nombre, e.apellido1 || ' ' || e.apellido2 
FROM empleados e inner join oficinas o 
  on e.codigooficina = o.codigooficina 
WHERE o.ciudad = 'Barcelona';

--23. Mostrar el precio final de cada pedido.
SELECT d.codigopedido, SUM(d.cantidad * d.preciounidad) AS total
FROM detallepedidos d 
GROUP BY d.codigopedido;

SELECT p.codigopedido, SUM(dp.cantidad * dp.preciounidad) AS total
FROM pedidos p INNER JOIN detallepedidos dp
  ON p.codigopedido = dp.codigopedido
GROUP BY p.codigopedido;

--24. Devuelve cuantos pedidos se ha entregado cada día de la semana (lunes, martes...) ordenados de menos pedidos a más. No se muestran los pedidos que no han sido entregados.
SELECT COUNT(*),(to_char (p.fechaentrega, 'DAY'))
FROM pedidos p
WHERE p.fechaentrega IS NOT NULL
GROUP BY (to_char (p.fechaentrega, 'DAY'))
ORDER BY 1;
--25.Nombre del cliente y fecha de pedido  con formato "1 de Enero de 2000" de los pedidos que tienen algún comentario
SELECT C.nombrecliente, to_char(P.fechapedido, 'DD')||' de '||to_char(P.fechapedido, 'Month')||' de '||to_char(P.fechapedido, 'YYYY') AS fecha_de_pedido
FROM clientes C INNER JOIN pedidos P ON C.codigocliente=P.codigocliente
WHERE P.comentarios IS NOT NULL;

SELECT cli.nombrecliente, to_char(ped.fechapedido, 'DL')
FROM clientes cli INNER JOIN pedidos ped USING (codigocliente)
WHERE ped.comentarios IS NOT NULL;
--26.Muestra el nombre de los clientes cuya ciudad empiezan por M y que han realizado algún pedido.
SELECT DISTINCT  c.nombrecliente 
FROM clientes c INNER JOIN pedidos p 
  ON c.codigocliente=p.codigocliente 
WHERE c.ciudad like 'M%';

SELECT nombrecliente, ciudad
FROM clientes
WHERE codigocliente IN (SELECT codigocliente FROM pedidos) AND ciudad LIKE 'M%';
--27.Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA).
SELECT nombre, SUM(cantidad) AS total_unidades,
       SUM(cantidad*preciounidad) AS total_facturado,
       SUM(cantidad*preciounidad)*1.21 AS total_con_impuestos
FROM detallepedidos INNER JOIN productos
  ON detallepedidos.codigoproducto = productos.codigoproducto
GROUP BY nombre
HAVING SUM(cantidad*preciounidad) > 3000;
--28. Mostrar el codigo de los pedidos donde se hayan vendido mas de 6 productos.
SELECT codigopedido, COUNT (*) AS productos_vendidos
FROM detallepedidos
GROUP BY codigopedido
HAVING COUNT (*)>6;

SELECT pe.codigopedido
FROM pedidos pe INNER JOIN detallepedidos dp
  ON pe.codigopedido = dp.codigopedido
GROUP BY pe.codigopedido
HAVING COUNT(*)>=6;

SELECT CODIGOPEDIDO FROM DETALLEPEDIDOS
WHERE NUMEROLINEA > 6
GROUP BY codigopedido;
--29.Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT clientes.nombrecliente, empleados.nombre, empleados.apellido1, empleados.apellido2, oficinas.ciudad
FROM oficinas INNER JOIN empleados
  ON oficinas.codigooficina = empleados.codigooficina
  INNER JOIN clientes
    ON empleados.codigoempleado = clientes.codigoempleadorepventas
WHERE clientes.codigocliente NOT IN (SELECT pagos.codigocliente FROM pagos);
--30.Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
SELECT E.nombre AS nombre_empleado, E.apellido1, E.apellido2, J.nombre AS nombre_jefe, J.apellido1, J.apellido2
FROM empleados E INNER JOIN empleados J
  ON E.codigojefe = J.codigoempleado;

SELECT NOMBRE AS EMPLEADO, NVL((SELECT NOMBRE FROM EMPLEADOS B WHERE B.CODIGOEMPLEADO = A.CODIGOJEFE),'No tiene jefe') AS JEFE FROM EMPLEADOS A;
