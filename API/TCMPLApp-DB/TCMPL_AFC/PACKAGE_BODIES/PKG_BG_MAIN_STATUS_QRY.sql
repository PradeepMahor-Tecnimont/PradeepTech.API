create or replace Package Body tcmpl_afc.pkg_bg_main_status_qry As

    Function fn_bg_status_select_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                status_type_id   data_value_field,
                status_type_desc data_text_field
            From
                bg_main_status_master
            Where
                to_list = 1
            Order By
                order_by,
                status_type_id;

        Return c;
    End fn_bg_status_select_list;

    Procedure sp_bg_status_detail(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_refnum               Varchar2,
        p_amendmentnum         Varchar2 Default Null,
        p_status_type_id_in    Varchar2 Default Null,
        p_status_type_id   Out Varchar2,
        p_status_type_desc Out Varchar2,
        p_modified_by      Out Varchar2,
        p_modified_date    Out Date,
        p_message_type     Out Varchar2,
        p_message_text     Out Varchar2
    ) Is
        v_amendmentnum bg_main_status.amendmentnum%Type;
    Begin
        If p_amendmentnum Is Null Then
            Select
                lpad(Max(To_Number(amendmentnum)), 3, '0')
            Into
                v_amendmentnum
            From
                bg_main_status
            Where
                refnum = Trim(p_refnum);
        Else
            v_amendmentnum := p_amendmentnum;
        End If;

        If p_status_type_id_in Is Null Then
            Select
                ms.status_type_id,
                msm.status_type_desc,
                ms.modified_by,
                ms.modified_date
            Into
                p_status_type_id,
                p_status_type_desc,
                p_modified_by,
                p_modified_date
            From
                (
                    Select
                        status_type_id,
                        modified_by,
                        modified_date
                    From
                        bg_main_status
                    Where
                        refnum           = Trim(p_refnum)
                        And amendmentnum = v_amendmentnum
                    Order By modified_date Desc
                )                           ms, bg_main_status_master msm
            Where
                ms.status_type_id = msm.status_type_id
                And Rownum        = 1;
        Else
            Select
                ms.status_type_id,
                msm.status_type_desc,
                ms.modified_by,
                ms.modified_date
            Into
                p_status_type_id,
                p_status_type_desc,
                p_modified_by,
                p_modified_date
            From
                bg_main_status                           ms, bg_main_status_master msm
            Where
                ms.status_type_id     = msm.status_type_id
                And ms.refnum         = Trim(p_refnum)
                And ms.amendmentnum   = v_amendmentnum
                And ms.status_type_id = p_status_type_id_in;
        End If;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_bg_status_detail;

    Function sp_bg_get_current_status(
        p_refnum       Varchar2,
        p_amendmentnum Varchar2
    ) Return Varchar2 As
        v_status_type_id bg_main_status.status_type_id%Type;
    Begin
        Select
            ms.status_type_id
        Into
            v_status_type_id
        From
            (
                Select
                    status_type_id
                From
                    bg_main_status
                Where
                    refnum           = Trim(p_refnum)
                    And amendmentnum = Trim(p_amendmentnum)
                Order By modified_date Desc
            ) ms
        Where
            Rownum = 1;

        Return v_status_type_id;
    End;

    Function sp_bg_get_current_status_desc(
        p_refnum       Varchar2,
        p_amendmentnum Varchar2 Default Null
    ) Return Varchar2 As
        v_status_type_desc bg_main_status_master.status_type_desc%Type;
        v_amendmentnum     bg_main_status.amendmentnum%Type;
    Begin
        If p_amendmentnum Is Null Then
            Select
                lpad(Max(To_Number(amendmentnum)), 3, '0')
            Into
                v_amendmentnum
            From
                bg_main_status
            Where
                refnum = Trim(p_refnum);
        Else
            v_amendmentnum := p_amendmentnum;
        End If;

        Select
            msm.status_type_desc
        Into
            v_status_type_desc
        From
            (
                Select
                    status_type_id
                From
                    bg_main_status
                Where
                    refnum           = Trim(p_refnum)
                    And amendmentnum = Trim(v_amendmentnum)
                Order By modified_date Desc
            )                           ms, bg_main_status_master msm
        Where
            ms.status_type_id = msm.status_type_id
            And Rownum        = 1;

        Return v_status_type_desc;
    End;

End pkg_bg_main_status_qry;