create or replace package body tcmpl_afc.pkg_bg_project_mast_qry as

  function fn_project_mast_list(
        p_person_id          varchar2,
        p_meta_id            varchar2,
        p_generic_search     Varchar2 default null,
        p_row_number         Number,
        p_page_length        Number        
    ) return sys_refcursor as
        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        v_count              Number;
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        Open c For
            Select
                *
            From
                (
                    Select
                        projnum,
                        name,
                        mngrname,
                        mngremail,
                        isclosed,                        
                        modifiedby,
                        modifiedon,
                        Row_Number() Over (Order By projnum Desc)                    row_number,
                        Count(*) Over ()                                             total_row
                    From
                        bg_project_mast
                    Where
                        (upper(projnum) Like upper('%' || Trim(p_generic_search) || '%') Or
                         upper(name) Like upper('%' || Trim(p_generic_search) || '%'))                         
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                projnum Desc;
            Return c;        
  end fn_project_mast_list;

  procedure sp_project_mast_details(
        p_person_id        varchar2,
        p_meta_id          varchar2,        
        p_projnum          varchar2 default null,
        p_name          out varchar2,
        p_mngrname      out varchar2,
        p_mngremail     out varchar2,
        p_isclosed      out number,
        p_modifiedby    out varchar2,
        p_modifiedon    out varchar2,
        p_message_type  out varchar2,
        p_message_text  out varchar2
    ) as
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
            name,           
            mngrname,
            mngremail,
            isclosed,
            modifiedby,
            modifiedon
        Into
            p_name,
            p_mngrname,
            p_mngremail,
            p_isclosed,
            p_modifiedby,
            p_modifiedon
        From
            bg_project_mast
        Where
            projnum = p_projnum;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
  end sp_project_mast_details;

end pkg_bg_project_mast_qry;