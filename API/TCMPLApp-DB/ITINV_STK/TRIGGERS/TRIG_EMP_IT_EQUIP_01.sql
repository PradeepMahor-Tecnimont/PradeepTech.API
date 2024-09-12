--------------------------------------------------------
--  DDL for Trigger TRIG_EMP_IT_EQUIP_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_EMP_IT_EQUIP_01" Before
    Insert On dist_emp_it_equip
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    Update dist_laptop_request
    Set
        is_requested = 'OK'
    Where
        empno = :new.empno;

    If Sql%rowcount = 0 Then
        Insert Into dist_laptop_request (
            empno,
            sw_required,
            is_requested
        ) Values (
            :new.empno,
            'Standard',
            'OK'
        );

    End If;

End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_EMP_IT_EQUIP_01" ENABLE;
