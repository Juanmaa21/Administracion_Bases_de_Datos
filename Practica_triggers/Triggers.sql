
-- Ejercicio 1

CREATE TABLE MENSAJES (
    Codigo NUMBER(20) PRIMARY KEY,
    Texto VARCHAR2(200)
);

CREATE TABLE AUDITA_MENSAJES (
    Quien VARCHAR2(20),
    Como VARCHAR2(20),
    Cuando DATE
);

CREATE OR REPLACE TRIGGER T1 BEFORE INSERT OR DELETE OR UPDATE ON MENSAJES
DECLARE
    V_OPERACION VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        V_OPERACION := 'INSERT';
    ELSIF UPDATING THEN
        V_OPERACION := 'UPDATE';
    ELSE
        V_OPERACION := 'DELETE';
    END IF;
    INSERT INTO AUDITA_MENSAJES VALUES (USER, V_OPERACION, SYSDATE);
END;
/


-- Ejercicio 2

ALTER TABLE MENSAJES ADD (TIPO VARCHAR2(20));

ALTER TABLE MENSAJES 
ADD CONSTRAINT check_tipo 
CHECK (TIPO IN ('INFORMACION', 'RESTRICCION', 'ERROR', 'AYUDA', 'AVISO'));




INSERT INTO MENSAJES (Codigo, Texto, TIPO) VALUES (1, 'Este es un mensaje de información', 'INFORMACION');
INSERT INTO MENSAJES (Codigo, Texto, TIPO) VALUES (2, 'Este es otro mensaje de información', 'INFORMACION');

INSERT INTO MENSAJES (Codigo, Texto, TIPO) VALUES (3, 'Este es un mensaje de restricción', 'RESTRICCION');
INSERT INTO MENSAJES (Codigo, Texto, TIPO) VALUES (4, 'Este es otro mensaje de restricción', 'RESTRICCION');

INSERT INTO MENSAJES (Codigo, Texto, TIPO) VALUES (5, 'Este es un mensaje de error', 'ERROR');
INSERT INTO MENSAJES (Codigo, Texto, TIPO) VALUES (6, 'Este es otro mensaje de error', 'ERROR');

INSERT INTO MENSAJES (Codigo, Texto, TIPO) VALUES (7, 'Este es un mensaje de aviso', 'AVISO');
INSERT INTO MENSAJES (Codigo, Texto, TIPO) VALUES (8, 'Este es otro mensaje de aviso', 'AVISO');

INSERT INTO MENSAJES (Codigo, Texto, TIPO) VALUES (9, 'Este es un mensaje de ayuda', 'AYUDA');
INSERT INTO MENSAJES (Codigo, Texto, TIPO) VALUES (10, 'Este es otro mensaje de ayuda', 'AYUDA');


CREATE TABLE MENSAJES_Info (
    Tipo VARCHAR2(30) PRIMARY KEY,
    Cuantos_Mensajes NUMBER(2),
    Ultimo VARCHAR2(200)
);

INSERT INTO MENSAJES_info VALUES('INFORMACION', 0,NULL);
INSERT INTO MENSAJES_info VALUES('RESTRICCION', 0,NULL);
INSERT INTO MENSAJES_info VALUES('ERROR', 0,NULL);
INSERT INTO MENSAJES_info VALUES('AVISO', 0,NULL);
INSERT INTO MENSAJES_info VALUES('AYUDA', 0,NULL);

CREATE OR REPLACE TRIGGER T_INSERT
AFTER INSERT ON MENSAJES
FOR EACH ROW
BEGIN
    UPDATE MENSAJES_Info
    SET Cuantos_Mensajes = NVL(Cuantos_Mensajes, 0) + 1,
        Ultimo = :new.Texto
    WHERE Tipo = :new.Tipo;

END;
/

CREATE OR REPLACE TRIGGER T_DELETE
AFTER DELETE ON MENSAJES
FOR EACH ROW
BEGIN
    UPDATE MENSAJES_Info
    SET Cuantos_Mensajes = Cuantos_Mensajes - 1,
        Ultimo = NULL
    WHERE Tipo = :old.Tipo;
END;
/

CREATE OR REPLACE TRIGGER T_UPDATE
AFTER UPDATE ON MENSAJES
FOR EACH ROW
BEGIN
    IF :old.Tipo != :new.Tipo THEN
        UPDATE MENSAJES_Info
        SET Cuantos_Mensajes = NVL(Cuantos_Mensajes, 0) + 1,
            Ultimo = :new.Texto
        WHERE Tipo = :new.Tipo;

        UPDATE MENSAJES_Info
        SET Cuantos_Mensajes = Cuantos_Mensajes - 1,
            Ultimo = NULL
        WHERE Tipo = :old.Tipo;
    END IF;
END;
/



-- Ejercicio 3

CREATE TABLE MENSAJES_TEXTO (
    Codigo NUMBER(20) PRIMARY KEY,
    Texto VARCHAR2(200)
);

CREATE TABLE MENSAJES_TIPO (
    Codigo NUMBER(20),
    Tipo VARCHAR2(20)
);

-- Mover datos a MENSAJES_TEXTO
INSERT INTO MENSAJES_TEXTO (Codigo, Texto)
SELECT Codigo, Texto FROM MENSAJES;

-- Mover datos a MENSAJES_TIPO
INSERT INTO MENSAJES_TIPO (Codigo, Tipo)
SELECT Codigo, Tipo FROM MENSAJES;

-- Eliminar la tabla MENSAJES
DROP TABLE MENSAJES;

-- Crear la vista MENSAJES
CREATE VIEW MENSAJES AS
SELECT T.Codigo, T.Texto, TT.Tipo
FROM MENSAJES_TEXTO T
JOIN MENSAJES_TIPO TT ON T.Codigo = TT.Codigo;

-- Si se puede hacer un select
SELECT * FROM MENSAJES;

--No podemos realizar inserciones directamente sobre la vista MENSAJES
--debido a que está basada en dos tablas subyacentes, MENSAJES_TEXTO y MENSAJES_TIPO,

-- Solucion al problema de insertar
CREATE OR REPLACE TRIGGER T2_INSERT
INSTEAD OF INSERT ON MENSAJES
FOR EACH ROW
BEGIN
    -- Insertar en MENSAJES_TEXTO
    INSERT INTO MENSAJES_TEXTO (Codigo, Texto) VALUES (:NEW.Codigo, :NEW.Texto);
    
    -- Insertar en MENSAJES_TIPO
    INSERT INTO MENSAJES_TIPO (Codigo, Tipo) VALUES (:NEW.Codigo, :NEW.Tipo);
END;
/

-- Ejercicio 4

CREATE TABLE MENSAJES_BORRADOS AS SELECT * FROM MENSAJES_TEXTO WHERE 1=0;

select * from mensajes_borrados;


CREATE OR REPLACE TRIGGER T_Borrar_Mensaje_Texto
AFTER DELETE ON MENSAJES_TEXTO
FOR EACH ROW
BEGIN
    INSERT INTO MENSAJES_BORRADOS (Codigo, Texto)
    VALUES (:old.Codigo, :old.Texto);
END;
/


-- Ejercicio 5
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'borrar_mensajes_borrados_job',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN DELETE FROM MENSAJES_BORRADOS; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY; INTERVAL=2',
    enabled         => TRUE
  );
END;
/
