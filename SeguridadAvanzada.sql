
/* EJERCICIO 2 */

-- Establecer el directorio dónde se va a almacenar el keystore
ALTER SYSTEM SET "WALLET_ROOT"='C:\app\alumnos\admin\orcl\wallet' scope=SPFILE;

-- Establecer el tipo de Keystore que vamos a utilizar:
ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" scope=both;

-- Desde SqlPlus: Sqlplus / as syskm
-- ADMINISTER KEY MANAGEMENT CREATE KEYSTORE IDENTIFIED BY bd;
-- ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE IDENTIFIED BY bd;
-- ADMINISTER KEY MANAGEMENT SET KEY force keystore identified by bd with backup;



-- Crear usuario con contraseña "LIFEFIT3123" y que cada vez que cree algo se 
-- guarda por defecto en el tablespace TS_LIFEFIT y sin limite de espacio
CREATE USER LIFEFIT3 IDENTIFIED BY LIFEFIT3123 DEFAULT TABLESPACE TS_LIFEFIT QUOTA UNLIMITED ON TS_LIFEFIT;
-- Asignar privilegios para conectarse
GRANT CONNECT, RESOURCE TO LIFEFIT3;



-- ESTO DENTRO DE LIFEFIT3
-- Crear una tabla con columnas
create table entrenador
(
    codigo varchar2(16) primary key,
    nombre varchar2(64) not null,
    telefono varchar2(16) not null
    );
    
-- Añadimos un dato
insert into entrenador values('111111', 'Jose Garcia', '555555');

-- Hay que hacerlo para que el resto de usuarios vean lo que hemos añadido/modificado
COMMIT; 

-- Modificamos la tabla para que el telefono esté encriptado
ALTER TABLE ENTRENADOR MODIFY
(
    TELEFONO ENCRYPT
);






