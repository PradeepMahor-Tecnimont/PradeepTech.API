--------------------------------------------------------
--  DDL for View DAILY_9794
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."DAILY_9794" ("NAME", "YYMM", "TS_DATE", "EMPNO", "PARENT", "ASSIGN", "WPCODE", "ACTIVITY", "HOURS", "OTHOURS", "PROJNO", "OT", "TOTHOURS", "POSTBY", "REMARKS") AS 
  (
    select c.name,a."YYMM",a."TS_DATE",a."EMPNO",a."PARENT",a."ASSIGN",a."WPCODE",a."ACTIVITY",a."HOURS",a."OTHOURS",a."PROJNO",a."OT",A.HOURS+A.OTHOURS TOTHOURS,B.POSTBY,
(   case 
   when a.wpcode= 4 AND A.OT = 1 and  a.ts_date <= b.postby THEN  'OT Adjustments' 
   ELSE 
   (case when a.wpcode= 4 AND A.OT = 0 and  a.ts_date <= b.postby THEN   'Adjustments' 
   ELSE 
   (case when a.wpcode<> 4 AND A.OT = 1 and  a.ts_date <= b.postby THEN   'OT Actuals' 
   ELSE
    (case when a.wpcode<> 4 AND A.OT = 0 and  a.ts_date <= b.postby THEN  'Actuals'  
   ELSE 
   (case when a.wpcode= 4 AND A.OT = 1 and  a.ts_date > b.postby THEN    'OT Adjustments Estimates' 
   ELSE 
   (case when a.wpcode= 4 AND A.OT = 0 and  a.ts_date > b.postby THEN    'Adjustments Estimates' 
   ELSE 
   (case when a.wpcode<> 4 AND A.OT = 1 and  a.ts_date > b.postby THEN   'OT Estimates'  
   ELSE
    (case when a.wpcode<> 4 AND A.OT = 0 and  a.ts_date > b.postby THEN   'Estimates' 
   END) 
      END) 
         END )
            END)
               END)
                  END)
                     END)
                        END) Remarks
                           
   FROM
   DATEWISE_TIMESHEET A , WRKHOURS B,emplmast c WHERE A.YYMM = B.YYMM  AND  A.PROJNO LIKE '09794%' and a.empno = c.empno 
   )
;
