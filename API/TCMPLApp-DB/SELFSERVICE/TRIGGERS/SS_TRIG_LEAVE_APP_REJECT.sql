--------------------------------------------------------
--  DDL for Trigger SS_TRIG_LEAVE_APP_REJECT
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SELFSERVICE"."SS_TRIG_LEAVE_APP_REJECT" before
    update of app_no,lead_apprl,hrd_apprl,hod_apprl on ss_leaveapp
    referencing
            old as old
            new as new
    for each row
begin
    if nvl(:new.hod_apprl,ss.pending) = ss.rejected or nvl(:new.hrd_apprl,ss.pending) = ss.rejected or nvl(:new.lead_apprl,ss.pending
    ) = ss.rejected then
        insert into ss_leaveapp_rejected (
            app_no,
            empno,
            app_date,
            rep_to,
            projno,
            caretaker,
            leaveperiod,
            leavetype,
            bdate,
            edate,
            reason,
            mcert,
            work_ldate,
            resm_date,
            contact_add,
            contact_phn,
            contact_std,
            last_hrs,
            last_mn,
            resm_hrs,
            resm_mn,
            dataentryby,
            office,
            hod_apprl,
            hod_apprl_dt,
            hod_code,
            hrd_apprl,
            hrd_apprl_dt,
            hrd_code,
            discrepancy,
            user_tcp_ip,
            hod_tcp_ip,
            hrd_tcp_ip,
            hodreason,
            hrdreason,
            hd_date,
            hd_part,
            lead_apprl,
            lead_apprl_dt,
            lead_code,
            lead_tcp_ip,
            lead_apprl_empno,
            lead_reason,
            rejected_on
        ) values (
            :old.app_no,
            :old.empno,
            :old.app_date,
            :old.rep_to,
            :old.projno,
            :old.caretaker,
            :old.leaveperiod,
            :old.leavetype,
            :old.bdate,
            :old.edate,
            :old.reason,
            :old.mcert,
            :old.work_ldate,
            :old.resm_date,
            :old.contact_add,
            :old.contact_phn,
            :old.contact_std,
            :old.last_hrs,
            :old.last_mn,
            :old.resm_hrs,
            :old.resm_mn,
            :old.dataentryby,
            :old.office,
            :new.hod_apprl,
            :old.hod_apprl_dt,
            :old.hod_code,
            :new.hrd_apprl,
            :old.hrd_apprl_dt,
            :old.hrd_code,
            :old.discrepancy,
            :old.user_tcp_ip,
            :old.hod_tcp_ip,
            :old.hrd_tcp_ip,
            :old.hodreason,
            :old.hrdreason,
            :old.hd_date,
            :old.hd_part,
            :new.lead_apprl,
            :old.lead_apprl_dt,
            :old.lead_code,
            :old.lead_tcp_ip,
            :old.lead_apprl_empno,
            :old.lead_reason,
            sysdate
        );

        null;
    end if;
end;

/
ALTER TRIGGER "SELFSERVICE"."SS_TRIG_LEAVE_APP_REJECT" ENABLE;
