--------------------------------------------------------
--  DDL for Function GET_MUSTER_STATUS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_MUSTER_STATUS" 
  ( parEmpNo IN Varchar2,
    parDate IN Date )
  RETURN  CHAR IS
--
--  THIS FUNCTION RETURN THE EMPLOYEE MUSTER STATUS FOR THE DAY
--  This functin returns the employee muster status for the day eg. leave, deputation, on duty, in office, etc.
--  Return values of this function
--------
--  PP  --  Employee is Present
--  IO  --  Forgetting Punch Card - But present in office
--  OD  --  On Duty for the whole day
--  LE  --  Employee is on leave
--  DP  --  Employee is on Deputaion
--  TR  --  Employee is on Tour
--  HT  --  Employee is at Home Town
--  AB  --  Employee is Absent
--  VS  --  Employee is on duty for  VISA PROBLEM
--  NA  --  Not Applicable (eg. parDate is < DOJ of Employee)
--------
    vRetVal     CHAR(2);
    vCount      Number;
BEGIN 
    vRetVal := 'NA';

    -- Check if employee has punched his Punch Card ( P R E S E N T )
    Select Count(*) InTo vCount From SS_Punch
        Where EmpNo = Trim(parEmpNo) And PDate = parDate;
    If vCount > 0 Then            Return 'PP';        End If;

    -- Check If Employee is on   L E A V E
    Select Count(*) InTo vCount From SS_LeaveLedg Where EmpNo = Trim(parEmpNo)
        And Bdate <= parDate And Nvl(EDate,BDate) >= parDate
        And DB_CR = 'D' And Adj_Type In ( 'LC', 'DR', 'LA');
    If vCount > 0 Then            Return 'LE';        End If;

    -- Check If Employee is on   O N   D U T Y
    Select Count(*) InTo vCount From SS_OnDuty Where EmpNo = Trim(parEmpNo)
        And PDate = parDate And Type = 'OD';
    If vCount > 0 Then            Return  'OD';        End If;

    -- Check If Employee has applied for  F O R G E T T I N G   P U N C H   C A R D
    Select Count(*) InTo vCount From SS_OnDuty Where EmpNo = Trim(parEmpNo)
        And PDate = parDate And Type = 'IO';
    If vCount > 0 Then            Return  'IO';        End If;


    -- Check If Employee is  H O M E   T O W N
    Select Count(*) InTo vCount From SS_Depu Where EmpNo = Trim(parEmpNo)
        And BDate <= parDate And EDate >= parDate And Type = 'HT';
    If vCount > 0 Then            Return  'HT';        End If;

    -- Check If Employee is on  D E P U T A T I O N
    Select Count(*) InTo vCount From SS_Depu Where EmpNo = Trim(parEmpNo)
        And BDate <= parDate And EDate >= parDate And Type = 'DP';
    If vCount > 0 Then            Return  'DP';        End If;

    -- Check If Employee is on   T O U R
    Select Count(*) InTo vCount From SS_Depu Where EmpNo = Trim(parEmpNo)
        And BDate <= parDate And EDate >= parDate And Type = 'TR';
    If vCount > 0 Then            Return  'TR';        End If;

    -- Check If Employee is on duty for  V I S A   P R O B L E M
    Select Count(*) InTo vCount From SS_Depu Where EmpNo = Trim(parEmpNo)
        And BDate <= parDate And EDate >= parDate And Type = 'VS';
    If vCount > 0 Then            Return  'VS';        End If;

    -- Check If Employee is  A B S E N T
    If IsAbsent(parEmpNo,pardate) = 1 Then   Return 'AB';   End If;


    RETURN vRetVal;
EXCEPTION
   WHEN Others THEN
       Return vRetVal;
END;





/
