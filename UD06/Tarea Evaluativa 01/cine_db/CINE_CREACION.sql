/* TABLESPACE (si procede en tu entorno) */
CREATE TABLESPACE CINE
DATAFILE 'cine01.dbf' SIZE 50M
AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

/* === TABLAS (todo NOT NULL; sin DEFAULT) === */

CREATE TABLE INTERPRETE (
  dni_interprete   VARCHAR2(12)    PRIMARY KEY,
  nombre_artistico VARCHAR2(100)   NOT NULL,
  edad             NUMBER(3)       NOT NULL
) TABLESPACE CINE;

CREATE TABLE PELICULA (
  cod_pelicula NUMBER(10)     PRIMARY KEY,
  titulo       VARCHAR2(150)  NOT NULL,
  director     VARCHAR2(100)  NOT NULL,
  pais         VARCHAR2(60)   NOT NULL
) TABLESPACE CINE;

CREATE TABLE SALA (
  id_sala     NUMBER(10)     PRIMARY KEY,
  nombre_sala VARCHAR2(100)  NOT NULL,
  sede        VARCHAR2(100)  NOT NULL,
  aforo       NUMBER(5)      NOT NULL
) TABLESPACE CINE;

CREATE TABLE TECNICO (
  nif_tecnico        VARCHAR2(12)  PRIMARY KEY,
  nombre             VARCHAR2(100) NOT NULL,
  anios_experiencia  NUMBER(2)     NOT NULL
) TABLESPACE CINE;

CREATE TABLE PROYECCION (
  cod_proyeccion NUMBER(10)   PRIMARY KEY,
  fecha_hora     DATE         NOT NULL,
  seccion        VARCHAR2(50) NOT NULL,     -- se eliminará en el Ej.2
  duracion_min   NUMBER(4)    NOT NULL,
  asistencia     NUMBER(5)    NOT NULL,
  cod_pelicula   NUMBER(10)   NOT NULL,
  id_sala        NUMBER(10)   NOT NULL,
  nif_supervisor VARCHAR2(12) NOT NULL,
  CONSTRAINT fk_proy_pelicula  FOREIGN KEY (cod_pelicula)   REFERENCES PELICULA(cod_pelicula),
  CONSTRAINT fk_proy_sala      FOREIGN KEY (id_sala)        REFERENCES SALA(id_sala),
  CONSTRAINT fk_proy_tecnico   FOREIGN KEY (nif_supervisor) REFERENCES TECNICO(nif_tecnico)
) TABLESPACE CINE;

CREATE TABLE ACTUA_EN (
  dni_interprete VARCHAR2(12) NOT NULL,
  cod_pelicula   NUMBER(10)   NOT NULL,
  papel          VARCHAR2(100) NOT NULL,
  CONSTRAINT pk_actua_en PRIMARY KEY (dni_interprete, cod_pelicula),
  CONSTRAINT fk_actua_interprete FOREIGN KEY (dni_interprete) REFERENCES INTERPRETE(dni_interprete),
  CONSTRAINT fk_actua_pelicula   FOREIGN KEY (cod_pelicula)   REFERENCES PELICULA(cod_pelicula)
) TABLESPACE CINE;

CREATE TABLE SUPLENCIA (
  nif_titular  VARCHAR2(12) NOT NULL,
  nif_suplente VARCHAR2(12) NOT NULL,
  fecha_inicio DATE         NOT NULL,
  fecha_fin    DATE         NOT NULL,
  CONSTRAINT pk_suplencia PRIMARY KEY (nif_titular, nif_suplente),
  CONSTRAINT fk_sup_titular  FOREIGN KEY (nif_titular)  REFERENCES TECNICO(nif_tecnico),
  CONSTRAINT fk_sup_suplente FOREIGN KEY (nif_suplente) REFERENCES TECNICO(nif_tecnico)
) TABLESPACE CINE;

CREATE TABLE ENTRADA (
  num_entrada    NUMBER(12)   PRIMARY KEY,
  zona           VARCHAR2(20) NOT NULL,
  fila           NUMBER(4)    NOT NULL,
  butaca         NUMBER(4)    NOT NULL,
  cod_proyeccion NUMBER(10)   NOT NULL,
  CONSTRAINT fk_entrada_proy FOREIGN KEY (cod_proyeccion) REFERENCES PROYECCION(cod_proyeccion),
  CONSTRAINT uq_asiento UNIQUE (cod_proyeccion, zona, fila, butaca)
) TABLESPACE CINE;

CREATE TABLE ENTRADA_COMPRADA (
  num_entrada NUMBER(12)  PRIMARY KEY,
  precio      NUMBER(8,2) NOT NULL,
  CONSTRAINT fk_ec_super FOREIGN KEY (num_entrada) REFERENCES ENTRADA(num_entrada),
  CONSTRAINT chk_ec_precio_pos CHECK (precio > 0)   -- <== exigencia de la nota
) TABLESPACE CINE;

CREATE TABLE ENTRADA_INVITACION (
  num_entrada NUMBER(12)  PRIMARY KEY,
  motivo_inv  VARCHAR2(200) NOT NULL,
  CONSTRAINT fk_ei_super FOREIGN KEY (num_entrada) REFERENCES ENTRADA(num_entrada)
) TABLESPACE CINE;


/* === CHECK 1/4: INTERPRETE.edad [0..120] === */
ALTER TABLE INTERPRETE
  ADD CONSTRAINT chk_interprete_edad CHECK (edad BETWEEN 0 AND 120);

/* === CHECK 2/4: SALA.aforo > 0 === */
ALTER TABLE SALA
  ADD CONSTRAINT chk_sala_aforo CHECK (aforo > 0);

/* === CHECK 3/4: TECNICO.anios_experiencia >= 0 === */
ALTER TABLE TECNICO
  ADD CONSTRAINT chk_tecnico_exp CHECK (anios_experiencia >= 0);

/* === CHECK 4/4: PROYECCION.duracion_min > 0 === */
ALTER TABLE PROYECCION
  ADD CONSTRAINT chk_proy_duracion CHECK (duracion_min > 0);

/* === ELIMINAR columna (delete) === */
ALTER TABLE PROYECCION DROP COLUMN seccion;

/* === AÑADIR columna (create) === */
ALTER TABLE TECNICO ADD (fecha_alta DATE DEFAULT SYSDATE);