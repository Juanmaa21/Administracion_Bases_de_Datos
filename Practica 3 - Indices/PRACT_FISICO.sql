-- Creamos la tabla con los atributos
CREATE TABLE PRUEBA(
    CLAVE number(16,0) primary key, --Tiene numeros de hasta 16 cifras y 0 decimales
    DISPERSO number(16,0),
    CONCENTRADO number(16,0),
    IDISPERSO number(16,0),
    ICONCENTRADO number(16,0),
    BCONCENTRADO number(16,0)
);


-- Rellenar con datos de la tabla
DECLARE
    I NUMBER(16,0);
    R NUMBER(16,0);
    BEGIN
    FOR I IN 1..500000 LOOP
         R := DBMS_RANDOM.VALUE(1,1000000000);
         INSERT INTO PRUEBA VALUES(I, R, MOD(R,11), 1000000000-R, MOD(1000000000-R, 11),
         MOD(2000000000-R, 11));
    END LOOP;
END;
/

-- No olvidar de hacer el commit para confirmar los cambios
COMMIT;

-- Crear tres índices sobre la tabla
CREATE INDEX PID ON PRUEBA (IDISPERSO);
CREATE INDEX PIC ON PRUEBA (ICONCENTRADO);
CREATE BITMAP INDEX PBC ON PRUEBA (BCONCENTRADO);


-- Ver cuántos índices hay en este usuario
select * from all_indexes where owner = 'PRACT_FISICO';


-- Activar el AUTOTRACE, muestra el plan de ejecución, así como
-- las estadísticas de la sentencia.
SET AUTOTRACE ON;
ALTER SESSION SET STATISTICS_LEVEL='ALL';


-- Cada vez que haga una busqueda, vacia la RAM
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SYSTEM FLUSH BUFFER_CACHE;


SELECT COUNT(*) FROM PRUEBA WHERE CLAVE = 50000;




