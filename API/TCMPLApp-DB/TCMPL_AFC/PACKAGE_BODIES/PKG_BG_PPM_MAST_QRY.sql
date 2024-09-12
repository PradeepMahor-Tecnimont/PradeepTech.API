--------------------------------------------------------
--  DDL for Package Body PKG_BG_PPM_MAST_QRY
--------------------------------------------------------

Create Or Replace Package Body tcmpl_afc."PKG_BG_PPM_MAST_QRY" As

    Function fn_ppm_mast(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,

        p_ppm_id      Varchar2 Default Null,
        p_projno      Varchar2 Default Null,
        p_comp_id     Varchar2 Default Null,
        p_is_visible  Number   Default Null,
        p_is_deleted  Number   Default Null,

        p_row_number  Number,
        p_page_length Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                    Distinct
                        a.ppmid                                             As application_id,
                        a.empno                                             As empno,
                        a.empno || ' : ' || get_emp_name(a.empno)           As employee,
                        a.compid                                            As comp_id,
                        b.compdesc                                          As comp_desc,
                        a.projectno                                         As project_no,
                        (
                            Select
                            Distinct substr(projno, 1, 5) || ' : ' || name
                            From
                                vu_projmast
                            Where
                                a.projectno = substr(projno, 1, 5)
                                And Rownum  = 1
                        )                                                   As project,
                        a.isvisible                                         As is_visible,
                        a.isdeleted                                         As is_deleted,
                        a.modifiedby || ' : ' || get_emp_name(a.modifiedby) As modified_by,
                        to_char(a.modifiedon, 'DD-MON-yyyy')                As modified_on,
                        Row_Number() Over (Order By a.ppmid Desc)           row_number,
                        Count(*) Over ()                                    total_row
                    From
                        bg_ppm_mast                    a, bg_company_mast b
                    Where
                        a.compid        = b.compid
                        And a.ppmid     = nvl(p_ppm_id, a.ppmid)
                        And a.compid    = nvl(p_comp_id, a.compid)
                        And a.isvisible = nvl(p_is_visible, a.isvisible)
                        And a.isdeleted = nvl(p_is_deleted, a.isdeleted)

                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    End fn_ppm_mast;

    Procedure sp_ppm_mast_details(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_ppm_id           Varchar2,
        p_empno        Out Varchar2,
        p_employee     Out Varchar2,
        p_projno       Out Varchar2,
        p_project      Out Varchar2,
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
            a.projectno                                         As project_no,
            (
                Select
                Distinct substr(projno, 1, 5) || ' : ' || name
                From
                    vu_projmast
                Where
                    a.projectno = substr(projno, 1, 5)
                    And Rownum  = 1
            )                                                   As project,
            a.compid                                            As comp_id,
            b.compdesc                                          As comp_desc,
            a.isvisible                                         As is_visible,
            a.isdeleted                                         As is_deleted,
            a.modifiedby || ' : ' || get_emp_name(a.modifiedby) As modified_by,
            to_char(a.modifiedon, 'DD-MON-yyyy')                As modified_on

        Into
            p_empno,
            p_employee,
            p_projno,
            p_project,
            p_comp_id,
            p_comp_desc,
            p_is_visible,
            p_is_deleted,
            p_modified_by,
            p_modified_on
        From
            bg_ppm_mast                    a, bg_company_mast b
        Where
            a.compid  = b.compid
            And ppmid = p_ppm_id;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_ppm_mast_details;

End pkg_bg_ppm_mast_qry;
/
Grant Execute On "TCMPL_AFC"."PKG_BG_PPM_MAST_QRY" To "TCMPL_APP_CONFIG";