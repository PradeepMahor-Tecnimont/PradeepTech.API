--------------------------------------------------------
--  DDL for Package Body APP_USERS
--------------------------------------------------------

Create Or Replace Package Body tcmpl_app_config.app_users As

    ok     Constant Varchar2(2) := 'OK';
    not_ok Constant Varchar2(2) := 'KO';

    Procedure get_user_modules_csv(
        p_empno           Varchar2,
        p_win_uid         Varchar2,
        p_modules_csv Out Varchar2,
        p_success     Out Varchar2,
        p_message     Out Varchar2
    ) As
        v_roles       Varchar2(1000);
        v_modules_csv Varchar2(1000);
        v_count       Number;
    Begin
        
        --SELFSERVICE access
        Select
            Count(*)
        Into
            v_count
        From
            vu_emplmast
        Where
            empno      = p_empno
            And status = 1;
        If v_count > 0 Then
            p_modules_csv := 'SELFSERVICE';
        End If;
        --
        --Get roles in SWP-Vaccine Module
        v_roles       := selfservice.swp_users.fnc_get_roles_for_user(param_win_uid => p_win_uid);
        If v_roles <> 'NONE' Then
            p_modules_csv := p_modules_csv || ',SWPVACCINE';
        End If;
        /*
                --Get roles in OffBoarding
                v_roles       := tcmpl_hr.ofb_user.get_roles_csv_from_win_uid(p_win_uid => p_win_uid);
                If v_roles <> 'NONE' Then
                    p_modules_csv := p_modules_csv || ',OFFBOARDING';
                End If;
        */
        Select
            Listagg(module_name,
                ',') Within
                Group (
                Order By
                    module_name
                ) modules_csv
        Into
            v_modules_csv
        From
            sec_modules
        Where
            module_id In (
                Select
                    module_id
                From
                    vu_module_user_role_actions
                Where
                    empno = p_empno
            );
        p_modules_csv := p_modules_csv || ',' || nvl(v_modules_csv, '');
        p_modules_csv := trim(Both ',' From p_modules_csv);
        If p_modules_csv Is Null Then
            p_success := not_ok;
        End If;
        p_success     := ok;
    Exception
        When Others Then
            p_modules_csv := Null;
            p_success     := not_ok;
            p_message     := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End get_user_modules_csv;

    Procedure update_win_uid_for_empno(
        p_empno         Varchar2,
        p_win_uid       Varchar2,
        p_employee_name Varchar2
    ) As
        v_user_domain Varchar2(60);
        v_user_id     Varchar2(60);
        v_empno       Varchar2(5);
    Begin
        v_user_domain := substr(p_win_uid, 1, instr(p_win_uid, '\') - 1);

        v_user_id     := substr(p_win_uid, instr(p_win_uid, '\') + 1);
        Delete
            From selfservice.userids
        Where
            empno = p_empno;
        Delete
            From selfservice.userids
        Where
            userid     = upper(v_user_id)
            And domain = upper(v_user_domain);

        Insert Into selfservice.userids (
            empno,
            name,
            domain,
            userid
        )
        Values (
            p_empno,
            p_employee_name,
            v_user_domain,
            v_user_id
        );
    End;

    Function get_empno_from_meta_id(
        p_meta_id In Varchar2
    ) Return Varchar2 As
        v_empno     Varchar2(5);
        v_meta_id   Varchar2(50);
        v_host_name Varchar2(100);
        c_dev_env   Constant Varchar2(100) := 'tpldevoradb';
    Begin
        v_meta_id := p_meta_id;
        Select
            empno
        Into
            v_empno
        From
            vu_emplmast
        Where
            Trim(metaid) = Trim(p_meta_id)
            And status   = 1
            And doj      = (
                     Select
                         Max(doj)
                     From
                         vu_emplmast
                     Where
                         status     = 1
                         And metaid = p_meta_id
                 );

        If Trim(v_empno) Is Null Then
            Return 'ERRRR';
        End If;
        Return v_empno;
    Exception
        When Others Then
            Return 'ERRRR';
    End get_empno_from_meta_id;

    Function get_empno_from_win_uid(
        p_win_uid Varchar2
    ) Return Varchar2 As
        v_user_domain Varchar2(60);
        v_user_id     Varchar2(60);
        v_empno       Varchar2(5);
    Begin
        v_user_domain := substr(p_win_uid, 1, instr(p_win_uid, '\') - 1);

        v_user_id     := substr(p_win_uid, instr(p_win_uid, '\') + 1);
        Select
            a.empno
        Into
            v_empno
        From
            vu_userids  a,
            vu_emplmast b
        Where
            a.empno             = b.empno
            And upper(a.userid) = upper(v_user_id)
            And upper(a.domain) = upper(v_user_domain)
            And b.status        = 1;

        If v_empno = '02320' Then
            Null;
            --v_empno := '02242'; -- Nitin Narvekar
            --v_empno := '02640'; -- Mayekar Abhijit
            --v_empno := '02848'; -- Nilesh Sawant
            --v_empno := '01938'; -- Sanjay Mistry
            --v_empno := '02079'; -- Kotian
            --v_empno := '04057'; --Kadam Sunil
            --v_empno := '00583'; -- MAKUR GAUTAM	
            --v_empno := '10072'; -- Vinay Joshi
            --v_empno := '02459'; --Annie Fernandes
            --v_empno := '01994'; --Sharvari Vaidya
            --v_empno := '01505'; --HoD 0240
            --v_empno := '00583';
            --v_empno := '04430';
        End If;
        Return v_empno;
    Exception
        When Others Then
            Return Null;
    End;

    Procedure get_emp_details_from_win_uid(
        p_win_uid       Varchar2,
        p_empno     Out Varchar2,
        p_emp_name  Out Varchar2,
        p_costcode  Out Varchar2,
        p_meta_id   Out Varchar2,
        p_person_id Out Varchar2,
        p_success   Out Varchar2,
        p_message   Out Varchar2
    ) As
        v_empno     Char(5);
        v_meta_id   Varchar2(20);
        v_person_id Varchar2(8);
        v_count     Number;
    Begin
        v_empno   := get_empno_from_win_uid(p_win_uid);
        Select
            empno,
            name,
            parent,
            metaid,
            personid
        Into
            p_empno,
            p_emp_name,
            p_costcode,
            v_meta_id,
            v_person_id
        From
            vu_emplmast
        Where
            empno = v_empno;

        Select
            Count(*)
        Into
            v_count
        From
            app_metaid_exceptions
        Where
            empno = v_empno;

        If p_win_uid Like 'TECNIMONT%' Or v_count > 0 Then
            p_meta_id   := v_meta_id;
            p_person_id := v_person_id;
        End If;

        p_success := 'OK';
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function get_emp_roles_actions(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_module_name Varchar2
    ) Return Sys_Refcursor As
        v_by_empno  Varchar2(5);
        c           Sys_Refcursor;
        --c_ofb       Constant Varchar2(30) := 'OFFBOARDING';
        c_ofb       Constant Varchar2(30) := 'X!X!X!';
        v_module_id sec_modules.module_id%Type;
    Begin
        v_by_empno := get_empno_from_meta_id(p_meta_id);
        If v_by_empno = 'ERRRR' Then
            raise_application_error(-20001, 'Incorrect metaid');
            Return Null;
        End If;

        Select
            module_id
        Into
            v_module_id
        From
            sec_modules
        Where
            Trim(module_name) = upper(Trim(p_module_name));

        If p_module_name = c_ofb Then
            If commonmasters.pkg_environment.is_development = ok Or commonmasters.pkg_environment.is_staging = ok Then
                Open c For
                    Select
                        role_id,
                        action_id
                    From
                        tcmpl_hr.ofb_vu_user_roles_actions
                    Where
                        empno = v_by_empno
                    Union
                    Select
                        role_id,
                        action_id
                    From
                        vu_module_user_role_actions
                    Where
                        empno         = v_by_empno
                        And module_id = v_module_id;

            Else
                Open c For
                    Select
                        role_id,
                        action_id
                    From
                        tcmpl_hr.ofb_vu_user_roles_actions
                    Where
                        empno = v_by_empno;
            End If;
        Else
            Open c For
                Select
                    role_id,
                    action_id
                From
                    vu_module_user_role_actions
                Where
                    empno         = v_by_empno
                    And module_id = v_module_id;
        End If;

        Return c;
    End;

    Procedure get_emp_details_from_metaid(
        p_meta_id             Varchar2,
        p_person_id           Varchar2,
        p_win_uid             Varchar2,
        p_module_name         Varchar2 Default Null,
        p_tcm_meta_id     Out Varchar2,
        p_tcm_person_id   Out Varchar2,
        p_empno           Out Varchar2,
        p_employee_name   Out Varchar2,
        p_costcode        Out Varchar2,
        p_modules_csv     Out Varchar2,
        p_profile_actions Out Sys_Refcursor,
        p_message_type    Out Varchar2,
        p_message_text    Out Varchar2
    ) As
        v_empno Varchar2(5);
        v_count Number;
    Begin
        --TECNIMONT user logic starts here
        If lower(p_win_uid) Like 'tecnimont%' Then
            --
            --
            v_empno := get_empno_from_win_uid(p_win_uid);
            --
            --
            If v_empno Is Null Then
                p_message_type := 'KO';
                p_message_text := 'Err - Tecnimont user mapping with TCMPLApp.Empno not found';
            Else
                p_empno        := v_empno;
                Select
                    name,
                    parent,
                    metaid,
                    personid
                Into
                    p_employee_name,
                    p_costcode,
                    p_tcm_meta_id,
                    p_tcm_person_id
                From
                    vu_emplmast
                Where
                    empno      = p_empno
                    And status = 1;

                p_message_type := 'OK';
                p_message_text := 'Procedure executed successfully.';
            End If;
            --Return;
        End If;
        --TECNIMONT user logic ends here
        --
        --
        --
        --TCMPL user logic starts here
        If nvl(p_meta_id, p_tcm_meta_id) Is Null Then
            p_message_type := 'KO';
            p_message_text := 'Err - MetaId cannot be blank';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            vu_emplmast
        Where
            metaid = nvl(p_meta_id, p_tcm_meta_id);
        If v_count = 0 Then
            p_message_type := 'KO';
            p_message_text := 'Err - MetaId not found in Employee database';
            Return;
        End If;

        Select
            empno,
            name,
            parent
        Into
            p_empno,
            p_employee_name,
            p_costcode
        From
            vu_emplmast
        Where
            status     = 1
            And metaid = nvl(p_meta_id, p_tcm_meta_id)
            And doj    = (
                   Select
                       Max(doj)
                   From
                       vu_emplmast
                   Where
                       status     = 1
                       And metaid = nvl(p_meta_id, p_tcm_meta_id)
               );
        v_empno           := get_empno_from_win_uid(p_win_uid);
        If nvl(v_empno, '-') <> p_empno Then
            update_win_uid_for_empno(
                p_empno,
                p_win_uid,
                p_employee_name
            );
            v_empno := get_empno_from_win_uid(p_win_uid);
        End If;

        If commonmasters.pkg_environment.is_development = ok or commonmasters.pkg_environment.is_staging = ok Then
            Select
                Count(*)
            Into
                v_count
            From
                app_user_master
            Where
                empno      = p_empno
                And status = 1;

            If v_count = 0 Then
                p_message_type := not_ok;
                p_message_text := 'Err - Empno not found in Master table';
                Return;
            End If;
        End If;
        get_user_modules_csv(
            p_empno       => v_empno,
            p_win_uid     => p_win_uid,
            p_modules_csv => p_modules_csv,
            p_success     => p_message_type,
            p_message     => p_message_text
        );
        If p_message_type = not_ok Then
            Return;
        End If;
        p_profile_actions := get_emp_roles_actions(
                                 p_person_id   => Null,
                                 p_meta_id     => nvl(p_meta_id, p_tcm_meta_id),
                                 p_module_name => p_module_name
                             );

        p_message_type    := ok;
        p_message_text    := 'Procedure executed successfully.';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End;

End app_users;
/