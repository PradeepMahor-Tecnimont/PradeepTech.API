--------------------------------------------------------
--  DDL for Package Body IOT_JOBS_UPDATE_PM_JS_BULK
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."IOT_JOBS_UPDATE_PM_JS_BULK" As

    Function fnc_json_create Return Varchar2 Is
        v_json_string Varchar2(4000);
    Begin
        With
            prep (role_name, empno_from, empno_to, remarks, fragment) As (
                Select
                    role_name,
                    empno_from,
                    empno_to,
                    remarks,
                    Json_Object(
                        Key 'roleName' Value role_name,
                        Key 'empnoFrom' Value empno_from,
                        Key 'empnoTo' Value empno_to,
                        Key 'remarks' Value remarks,
                        Key 'projno'
                        Value nullif(Json_Arrayagg(projno Order By
                                    projno), '[]')
                        Format Json Absent On Null
                    )
                From
                    job_update_pm_js
                Group By
                    role_name, empno_from, empno_to, remarks
            )
        Select
            Json_Objectagg(Key 'data'
                Value Json_Arrayagg(fragment Order By
                        role_name,
                        empno_from,
                        empno_to,
                        remarks)
            ) As json_str
        Into
            v_json_string
        From
            prep
        Group By
            role_name, empno_from, empno_to, remarks;
        Return v_json_string;
    End;

    Procedure prc_insert_update_pm_js_bulk_log(
        p_person_id        Varchar2,
        p_meta_id          Varchar2,

        p_projno           Varchar2,
        p_role_name        Varchar2,
        p_empno_from       Varchar2,
        p_empno_to         Varchar2,
        p_remarks          Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno Varchar2(5);
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Insert Into job_update_pm_js_bulk_log
        (
            projno,
            role_name,
            empno_from,
            empno_to,
            remarks,
            modified_by,
            modified_on)
        Values
        (
            p_projno,
            p_role_name,
            p_empno_from,
            p_empno_to,
            p_remarks,
            v_empno,
            sysdate
        );

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
    End;

    Procedure sp_update_pm_js(
        p_person_id              Varchar2,
        p_meta_id                Varchar2,

        p_projno_pm_js_role_json Blob Default Null,

        p_message_type Out       Varchar2,
        p_message_text Out       Varchar2
    ) As
        rec_jobmaster     jobmaster%rowtype;
        v_role_name       Varchar2(2);
        v_fnc_json_create Varchar2(4000);

        Cursor cur_json Is
            Select
                jt.*
            From
                --Json_Table(p_projno_pm_js_role_json Format Json, '$[*]'
                Json_Table(v_fnc_json_create Format Json, '$.data[*]'
                    Columns (
                        role_name  Varchar2(2)   Path '$.roleName',
                        empno_from Varchar2(5)   Path '$.empnoFrom',
                        empno_to   Varchar2(5)   Path '$.empnoTo',
                        remarks    Varchar2(200) Path '$.remarks',
                        Nested Path '$.projno[*]'
                        Columns (
                            projno Varchar2 (5) Path '$[*]'
                        )
                    )
                )
                As "JT";
    Begin
        v_fnc_json_create := fnc_json_create;
        For c1 In cur_json
        Loop
            If c1.role_name = 'PM' Then
                v_role_name := 'JS';

                Select
                    *
                Into
                    rec_jobmaster
                From
                    jobmaster
                Where
                    pm_empno   = Trim(c1.empno_from)
                    And projno = Trim(c1.projno);
            Elsif c1.role_name = 'JS' Then
                v_role_name := 'PM';

                Select
                    *
                Into
                    rec_jobmaster
                From
                    jobmaster
                Where
                    dirvp_empno = Trim(c1.empno_from)
                    And projno  = Trim(c1.projno);
            Else
                p_message_type := not_ok;
                p_message_text := 'Role should be PM or JS';
                Return;
            End If;

            iot_jobs.sp_update_pm_js(
                p_person_id    => p_person_id,
                p_meta_id      => p_meta_id,

                p_projno       => c1.projno,
                p_role_name    => v_role_name,
                p_pm_empno     => c1.empno_to,
                p_js_empno     => c1.empno_to,

                p_message_type => p_message_type,
                p_message_text => p_message_text
            );

            If p_message_type = ok Then
                prc_insert_update_pm_js_bulk_log(
                    p_person_id    => p_person_id,
                    p_meta_id      => p_meta_id,

                    p_projno       => c1.projno,
                    p_role_name    => c1.role_name,
                    p_empno_from   => c1.empno_from,
                    p_empno_to     => c1.empno_to,
                    p_remarks      => c1.remarks,

                    p_message_type => p_message_type,
                    p_message_text => p_message_text
                );
            Else
                p_message_text := 'Error while updating ' || c1.projno || ' . Refresh the page and try again';
                Return;
            End If;

        End Loop;

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := sqlcode || ' - ' || sqlerrm;
    End;

End iot_jobs_update_pm_js_bulk;