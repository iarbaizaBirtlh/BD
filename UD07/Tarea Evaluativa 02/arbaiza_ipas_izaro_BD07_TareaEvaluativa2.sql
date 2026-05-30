/*
Consulta 1: Crea un bloque anónimo con un cursor que visualice el num_entrada, 
el título de la película y el precio de las entradas compradas cuyo precio sea
superior a 7, ordenado por el título. 
Por cada cinco entradas visualizadas, añade una tira de guiones.
*/

SET SERVEROUTPUT ON
DECLARE
    CURSOR cur_entr IS
        SELECT
            E.num_entrada,
			P.titulo,
			EC.precio
		FROM 
			entrada E
		JOIN 
			entrada_comprada EC 
			ON E.num_entrada = EC.num_entrada
		JOIN 
			proyeccion PR 
			ON E.cod_proyeccion = PR.cod_proyeccion
		JOIN 
			pelicula P 
			ON PR.cod_pelicula = P.cod_pelicula
		WHERE 
			EC.precio > 7
		ORDER BY 
			P.titulo;
    v_reg cur_entr%ROWTYPE;
    v_cont NUMBER := 0;
BEGIN
    OPEN cur_entr;
	LOOP
		FETCH cur_entr INTO v_reg;
		EXIT WHEN cur_entr%NOTFOUND;
		v_cont := v_cont + 1;
		dbms_output.put_line(v_cont || '. Entrada ' || v_reg.num_entrada || ' | ' || v_reg.titulo || ' | Precio: ' ||
			v_reg.precio);
		IF (MOD(v_cont, 5) = 0) THEN
			dbms_output.put_line('------------------------------------------------------');
		END IF;
	END LOOP;
	CLOSE cur_entr;
END;
/

/*
Ejercicio 2: Mismo ejercicio anterior pero usando FOR LOOP.
*/

DECLARE
	v_cont NUMBER := 0;
BEGIN
	FOR v_reg IN (
		SELECT 
			E.num_entrada,
			P.titulo,
			EC.precio
		FROM 
			entrada E
		JOIN 
			entrada_comprada EC 
			ON E.num_entrada = EC.num_entrada
		JOIN 
			proyeccion PR 
			ON E.cod_proyeccion = PR.cod_proyeccion
		JOIN 
			pelicula P 
			ON PR.cod_pelicula = P.cod_pelicula
		WHERE 
			EC.precio > 7
		ORDER BY 
			P.titulo
	) LOOP
		v_cont := v_cont + 1;
		dbms_output.put_line(v_cont || '. Entrada ' || v_reg.num_entrada || ' | ' || v_reg.titulo || ' | Precio: ' ||
			v_reg.precio);
		IF (MOD(v_cont, 5) = 0) THEN
			dbms_output.put_line('------------------------------------------------------');
		END IF;
	END LOOP;
END;
/

/*
Ejercicio 3: Procedimiento que recibe un número y muestra proyecciones con
asistencia >= valor. Muestra total usando %ROWCOUNT.
*/

CREATE OR REPLACE PROCEDURE proyecciones_min_asistencia (p_min_asistencia NUMBER) AS
	CURSOR c_proy IS
		SELECT 
			PR.cod_proyeccion,
			PR.fecha_hora,
			P.titulo,
			S.nombre_sala,
			PR.asistencia
		FROM 
			proyeccion PR
		INNER JOIN 
			pelicula P 
			ON PR.cod_pelicula = P.cod_pelicula
		INNER JOIN 
			sala S 
			ON PR.id_sala = S.id_sala
		WHERE 
			PR.asistencia >= p_min_asistencia
		ORDER BY 
			PR.asistencia;
	v_proy c_proy%ROWTYPE;
BEGIN
	OPEN c_proy;
	FETCH c_proy INTO v_proy;
	WHILE c_proy%FOUND LOOP
		dbms_output.put_line(v_proy.cod_proyeccion || ' | ' || v_proy.fecha_hora || ' | ' || v_proy.titulo 
			|| ' | ' || v_proy.nombre_sala || ' | ' || v_proy.asistencia);
		FETCH c_proy INTO v_proy;
	END LOOP;
	dbms_output.put_line('Total: ' || c_proy%ROWCOUNT);
	CLOSE c_proy;
