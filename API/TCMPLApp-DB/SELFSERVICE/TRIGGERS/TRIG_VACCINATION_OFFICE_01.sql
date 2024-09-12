--------------------------------------------------------
--  DDL for Trigger TRIG_VACCINATION_OFFICE_01
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."TRIG_VACCINATION_OFFICE_01" BEFORE
    INSERT OR UPDATE OF attending_vaccination, cowin_regtrd, empno, jab_number, mobile, not_attending_reason, office_bus, office_bus_route
    ON swp_vaccination_office
    REFERENCING
            OLD AS old
            NEW AS new
    FOR EACH ROW
BEGIN
    :new.modified_on := sysdate;
END;

/
ALTER TRIGGER "SELFSERVICE"."TRIG_VACCINATION_OFFICE_01" ENABLE;
