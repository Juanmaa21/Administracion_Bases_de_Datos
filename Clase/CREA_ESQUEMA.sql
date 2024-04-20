


ALTER SESSION SET CURRENT_SCHEMA=LIFEFIT;

CREATE TABLE GERENTE (
    USUAIO   NUMBER(9),
    DESPACHO VARCHAR2(50),
    HORARIO  VARCHAR2(50)
) TABLESPACE TS_LIFEFIT;

CREATE TABLE USUARIO (
    ID        NUMBER(9),
    NOMBRE    VARCHAR2(50) ENCRYPT NOT NULL,
    APELLIDOS VARCHAR2(50) ENCRYPT NOT NULL,
    TELEFONO  VARCHAR2(50) ENCRYPT,
    CONSTRAINT USUARIO_PK
        PRIMARY KEY (ID)
        USING INDEX TABLESPACE TS_INDICES
) TABLESPACE TS_LIFEFIT;

ALTER TABLE GERENTE ADD
    CONSTRAINT GERENTE_USUARIO_FK
        FOREIGN KEY (USUARIO)
            REFERENCES USUARIO (ID);