END;
/

/*
Ejercicio 4: Mismo procedimiento pero con FOR LOOP. Contador manual.
*/

CREATE OR REPLACE PROCEDURE proyecciones_min_asistencia_for (p_min_asistencia NUMBER) AS
	v_cont NUMBER := 0;
BEGIN
	FOR v_proy IN (
		SELECT 
			PR.cod_proyeccion,
			PR.fecha_hora,
			P.titulo,
			S.nombre_sala,
			PR.asistencia
		FROM 
			proyeccion PR
		INNER JOIN 
			pelicula P 
			ON PR.cod_pelicula = P.cod_pelicula
		INNER JOIN 
			sala S 
			ON PR.id_sala = S.id_sala
		WHERE 
			PR.asistencia >= p_min_asistencia
		ORDER BY 
			PR.asistencia
	) LOOP
		v_cont := v_cont + 1;
		dbms_output.put_line(v_proy.cod_proyeccion || ' | ' || v_proy.fecha_hora || ' | ' || v_proy.titulo 
			|| ' | ' || v_proy.nombre_sala || ' | ' || v_proy.asistencia);
	END LOOP;
	dbms_output.put_line('Total: ' || v_cont);
END;
/

/*
Ejercicio 5: Función que cuenta cuántas veces aparece un carácter en una frase.
Ignora mayúsculas/minúsculas.
*/

CREATE OR REPLACE FUNCTION contarletras (
	p_frase VARCHAR2,
	p_letra CHAR
) RETURN NUMBER AS
	v_cont NUMBER := 0;
BEGIN
	FOR i IN 1 .. LENGTH(p_frase) LOOP
		IF UPPER(SUBSTR(p_frase, i, 1)) = UPPER(p_letra) THEN
			v_cont := v_cont + 1;
		END IF;
	END LOOP;
	RETURN v_cont;
END;
/

/*
Ejercicio 6: Para protagonistas, contar N, R, L, T en nombre artístico.
*/

SET SERVEROUTPUT ON
DECLARE
	CURSOR c_inter IS
		SELECT 
			I.nombre_artistico
		FROM 
			interprete I
		INNER JOIN 
			actua_en A 
			ON I.dni_interprete = A.dni_interprete
		WHERE 
			A.papel = 'Protagonista';
	v_nombre interprete.nombre_artistico%TYPE;
BEGIN
	OPEN c_inter;
	FETCH c_inter INTO v_nombre;
	WHILE c_inter%FOUND LOOP
		dbms_output.put_line(v_nombre || ' -> ' || 'N: ' || contarletras(v_nombre, 'N') || ', ' || 'R: ' 
			|| contarletras(v_nombre, 'R') || ', ' || 'L: ' || contarletras(v_nombre, 'L') || ', ' || 'T: ' 
			|| contarletras(v_nombre, 'T'));
		FETCH c_inter INTO v_nombre;
	END LOOP;
	CLOSE c_inter;
END;
/

/*
Ejercicio 7: Intérpretes en películas de Italia o Reino Unido con exactamente
una 'L' en el nombre artístico.
Sin repetidos.
*/

SET SERVEROUTPUT ON
DECLARE
	CURSOR c_inter IS
		SELECT DISTINCT
			I.nombre_artistico
		FROM 
			interprete I
		INNER JOIN 
			actua_en A 
			ON I.dni_interprete = A.dni_interprete
		INNER JOIN 
			pelicula P 
			ON A.cod_pelicula = P.cod_pelicula
		WHERE 
			P.pais IN ('Italia', 'Reino Unido');
	v_nombre interprete.nombre_artistico%TYPE;
BEGIN
	OPEN c_inter;
	FETCH c_inter INTO v_nombre;
	WHILE c_inter%FOUND LOOP
		IF contarletras(v_nombre, 'L') = 1 THEN
			dbms_output.put_line(v_nombre);
		END IF;
		FETCH c_inter INTO v_nombre;
	END LOOP;
	CLOSE c_inter;
END;
/
