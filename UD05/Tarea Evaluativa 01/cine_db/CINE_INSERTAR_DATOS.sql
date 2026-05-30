-- cine_database_insert.sql
-- Script de inserción de datos para la base de datos CINE

/* INSERTS INTERPRETE */
INSERT INTO INTERPRETE (dni_interprete, nombre_artistico, edad) VALUES
  ('INT0001A', 'Ana López', 32);
INSERT INTO INTERPRETE (dni_interprete, nombre_artistico, edad) VALUES
  ('INT0002B', 'Bruno Díaz', 41);
INSERT INTO INTERPRETE (dni_interprete, nombre_artistico, edad) VALUES
  ('INT0003C', 'Carla Martín', 27);
INSERT INTO INTERPRETE (dni_interprete, nombre_artistico, edad) VALUES
  ('INT0004D', 'Diego Sánchez', 55);
INSERT INTO INTERPRETE (dni_interprete, nombre_artistico, edad) VALUES
  ('INT0005E', 'Elena Romero', 19);
INSERT INTO INTERPRETE (dni_interprete, nombre_artistico, edad) VALUES
  ('INT0006F', 'Fernando Torres', 62);

/* INSERTS PELICULA */
INSERT INTO PELICULA (cod_pelicula, titulo, director, pais) VALUES
  (1, 'El silencio de la ciudad', 'Lucía Herrera', 'España');
INSERT INTO PELICULA (cod_pelicula, titulo, director, pais) VALUES
  (2, 'Sombras en la nieve', 'Kenji Tanaka', 'Japón');
INSERT INTO PELICULA (cod_pelicula, titulo, director, pais) VALUES
  (3, 'La última luz del día', 'Marco Bianchi', 'Italia');
INSERT INTO PELICULA (cod_pelicula, titulo, director, pais) VALUES
  (4, 'Horizontes lejanos', 'Charlotte Miller', 'Reino Unido');
INSERT INTO PELICULA (cod_pelicula, titulo, director, pais) VALUES
  (5, 'Caminos cruzados', 'Jorge Castillo', 'México');

/* INSERTS SALA */
INSERT INTO SALA (id_sala, nombre_sala, sede, aforo) VALUES
  (1, 'Sala Roja', 'Cine Centro', 120);
INSERT INTO SALA (id_sala, nombre_sala, sede, aforo) VALUES
  (2, 'Sala Azul', 'Cine Centro', 80);
INSERT INTO SALA (id_sala, nombre_sala, sede, aforo) VALUES
  (3, 'Sala Oro', 'Cine Palacio Real', 200);

/* INSERTS TECNICO */
INSERT INTO TECNICO (nif_tecnico, nombre, anios_experiencia) VALUES
  ('TEC001', 'Laura Gómez', 5);
INSERT INTO TECNICO (nif_tecnico, nombre, anios_experiencia) VALUES
  ('TEC002', 'Carlos Ruiz', 12);
INSERT INTO TECNICO (nif_tecnico, nombre, anios_experiencia) VALUES
  ('TEC003', 'Marta Sánchez', 8);
INSERT INTO TECNICO (nif_tecnico, nombre, anios_experiencia) VALUES
  ('TEC004', 'David Torres', 0);
INSERT INTO TECNICO (nif_tecnico, nombre, anios_experiencia) VALUES
  ('TEC005', 'Elena Martín', 20);

/* INSERTS PROYECCION */
INSERT INTO PROYECCION (cod_proyeccion, fecha_hora, duracion_min, asistencia, cod_pelicula, id_sala, nif_supervisor)
VALUES (1001, TO_DATE('2025-03-10 18:00','YYYY-MM-DD HH24:MI'), 115, 60, 1, 1, 'TEC001');

INSERT INTO PROYECCION (cod_proyeccion, fecha_hora, duracion_min, asistencia, cod_pelicula, id_sala, nif_supervisor)
VALUES (1002, TO_DATE('2025-03-10 20:30','YYYY-MM-DD HH24:MI'), 130, 75, 2, 1, 'TEC002');

INSERT INTO PROYECCION (cod_proyeccion, fecha_hora, duracion_min, asistencia, cod_pelicula, id_sala, nif_supervisor)
VALUES (1003, TO_DATE('2025-03-11 17:00','YYYY-MM-DD HH24:MI'), 100, 45, 3, 2, 'TEC003');

INSERT INTO PROYECCION (cod_proyeccion, fecha_hora, duracion_min, asistencia, cod_pelicula, id_sala, nif_supervisor)
VALUES (1004, TO_DATE('2025-03-11 19:30','YYYY-MM-DD HH24:MI'), 140, 120, 4, 3, 'TEC004');

