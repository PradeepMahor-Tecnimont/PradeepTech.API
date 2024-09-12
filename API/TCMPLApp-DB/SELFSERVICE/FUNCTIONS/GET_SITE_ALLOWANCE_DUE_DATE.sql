--------------------------------------------------------
--  DDL for Function GET_SITE_ALLOWANCE_DUE_DATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_SITE_ALLOWANCE_DUE_DATE" (pEmpNo IN varchar2, pMonth In Date, pAllowanceStartDate In date) RETURN DATE AS 
  --vMobiDate Date;
  --vSiteCode char(4);
  --vAllowanceStartDt Date;
  vLeaveSum Number;
  --vMonth char(6) := To_Char(pMonth,'yyyymm');
  vAdjSum Number;
  vDueDate Date;
  vTempAllowDueDate Date;
BEGIN
/*
  Begin

    Select mobi_date,SITECODE InTo vMobiDate, vsitecode From ss_site_employee 
      Where EmpNo = pEmpNo And nvl(de_mobi_date,trunc(pmonth,'MONTH')) >= pMonth
      And nvl(ALLOWANCE_APPLICABLE,0) = 1 ;




  Exception
    When No_Data_Found Then
      Return Null;
  End;
  */

  vTempAllowDueDate := Add_Months(pAllowanceStartDate,6) - 1;
  /*
  Select Greatest(START_DATE) InTo vAllowanceStartDt from ss_site_allowance_trans where EMPNO = pempno;
  */
  --If vMobiDate >= pMonth Then Return Null; End If;

  Select Sum(NoOfDays) InTo vLeaveSum From 
  (
    Select (Trunc(EDate) - Trunc(BDate) + 1) NoOfDays FROM ss_leaveledg 
      Where bdate >= pAllowanceStartDate and empno = pempno and leavetype = 'PL' and 
      db_cr = 'D' and nvl(BDATE,bdate) <= vtempallowduedate And adj_type in ('OH','LC','LA')
  );


  SELECT Sum(NoOfDays) InTo vAdjSum From 
  (
      Select (Trunc(ADJ_TO) - Trunc(adj_from) + 1) NoOfDays ,
      CASE 
      WHEN ADJ_ON_LAST_DAY = 0 THEN adjustment_month
      WHEN ADJ_ON_LAST_DAY = 1 THEN LAST_DAY(adjustment_month)
      ELSE NULL
      END AS ADJ_DATE
      from ss_site_allowance_period_adj 
        where empno = pEmpNo And ADJUSTMENT_MONTH <= pMonth and nvl(for_allowance,0) = 1
        And ADJUSTMENT_MONTH >= TO_Date('01' || to_char(pallowancestartdate,'mmyyyy'),'ddmmyyyy')
  ) 
  WHERE ADJ_DATE >= pallowancestartdate;

/*  
  Select Sum(NoOfDays) InTo vAdjSum From 
  (  
    Select (Trunc(ADJ_TO) - Trunc(adj_from) + 1) NoOfDays from ss_site_allowance_period_adj 
      where empno = pEmpNo And ADJUSTMENT_MONTH <= pMonth and nvl(for_allowance,0) = 1
      And ADJUSTMENT_MONTH >= TO_Date('01' || to_char(pallowancestartdate,'mmyyyy'),'ddmmyyyy')
  );
 */   
  vDueDate := Add_Months(pAllowanceStartDate,6) - 1;
  vDueDate := vDueDate + Nvl(vLeaveSum,0) + Nvl(vAdjSum,0);

  Loop
    Exit When vDueDate = vTempallowDueDate;

    Declare
      vTempNuAllowDueDate Date := vDueDate;
      vTempOldAllowDueDate Date := vTempAllowDueDate;
      vNuLeaveSum Number;
    Begin
      vTempAllowDueDate := vDueDate;
      Select Sum(NoOfDays) InTo vNuLeaveSum From 
      (
        Select (Trunc(EDate) - Trunc(BDate) + 1) NoOfDays FROM ss_leaveledg 
          Where bdate > vTempOldAllowDueDate and empno = pempno and leavetype = 'PL' and 
          db_cr = 'D' and nvl(BDATE,bdate) <= vTempNuAllowDueDate and adj_type in ('OH','LC','LA')
      );
        vDueDate := vDueDate + nvl(vNuLeaveSum,0);
    End;
  End Loop;


  RETURN vDueDate;

END Get_SITE_ALLOWANCE_Due_Date;


/
