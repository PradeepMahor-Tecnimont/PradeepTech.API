--------------------------------------------------------
--  DDL for Package Body PKG_LOGBOOK_QRY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "LOGBOOK1"."PKG_LOGBOOK_QRY" As

    Function fn_logbook_excel(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_projno   Varchar2
    ) Return Sys_Refcursor As
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For

            Select rework_no,
                   type,
                   doc_code,
                   dept_no,
                   area,
                   corr_mode,
                   r_date,
                   reason,
                   corr_ref_no,
                   approval_date,
                   a,
                   b,
                   c,
                   d,
                   sal,
                   remarks
              From rscl_rwk_add
             Where projno = p_projno
             Order By rework_no;

        Return c;
    End;
End pkg_logbook_qry;

/
