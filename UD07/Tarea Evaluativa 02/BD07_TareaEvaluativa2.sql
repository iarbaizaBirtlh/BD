-- =========================================================
-- SOLUCIONES TAREA PL/SQL (BD CINE)
-- Cursores, procedimientos y funciones
-- =========================================================

SET SERVEROUTPUT ON;

-- =========================================================
-- EJERCICIO 1
-- Cursor explícito + LOOP: entradas compradas con precio > 7,
-- mostrando num_entrada, titulo y precio; guiones cada 5 filas
-- =========================================================
DECLARE
  CURSOR c_entradas IS
    SELECT ec.num_entrada, p.titulo, ec.precio
    FROM entrada_comprada ec
    JOIN entrada e      ON e.num_entrada = ec.num_entrada
    JOIN proyeccion pr  ON pr.cod_proyeccion = e.cod_proyeccion
    JOIN pelicula p     ON p.cod_pelicula = pr.cod_pelicula
    WHERE ec.precio > 7
    ORDER BY p.titulo;

  v_num   entrada_comprada.num_entrada%TYPE;
  v_tit   pelicula.titulo%TYPE;
  v_prec  entrada_comprada.precio%TYPE;

  v_i     PLS_INTEGER := 0;
  v_dash  VARCHAR2(60) := '--------------------------';
BEGIN
  OPEN c_entradas;
  LOOP
    FETCH c_entradas INTO v_num, v_tit, v_prec;
    EXIT WHEN c_entradas%NOTFOUND;

    v_i := v_i + 1;

    DBMS_OUTPUT.PUT_LINE(
      v_i || '. Entrada ' || v_num || ' | ' || v_tit ||
      ' | Precio: ' || TO_CHAR(v_prec, 'FM9990D00') ||
      CASE WHEN MOD(v_i, 5) = 0 THEN v_dash ELSE '' END
    );
  END LOOP;
  CLOSE c_entradas;
END;
/
-- =========================================================
-- EJERCICIO 2
-- Mismo ejercicio con FOR ... IN cursor
-- =========================================================
DECLARE
  CURSOR c_entradas IS
    SELECT ec.num_entrada, p.titulo, ec.precio
    FROM entrada_comprada ec
    JOIN entrada e      ON e.num_entrada = ec.num_entrada
    JOIN proyeccion pr  ON pr.cod_proyeccion = e.cod_proyeccion
    JOIN pelicula p     ON p.cod_pelicula = pr.cod_pelicula
    WHERE ec.precio > 7
    ORDER BY p.titulo;

  v_i    PLS_INTEGER := 0;
  v_dash VARCHAR2(60) := '--------------------------';
BEGIN
  FOR r IN c_entradas LOOP
    v_i := v_i + 1;

    DBMS_OUTPUT.PUT_LINE(
      v_i || '. Entrada ' || r.num_entrada || ' | ' || r.titulo ||
      ' | Precio: ' || TO_CHAR(r.precio, 'FM9990D00') ||
      CASE WHEN MOD(v_i, 5) = 0 THEN v_dash ELSE '' END
    );
  END LOOP;
END;
/
-- =========================================================
-- EJERCICIO 3
-- Procedimiento con cursor explícito + %ROWCOUNT
-- listar_proyecciones_por_asistencia(p_min_asistencia)
-- =========================================================
CREATE OR REPLACE PROCEDURE listar_proyecciones_por_asistencia (
  p_min_asistencia IN NUMBER
) AS
  CURSOR c_proy IS
    SELECT pr.cod_proyeccion,
           pr.fecha_hora,
           p.titulo,
           s.nombre_sala,
           pr.asistencia
    FROM proyeccion pr
    JOIN pelicula p ON p.cod_pelicula = pr.cod_pelicula
    JOIN sala s     ON s.id_sala      = pr.id_sala
    WHERE pr.asistencia >= p_min_asistencia
    ORDER BY pr.asistencia;

  v_cod   proyeccion.cod_proyeccion%TYPE;
  v_fh    proyeccion.fecha_hora%TYPE;
  v_tit   pelicula.titulo%TYPE;
  v_sala  sala.nombre_sala%TYPE;
  v_asist proyeccion.asistencia%TYPE;
BEGIN
  OPEN c_proy;
  LOOP
    FETCH c_proy INTO v_cod, v_fh, v_tit, v_sala, v_asist;
    EXIT WHEN c_proy%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      'Proy ' || v_cod || ' | ' ||
      TO_CHAR(v_fh, 'YYYY-MM-DD HH24:MI') || ' | ' ||
      v_tit || ' | ' || v_sala || ' | Asistencia: ' || v_asist
    );
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Total proyecciones: ' || c_proy%ROWCOUNT);
  CLOSE c_proy;
