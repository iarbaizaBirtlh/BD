--1 Nombre de clientes que pertenecen a la tienda 2 y su apellido comienza por B y contiene una R.
select nombre,apellidos from cliente where apellidos like 'B%' and apellidos like '%R%';
--2 Título de las películas realizadas por DAN HARRIS.
select p.titulo from pelicula p
inner join actor_pelicula ap on p.id_pelicula=ap.id_pelicula  
inner join actor a on a.id_actor= ap.id_actor
where upper(a.nombre) ='DAN'
and upper (a.apellidos) ='HARRIS';

--3 Número de películas que pertenecen a la categoría ‘Drama’.
select count (cp.id_pelicula) from categoria_pelicula cp
inner join categoria c on cp.id_categoria=c.id_categoria
where c.nombre= 'Drama';

--4 Lista de títulos de películas junto con el número de películas  que se encuentran en el inventario ordenado descendentemente por cantidad y en orden alfabético.
select titulo, count(b.id_pelicula) from pelicula a inner join inventario b on a.id_pelicula=b.id_pelicula group by titulo order by count(b.id_pelicula) desc, titulo asc;
--5 Nombre de actores cuya cuarta letra es es una E y  la anteúltima una I.
select nombre from actor where nombre LIKE '___A%I_';
--6 Nombre y apellidos concatenados (con espacio entre ellos) de clientes que se encuentran inactivos (o activo=0).
Select nombre||' ' ||apellidos from cliente where activo=0;
--7 Número de clientes distintos que han alquilado una película en junio de 2005.
select count (distinct (id_cliente)) from alquiler a
where a.fecha_alquiler between '01/06/05' and '30/06/05';
--8 Nombre y email de los clientes que no han devuelto películas junto con el número de películas a devolver.
select nombre,email,count(b.id_cliente) as ADevolver from cliente a inner join alquiler b on a.id_cliente=b.id_cliente where fecha_devol is null group by nombre,email;
--9 Título de películas que se encuentran en la tienda 1 y 2. (en las dos)
select titulo from inventario a inner join pelicula b on a.id_pelicula=b.id_pelicula where id_tienda=1 and a.id_pelicula in (select id_pelicula from inventario where id_tienda=2) group by a.id_pelicula,titulo;
--10 Nombre y apellidos de actores que participan en las películas que se alquilaron en el mes de julio de 2005.
select nombre,apellidos from alquiler a inner join inventario b on a.id_inventario=b.id_inventario inner join pelicula c on b.id_pelicula=c.id_pelicula
inner join actor_pelicula d on c.id_pelicula=d.id_pelicula inner join actor e on d.id_actor=e.id_actor
where fecha_alquiler between '01/07/05' and '31/07/05' group by nombre,apellidos;

--11 Nombre y apellidos del/a actor/actriz que más películas ha protagonizado.
-- bi aukera

select a.nombre, a.apellidos from actor a 
inner join actor_pelicula ap on a.id_actor= ap.id_actor
group by a.id_actor, a.nombre, a.apellidos
order by count(a.id_actor) desc
fetch first 1 rows only;

select a.nombre, a.apellidos from actor a 
where a.id_actor = (select ac.id_actor from actor_pelicula ac
group by ac.id_actor order by count(ac.id_actor) desc fetch first 1 rows only);


--12 Cuantas películas ha realizado cada actor (nombre y apellidos), ordenadas descendentemente por cantidad.
-- Susan davis bi aldiz agertzen da, id_actor desberdinarekin
select nombre, apellidos, count(b.id_actor) from actor a inner join actor_pelicula b on a.id_actor=b.id_actor group by a.id_actor,nombre,apellidos order by count(b.id_actor) desc ; 
--13 Cuantas películas han sido alquiladas por categoría (mostrar el nombre de la categoría), ordenadas de mayor a menor.
select e.nombre, count(a.id_alquiler) from alquiler a inner join inventario b on a.id_inventario=b.id_inventario inner join pelicula c on b.id_pelicula=c.id_pelicula 
inner join categoria_pelicula d on c.id_pelicula=d.id_pelicula inner join categoria e on d.id_categoria=e.id_categoria group by e.nombre order by  count(a.id_alquiler) desc; 

--14 Media de duración de las películas de la categoría ‘Comedy’, redondeada a un decimal
select round(avg(p.duracion),1)from pelicula p
inner join categoria_pelicula cp on p.id_pelicula = cp.id_pelicula
inner join categoria c on cp.id_categoria=c.id_categoria
where c.nombre='Comedy';


--15 Películas que no se hallan en el inventario.
select titulo from pelicula where id_pelicula not in (select distinct b.id_pelicula from inventario a inner join pelicula b on a.id_pelicula=b.id_pelicula );

