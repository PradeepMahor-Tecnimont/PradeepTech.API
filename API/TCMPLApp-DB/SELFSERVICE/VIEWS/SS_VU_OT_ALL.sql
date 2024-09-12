--------------------------------------------------------
--  DDL for View SS_VU_OT_ALL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SS_VU_OT_ALL" ("EMPNO", "NAME", "PARENT", "GRADE", "D_DATE", "YYYYMM", "OT_HRS_ROUND", "OT_HRS", "HOLIDAY") AS 
  select a.empno,b.name,b.parent, b.grade,a.d_date,to_char(a.d_date,'yyyymm') yyyymm,a.ot_hrs_round,a.ot_hrs,a.holiday from
(
select empno, D_DATE ,
trunc(OT_HRS/60) OT_Hrs_round,
OT_HRS ,
HOLIDAY  
 from SS_OT_DETAILS_4_YEAR_ALL
union
select empno,D_DATE ,
trunc(OT_HRS/60) OT_Hrs_round,
OT_HRS ,
HOLIDAY  
 from SS_OT_DETAILS_4_YEAR_ALL_0225
UNION
select empno,D_DATE ,
trunc(OT_HRS/60) OT_Hrs_round,
OT_HRS ,
HOLIDAY  
 from SS_OT_DETAILS_4_YEAR_ALL_REST) a, ss_emplmast b
where a.empno = b.empno
;
