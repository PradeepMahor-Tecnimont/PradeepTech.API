Select
    *
From
    swp_primary_workspace;

Insert Into swp_primary_workspace (key_id, empno, primary_workspace, start_date, modified_on, modified_by, active_code)
Select
    dbms_random.string('X', 10), empno, 1, to_date('31-JAN-2022'), sysdate, 'Sys', 2
From
    ss_emplmast
Where
    status = 1
    And emptype In (
        Select
            emptype
        From
            swp_include_emptype
    )
    And assign Not In (
        Select
            assign
        From
            swp_exclude_assign
    )
    And empno Not In (
        Select
            empno
        From
            swp_primary_workspace
    );