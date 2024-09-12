--------------------------------------------------------
--  DDL for Procedure DELETE_IN_BETWEEN_PUNCH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "DELETE_IN_BETWEEN_PUNCH" 
(
  paramEMPNO IN VARCHAR2  
, paramPDATE IN DATE  
) AS 
  GetInPunch constant Number  := 0;
  GetOutPunch constant Number  := 1;
  vInPunch Number;
  vOutPunch Number;
  vInHH Number;
  vInMN Number;
  vOutHH Number;
  vOutMN Number;
  vInRow ss_punch%rowtype;
  vOutRow SS_Punch%rowtype;
BEGIN

/*
  Select dd,empno,falseflag,hh,mach,mm,mon,pdate,ss,yyyy  from ss_punch 
    where empno = paramEmpNo and pdate = paramPDate 
    order by hh,mm,ss,mach;
  */
  vInPunch := FirstLastPunch(paramEMPNO,paramPDATE, GetInPunch);
  vOutPunch := FirstLastPunch(paramEMPNO,paramPDATE, GetOutPunch);
  vInHH := Floor(vInPunch / 60);
  vInMN := MOD(vInPunch, 60);
  vOutHH := Floor(vOutPunch / 60);
  vOutMN := Mod(vOutPunch , 60); 
  
  delete from ss_punch where 
  empno = paramEMPNO and pDate = paramPDate 
    and hh <> vInHH and mm <> vInMn And hh <> vOutHH and mm <> vOutMn;
    
  --Update ss_punch set falseflag = 0 Where empno = paramEMPNO and pDate = paramPDate 
    --and hh <> vInHH and mm <> vInMn And hh <> vOutHH and mm <> vOutMn;
  Commit;
  Exception
    When No_Data_Found Then
      Null;
END DELETE_IN_BETWEEN_PUNCH;

/
