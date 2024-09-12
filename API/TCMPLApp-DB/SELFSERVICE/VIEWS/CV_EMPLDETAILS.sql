--------------------------------------------------------
--  DDL for View CV_EMPLDETAILS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."CV_EMPLDETAILS" ("EMPNO", "RES_ADD1", "RES_ADD2", "RES_ADD3", "RES_PIN", "RES_STATE", "MOBILENO", "NATIONALITY", "PASSPORTNO", "PASSPORTISSUEDATE", "PASSPORTEXPDATE", "PASSPORTISSUEPLACE") AS 
  SELECT "EMPNO","RES_ADD1","RES_ADD2","RES_ADD3","RES_PIN","RES_STATE","MOBILENO","NATIONALITY","PASSPORTNO","PASSPORTISSUEDATE","PASSPORTEXPDATE","PASSPORTISSUEPLACE"
FROM
(Select a.empno, a.res_add1, a.res_add2, a.res_add3, a.res_pin, a.res_state,'' MobileNo, a.nationality, 
a.passportno, a.passportissuedate, a.passportexpdate, a.passportissueplace 
from commonmasters.cv_emplmast a, commonmasters.emplmast b where a.empno = b.empno and b.emptype <> 'R'
Union
select a.empno,a.r_add_1 res_add1,a.r_add_2 res_add2,a.r_add_3 res_add3,to_char(a.r_pincode) res_pin,
a.r_add_4 res_state,a.MOBILE_RES MobileNo,a.nationality,a.passport_no passportno,a.issue_date passportissuedate,
a.expiry_date passportexpdate,a.passport_issued_at passportissueplace
from commonmasters.emp_details a, commonmasters.emplmast b where a.empno = b.empno and b.emptype = 'R')
;
