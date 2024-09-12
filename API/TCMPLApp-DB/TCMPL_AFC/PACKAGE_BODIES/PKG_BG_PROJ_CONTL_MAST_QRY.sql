--------------------------------------------------------
--  DDL for Package Body PKG_BG_PROJ_CONTL_MAST_QRY
--------------------------------------------------------

Create Or Replace Package Body tcmpl_afc."PKG_BG_PROJ_CONTL_MAST_QRY" As

    Function fn_proj_contl_mast(
        p_person_id     Varchar2,
        p_meta_id       Varchar2,

        p_proj_contl_id Varchar2 Default Null,
        p_comp_id       Varchar2 Default Null,
        p_is_visible    Number   Default Null,
        p_is_deleted    Number   Default Null,

        p_row_number    Number,
        p_page_length   Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        a.projcontlid                                       As application_id,
                        a.empno                                             As empno,
                        a.empno || ' : ' || get_emp_name(a.empno)           As employee,
                        a.compid                                            As comp_id,
                        b.compdesc                                          As comp_desc,
                        a.isvisible                                         As is_visible,
                        a.isdeleted                                         As is_deleted,
                        a.modifiedby || ' : ' || get_emp_name(a.modifiedby) As modified_by,
                        to_char(a.modifiedon, 'DD-MON-yyyy')                As modified_on,
                        Row_Number() Over (Order By a.projcontlid Desc)     row_number,
                        Count(*) Over ()                                    total_row
                    From
                        bg_proj_contl_mast                    a, bg_company_mast b
                    Where
                        a.compid          = b.compid
                        And a.projcontlid = nvl(p_proj_contl_id, a.projcontlid)
                        And a.compid      = nvl(p_comp_id, a.compid)
                        And a.isvisible   = nvl(p_is_visible, a.isvisible)
                        And a.isdeleted   = nvl(p_is_deleted, a.isdeleted)

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_proj_contl_mast;

    Procedure sp_proj_contl_mast_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_proj_contl_id    Varchar2,
        p_empno        Out Varchar2,
        p_employee     Out Varchar2,
        p_comp_id      Out Varchar2,
        p_comp_desc    Out Varchar2,
        p_is_visible   Out Number,
        p_is_deleted   Out Number,
        p_modified_by  Out Varchar2,
        p_modified_on  Out Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            a.empno                                             As empno,
            a.empno || ' : ' || get_emp_name(a.empno)           As employee,
            a.compid                                            As comp_id,
            b.compdesc                                          As comp_desc,
            a.isvisible                                         As is_visible,
            a.isdeleted                                         As is_deleted,
            a.modifiedby || ' : ' || get_emp_name(a.modifiedby) As modified_by,
            to_char(a.modifiedon, 'DD-MON-yyyy')                As modified_on

        Into
            p_empno,
            p_employee,
            p_comp_id,
            p_comp_desc,
            p_is_visible,
            p_is_deleted,
            p_modified_by,
            p_modified_on
        From
            bg_proj_contl_mast                    a, bg_company_mast b
        Where
            a.compid        = b.compid
            And projcontlid = p_proj_contl_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_proj_contl_mast_details;

End pkg_bg_proj_contl_mast_qry;
/
Grant Execute On "TCMPL_AFC"."PKG_BG_PROJ_CONTL_MAST_QRY" To "TCMPL_APP_CONFIG";