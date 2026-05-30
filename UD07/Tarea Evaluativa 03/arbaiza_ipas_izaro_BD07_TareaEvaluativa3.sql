/*DROP TABLE AUDITORIA_TECNICO CASCADE CONSTRAINTS;
CREATE TABLE AUDITORIA_TECNICO (
	datos VARCHAR2(200)
);*/

/*
Consulta 1: Auditar modificaciones en TECNICO
*/

CREATE OR REPLACE TRIGGER auditoria_tecnico
    AFTER UPDATE
    ON TECNICO
    FOR EACH ROW
BEGIN
	IF :OLD.nombre <> :NEW.nombre THEN
		INSERT INTO AUDITORIA_TECNICO 
		VALUES (
			TO_CHAR(SYSDATE,'DD/MM/YY*HH24:MI*') || :OLD.nif_tecnico ||
            '*MODIFICACION*nombre*' || :OLD.nombre || '*' || :NEW.nombre
		);
	END IF;
	IF :OLD.anios_experiencia <> :NEW.anios_experiencia THEN
		INSERT INTO AUDITORIA_TECNICO 
		VALUES (
			TO_CHAR(SYSDATE,'DD/MM/YY*HH24:MI*') || :OLD.nif_tecnico ||
            '*MODIFICACION*anios_experiencia*' || :OLD.anios_experiencia ||
            '*' || :NEW.anios_experiencia
		);
	END IF;
END;
/

/*
Consulta 2: Impide cambiar a sala con menor aforo
*/

CREATE OR REPLACE TRIGGER control_aforo
    BEFORE UPDATE OF id_sala
    ON PROYECCION
    FOR EACH ROW
DECLARE
	v_aforo SALA.aforo%TYPE;
BEGIN
	SELECT aforo INTO v_aforo
	FROM SALA WHERE id_sala = :NEW.id_sala;
	IF v_aforo < :OLD.asistencia THEN
		RAISE_APPLICATION_ERROR(-20001, 'Error: aforo insuficiente para la asistencia');
	END IF;
END;
/

/*
Consulta 3: Impide usar técnicos con menos de 2 años
*/

CREATE OR REPLACE TRIGGER control_tecnico
    BEFORE INSERT OR UPDATE OF nif_supervisor
    ON PROYECCION
    FOR EACH ROW
DECLARE
	v_exp TECNICO.anios_experiencia%TYPE;
BEGIN
	SELECT anios_experiencia INTO v_exp FROM TECNICO
	WHERE nif_tecnico = :NEW.nif_supervisor;
	IF v_exp < 2 THEN
		RAISE_APPLICATION_ERROR(-20002, 'Error: tecnico con menos de 2 años de experiencia');
	END IF;
END;
/

/*
Consulta 4: Ajusta automáticamente la asistencia al aforo
*/

CREATE OR REPLACE TRIGGER ajuste_asistencia
    BEFORE UPDATE OF id_sala
    ON PROYECCION
    FOR EACH ROW
DECLARE
	v_aforo SALA.aforo%TYPE;
BEGIN
	SELECT aforo INTO v_aforo FROM SALA
	WHERE id_sala = :NEW.id_sala;
	IF :OLD.asistencia > v_aforo THEN
		:NEW.asistencia := v_aforo;
	END IF;
END;
/

/*
Consulta 5: Impide modificar o borrar película con proyecciones
*/

CREATE OR REPLACE TRIGGER control_pelicula
    BEFORE UPDATE OR DELETE
    ON PELICULA
    FOR EACH ROW
DECLARE
	v_total NUMBER;
BEGIN
	SELECT COUNT(*) INTO v_total FROM PROYECCION
	WHERE cod_pelicula = :OLD.cod_pelicula;
	IF v_total > 0 THEN
		RAISE_APPLICATION_ERROR(-20003, 'Error: la pelicula tiene proyecciones asociadas');
	END IF;
END;
/
