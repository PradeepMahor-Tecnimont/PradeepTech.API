--------------------------------------------------------
--  DDL for Procedure UPDATE_PASSPORT_DETAILS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "COMMONMASTERS"."UPDATE_PASSPORT_DETAILS" AS 
  cursor cur_main is select empno, expiry_date from emp_details where empno='02100';
  v_pp_no varchar2(50);
  v_exp_date date;
  v_issue_date date;
  v_pp_at varchar2(50);
BEGIN
  For cur_temp In cur_main  loop
          Select passportexpdate,passportissuedate,passportissueplace,passportno
          into v_exp_date,v_issue_date,v_pp_at,v_pp_no
          from cv_emplmast Where empno = cur_temp.empno;

          If v_exp_date > cur_temp.expiry_date then
            update emp_details set 
              passport_no = v_pp_no,
              expiry_date = v_exp_date,
              issue_date = v_issue_date,
              passport_issued_at = v_pp_at
              where empno = cur_temp.empno;
              commit;
          end If;
  End Loop;
END UPDATE_PASSPORT_DETAILS;

/
