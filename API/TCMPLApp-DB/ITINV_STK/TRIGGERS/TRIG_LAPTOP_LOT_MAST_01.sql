--------------------------------------------------------
--  DDL for Trigger TRIG_LAPTOP_LOT_MAST_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ITINV_STK"."TRIG_LAPTOP_LOT_MAST_01" Before
    Insert Or Update On dist_laptop_lot_mast
    Referencing
            Old As old
            New As new
    For Each Row
Begin
    If inserting Then
        If :new.key_id Is Null Then
            :new.key_id := dbms_random.string(
                'X',
                5
            );
        End If;
    End If;

    :new.lot_desc := Upper(Trim(:new.lot_desc));
End;
/
ALTER TRIGGER "ITINV_STK"."TRIG_LAPTOP_LOT_MAST_01" ENABLE;
