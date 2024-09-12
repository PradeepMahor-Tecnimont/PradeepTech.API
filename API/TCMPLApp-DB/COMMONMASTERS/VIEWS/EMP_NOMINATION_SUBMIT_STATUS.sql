--------------------------------------------------------
--  DDL for View EMP_NOMINATION_SUBMIT_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "COMMONMASTERS"."EMP_NOMINATION_SUBMIT_STATUS" ("EMPNO", "NAME", "PARENT", "DOJ", "EMAIL", "NOMINATION_SUBMITTED", "SUBMITTED_DATE", "STATUS", "SUBMIT_STATUS") AS 
  SELECT 
    a.empno,b.name,b.parent,b.doj,b.email,
    case a.submitted when 'OK' Then 'Yes' Else 'No' End nomination_submitted, modified_on submitted_date,
    status,nvl(a.submitted,'KO') submit_status
FROM 
    emp_nomination_status a , emplmast b
    where a.empno=b.empno
union
select empno,name,parent,doj,email,'No',null, status,'KO' from emplmast
where empno not in (Select empno from emp_nomination_status)
and emptype='R'
;
