--1.Equipo y ciudad de los jugadores españoles de la NBA.
SELECT equipos.nombre,equipos.ciudad 
FROM equipos INNER JOIN jugadores 
  ON equipos.nombre=jugadores.nombre_equipo 
WHERE procedencia='Spain';
--2.Equipos que comiencen por H y terminen en s.
SELECT equipos.nombre 
FROM equipos 
WHERE nombre LIKE 'H%s';
--3.Puntos por partido de 'Pau Gasol' en toda su carrera.
SELECT round (AVG(puntos_por_partido),2) 
FROM estadisticas INNER JOIN jugadores 
  ON jugadores.codigo=estadisticas.jugador
WHERE jugadores.nombre='Pau Gasol';
--4.Equipos que hay en la conferencia oeste('west').
SELECT nombre 
FROM equipos 
WHERE conferencia='West';
--5.Jugadores de Arizona que pesen mas de 100 kilos y midan mas de 1.82 cm (6 pies).
SELECT nombre,altura 
FROM jugadores 
WHERE procedencia='Arizona' AND altura > '6' AND peso*0.4536 > 100;
--6.Puntos por partido  de los jugadores de los 'cavaliers'.
SELECT round (AVG(puntos_por_partido),2) AS puntos,nombre 
FROM estadisticas INNER JOIN jugadores 
  ON jugadores.codigo=estadisticas.jugador         
WHERE nombre_equipo='Cavaliers' 
GROUP BY nombre;
--7.Jugadores cuya tercera letra de su nombre sea la v.
SELECT nombre 
FROM jugadores 
WHERE nombre LIKE '__v%';
--8.Número de jugadores que tiene cada equipo de la conferencia oeste 'west'.
SELECT COUNT (*),equipos.nombre 
FROM jugadores INNER JOIN equipos 
  ON jugadores.nombre_equipo = equipos.nombre 
WHERE conferencia ='West' 
GROUP BY equipos.nombre;
--9.Número de jugadores Argentinos en la NBA.
SELECT COUNT (*) 
FROM jugadores 
WHERE procedencia ='Argentina';
--10.Máxima media de puntos en una temporada de 'LeBron James' en su carrera.
SELECT MAX (puntos_por_partido) 
FROM estadisticas INNER JOIN jugadores     
  ON jugadores.codigo = estadisticas.jugador 
WHERE jugadores.nombre='LeBron James';
--11.Asistencias por partido de 'Jose Calderon' en la temporada '07/08'.
SELECT asistencias_por_partido, nombre, temporada 
FROM estadisticas INNER JOIN jugadores 
  ON jugadores.codigo = estadisticas.jugador 
WHERE jugadores.nombre = 'Jose Calderon' AND temporada ='06/07';
--12.Puntos por partido de 'LeBron James' en las temporadas del 03/04 al 05/06.
SELECT puntos_por_partido, nombre, temporada 
FROM estadisticas INNER JOIN jugadores 
  ON jugadores.codigo =estadisticas.jugador
WHERE jugadores.nombre = 'LeBron James' AND temporada BETWEEN '03/04' AND '05/06';
--13.Número de jugadores que tiene cada equipo de la conferencia este 'East'.
SELECT COUNT(*), equipos.nombre
FROM jugadores INNER JOIN equipos
  ON jugadores.nombre_equipo=equipos.nombre
WHERE conferencia ='East'
GROUP BY equipos.nombre;
--14.Tapones por partido de los jugadores de lo 'Blazers'.
SELECT round (AVG(tapones_por_partido),2) AS taponespartido,nombre 
FROM estadisticas INNER JOIN jugadores 
  ON jugadores.codigo =estadisticas.jugador
WHERE jugadores.nombre_equipo = 'Trail Blazers' 
GROUP BY nombre;
--15.Media de rebotes por partido de los jugadores de la conferencia este 'East'.
SELECT round(AVG (rebotes_por_partido),2), jugadores.nombre 
FROM    estadisticas INNER JOIN jugadores 
  ON jugadores.codigo = estadisticas.jugador 
  INNER JOIN equipos
    ON jugadores.nombre_equipo = equipos.nombre 
WHERE equipos.conferencia = 'East'
GROUP BY jugadores.nombre;
--16.Media de rebotes por partido de los jugadores de los equipos de Los Angeles.
SELECT round(AVG (rebotes_por_partido),2), jugadores.nombre 
FROM    estadisticas INNER JOIN jugadores 
  ON jugadores.codigo = estadisticas.jugador 
  INNER JOIN equipos
    ON jugadores.nombre_equipo = equipos.nombre 
WHERE equipos.ciudad= 'Los Angeles'
GROUP BY jugadores.nombre;
--17.Número de jugadores que tiene cada equipo de la división NorthWest.
SELECT COUNT (*), equipos.nombre 
FROM jugadores INNER JOIN equipos 
  ON jugadores.nombre_equipo = equipos.nombre 
