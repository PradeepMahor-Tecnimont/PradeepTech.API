--------------------------------------------------------
--  DDL for Package Body PKG_DB_EMP_PROJ_MAP_QRY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "DESK_BOOK"."PKG_DB_EMP_PROJ_MAP_QRY" As

    Function fn_emp_proj_map_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_projno         Varchar2 Default Null,
        p_assign_code    Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor Is
        c                     Sys_Refcursor;
        v_count               Number;
        v_empno               Varchar2(5);
        v_hod_sec_assign_code Varchar2(4);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        If v_empno Is Null Or p_assign_code Is Not Null Then
            v_hod_sec_assign_code := selfservice.iot_swp_common.get_default_costcode_hod_sec(
                                                                           p_hod_sec_empno => v_empno,
                                                                           p_assign_code => p_assign_code
                                     );
        End If;
        Open c For With proj As (
                                Select Distinct
                                    proj_no,
                                    name
                                  From
                                    vu_projmast
                                 Where
                                    active = 1
                            )
                            Select
                                *
                              From
                                (
                                    Select
                                        empprojmap.key_id As keyid,
                                        empprojmap.empno  As empno,
                                        a.name            As empname,
                                        empprojmap.projno As projno,
                                        b.name            As projname,
                                        Row_Number()
                                        Over(
                                             Order By
                                                empprojmap.key_id Desc
                                        )                 row_number,
                                        Count(*)
                                        Over()            total_row
                                      From
                                        db_emp_proj_mapping empprojmap,
                                        vu_emplmast         a,
                                        proj                b
                                     Where
                                            a.empno           = empprojmap.empno And
                                        b.proj_no         = empprojmap.projno And
                                        empprojmap.projno = nvl(
                                            p_projno,
                                            empprojmap.projno
                                        ) And
                                        ( upper(
                                            a.name
                                        ) Like upper('%' || p_generic_search || '%') Or
                                          upper(
                                              a.empno
                                          ) Like upper('%' || p_generic_search || '%') ) And
                                        empprojmap.empno In (
                                            Select Distinct
                                                empno
                                              From
                                                vu_emplmast
                                             Where
                                                    status   = 1 And
                                                a.assign = nvl(
                                                    v_hod_sec_assign_code,
                                                    a.assign
                                                )
                          /*
                          And assign In (
                                  Select parent
                                    From ss_user_dept_rights
                                   Where empno = v_empno
                                  Union
                                  Select costcode
                                    From ss_costmast
                                   Where hod = v_empno
                               )
                          */
                                        )
                                )
                   Where
                      row_number Between ( nvl(
                          p_row_number,
                          0
                      ) + 1 ) And ( nvl(
                          p_row_number,
                          0
                      ) + p_page_length )
                   Order By
                      empno,
                      projno;
        Return c;
    End fn_emp_proj_map_list;

    Procedure sp_db_emp_emp_proj_details (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_application_id Varchar2,
        p_empno          Out Varchar2,
        p_emp_name       Out Varchar2,
        p_projno         Out Varchar2,
        p_proj_name      Out Varchar2,
        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        With proj As (
            Select Distinct
                proj_no,
                name
              From
                vu_projmast
             Where
                active = 1
        )
        Select
            empprojmap.empno  As empno,
            a.name            As empname,
            empprojmap.projno As projno,
            b.name            As projname
          Into
            p_empno,
            p_emp_name,
            p_projno,
            p_proj_name
          From
            db_emp_proj_mapping empprojmap,
            vu_emplmast         a,
            proj                b
         Where
                empprojmap.key_id = p_application_id And
            a.empno           = empprojmap.empno And
            b.proj_no         = empprojmap.projno;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- '
                              || sqlcode
                              || ' - '
                              || sqlerrm;
    End sp_db_emp_emp_proj_details;

End pkg_db_emp_proj_map_qry;

/

  GRANT EXECUTE ON "DESK_BOOK"."PKG_DB_EMP_PROJ_MAP_QRY" TO "TCMPL_APP_CONFIG";
