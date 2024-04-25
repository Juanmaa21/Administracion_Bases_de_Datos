SET SERVEROUTPUT ON;

-- Ejercicio 1
DECLARE
    cursor c is select * from user_tables; -- Crear cursor
BEGIN
    for fila in c loop
        DBMS_OUTPUT.PUT_LINE('La tabla '  || fila.table_name || ' pertenece al esquema ' || USER);
    end loop;
END;
/

-- Ejercicio 2
DECLARE
    cursor c is select * from all_tables where owner <> USER; -- Crear cursor
BEGIN
    for fila in c loop
        DBMS_OUTPUT.PUT_LINE('La tabla '  || fila.table_name || ' pertenece al esquema ' || fila.owner);
    end loop;
END;
/

-- Ejercicio 3
-- No.

-- Ejercicio 4
DECLARE
    cursor c is select * from all_tables where owner = USER; -- Crear cursor
BEGIN
    for fila in c loop
        DBMS_OUTPUT.PUT_LINE('La tabla '  || fila.table_name || ' pertenece al esquema ' || fila.owner);
    end loop;
END;
/


-- Ejercicio 5
CREATE OR REPLACE PROCEDURE RECORRE_TABLAS (P_MODE IN NUMBER) AS
    CURSOR MIS_TABLAS    IS SELECT * FROM ALL_TABLES WHERE OWNER =  USER;
    CURSOR NO_MIS_TABLAS IS SELECT * FROM ALL_TABLES WHERE OWNER <> USER;
BEGIN
    IF P_MODE IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Debe añadirse un argumento: 0 para ver el resto de tablas y != 0 para las del usuario');
    ELSIF P_MODE = 0 THEN
        FOR T IN NO_MIS_TABLAS LOOP
            DBMS_OUTPUT.PUT_LINE('La tabla '  || T.table_name || ' pertenece al esquema ' || T.owner);
        END LOOP;
    ELSE
        FOR T IN MIS_TABLAS LOOP
            DBMS_OUTPUT.PUT_LINE('La tabla '  || T.table_name || ' pertenece al esquema ' || T.owner);
        END LOOP;
    END IF;
END;
/

-- Lo ejecutamos
BEGIN
    RECORRE_TABLAS(1);
END;
/



