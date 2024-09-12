--------------------------------------------------------
--  DDL for Trigger SS_TRIG_ONDUTYAPP_DELETE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_ONDUTYAPP_DELETE" before
    delete on ss_ondutyapp
    referencing
            old as old
            new as new
    for each row
begin
    insert into ss_ondutyapp_deleted (
        empno,
        hh,
        mm,
        pdate,
        dd,
        mon,
        yyyy,
        type,
        app_no,
        description,
        hod_apprl,
        hod_apprl_dt,
        hod_code,
        hrd_apprl,
        hrd_apprl_dt,
        hrd_code,
        app_date,
        hh1,
        mm1,
        reason,
        user_tcp_ip,
        hod_tcp_ip,
        hrd_tcp_ip,
        hodreason,
        hrdreason,
        odtype,
        lead_apprl,
        lead_code,
        lead_apprl_dt,
        lead_tcp_ip,
        lead_reason,
        lead_apprl_empno,
        deleted_on
    )
        values(
            :old.empno,
            :old.hh,
            :old.mm,
            :old.pdate,
            :old.dd,
            :old.mon,
            :old.yyyy,
            :old.type,
            :old.app_no,
            :old.description,
            :old.hod_apprl,
            :old.hod_apprl_dt,
            :old.hod_code,
            :old.hrd_apprl,
            :old.hrd_apprl_dt,
            :old.hrd_code,
            :old.app_date,
            :old.hh1,
            :old.mm1,
            :old.reason,
            :old.user_tcp_ip,
            :old.hod_tcp_ip,
            :old.hrd_tcp_ip,
            :old.hodreason,
            :old.hrdreason,
            :old.odtype,
            :old.lead_apprl,
            :old.lead_code,
            :old.lead_apprl_dt,
            :old.lead_tcp_ip,
            :old.lead_reason,
            :old.lead_apprl_empno,
            sysdate
        );
end;

/
ALTER TRIGGER "SELFSERVICE"."SS_TRIG_ONDUTYAPP_DELETE" ENABLE;
