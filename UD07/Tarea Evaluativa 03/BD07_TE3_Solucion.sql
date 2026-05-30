/* 1. Se pide crear un trigger que audite únicamente las modificaciones realizadas sobre la tabla TECNICO.
La información se guardará en una tabla AUDITATECNICO, en una sola columna de tipo VARCHAR2(200), concatenando la fecha y hora, el identificador del técnico modificado, la palabra MODIFICACION y el valor antiguo y nuevo del atributo cambiado.*/

CREATE TABLE AUDITATECNICO (
    col1 VARCHAR2(200)
);

CREATE OR REPLACE TRIGGER trg_audita_update_tecnico
AFTER UPDATE ON TECNICO
FOR EACH ROW
BEGIN
    INSERT INTO AUDITATECNICO (col1)
    VALUES (
        TO_CHAR(SYSDATE, 'DD/MM/RR*HH24:MI') || '*' ||
        :OLD.nif_tecnico || '*' ||
        'MODIFICACION' || '*' ||
        CASE
            WHEN NVL(:OLD.nombre, '#') <> NVL(:NEW.nombre, '#') THEN :OLD.nombre || '*' || :NEW.nombre
            WHEN NVL(:OLD.anios_experiencia, -1) <> NVL(:NEW.anios_experiencia, -1) THEN TO_CHAR(:OLD.anios_experiencia) || '*' || TO_CHAR(:NEW.anios_experiencia)
            WHEN NVL(:OLD.fecha_alta, DATE '1900-01-01') <> NVL(:NEW.fecha_alta, DATE '1900-01-01') THEN TO_CHAR(:OLD.fecha_alta, 'DD/MM/YYYY') || '*' || TO_CHAR(:NEW.fecha_alta, 'DD/MM/YYYY')
        END
    );
END;
/

/* Comprobacion */
select * from AUDITATECNICO;


/* 2. Crea un disparador BEFORE UPDATE que impida cambiar una proyección a otra sala si el aforo de la nueva sala es menor que la asistencia registrada para esa proyección. Tiene que lanzar el error RAISE_APPLICATION_ERROR */
CREATE OR REPLACE TRIGGER trg_control_cambio_sala
BEFORE UPDATE OF id_sala ON PROYECCION
FOR EACH ROW
DECLARE
    v_aforo SALA.aforo%TYPE;
BEGIN
    IF :OLD.id_sala <> :NEW.id_sala THEN
        SELECT aforo
        INTO v_aforo
        FROM SALA
        WHERE id_sala = :NEW.id_sala;

        IF :NEW.asistencia > v_aforo THEN
            RAISE_APPLICATION_ERROR(
                -20010,
                'No se puede cambiar la proyeccion a la nueva sala: el aforo es insuficiente.'
            );
        END IF;
    END IF;
END;
/

/* Comprobacion */
UPDATE PROYECCION
SET id_sala = 2
WHERE cod_proyeccion = 1004;

/* 3. Escribe un disparador que impida insertar o modificar una proyección si el técnico asignado como supervisor tiene menos de 2 años de experiencia. Tiene que lanzar el error RAISE_APPLICATION_ERROR */
CREATE OR REPLACE TRIGGER trg_supervisor_con_experiencia
BEFORE INSERT OR UPDATE OF nif_supervisor ON PROYECCION
FOR EACH ROW
DECLARE
    v_exp TECNICO.anios_experiencia%TYPE;
BEGIN
    SELECT anios_experiencia
    INTO v_exp
    FROM TECNICO
    WHERE nif_tecnico = :NEW.nif_supervisor;

    IF v_exp < 2 THEN
        RAISE_APPLICATION_ERROR(
            -20011,
            'El supervisor asignado no tiene la experiencia minima requerida.'
        );
    END IF;
END;
/

/* Comprobacion */
UPDATE PROYECCION
SET nif_supervisor = 'TEC004'
WHERE cod_proyeccion = 1001;

/* 4. Crea un disparador BEFORE UPDATE sobre la tabla PROYECCION que, cuando se cambie el campo id_sala, actualice también automáticamente el campo asistencia si esta supera el aforo de la nueva sala.

Es decir:

si la nueva sala tiene aforo suficiente, la asistencia se deja igual;
si la asistencia es mayor que el aforo de la nueva sala, la asistencia se cambia automáticamente al valor del aforo.*/

CREATE OR REPLACE TRIGGER trg_ajusta_asistencia_por_cambio_sala
BEFORE UPDATE OF id_sala ON PROYECCION
FOR EACH ROW
DECLARE
    v_aforo SALA.aforo%TYPE;
BEGIN
    SELECT aforo
    INTO v_aforo
    FROM SALA
    WHERE id_sala = :NEW.id_sala;

    IF :NEW.asistencia > v_aforo THEN
        :NEW.asistencia := v_aforo;
    END IF;
END;
/

/* Comprobacion */
UPDATE PROYECCION
SET id_sala = 2
WHERE cod_proyeccion = 1004;

/* 5. Crea un trigger que impida modificar o borrar una película si esa película ya tiene una o más proyecciones programadas en la tabla PROYECCION. Tiene que lanzar el error RAISE_APPLICATION_ERROR */
CREATE OR REPLACE TRIGGER trg_bloquea_pelicula_con_proyecciones
BEFORE UPDATE OR DELETE ON PELICULA
FOR EACH ROW
DECLARE
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM PROYECCION
    WHERE cod_pelicula = :OLD.cod_pelicula;

    IF v_total > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20012,
            'No se puede modificar o borrar una pelicula que tiene proyecciones asociadas.'
        );
    END IF;
END;
/

/* Comprobacion */
UPDATE PELICULA
SET titulo = 'Nuevo titulo'
WHERE cod_pelicula = 1;