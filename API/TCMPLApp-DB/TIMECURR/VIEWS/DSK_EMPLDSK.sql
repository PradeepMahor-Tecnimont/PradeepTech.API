--------------------------------------------------------
--  DDL for View DSK_EMPLDSK
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."DSK_EMPLDSK" ("EMPNO", "NAME", "EMPTYPE", "ASSIGN", "STATUS", "DSK_NO", "DSK_SHARED") AS 
  (Select a.empno,a.name,a.emptype,a.assign,a.status,b.dsk_no,b.dsk_shared
from emplmast a,dsk_empdsktrans b where a.empno = b.empno(+) and a.status = 1)
Union
(
Select d.EmpNo,d.GuestName Name,EmpType,assign,1 Status,e.dsk_No, e.dsk_shared
From DSK_GuestMast d, dsk_empdsktrans E Where D.empno = e.empno(+)
)

;
