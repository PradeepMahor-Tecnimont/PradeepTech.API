--------------------------------------------------------
--  DDL for Package Body DEPUTATION
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."DEPUTATION" AS
FUNCTION EmpnoFound(pempno in VARCHAR2) RETURN NUMBER IS
MyEmpno CHAR(5);
BEGIN
  Select empno into MyEmpno from commonmasters.emplmast where empno = pEmpno;
  RETURN 1;
  EXCEPTION
    when no_data_found then
    return 0;
end;



FUNCTION ProjnoFound(pprojno in VARCHAR2) RETURN NUMBER IS
MyProjno CHAR(7);
BEGIN
  Select projno into Myprojno from commonmasters.projmast where projno = pprojno;
  RETURN 1;
  EXCEPTION
    when no_data_found then
    return 0;
end;

FUNCTION WPCodeFound(pwpcode in VARCHAR2) RETURN NUMBER IS
MyWPCode CHAR(1);
BEGIN
  Select WPCODE into MyWpCode from commonmasters.time_wpcode where wpcode = pwpcode;
  RETURN 1;
  EXCEPTION
    when no_data_found then
    return 0;
end;

FUNCTION CostCodeFound(pcostcode in VARCHAR2) RETURN NUMBER IS
MyCostCode CHAR(4);
BEGIN
  Select costcode into MyCostCode from commonmasters.costmast where costcode = pCostCode;
  RETURN 1;
  EXCEPTION
    when no_data_found then
    return 0;
end;

FUNCTION ActivityFound(pcostcode in VARCHAR2,pActivity in varchar2) RETURN NUMBER IS
MyActivity CHAR(2);
BEGIN
  Select activity into MyActivity from commonmasters.act_mast where costcode = pCostCode and activity = pActivity;
  RETURN 1;
  EXCEPTION
    when no_data_found then
    return 0;
end;

FUNCTION GrpFound(pCostcode in VARCHAR2,pGrp in varchar2) RETURN NUMBER IS
MyGrp CHAR(2);
BEGIN
  Select activity into MyGrp from commonmasters.costmast where costcode = pCostCode and grp = Pgrp;
  RETURN 1;
  EXCEPTION
    when no_data_found then
    return 0;
end;


END DEPUTATION;

/
