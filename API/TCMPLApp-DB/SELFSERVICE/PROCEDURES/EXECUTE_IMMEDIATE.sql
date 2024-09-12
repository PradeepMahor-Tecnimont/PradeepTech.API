--------------------------------------------------------
--  DDL for Procedure EXECUTE_IMMEDIATE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."EXECUTE_IMMEDIATE" (
    p_sql_text Varchar2
) Is

    compilation_error Exception;
    Pragma exception_init ( compilation_error, -24344 );
    l_cursor   Integer Default 0;
    rc         Integer Default 0;
    stmt       Varchar2(1000);
Begin
    l_cursor   := dbms_sql.open_cursor;
    dbms_sql.parse(
        l_cursor,
        p_sql_text,
        dbms_sql.native
    );
    rc         := dbms_sql.execute(l_cursor);
    dbms_sql.close_cursor(l_cursor);
--
-- Ignore compilation errors because these sometimes happen due to
-- dependencies between views AND procedures
--
Exception
    When compilation_error Then
        dbms_sql.close_cursor(l_cursor);
    When Others Then
        Begin
            dbms_sql.close_cursor(l_cursor);
            raise_application_error(
                -20101,
                Sqlerrm || '  when executing ''' || p_sql_text || '''   '
            );
        End;
End;


/
