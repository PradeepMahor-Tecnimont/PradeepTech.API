--------------------------------------------------------
--  DDL for Procedure SEND_MAIL_OT_NOT_APPROVED
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."SEND_MAIL_OT_NOT_APPROVED" as 
    cursor cur_approvers is 
        select approver,email From ss_emplmast a, 
        ( 
          Select lead_apprl_empno as Approver from ss_otmaster where nvl(lead_apprl,ss.ot_pending) = ss.ot_pending 
            union 
          select  mngr As Approver from ss_emplmast where empno in 
            ( 
              select empno from ss_otmaster where nvl(lead_apprl,ss.ot_pending) <> ss.ot_pending 
                and nvl(hod_apprl,ss.ot_pending) = ss.ot_pending
            )
        ) b 
        Where a.empno = b.approver and a.status = 1;
    vSubject varchar2(100);
    vBody varchar2(1000);
    v_error number;
    v_error_msg varchar2(1000);
begin
    vSubject := 'Extra Hours / C.Off Hours Approval Reminder';
    vBody := 'If any Extra Hrs / Compensatory offs  Claim of employee  is pending for your approval in self service, please approve the same claim  as per our circular no 3/2012.';

    for c1 in cur_approvers loop
        ss_mail.send_Mail(c1.email,vSubject,vBody, v_error, v_error_msg);
    end loop;

end send_mail_ot_not_approved;


/
