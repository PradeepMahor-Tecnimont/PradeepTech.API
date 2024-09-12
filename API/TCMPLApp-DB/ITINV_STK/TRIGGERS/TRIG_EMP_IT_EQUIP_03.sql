--------------------------------------------------------
--  DDL for Trigger TRIG_EMP_IT_EQUIP_03
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_EMP_IT_EQUIP_03" Before
    Delete On dist_emp_it_equip
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    Insert Into dist_emp_it_equip_del_log (
        empno,
        headset,
        docking_stn,
        laptop_charger,
        travel_bag,
        display_converter,
        projector_converter,
        is_issued,
        document_no,
        laptop_ams_id,
        modified_on,
        del_on
    ) Values (
        :old.empno,
        :old.headset,
        :old.docking_stn,
        :old.laptop_charger,
        :old.travel_bag,
        :old.display_converter,
        :old.projector_converter,
        :old.is_issued,
        :old.document_no,
        :old.laptop_ams_id,
        :old.modified_on,
        Sysdate
    );

End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_EMP_IT_EQUIP_03" ENABLE;
