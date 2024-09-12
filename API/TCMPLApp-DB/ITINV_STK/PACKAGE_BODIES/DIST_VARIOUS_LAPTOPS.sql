--------------------------------------------------------
--  DDL for Package Body DIST_VARIOUS_LAPTOPS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "ITINV_STK"."DIST_VARIOUS_LAPTOPS" As

    Procedure remove_laptop_assignment (
        param_empno           Varchar2,
        param_laptop_ams_id   Varchar2,
        param_success         Out                   Varchar2,
        param_message         Out                   Varchar2
    ) As
        v_count Number;
    Begin
        Delete From dist_laptop_already_issued
        Where
            empno = param_empno
            And laptop_ams_id = param_laptop_ams_id;
        
        If Sql%rowcount = 0 Then
            param_success   := 'KO';
            param_message   := 'Err - No record found for the selected criteria.';
            return;
        End If;
        
        
        Delete From dist_laptop_status
        Where
            ams_asset_id = param_laptop_ams_id;

        Delete From dist_emp_it_equip
        Where
            empno = param_empno and trim(laptop_ams_id) = trim(param_laptop_ams_id);

        Commit;
        param_success   := 'OK';
        param_message   := 'Record delete successfully.';
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := Sqlcode || ' - ' || Sqlerrm;
    End remove_laptop_assignment;

    Procedure add_laptop_assignment (
        param_empno           Varchar2,
        param_laptop_ams_id   Varchar2,
        param_is_permanent    Varchar2,
        param_success         Out                   Varchar2,
        param_message         Out                   Varchar2
    ) As
    Begin
        Insert Into dist_laptop_already_issued (
            empno,
            laptop_ams_id,
            permanent_issued
        ) Values (
            param_empno,
            param_laptop_ams_id,
            param_is_permanent
        );

        If Sql%rowcount > 0 Then
            Commit;
            param_success   := 'OK';
            param_message   := 'Record added successfully.';
        Else
            param_success   := 'KO';
            param_message   := 'Err - Record could not be added.';
        End If;

        return;
    Exception
        When Others Then
            param_success   := 'KO';
            param_message   := Sqlcode || ' - ' || Sqlerrm;
    End add_laptop_assignment;

End dist_various_laptops;

/
