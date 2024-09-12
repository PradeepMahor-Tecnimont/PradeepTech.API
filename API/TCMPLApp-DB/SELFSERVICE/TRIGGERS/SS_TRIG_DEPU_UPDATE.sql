--------------------------------------------------------
--  DDL for Trigger SS_TRIG_DEPU_UPDATE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_DEPU_UPDATE" before
    update of app_no,hod_apprl,hrd_apprl,lead_apprl on ss_depu
    referencing
            old as old
            new as new
    for each row
begin if nvl(:old.hod_apprl,ss.pending) = ss.rejected or nvl(:old.hrd_apprl,ss.pending) = ss.rejected or nvl(:old.lead_apprl
   ,ss.pending) = ss.rejected then
    insert into ss_depu_rejected (
        empno,
        app_no,
        bdate,
        edate,
        description,
        type,
        hod_apprl,
        hod_apprl_dt,
        hod_code,
        hrd_apprl,
        hrd_apprl_dt,
        hrd_code,
        app_date,
        reason,
        user_tcp_ip,
        hod_tcp_ip,
        hrd_tcp_ip,
        hodreason,
        hrdreason,
        chg_no,
        chg_date,
        lead_apprl,
        lead_apprl_dt,
        lead_code,
        lead_tcp_ip,
        lead_reason,
        lead_apprl_empno,
        chg_by,
        site_code,
        rejected_on
    ) values (
        :old.empno,
        :old.app_no,
        :old.bdate,
        :old.edate,
        :old.description,
        :old.type,
        :new.hod_apprl,
        :old.hod_apprl_dt,
        :old.hod_code,
        :new.hrd_apprl,
        :old.hrd_apprl_dt,
        :old.hrd_code,
        :old.app_date,
        :old.reason,
        :old.user_tcp_ip,
        :old.hod_tcp_ip,
        :old.hrd_tcp_ip,
        :old.hodreason,
        :old.hrdreason,
        :old.chg_no,
        :old.chg_date,
        :new.lead_apprl,
        :old.lead_apprl_dt,
        :old.lead_code,
        :old.lead_tcp_ip,
        :old.lead_reason,
        :old.lead_apprl_empno,
        :old.chg_by,
        :old.site_code,
        sysdate
    );
    end
if;

null;

end;

/
ALTER TRIGGER "SELFSERVICE"."SS_TRIG_DEPU_UPDATE" ENABLE;
