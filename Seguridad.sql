/* Distintos selects utiles
SELECT * FROM DBA_TABLESPACES;
SELECT * FROM DBA_PROFILES;
SELECT * FROM DBA_USERS;
SELECT * FROM v$tablespace;
SELECT * FROM v$datafile;
SELECT * FROM v$parameter WHERE UPPER(NAME) LIKE '%RESOURCE%';
SHOW PARAMETER RESOURCE_LIMIT;
*/

// Ejercicio 3
// Creamos un tablespace de nombre TS_LIFEFIT y ruta ... 
CREATE TABLESPACE TS_LIFEFIT DATAFILE 'C:\APP\ALUMNOS\ORADATA\ORCL\liefit.dbf' SIZE 10M AUTOEXTEND ON;
// DROP TABLESPACE TS_LIFEFIT;

// Borra un perfil y toda su info asociada
// DROP PROFILE PERF_ADMINISTRATIVO CASCADE;

// Ejercicio 4
// Crea perfil admin
CREATE PROFILE PERF_ADMINISTRATIVO LIMIT 
    IDLE_TIME 5
    FAILED_LOGIN_ATTEMPTS 3
    ;

// Ejercicio 5
// Crea perfil usuario
CREATE PROFILE PERF_USUARIO LIMIT
    SESSIONS_PER_USER 4
    PASSWORD_LIFE_TIME 30
    ;

//Ejercicio 6
SHOW PARAMETER RESOURCE_LIMIT; // Comprobar si esta activo o no
ALTER SYSTEM SET RESOURCE_LIMIT = TRUE; // En caso de que no, activarlo

// Aun no se ha determinado la limitacion de los recursos de cada uno de los usuarios
// Por lo tanto, esos campos no estan todavia incluidos en los create.
    
/*
CREATE USER ADMINISTRADOR IDENTIFIED BY admin
    PROFILE PERF_ADMINISTRATIVO
    DEFAULT TABLESPACE TS_LIFEFIT
    ;
*/    
// DROP USER ADMINISTRADOR CASCADE;

// Ejercicio 7
-- Crear el rol
CREATE ROLE R_ADMINISTRADOR_SUPER;

-- Otorgar permiso para conectarse a la base de datos
GRANT CONNECT TO R_ADMINISTRADOR_SUPER;

-- Otorgar permiso para crear tablas en el esquema público
GRANT CREATE TABLE TO R_ADMINISTRADOR_SUPER;

// Ejercicio 8
-- Creación de ambos usuarios
CREATE USER USUARIO1 IDENTIFIED BY usuario QUOTA 1M ON TS_LIFEFIT DEFAULT TABLESPACE TS_LIFEFIT PROFILE PERF_ADMINISTRATIVO;
CREATE USER USUARIO2 IDENTIFIED BY usuario QUOTA 1M ON TS_LIFEFIT DEFAULT TABLESPACE TS_LIFEFIT PROFILE PERF_ADMINISTRATIVO;

-- Otorgamos los roles
GRANT R_ADMINISTRADOR_SUPER TO USUARIO1;
GRANT R_ADMINISTRADOR_SUPER TO USUARIO2;


// Ejercicio 9
-- Crear TABLA2 en ambos usuarios
CREATE TABLE USUARIO1.TABLA2 (
    CODIGO NUMBER
);
CREATE TABLE USUARIO2.TABLA2 (
    CODIGO NUMBER
);

// Ejercicio 10
-- Tal cual, con la barra del 7 también
CREATE OR REPLACE PROCEDURE USUARIO1.PR_INSERTA_TABLA2 (
                                P_CODIGO IN NUMBER) AS
 BEGIN
      INSERT INTO TABLA2 VALUES (P_CODIGO);
 END PR_INSERTA_TABLA2;
/

// Ejercicio 11
-- Abrimos SQLPlus
-- Funciona divinamente
-- exec PR_INSERTA_TABLA2(12);

// Ejercicio 12
-- Desde el USUARIO1, GRANT EXECUTE ON PR_INSERTA_TABLA2 TO USUARIO2;

