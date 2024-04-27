SET SERVEROUTPUT ON;
-- Ejercicio 1
CREATE TABLE TB_OBJETOS (
    NOMBRE            VARCHAR2(255)  NOT NULL,
    CODIGO            INTEGER   NOT NULL primary key,
    FECHA_CREACION    DATE           DEFAULT SYSDATE,
    FECHA_MODIFICACION DATE,
    TIPO              VARCHAR2(32),
    ESQUEMA_ORIGINAL  VARCHAR2(64)   NOT NULL
);

DECLARE
    cursor c is select * from all_objects;
BEGIN
    for fila in c loop
        insert into TB_OBJETOS values(fila.object_name, fila.object_id, fila.created, fila.last_ddl_time, fila.object_type, fila.namespace);
    end loop;

END;
/


-- Ejercicio 2
CREATE TABLE TB_ESTILO (
    TIPO_OBJETO            VARCHAR2(32)  NOT NULL,
    PREFIJO                VARCHAR2(64) 
);


-- Ejercicio 3
ALTER TABLE TB_OBJETOS ADD ESTADO VARCHAR2(50);
ALTER TABLE TB_OBJETOS ADD NOMBRE_CORRECTO VARCHAR2(255);

CREATE OR REPLACE PROCEDURE PR_COMRPOBAR (ESQUEMA IN VARCHAR2 DEFAULT NULL) AS
    CURSOR TABLA_TB_OBJETOS IS SELECT * FROM TB_OBJETOS where ESQUEMA_ORIGINAL = NVL(ESQUEMA, ESQUEMA_ORIGINAL);
    v_prefix VARCHAR2(64);
BEGIN
    FOR fila in TABLA_TB_OBJETOS LOOP
        SELECT PREFIJO INTO v_prefix
        FROM TB_ESTILO
        WHERE TIPO_OBJETO = fila.TIPO;
        
        IF SUBSTR(fila.nombre, 1, LENGTH(v_prefix)) = v_prefix THEN
            -- Es prefijo
            fila.estado := 'CORRECTO';
            fila.nombre_correcto := fila.nombre;
        ELSE
            fila.estado := 'INCORRECTO';
            fila.nombre_correcto := v_prefix || fila.nombre;
        END IF;
        
        IF LENGTH(fila.nombre_correcto) > 255 THEN
            fila.nombre_correcto := SUBSTR(fila.nombre_correcto, 1, 255);
        ELSE
            fila.nombre_correcto := fila.nombre_correcto;
        END IF;
        
    end LOOP;
    COMMIT;
END;
/




