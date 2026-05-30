--1.Código y nombre de todos los departamentos.
SELECT codigo, nombre FROM departamentos;
--2.Mes y ejercicio de los justificantes de nómina pertenecientes al empleado cuyo código es 1.
SELECT mes, ejercicio FROM just_nominas WHERE(cod_emp = 1);
--3.Número de cuenta y nombre de los empleados cuya retención es mayor o igual que 10.
SELECT cuenta, nombre FROM empleados WHERE(retencion >= 10);
--4.Código y nombre de los empleados ordenados ascendentemente por nombre.
SELECT codigo, nombre FROM empleados ORDER BY nombre ASC;
--5.Nombre de los empleados que tienen más de 2 hijos.
SELECT nombre FROM empleados WHERE(hijos > 2);
--6.Código y número de cuenta de los empleados cuyo nombre empiece por 'A' o por 'J'.
SELECT codigo, cuenta FROM empleados WHERE(nombre LIKE 'A%' OR nombre LIKE 'J%');
--7.Número de empleados que hay en la base de datos.
SELECT COUNT(*) FROM empleados;
--8.Nombre del primer y último empleado en términos alfabéticos.
SELECT MIN(NOMBRE), MAX(nombre) FROM empleados;
--9.Nombre y número de hijos de los empleados cuya retención es: 8, 10 o 12.
SELECT nombre, hijos FROM empleados WHERE(retencion=8 OR retencion=10 OR retencion=12);
SELECT nombre, hijos FROM empleados WHERE(retencion IN(8, 10, 12));
--10.Número de hijos y número de empleados agrupados por hijos, mostrando sólo los grupos cuyo número de hijos sea mayor que 1.
SELECT hijos, COUNT(*) FROM empleados GROUP BY hijos HAVING hijos>1;
--11.Número de hijos, retención máxima, mínima y media de los empleados agrupados por hijos.
SELECT hijos, MAX(retencion), MIN(retencion), AVG(retencion)  FROM empleados GROUP BY hijos;
--12.Nombre y función de los empleados que han trabajado en el departamento 1.
SELECT empleados.nombre, trabajan.funcion FROM empleados 
JOIN trabajan ON empleados.codigo = trabajan.cod_emp
WHERE(trabajan.cod_dep = 1);
--13.Nombre del empleado, nombre del departamento y función que han realizado de los empleados que tienen 1 hijo.
SELECT empleados.nombre, departamentos.nombre, trabajan.funcion FROM empleados
JOIN trabajan ON empleados.codigo = trabajan.cod_emp
JOIN departamentos ON trabajan.cod_dep = departamentos.codigo
WHERE(empleados.hijos=1);
--14.Nombre del empleado y nombre del departamento en el que han trabajado empleados que no tienen hijos.
SELECT empleados.nombre, departamentos.nombre FROM empleados
JOIN trabajan ON empleados.codigo = trabajan.cod_emp
JOIN departamentos ON trabajan.cod_dep = departamentos.codigo
WHERE(empleados.hijos=0);
--15.Nombre del empleado, mes y ejercicio de sus justificantes de nómina, número de línea y cantidad de las líneas de los justificantes para el empleado cuyo código=1.
SELECT empleados.nombre, just_nominas.mes, just_nominas.ejercicio, lineas.numero, lineas.cantidad
FROM empleados
JOIN just_nominas ON empleados.codigo = just_nominas.cod_emp
JOIN lineas ON just_nominas.cod_emp = lineas.cod_emp
AND just_nominas.mes = lineas.mes AND just_nominas.ejercicio = lineas.ejercicio
WHERE(empleados.codigo=1);
--16.Nombre del empleado, mes y ejercicio de sus justificantes de nómina para los empleados que han trabajado en el departamento de Ventas.
SELECT empleados.nombre, just_nominas.mes, just_nominas.ejercicio FROM empleados
JOIN just_nominas ON empleados.codigo = just_nominas.cod_emp
JOIN trabajan ON empleados.codigo = trabajan.cod_emp
JOIN departamentos ON trabajan.cod_dep = departamentos.codigo
WHERE(departamentos.nombre LIKE 'Ventas');
--17.Nombre del empleado e ingresos totales percibidos agrupados por nombre.
SELECT empleados.nombre, SUM(lineas.cantidad) FROM empleados
JOIN just_nominas ON empleados.codigo = just_nominas.cod_emp
JOIN lineas ON just_nominas.mes = lineas.mes AND just_nominas.ejercicio = lineas.ejercicio AND just_nominas.cod_emp = lineas.cod_emp
GROUP BY empleados.nombre;
--18.Nombre de los empleados que han ganado más de 2000 € en el año 2006.
SELECT empleados.nombre FROM empleados
JOIN just_nominas ON empleados.codigo = just_nominas.cod_emp
JOIN lineas ON just_nominas.mes = lineas.mes AND just_nominas.ejercicio = lineas.ejercicio AND just_nominas.cod_emp = lineas.cod_emp
WHERE(lineas.ejercicio = 2006)
GROUP BY empleados.nombre HAVING SUM(lineas.cantidad)>2000;
--19.Número de empleados cuyo número de hijos es superior a la media de hijos de los empleados.
SELECT COUNT(*) FROM empleados WHERE(hijos > (SELECT AVG(hijos) FROM empleados));
--20.Nombre de los empleados que más hijos tienen o que menos hijos tienen.
SELECT nombre FROM empleados 
WHERE(hijos = (SELECT MAX(hijos) FROM empleados) 
OR hijos = (SELECT MIN(hijos)   FROM empleados));
--21.Nombre de los empleados que no tienen justificante de nóminas.
SELECT empleados.nombre FROM empleados
LEFT JOIN just_nominas ON empleados.codigo = just_nominas.cod_emp
WHERE(just_nominas.cod_emp IS NULL);
--or
SELECT nombre FROM empleados
WHERE codigo NOT IN(SELECT cod_emp FROM just_nominas);
--22.Nombre y fecha de nacimiento de todos los empleados.
SELECT nombre, to_char(fnacimiento, 'DD/MM/YYYY') AS fecha_nacimiento FROM empleados;
--23.Nombre y fecha de nacimiento con formato "1 de Enero de 2000" y etiquetada la columna como fecha, de todos los empleados.
SELECT nombre, to_char(fnacimiento, 'DD " de " Month " de " YYYY') 
AS fecha_nacimiento FROM empleados;
--24.Nombre de los empleados, nombre de los departamentos en los que ha trabajado y función en mayúsculas que ha realizado en cada departamento.
SELECT empleados.nombre, departamentos.nombre, UPPER(trabajan.funcion) FROM empleados
JOIN trabajan ON empleados.codigo = trabajan.cod_emp
JOIN departamentos ON trabajan.cod_dep = departamentos.codigo;
--25.Nombre, fecha de nacimiento y nombre del día de la semana de su fecha de nacimiento de todos los empleados.
SELECT nombre, to_char(fnacimiento, 'DD/MM/YYYY'), to_char(fnacimiento, 'Day') FROM empleados;
--26.Nombre y edad de los empleados.
SELECT nombre, TRUNC(months_between(sysdate, fnacimiento)/12) FROM empleados;
--27.Nombre, edad y número de hijos de los empleados que tienen menos de 40 años y tienen hijos.
SELECT nombre, TRUNC(months_between(sysdate, fnacimiento)/12), hijos FROM empleados
WHERE(TRUNC(months_between(sysdate, fnacimiento)/12)<40 AND hijos>0);
--28.Nombre, edad de los empleados y nombre del departamento de los empleados que han trabajado en más de un departamento.
SELECT empleados.nombre, TRUNC(months_between(sysdate, fnacimiento)/12), departamentos.nombre FROM empleados
JOIN trabajan ON empleados.codigo = trabajan.cod_emp
JOIN departamentos ON trabajan.cod_dep = departamentos.codigo
WHERE empleados.codigo IN(SELECT cod_emp FROM trabajan GROUP BY cod_emp HAVING COUNT(*)>1);
--29.Nombre, edad y número de cuenta de aquellos empleados cuya edad es múltiplo de 3.
SELECT nombre, TRUNC(months_between(sysdate, fnacimiento)/12), cuenta FROM empleados
WHERE(MOD(TRUNC(months_between(sysdate, fnacimiento)/12), 3)=0);
--30.Nombre e ingresos percibidos empleado más joven y del más longevo.
SELECT empleados.nombre, SUM(just_nominas.ingreso)-SUM(just_nominas.descuento) FROM empleados
JOIN just_nominas ON empleados.codigo = just_nominas.cod_emp
WHERE(empleados.fnacimiento = (SELECT MIN(fnacimiento) FROM empleados)
OR empleados.fnacimiento = (SELECT MAX(fnacimiento) FROM empleados)) GROUP BY empleados.nombre;