--16 Primeras 30 películas ordenadas por tarifa de alquiler ascendente y alfabéticamente por el título ascendentemente.
select * from pelicula order by tarifa_alquiler, titulo asc FETCH FIRST 30 ROWS ONLY;

--17 Nombre y apellidos de los actores junto con el número de películas realizadas.
select count(id_pelicula) as cantidadPeliculas,a.nombre,a.apellidos from actor a inner join actor_pelicula b on a.id_actor=b.id_actor group by a.id_Actor,a.nombre,a.apellidos order by count(id_pelicula);

--18 Clientes que no hayan hecho ningún alquiler y que pertenezcan a la tienda 2.
select * from cliente where id_cliente not in(select distinct id_cliente from alquiler) and id_tienda like '2';
--19 Suma de las tarifas de alquiler de películas, agrupadas por tarifas de alquiler que sean mayores a 1 dólar, y que la suma agrupada sea mayor que 500.
select sum(tarifa_alquiler),tarifa_alquiler from pelicula where tarifa_alquiler >1 group by tarifa_alquiler having sum(tarifa_alquiler)> 500;

--20 Cantidad de dinero (tarifa_alquiler) que ha gastado el cliente con id_cliente 597, en dólares y euros (transformar a euros --> 1 dólar = 1,21 euros).
select sum(tarifa_alquiler) as dolar, sum(tarifa_alquiler)*1.21 as euros  from pelicula a inner join inventario b on a.id_pelicula=b.id_pelicula inner join alquiler c on b.id_inventario=c.id_inventario where c.id_cliente =597;
--21 Cantidad de películas agrupadas por costo de reposición, siempre que la cantidad de películas sea superior a 50.
select count(id_pelicula),costo_reposicion from pelicula group by costo_reposicion having count(id_pelicula)>50;

--22 Título de la película con id_idioma English, que menos duración tiene.
select duracion,titulo from pelicula a inner join idioma b on a.id_idioma=b.id_idioma where b.nombre='English' order by duracion asc FETCH FIRST 1 ROWS ONLY;

--23 Media de las tarifas de alquiler de las películas y duración media de las películas.
select round(avg(tarifa_alquiler),2) as tarifaMedia,round(avg(duracion),2) as duracionMedia from pelicula 

--24 Mostrar la ratio, redondeada con cuatro decimales, del precio por minuto (tarifa_alquiler/duración) de las películas por cada  nombre de categoría.
select c.nombre,round((avg(tarifa_alquiler))/(avg(duracion)),4) as ratio from pelicula a 
inner join categoria_pelicula b on a.id_pelicula=b.id_pelicula inner join categoria c on c.id_categoria=b.id_categoria
group by c.nombre;

--25 Mostrar el resultado de tarifa de alquiler/ duración de cada título de película, con el nombre de columna PrecioPorMinuto.
select titulo, round(tarifa_alquiler/duracion,2) as precioporminuto from pelicula;
--26 Mostrar nombre y apellidos concatenados y en minúscula de los clientes que alquilaron una película el día 26/05/05 
select lower(c.nombre || c.apellidos) from cliente c 
inner join alquiler a on a.id_cliente=c.id_cliente 
where fecha_alquiler like '26/05/05';

--27 Mostrar la media de las tarifas de alquiler y duración máxima por nombre de categoría, cuando la duración máxima de esa categoría es superior a los 182 minutos.
select c.nombre,round(avg(tarifa_alquiler),2),round(max(duracion),2) from pelicula a inner join categoria_pelicula b on a.id_pelicula=b.id_pelicula inner join categoria c on c.id_categoria=b.id_categoria
group by c.nombre having max(duracion)>182 ;
--28 Cantidad de películas que disponemos en inventario de ‘ARMAGEDDON LOST’ en la tienda 2.
select count(id_inventario) as cantidad,titulo from pelicula a inner join inventario b on a.id_pelicula=b.id_pelicula where titulo like 'CHICAGO NORTH' and id_tienda=2 group by titulo;
--29 Cantidad de películas que disponemos en inventario en la tienda donde menos películas tenemos. 
select count(i.id_inventario) as cantidad,id_tienda from inventario i
group by i.id_tienda 
order by count(i.id_inventario) asc 
fetch first 1 rows only;

--30 ¿Cuántas letras tiene la cadena nombre de cliente y email (nombre_cliente+ ‘:‘ +email) más larga? Mostrar el número de letras junto con la cadena.
SELECT LENGTH (nombre ||':'|| email) AS numero_letras, nombre ||':'|| email AS nombre 
FROM cliente 
WHERE LENGTH (nombre ||':'|| email) = (SELECT MAX(LENGTH(nombre ||':'|| email)) FROM cliente);