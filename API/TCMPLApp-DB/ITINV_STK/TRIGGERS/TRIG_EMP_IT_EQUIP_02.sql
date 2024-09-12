--------------------------------------------------------
--  DDL for Trigger TRIG_EMP_IT_EQUIP_02
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_EMP_IT_EQUIP_02" Before
    Insert Or Update On dist_emp_it_equip
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    :new.modified_on := Sysdate;
End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_EMP_IT_EQUIP_02" ENABLE;