// Ejercicio 13
-- Desde USUARIO2, exec USUARIO1.PR_INSERTA_TABLA2(12);
-- No funciona, ya que hay que hacer un "commit;" para guardar

// Ejercicio 14
-- En la tabla del USUARIO1 porque así lo dice el propio procedimiento
-- Los datos del USUARIO1 al inicio y los del USUARIO2 al final

// Ejercicio 15
 CREATE OR REPLACE PROCEDURE USUARIO1.PR_INSERTA_TABLA2 (
      P_CODIGO IN NUMBER) AS
 BEGIN
      execute immediate 'INSERT INTO TABLA2 VALUES ('||P_CODIGO||')';
 END PR_INSERTA_TABLA2;
/ 

// Ejercicio 16 y 17
-- Funciona muy bien en ambos, solo que se sigue necesitando realizar el commit

// Ejercicio 18
-- En USUARIO1
CREATE OR REPLACE PROCEDURE USUARIO1.PR_CREA_TABLA (
  P_TABLA IN VARCHAR2, P_ATRIBUTO IN VARCHAR2) AS
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE '||P_TABLA||'('||P_ATRIBUTO||' NUMBER(9))';
 END PR_CREA_TABLA;
/

// Ejercicio 19
-- exec PR_CREA_TABLA('EjemploTabla', 'ID');
-- No funciona, no tiene permisos

// Ejercicio 20
-- Permitir al USUARIO1 crear tablas
GRANT CREATE TABLE TO USUARIO1;

-- Desde USUARIO1: GRANT EXECUTE ON PR_CREA_TABLA TO USUARIO2;
GRANT EXECUTE ON PR_CREA_TABLA TO USUARIO2;

// Ejercicio 21
-- En USUARIO2: exec USUARIO1.PR_CREA_TABLA('EjemploTabla', 'ID');
-- Si funciona, las crea en el USUARIO1

// Ejercicio 22
// select * from DBA_USERS_WITH_DEFPWD;

SELECT * FROM DBA_USERS_WITH_DEFPWD;

// Ejercicio 23
--  Parámetros existentes del profile por defecto
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';

-- Cambia el número de logins fallidos a 4 y el tiempo de gracia a 5 días
ALTER PROFILE DEFAULT LIMIT FAILED_LOGIN_ATTEMPTS 4 PASSWORD_GRACE_TIME 5;

-- Cambia el perfil del usuario1 al perfil por defecto y haz 5 logins fallidos.
ALTER USER USUARIO1 PROFILE DEFAULT;
--¿Que ocurre la quinta vez? Para responder interpreta bien los mensajes que recibes.
-- Se bloquea el usuario y no se puede acceder

--Desbloquea la cuenta (alter user...)
ALTER USER USUARIO1 ACCOUNT UNLOCK;

-- A pesar de que hayamos cambiado el parámetro de failed_login_attempts,
-- como habrás visto, es posible que antes, aunque el usuario no se bloquee, 
-- si nos eche de la sesión. Si consultamos el parámetro de inicialización
-- sec_max_failed_login_attempts (show parameter...) aparece un valor menor
-- (si no lo has cambiado antes). Significan por tanto diferentes cosas.
-- ¿Para qué es útil cada uno?
SELECT value
FROM v$parameter
WHERE name = 'sec_max_failed_login_attempts';
-- Se muestra "3", por lo que esos serían los intentos maximos por defecto que
-- Oracle asigna a un perfil, puediendose cambiar posteriormente.

-- Investiga si existe una forma de "quitar" los perfiles que hemos creado
-- al principio. ¿Se puede hacer con todos los perfiles de oracle?
// Se podría accediendo desde SYS y conociendo la contraseña del usuario, cosa
// que se debería evitar.

-- Una última pregunta. Algunos parámetros de inicialización son dinámicos,
-- y otros estáticos. ¿Cual es la diferencia entre ellos?
// Los estáticos no pueden ser modificados, mientras que los dinámicos, por medio
// de comandos, si se podría.


















