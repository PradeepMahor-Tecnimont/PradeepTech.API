--------------------------------------------------------
--  DDL for Procedure CHANGE_SHIFT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "CHANGE_SHIFT" 
(
  pdate IN DATE  
, pFromShift IN VARCHAR2
, pToShift IN varchar2
) AS 
vStartStrLastPos Number;
vEndStrFirstPos Number;
BEGIN
  vStartStrLastPos  := (To_number(To_Char(PDate,'dd')) - 1) * 2 ;
  vEndStrFirstPos := (To_number(To_Char(PDate,'dd'))  * 2) + 1 ;
  Update ss_muster set s_mrk = substr(s_mrk,1,vStartStrLastPos) || Trim(pToShift) || substr(s_mrk,vEndStrFirstPos)
  Where Substr(s_mrk,vStartStrLastPos+1,2) = Trim(pFromShift)  
  And  mnth = to_char(pdate,'yyyymm') ;
  --and empno=Trim(pEmpNo);
  Commit;
END CHANGE_SHIFT;

/
