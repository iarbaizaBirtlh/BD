--1.Equipos y ciudad de los jugadores españoles de la NBA.
SELECT equipos.nombre, equipos.ciudad FROM equipos 
JOIN jugadores ON equipos.nombre = jugadores.nombre_equipo 
WHERE(jugadores.procedencia = 'Spain');
--2.Equipos cuyo nombre comienza por H y finaliza por s.
SELECT AVG(puntos_por_patido) FROM estadisticas 
JOIN jugadores ON estadisticas.jugador = jugadores.nombre
WHERE(jugadores.nombre = 'Pau Gasol');
--3.Puntos por partido de ‘Pau Gasol’ en toda su carrera.
SELECT AVG(puntos_por_partido) FROM estadisticas
JOIN jugadores ON estadisticas.jugador = jugadores.nombre
WHERE(jugadores.nombre = 'Pau Gasol');
--4.Equipos que hay en la conferencia Oeste (West).
SELECT nombre FROM equipos WHERE(conferencia='West');
--5.Jugadores procedentes de Arizona que pesan más de 100 kg (1 libra = 453,59237 gramos) y miden más de 6 pies (1 pie=30.48 cm).
SELECT nombre FROM jugadores WHERE(procedencia='Arizona' AND (peso*0.4535)>100 AND to_number(replace(altura, '-', ''))>60);
--6.Puntos por partido de los jugadores de los Cavaliers.
SELECT puntos_por_partido FROM estadisticas
JOIN jugadores ON estadisticas.jugador = jugadores.codigo 
WHERE(jugadores.nombre_equipo = 'Cavaliers');
--7.Jugadores cuya 3ª letra de su nombre es una ‘v’.
--8.¿Cuántos jugadores tiene cada equipo de la conferencia Oeste?
--9.¿Cuantos jugadores argentinos juegan en la NBA?
--10.Máxima media de puntos en una temporada de LeBron James en su carrera.
--11.Asistencias por partido de Jose Calderón en la temporada 07/08.
--12.Puntos por partido de LeBron James de la temporada 03/04 a la 05/06.
--13.¿Cuántos jugadores tiene cada equipo de la conferencia Este (East)?
--14.Tapones por partido de los jugadores de los Blazers.
--15.Media de rebotes por partido de los jugadores de la conferencia Este.
--16.Media de rebotes por partido de los jugadores de los equipos de Los Ángeles.
--17.¿Cuántos jugadores tiene cada equipo de la division NorthWest?
--18.Número de jugadores españoles o franceses.
--19.Número de pivots ‘C’ que tiene cada equipo.
--20.¿Cuanto mide el pivot más alto de la NBA?
--21.¿Cuanto pesa el jugador más alto de la NBA (1 libra = 453,59237 gramos)?
--22.Jugadores cuyo nombre comienza por 'Y'.
--23.Jugadores que no metieron ningún punto el alguna temporada.
--24.Número total de jugadores en cada división.
--25.Peso medio en kilos y en libras de los jugadores de los Raptors.
--26.Listado de los jugadores en formato Nombre (Equipo)en una sola columna.
--27.Puntuación más baja de un partido de la NBA.
--28.Primeros 10 jugadores por orden alfabético.
--29.Temporada con más puntos por partido de Kobe Bryant.
--30.Número de bases ‘G’ que tiene cada equipo de la conferencia Este.
--31.Número de equipos por conferencia.
--32.Nombre de las divisiones de la conferencia Este.
--33.Máximo reboteador de los Suns.
--34.Máximo anotador de toda la base de datos en una temporada.
--35.¿Cuantas letras tiene el nombre de cada jugador de los Grizzlies (función LENGTH)?
--36.¿Cuantas letras tiene el equipo con nombre más largo de la NBA (Ciudad y Nombre)?