END;
/
-- Ejemplo de ejecución:
BEGIN
  listar_proyecciones_por_asistencia(70);
END;
/
-- =========================================================
-- EJERCICIO 4
-- Mismo procedimiento con cursor FOR...LOOP (contador manual)
-- listar_proyecciones_por_asistencia_for(p_min_asistencia)
-- =========================================================
CREATE OR REPLACE PROCEDURE listar_proyecciones_por_asistencia_for (
  p_min_asistencia IN NUMBER
) AS
  v_total PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT pr.cod_proyeccion,
           pr.fecha_hora,
           p.titulo,
           s.nombre_sala,
           pr.asistencia
    FROM proyeccion pr
    JOIN pelicula p ON p.cod_pelicula = pr.cod_pelicula
    JOIN sala s     ON s.id_sala      = pr.id_sala
    WHERE pr.asistencia >= p_min_asistencia
    ORDER BY pr.asistencia
  ) LOOP
    v_total := v_total + 1;

    DBMS_OUTPUT.PUT_LINE(
      'Proy ' || r.cod_proyeccion || ' | ' ||
      TO_CHAR(r.fecha_hora, 'YYYY-MM-DD HH24:MI') || ' | ' ||
      r.titulo || ' | ' || r.nombre_sala || ' | Asistencia: ' || r.asistencia
    );
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Total proyecciones: ' || v_total);
END;
/
-- Ejemplo de ejecución:
BEGIN
  listar_proyecciones_por_asistencia_for(70);
END;
/
-- =========================================================
-- EJERCICIO 5
-- Función contarletras(frase, caracter): cuenta sin distinguir
-- mayúsculas/minúsculas. Si frase o caracter son NULL -> 0
-- =========================================================
CREATE OR REPLACE FUNCTION contarletras (
  p_frase    IN VARCHAR2,
  p_caracter IN CHAR
) RETURN NUMBER AS
  v_count NUMBER := 0;
  v_chr   CHAR(1);
  v_seek  CHAR(1);
BEGIN
  IF p_frase IS NULL OR p_caracter IS NULL THEN
    RETURN 0;
  END IF;

  v_seek := SUBSTR(p_caracter, 1, 1);

  FOR i IN 1 .. LENGTH(p_frase) LOOP
    v_chr := SUBSTR(p_frase, i, 1);
    IF UPPER(v_chr) = UPPER(v_seek) THEN
      v_count := v_count + 1;
    END IF;
  END LOOP;

  RETURN v_count;
END;
/
-- =========================================================
-- EJERCICIO 6
-- Cursor + contarletras: para intérpretes con papel='Protagonista',
-- contar 'N', 'R', 'L' y 'T' en nombre_artistico (sin tildes)
-- =========================================================
DECLARE
  CURSOR c_int IS
    SELECT DISTINCT i.nombre_artistico
    FROM interprete i
    JOIN actua_en ae ON ae.dni_interprete = i.dni_interprete
    WHERE ae.papel = 'Protagonista'
    ORDER BY i.nombre_artistico;

  v_n NUMBER;
  v_r NUMBER;
  v_l NUMBER;
  v_t NUMBER;
BEGIN
  FOR r IN c_int LOOP
    v_n := contarletras(r.nombre_artistico, 'N');
    v_r := contarletras(r.nombre_artistico, 'R');
    v_l := contarletras(r.nombre_artistico, 'L');
    v_t := contarletras(r.nombre_artistico, 'T');

    DBMS_OUTPUT.PUT_LINE(
      r.nombre_artistico || ' -> ' ||
      'N:' || v_n || ' ' ||
      'R:' || v_r || ' ' ||
      'L:' || v_l || ' ' ||
      'T:' || v_t
    );
  END LOOP;
END;
/
-- =========================================================
-- EJERCICIO 7
-- Cursor + contarletras: intérpretes que hayan actuado en películas
-- de Italia o Reino Unido y con exactamente 1 'L' en nombre_artistico.
-- Sin duplicados.
-- =========================================================
DECLARE
  CURSOR c_nombres IS
    SELECT DISTINCT i.nombre_artistico
    FROM interprete i
    JOIN actua_en ae ON ae.dni_interprete = i.dni_interprete
    JOIN pelicula p  ON p.cod_pelicula   = ae.cod_pelicula
    WHERE p.pais IN ('Italia', 'Reino Unido')
    ORDER BY i.nombre_artistico;

  v_l NUMBER;
BEGIN
  FOR r IN c_nombres LOOP
    v_l := contarletras(r.nombre_artistico, 'L');

    IF v_l = 1 THEN
      DBMS_OUTPUT.PUT_LINE(r.nombre_artistico);
    END IF;
  END LOOP;
END;
/