WHERE equipos.division = 'NorthWest' 
GROUP BY equipos.nombre;
--18.Número de jugadores de España y Francia en la NBA.
SELECT COUNT (*), procedencia 
FROM jugadores 
WHERE procedencia ='Spain' OR procedencia ='France' 
GROUP BY procedencia;
--19.Número de pivots 'C' que tiene cada equipo.
SELECT COUNT (*),nombre_equipo 
FROM jugadores 
WHERE posicion ='C' 
GROUP BY nombre_equipo;
--20.¿Cuanto mide el pivot mas alto de la nba?.
SELECT MAX(altura) 
FROM jugadores 
WHERE posicion ='C';
--21.¿Cuanto pesa (en libras y en kilos) el pivot mas alto de la nba?
SELECT peso AS libras, peso*0.4535 AS kilos 
FROM jugadores             
WHERE altura = (SELECT MAX (altura) FROM jugadores);
--22.Número de jugadores que empiezan por 'Y'.
SELECT COUNT (*) FROM jugadores 
WHERE nombre LIKE 'Y%';
--23.Jugadores que no metieron ningun punto en alguna temporada.
SELECT DISTINCT jugadores.nombre 
FROM estadisticas INNER JOIN jugadores          
  ON jugadores.codigo = estadisticas.jugador 
WHERE puntos_por_partido=0;
--24.Número total de jugadores de cada división.
SELECT COUNT (*), division 
FROM jugadores INNER JOIN equipos
  ON equipos.nombre =jugadores.nombre_equipo 
GROUP BY division;
--25.Peso medio en kilos y en libras de los jugadores de los 'Raptors'.
SELECT round(AVG(peso),2) AS medialibras, round(AVG(peso*0.4536),2) AS mediakilos 
FROM jugadores 
WHERE nombre_equipo ='Raptors';
--26.Mostrar un listado de jugadores con el formato Nombre(Equipo) en una sola columna.
--Opción 1
SELECT CONCAT(CONCAT(CONCAT (nombre,'('),nombre_equipo),')') AS nombre_equipo FROM jugadores
ORDER BY nombre_equipo;
--Opción 2
SELECT nombre ||'(' || nombre_equipo || ')' AS nombre_equipo 
FROM jugadores
ORDER BY nombre_equipo;
--27.Puntuación más baja de un partido de la NBA.
SELECT MIN(puntos_local+puntos_visitante) FROM partidos;
--28.Primeros 10 jugadores por orden alfabético.
SELECT * FROM (
  SELECT nombre FROM jugadores 
  ORDER BY nombre)
WHERE ROWNUM <=10;
https://blogs.oracle.com/oraclemagazine/on-rownum-and-limiting-results
-- En versiones más recientes se pueden usar otras opciones.
--29.Temporada con más puntos por partido de 'Kobe Bryant'.
SELECT temporada, puntos_por_partido, nombre 
FROM estadisticas INNER JOIN jugadores 
  ON estadisticas.jugador =  jugadores.codigo 
WHERE puntos_por_partido = (SELECT MAX (puntos_por_partido) 
                            FROM estadisticas INNER JOIN jugadores
                              ON   estadisticas.jugador = jugadores.codigo
                            WHERE nombre ='Kobe Bryant');
--30.Número de bases 'G' que tiene cada equipo de la conferencia este 'East'.
SELECT COUNT (*), nombre_equipo 
FROM jugadores INNER JOIN equipos 
  ON jugadores.nombre_equipo = equipos.nombre
WHERE jugadores.posicion = 'G' AND equipos.conferencia = 'East' 
GROUP BY nombre_equipo;
--31.Número de equipos que tiene cada conferencia.
SELECT COUNT (*), conferencia 
FROM equipos 
GROUP BY conferencia;
--32.Nombre de las divisiones de la conferencia Este.
SELECT DISTINCT division 
FROM equipos 
WHERE conferencia ='East';
--33.Máximo reboteador de los 'Suns'.
SELECT nombre 
FROM jugadores INNER JOIN estadisticas 
  ON estadisticas.jugador = jugadores.codigo 
WHERE rebotes_por_partido = (SELECT MAX (rebotes_por_partido) 
                             FROM estadisticas INNER JOIN jugadores 
                               ON estadisticas.jugador = jugadores.codigo 
                             WHERE  nombre_equipo ='Suns') 
AND nombre_equipo ='Suns';
--34.Máximo anotador de la toda base de datos en una temporada.
SELECT nombre 
FROM jugadores INNER JOIN estadisticas 
  ON estadisticas.jugador = jugadores.codigo 
WHERE puntos_por_partido = (SELECT MAX (puntos_por_partido) FROM estadisticas); --aviso: Shavlik Randolph aparece por error en los datos
--35.Sacar cuántas letras tiene el nombre de cada jugador de los 'grizzlies' (usar  función LENGTH).
SELECT LENGTH (nombre),nombre
FROM jugadores 
WHERE nombre_equipo ='Grizzlies';
--36.¿Cuantas letras tiene el equipo con nombre más largo de la NBA (Ciudad y Nombre)?
--Opción 1
SELECT LENGTH (CONCAT(ciudad,nombre)) AS numero_letras, CONCAT(CONCAT(ciudad,' '),nombre)AS nombre 
FROM equipos 
WHERE LENGTH(CONCAT(ciudad,nombre))= (SELECT MAX(LENGTH(CONCAT(ciudad,nombre))) FROM equipos);
--Opción 2
SELECT LENGTH (ciudad || nombre) AS numero_letras, ciudad ||' '|| nombre AS nombre 
FROM equipos 
WHERE LENGTH (ciudad || nombre) = (SELECT MAX(LENGTH(ciudad ||  nombre)) FROM equipos);
--Opción 3 (Elimina los espacios dentro del nombre para que no los cuente como letras en la longitud)
SELECT LENGTH (ciudad || REPLACE(nombre,' ','')) AS numero_letras, ciudad ||' '|| nombre AS nombre 
FROM equipos 
WHERE LENGTH (ciudad || REPLACE(nombre,' ','')) = (SELECT MAX(LENGTH(ciudad || REPLACE(nombre,' ',''))) FROM equipos);