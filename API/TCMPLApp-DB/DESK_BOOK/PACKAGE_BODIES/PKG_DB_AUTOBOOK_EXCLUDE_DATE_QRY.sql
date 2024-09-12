--------------------------------------------------------
--  DDL for Package Body PKG_DB_AUTOBOOK_EXCLUDE_DATE_QRY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "DESK_BOOK"."PKG_DB_AUTOBOOK_EXCLUDE_DATE_QRY" As

    Function fn_db_autobook_exclude_date_list (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_row_number      Number,
        p_page_length     Number
    ) Return Sys_Refcursor As
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For Select
                      *
                    From
                      (
                          Select
                              a.key_id          As key_id,        
                              a.empno           As empno,         
                              a.attendance_date As attendance_date,     
                              a.modified_on     As modified_on,       
                              a.modified_by     As modified_by,         
                              Row_Number() Over( Order By a.empno ) row_number,                                          Count(*)
                              Over()            total_row
                            From
                              db_autobook_exclude_date a
                           Where
                                  a.empno = v_empno
                             order by a.attendance_date  
                      )
            Where
               row_number Between ( nvl( p_row_number, 0 ) + 1 ) And ( nvl( p_row_number, 0 ) + p_page_length );
        Return c;
    End fn_db_autobook_exclude_date_list;


    Procedure sp_db_autobook_exclude_date_details (
        p_person_id       Varchar2,
        p_meta_id         Varchar2,

        p_key_id          Out Varchar2,
        p_empno           Out Varchar2,
        p_attendance_date Out Date,
        p_modified_on     Out Date,
        p_modified_by     Out Varchar2,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_exists       Number;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
          Into v_exists
          From
            db_autobook_exclude_date
         Where
            key_id = p_key_id;

        If v_exists = 1 Then
            Select
                key_id,
                empno,
                attendance_date,
                modified_on,
                modified_by
              Into
                p_key_id,
                p_empno,
                p_attendance_date,
                p_modified_on,
                p_modified_by
              From
                db_autobook_exclude_date
             Where
                p_empno = v_empno;

            Commit;
            p_message_type := ok;
            p_message_text := 'Procedure executed successfully.';
        Else
            p_message_type := not_ok;
            p_message_text := 'No matching Autobook exclude exists !!!';
        End If;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_db_autobook_exclude_date_details;


    Function fn_db_autobook_exclude_date_xl_list (
        p_person_id       Varchar2,
        p_meta_id         Varchar2
    ) Return Sys_Refcursor As
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
        c       Sys_Refcursor;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For 
                Select
                      a.key_id          As key_id,
                      a.empno           As empno,
                      a.attendance_date As attendance_date,
                      a.modified_on     As modified_on,
                      a.modified_by     As modified_by
                    From
                      db_autobook_exclude_date a
                     order by a.attendance_date ;
        Return c;
    End fn_db_autobook_exclude_date_xl_list;

End pkg_db_autobook_exclude_date_qry;


/
