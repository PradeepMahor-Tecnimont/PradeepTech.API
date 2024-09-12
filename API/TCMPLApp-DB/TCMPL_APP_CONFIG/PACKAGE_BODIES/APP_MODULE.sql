--------------------------------------------------------
--  DDL for Package Body APP_MODULE
--------------------------------------------------------

Create Or Replace Package Body "TCMPL_APP_CONFIG"."APP_MODULE" As

    Procedure get_user_access(
        p_win_uid         Varchar2,
        p_modules_csv Out Varchar2,
        p_success     Out Varchar2,
        p_message     Out Varchar2
    ) As
        v_empno       Char(5);
        v_roles       Varchar2(1000);
        v_modules_csv Varchar2(1000);
        v_count       Number;
    Begin

        --Initialze

        --Initialize
        --************** 

        --
        v_empno       := app_users.get_empno_from_win_uid(p_win_uid);
        If v_empno Is Null Then
            Return;
        End If;
        --SELFSERVICE access
        Select
            Count(*)
        Into
            v_count
        From
            vu_emplmast
        Where
            empno      = v_empno
            And status = 1;
        If v_count > 0 Then
            p_modules_csv := 'SELFSERVICE,SWPVACCINE';
        End If;
        --
        --Get roles in SWP-Vaccine Module
        /*
        v_roles       := selfservice.swp_users.fnc_get_roles_for_user(param_win_uid => p_win_uid);
        If v_roles <> 'NONE' Then
            p_modules_csv := p_modules_csv || ',SWPVACCINE';
        End If;
        */
        --Get roles in OffBoarding
        v_roles       := tcmpl_hr.ofb_user.get_roles_csv_from_win_uid(p_win_uid => p_win_uid);
        If v_roles <> 'NONE' Then
            p_modules_csv := p_modules_csv || ',OFFBOARDING';
        End If;

        Select
            Listagg(module_name, ',') Within
                Group (Order By
                    module_name) modules_csv
        Into
            v_modules_csv
        From
            sec_modules
        Where
            module_id In (
                Select
                    module_id
                From
                    tcmpl_app_config.vu_module_user_role_actions
                Where
                    empno = v_empno
            );
        p_modules_csv := p_modules_csv || ',' || nvl(v_modules_csv, '');
        p_modules_csv := trim(Both ',' From p_modules_csv);
        p_success     := 'OK';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End get_user_access;

End app_module;
/