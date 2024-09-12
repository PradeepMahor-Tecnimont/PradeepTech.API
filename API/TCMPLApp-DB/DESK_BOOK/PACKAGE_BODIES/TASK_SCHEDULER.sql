Create Or Replace Package Body desk_book.task_scheduler As
    c_module_id Constant Varchar2(3) := 'M20';
    c_role_id Constant Varchar2(4) := 'R112';
    Procedure sp_daily_generate_desk_dates_lock As
    Begin
        pkg_deskbooking.sp_generate_desk_dates_lock;
    End sp_daily_generate_desk_dates_lock;

    Procedure sp_daily_cabin_booking_emp_role_update
    As
    Begin
        Delete
            From tcmpl_app_config.sec_module_users_roles_actions
        Where
            module_id = c_module_id
            And role_id = c_role_id;

        Insert Into tcmpl_app_config.sec_module_users_roles_actions
        (
            module_id,
            empno,
            role_id,
            action_id,
            modified_on)
        Select
            a.module_id,
            c.empno,
            a.role_id,
            a.action_id,
            sysdate
        From
            db_cabin_users c
            Cross Join (
                Select
                    module_id, role_id, action_id
                From
                    tcmpl_app_config.sec_module_role_actions
                Where
                    module_id = c_module_id
                    And role_id = c_role_id
            )              a;
    End;
End task_scheduler;
/