--------------------------------------------------------
--  DDL for Package Body LOGBOOK_REPORT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "LOGBOOK1"."LOGBOOK_REPORT" As

    Function fn_get_logbook_url Return Varchar2 Is
        v_oracle_db_server Varchar2(50);
    Begin
        Select sys_context('USERENV', 'SERVICE_NAME')
          Into v_oracle_db_server
          From dual;

        If commonmasters.pkg_environment.is_development = ok Then
            c_logbook_url := 'http://localhost:62783/Logbook';
        Elsif commonmasters.pkg_environment.is_staging = ok Then
            c_logbook_url := 'http://tplappsqual.ticb.comp/TCMPLApp/Logbook';
        Elsif commonmasters.pkg_environment.is_production = ok Then
            c_logbook_url := 'http://tplapps02.ticb.comp/TCMPLApp/Logbook';
        End If;

        Return c_logbook_url;

    End fn_get_logbook_url;

    Function fn_get_report_detail(
        p_person_id Varchar2,
        p_meta_id   Varchar2
    ) Return Sys_Refcursor Is
        p_rec   Sys_Refcursor;
        v_empno Varchar2(5);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);

        Open p_rec For
            Select lrh.key_id,
                   lrh.empno,
                   lrh.report_id,
                   lrl.report_name,
                   lrl.report_url,
                   lrh.parameter_json report_parameter
              From lb_report_hits lrh,
                   lb_report_list lrl
             Where lrl.report_id = lrh.report_id
               And lrh.empno = Trim(v_empno);

        Return p_rec;
    End fn_get_report_detail;

    Procedure sp_report_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_proj_no          Varchar2,
        p_costcode         Varchar2 Default Null,
        p_empno            Varchar2,
        p_report_id        Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno           Varchar2(5);
        v_module_name     Varchar2(50)  := 'LOGBOOK';
        v_mvc_action_name Varchar2(100) := 'LOGBOOKCOMMONINDEX';
        v_userid          Varchar2(50);
        v_filter_json     Varchar2(4000);
        v_parameter_json  Varchar2(4000);
    Begin
        v_empno       := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        sp_app_filter_delete(p_person_id,
                             p_meta_id,
                             v_module_name,
                             p_message_type,
                             p_message_text
        );
        Select userid
          Into v_userid
          From selfservice.userids
         Where empno = v_empno;
        v_filter_json := fn_gen_filter_json(p_proj_no, p_costcode, v_userid);

        If p_message_type = 'OK' Then
            sp_app_filter_add(p_person_id,
                              p_meta_id,
                              v_module_name,
                              v_mvc_action_name,
                              v_filter_json,
                              p_message_type,
                              p_message_text);
        End If;
        If p_message_type = 'OK' Then
            v_parameter_json := fn_gen_parameter_json(p_proj_no, p_costcode);
            Insert Into lb_report_hits (key_id, report_id, empno, parameter_json, created_on)
            Values(dbms_random.string('X', 8),
                p_report_id, v_empno, v_parameter_json, sysdate);
            Commit;
            p_message_type   := 'OK';
            p_message_text   := 'Procedure executed successfully.';
        End If;
    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_report_add;

    Procedure sp_report_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_key_id           Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As

        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Delete
          From lb_report_hits
         Where key_id = Trim(p_key_id);
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_report_delete;

    Procedure sp_app_filter_add(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_module_name      Varchar2,
        p_mvc_action_name  Varchar2,
        p_parameter_json   Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Insert Into tcmpl_app_config.app_filter (meta_id,
            module_name,
            mvc_action_name,
            filter_json,
            person_id,
            modified_on)
        Values(p_meta_id, p_module_name, p_mvc_action_name, p_parameter_json, p_person_id, sysdate);
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_app_filter_delete(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_module_name      Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
    Begin
        Delete
          From tcmpl_app_config.app_filter
         Where meta_id = p_meta_id
           And module_name = p_module_name;
        Commit;
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Function fn_gen_filter_json(
        p_proj_no  Varchar2,
        p_costcode Varchar2,
        p_userid   Varchar2
    ) Return Varchar2 As
        v_filter_json Varchar2(4000);
    Begin
        apex_json.initialize_clob_output;
        apex_json.open_object;
        apex_json.write('Projno', p_proj_no);
        apex_json.write('Costcode', p_costcode);
        apex_json.write('User', p_userid);
        apex_json.close_object;
        v_filter_json := apex_json.get_clob_output;
        apex_json.free_output;
        Return v_filter_json;

    End;

    Function fn_gen_parameter_json(
        p_proj_no  Varchar2,
        p_costcode Varchar2
    ) Return Varchar2 As
        v_parameter_json Varchar2(4000);
    Begin
        apex_json.initialize_clob_output;
        apex_json.open_object;
        apex_json.write('Projno', p_proj_no);
        apex_json.write('Costcode', p_costcode);
        apex_json.close_object;
        v_parameter_json := apex_json.get_clob_output;
        apex_json.free_output;
        Return v_parameter_json;

    End;
End logbook_report;

/
