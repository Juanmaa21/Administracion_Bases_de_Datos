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



