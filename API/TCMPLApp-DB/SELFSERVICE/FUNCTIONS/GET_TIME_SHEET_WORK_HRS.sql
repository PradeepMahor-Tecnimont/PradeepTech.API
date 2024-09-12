--------------------------------------------------------
--  DDL for Function GET_TIME_SHEET_WORK_HRS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_TIME_SHEET_WORK_HRS" 
(
  PARAM_EMPNO IN VARCHAR2  
, PARAM_DATE IN DATE  
) RETURN Number AS 
vDD char(2);
vWorkHours Number;
BEGIN
  vDD := to_Char(param_date,'dd');
Select Sum(Regular_Hrs) InTo vWorkHours  From  (
  select case vDD
  When '01' Then nvl(d1,0)
  When '02' Then nvl(d2,0)
  When '03' Then nvl(d3,0)
  When '04' Then nvl(d4,0)
  When '05' Then nvl(d5,0)
  When '06' Then nvl(d6,0)
  When '07' Then nvl(d7,0)
  When '08' Then nvl(d8,0)
  When '09' Then nvl(d9,0)
  When '10' Then nvl(d10,0)
  When '11' Then nvl(d11,0)
  When '12' Then nvl(d12,0)
  When '13' Then nvl(d13,0)
  When '14' Then nvl(d14,0)
  When '15' Then nvl(d15,0)
  When '16' Then nvl(d16,0)
  When '17' Then nvl(d17,0)
  When '18' Then nvl(d18,0)
  When '19' Then nvl(d19,0)
  When '20' Then nvl(d20,0)
  When '21' Then nvl(d21,0)
  When '22' Then nvl(d22,0)
  When '23' Then nvl(d23,0)
  When '24' Then nvl(d24,0)
  When '25' Then nvl(d25,0)
  When '26' Then nvl(d26,0)
  When '27' Then nvl(d27,0)
  When '28' Then nvl(d28,0)
  When '29' Then nvl(d29,0)
  When '30' Then nvl(d30,0)
  When '31' Then nvl(d31,0)
  Else 0 End As Regular_Hrs
  from ss_time_daily
  Where empno = trim(param_empno)
  And yymm = to_Char(param_date,'yyyymm')
  And not (  projno  Like '11114%'
    or projno  Like '22224%'
    or projno  Like '33334%'
    or projno  Like 'E1114%'
    or projno  Like 'E2224%'
    or projno  Like 'E3334%')   );
  Return vWorkHours;
  Exception
  When Others then return Null;
END GET_TIME_SHEET_work_hrs;

/
