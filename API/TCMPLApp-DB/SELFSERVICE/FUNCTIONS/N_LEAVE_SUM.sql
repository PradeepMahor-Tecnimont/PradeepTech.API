--------------------------------------------------------
--  DDL for Function N_LEAVE_SUM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_LEAVE_SUM" (
     pEmpNo In Varchar2, pBeginDate in Date , pEndDate In Date,
    pLeaveType In Varchar2 )
  return Number
as
    vSingleMM Number;
    vMultipleMM Number;
    vRetVal Number;
begin
    If Ltrim(Rtrim(pLeaveType)) <> 'SL' Then
        /*----------------------------------------------------*/
        /*   Leave period extends over a period of 1 month    */
        /*----------------------------------------------------*/
        Begin
            select sum( Nvl((leaveperiod / 8),0)  ) * -1 InTo vSingleMM from SS_LeaveLedg 
                where 
                --to_char(bdate,'mmyyyy') = to_char(nvl(edate,bdate),'mmyyyy')
                bdate >= pBeginDate and Nvl(edate,bdate) <= pEndDate 
                And adj_type <> 'YA'
                And adj_type <> 'DA'
                --And description not like 'Year End % Adjustment Entry%' and description not like 'On Deputation Leave Adj%'
                and EmpNo=Ltrim(Rtrim(pEmpNo)) 
                and (Leavetype = Ltrim(Rtrim(pLeaveType))  and db_Cr = 'D');
        Exception
            When No_Data_Found Then
                vSingleMM := 0;
        End;
--    ElsIf Ltrim(Rtrim(LeaveType)) = 'SL' Then
    ElsIf Ltrim(Rtrim(pLeaveType)) = 'SL' Then
        Begin
            Select Sum(Nvl(Leaves,0)) InTo vSingleMM From
            (
              select sum( (leaveperiod / 8*-1)  - holidaysbetween(bdate,edate) )  As Leaves
                from SS_LeaveLedg where
                --to_char(bdate,'mmyyyy') = to_char(nvl(edate,bdate),'mmyyyy')
                bdate >= pBeginDate and Nvl(edate,bdate) <= pEndDate 
                And adj_type <> 'LE' 
                And adj_type <> 'YA'
                And adj_type <> 'DA'
                --And description not like 'Year End % Adjustment Entry%'
                --and description not like 'On Deputation Leave Adj%'
                And empno=Ltrim(Rtrim(pEmpNo)) 
                And (Leavetype = Ltrim(Rtrim(pLeaveType)) and db_Cr  = 'D') );
        Exception
            When No_Data_Found Then
                vSingleMM := 0;
        End;
        vRetVal := vSingleMM;
    End If;
    /*----------------------------------------------------*/
    /*   Leave period extends over a period of 2 months   */
    /*----------------------------------------------------*/
    Begin
      Select Sum(Nvl(Leaves,0)) InTo vMultipleMM From 
      (
          select sum( (edate - (pBeginDate-1) ) - holidaysbetween(pBeginDate,edate) ) As Leaves
          from SS_LeaveLedg where 
          to_char(bdate,'mmyyyy') <> to_char(nvl(edate,bdate),'mmyyyy')
          and To_Char(edate,'mmyyyy') = To_Char(pBeginDate,'mmyyyy')
          and db_Cr = 'D' And adj_type <> 'LE' 
          And adj_type <> 'YA'
          And adj_type <> 'DA'
          and leavetype = Ltrim(Rtrim(pLeaveType))
          And empno = Ltrim(Rtrim(pEmpNo)) 
        union all 
          select Sum( ((pEndDate+1) - bdate) - HolidaysBetween(bdate,pEndDate) ) as leaves 
          from SS_LeaveLedg where 
          to_char(bdate,'mmyyyy') <> to_char(nvl(edate,bdate),'mmyyyy') 
          and To_Char(bdate,'mmyyyy') = To_Char(pEndDate,'mmyyyy')
          and db_Cr = 'D' And adj_type <> 'LE'
          And adj_type <> 'YA'
          And adj_type <> 'DA'
          And empno = Ltrim(Rtrim(pEmpNo)) and leavetype = Ltrim(Rtrim(pLeaveType))
      );
    Exception
      When No_Data_Found Then
        vMultipleMM := 0;
    End;
    vRetVal := Nvl(vMultipleMM,0) + Nvl(vSingleMM,0);
    Return vRetVal;
end;


/