INSERT INTO PROYECCION (cod_proyeccion, fecha_hora, duracion_min, asistencia, cod_pelicula, id_sala, nif_supervisor)
VALUES (1005, TO_DATE('2025-03-12 21:00','YYYY-MM-DD HH24:MI'), 110, 90, 5, 3, 'TEC005');

/* INSERTS ACTUA_EN */
INSERT INTO ACTUA_EN VALUES ('INT0001A', 1, 'Protagonista');
INSERT INTO ACTUA_EN VALUES ('INT0002B', 1, 'Antagonista');
INSERT INTO ACTUA_EN VALUES ('INT0003C', 1, 'Personaje secundario');
INSERT INTO ACTUA_EN VALUES ('INT0002B', 2, 'Protagonista');
INSERT INTO ACTUA_EN VALUES ('INT0004D', 2, 'Secundario');
INSERT INTO ACTUA_EN VALUES ('INT0003C', 3, 'Protagonista');
INSERT INTO ACTUA_EN VALUES ('INT0005E', 3, 'Cameo');
INSERT INTO ACTUA_EN VALUES ('INT0001A', 4, 'Secundario');
INSERT INTO ACTUA_EN VALUES ('INT0006F', 4, 'Protagonista');
INSERT INTO ACTUA_EN VALUES ('INT0004D', 5, 'Protagonista');
INSERT INTO ACTUA_EN VALUES ('INT0005E', 5, 'Secundario');

/* INSERTS SUPLENCIA */
INSERT INTO SUPLENCIA VALUES ('TEC001', 'TEC003', TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-05','YYYY-MM-DD'));
INSERT INTO SUPLENCIA VALUES ('TEC002', 'TEC004', TO_DATE('2025-03-06','YYYY-MM-DD'), TO_DATE('2025-03-10','YYYY-MM-DD'));
INSERT INTO SUPLENCIA VALUES ('TEC003', 'TEC005', TO_DATE('2025-03-10','YYYY-MM-DD'), TO_DATE('2025-03-15','YYYY-MM-DD'));

/* INSERTS ENTRADA */
INSERT INTO ENTRADA VALUES (1, 'PLATEA', 1, 1, 1001);
INSERT INTO ENTRADA VALUES (2, 'PLATEA', 1, 2, 1001);
INSERT INTO ENTRADA VALUES (3, 'PLATEA', 1, 3, 1001);
INSERT INTO ENTRADA VALUES (4, 'ANFITEATRO', 2, 10, 1001);

INSERT INTO ENTRADA VALUES (5, 'PLATEA', 3, 4, 1002);
INSERT INTO ENTRADA VALUES (6, 'PLATEA', 3, 5, 1002);
INSERT INTO ENTRADA VALUES (7, 'ANFITEATRO', 5, 12, 1002);

INSERT INTO ENTRADA VALUES (8, 'PLATEA', 1, 1, 1003);
INSERT INTO ENTRADA VALUES (9, 'VIP', 1, 2, 1003);

INSERT INTO ENTRADA VALUES (10, 'PLATEA', 4, 6, 1004);
INSERT INTO ENTRADA VALUES (11, 'PLATEA', 4, 7, 1004);
INSERT INTO ENTRADA VALUES (12, 'ANFITEATRO', 6, 15, 1004);

INSERT INTO ENTRADA VALUES (13, 'PLATEA', 2, 8, 1005);
INSERT INTO ENTRADA VALUES (14, 'VIP', 1, 1, 1005);

/* INSERTS ENTRADA_COMPRADA */
INSERT INTO ENTRADA_COMPRADA VALUES (1, 7.50);
INSERT INTO ENTRADA_COMPRADA VALUES (2, 7.50);
INSERT INTO ENTRADA_COMPRADA VALUES (3, 7.50);
INSERT INTO ENTRADA_COMPRADA VALUES (4, 6.00);
INSERT INTO ENTRADA_COMPRADA VALUES (5, 8.00);
INSERT INTO ENTRADA_COMPRADA VALUES (6, 8.00);
INSERT INTO ENTRADA_COMPRADA VALUES (7, 6.50);
INSERT INTO ENTRADA_COMPRADA VALUES (8, 9.00);
INSERT INTO ENTRADA_COMPRADA VALUES (9, 12.00);
INSERT INTO ENTRADA_COMPRADA VALUES (10, 9.50);

/* INSERTS ENTRADA_INVITACION */
INSERT INTO ENTRADA_INVITACION VALUES (11, 'Invitación a crítico de cine');
INSERT INTO ENTRADA_INVITACION VALUES (12, 'Invitación organización del festival');
INSERT INTO ENTRADA_INVITACION VALUES (13, 'Invitación patrocinador principal');
INSERT INTO ENTRADA_INVITACION VALUES (14, 'Invitación director de la película');

COMMIT;
