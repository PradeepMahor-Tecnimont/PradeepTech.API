--------------------------------------------------------
--  DDL for Package Body SA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SA" AS -- Shift Allowance
    --This FUNCTION is used for Shift Allowance calculations
    --This FUNCTION returns shift code for an employee On a particular date

    /*********  F u n c t i o n    G E T S H I F T ***********/
    FUNCTION GetShift4Allowance(pEmpNum In Varchar2, p_Date In Date) RETURN Char IS
      vDD 		Char(2);	
      SCode				Char(2);
      IsHoliday 	Number;
    BEGIN
        vDD := To_Char(p_Date, 'dd');									
        Select Substr(Shift, ((To_number(vDD) * 2) - 1), 2) Into SCode From SS_Muster_4Allowance
          Where empno = Trim(pEmpNum) And mnth = Ltrim(Rtrim(To_Char(p_Date, 'yyyymm')));
        Return SCode;	
    Exception
        When others then
          return 'NA';
    END GetShift4Allowance;
    /*********  F u n c t i o n    G E T S H I F T ***********/


    /*********  F u n c t i o n    G E T S H I F T 4 P U N C H***********/
  Function GetShift4Punch(pEmpNo IN Varchar2, p_Date IN Date) Return Varchar2 IS
      vDD 		Char(2);	
      SCode				Char(2);
      IsHoliday 	Number;
    BEGIN
        vDD := To_Char(p_Date, 'dd');									
        Select Substr(S_Mrk, ((To_number(vDD) * 2) - 1), 2) Into SCode From ss_muster
          Where empno = Trim(pEmpNo) And mnth = Ltrim(Rtrim(To_Char(p_Date, 'yyyymm')));
        Return SCode;	
    Exception
        When others then
          return 'NA';
    END GetShift4Punch;
    /*********  F u n c t i o n    G E T S H I F T 4 P U N C H***********/



    /*********  F u n c t i o n    H r s I n S h i f t _ W r k ***********/
    Function HrsInShift_Wrk(pEmpNum Varchar2,p_Date IN Date,pShiftCode In Varchar2) Return Number As
        vWorkedHours  Number;
        vAvailedLunchBreak Number;
        vRetVal Number;
    Begin
        vWorkedHours := WorkedHrs(pEmpNum,p_Date,pShiftCode);
        vAvailedLunchBreak := AvailedLunchBreak(pEmpNum ,p_Date, pShiftCode );
        vRetVal := vWorkedHours - vAvailedLunchBreak;
        Return vRetVal;
    End HrsInShift_Wrk;
    /*********  F u n c t i o n    H r s I n S h i f t _ W r k ***********/







    /*********  F u n c t i o n    A v a i l e d L u n c h B r e a k ***********/
    Function AvailedLunchBreak(pEmpNo IN Varchar2, p_Date IN Date, pSCode IN Varchar2) Return Number IS
        vRetVal			  Number := 0;
        vParent 			Varchar2(4);
        vStartHH 			Number := 0;
        vStartMN 			Number := 0;
        vEndHH 				Number := 0;
        vEndMN 				Number := 0;
        vFirstPunch 	Number := 0;
        vLastPunch 		Number := 0;
    BEGIN
      vRetVal := availedlunchtime1(pEmpNo,p_date,pSCode);
      return vRetVal;
          /*Select Min(hh*60+mm), Max(hh*60+mm) InTo vFirstPunch, vLastPunch from SS_IntegratedPunch	
             where EmpNo = ltrim(rtrim(pEmpNo)) and PDate = p_Date order by PDate,hhsort,mmsort,hh,mm;
          If Ltrim(Rtrim(pSCode)) = 'OO' Or Ltrim(Rtrim(pSCode)) = 'HH' Then
              If vFirstPunch < 720 And vLastPunch > 820 Then
                  vRetVal := 30;
              End If;
              Return vRetVal;
          End If;

          Select Assign InTo vParent From SS_EmplMast Where EmpNo = Ltrim(RTrim(pEmpNo));

          Select StartHH, StartMN, EndHH, EndMN
            InTo vStartHH, vStartMN, vEndHH, vEndMN
            From SS_LunchMast Where ShiftCode = Ltrim(RTrim(pSCode)) And Parent = Ltrim(RTrim(vParent));


          If vFirstPunch >= (vEndHH * 60) + vEndMN Then
              Return 0;
          ElsIf vLastPunch <= (vStartHH * 60) + vStartMN Then
              Return 0;

          ElsIf vFirstPunch <= (vStartHH * 60) + vStartMN And vLastPunch >= ((vEndHH * 60) + vEndMN) Then
              Return ((vEndHH * 60) + vEndMN) - ((vStartHH * 60) + vStartMN);

          ElsIf (vFirstPunch > (vStartHH * 60) + vStartMN) And (vFirstPunch < (vEndHH * 60) + vEndMN) And vLastPunch >= (vEndHH * 60) + vEndMN Then
              Return ((vEndHH * 60) + vEndMN) - vFirstPunch;

          ElsIf (vFirstPunch < (vStartHH * 60) + vStartMN) And (vLastPunch < (vEndHH * 60) + vEndMN) And vLastPunch >= (vStartHH * 60) + vStartMN Then
              Return vLastPunch - ((vStartHH * 60) + vStartMN);

          ElsIf (vFirstPunch > (vStartHH * 60) + vStartMN) And (vLastPunch < (vEndHH * 60) + vEndMN) Then
              Return vLastPunch - vFirstPunch;

          ElsIf NVL(LTrim(rTrim(vFirstPunch)),0) = 0 Then
              Return 0;
          ElsIf IsLeaveDepuTour(p_Date, pEmpNo) > 0 Then
              Return 0;
          Else
              Return 30;
          End If;
    Exception
      When Others Then
        Return 30;*/
    END AvailedLunchBreak;
    /*********  F u n c t i o n    A v a i l e d L u n c h B r e a k ***********/



    /*********  F u n c t i o n    W o r k e d H r s  ***********/
    FUNCTION WorkedHrs(pEmpNum IN Varchar2, p_Date IN Date, pShiftCode IN Varchar2) Return Number IS

        Cursor C1 is select HH*60+MM As Hrs from SS_IntegratedPunch
          where EmpNo = ltrim(rtrim(pEmpNum))
          and PDate = p_Date Order By PDate,hhsort,mmsort,hh,mm;

        Type recHrs is record (Hrs number);
        Type TabHrs  is table of recHrs index by Binary_Integer;
        vTHrs TabHrs;
        i Number;
        vCntr Number;
        --vTHrs Varchar2(10);
        vPrevHrs Number;
        vTotalHrs Number;
        inTimeHH Number;
        inTimeMN Number;
        vOutTimeHH Number;
        vOutTimeMN Number;
        vAvailedLunchTime Number := 0;
        --vTotalHrs Number;
    BEGIN
      Select TimeIn_HH, TimeIn_Mn, TimeOut_HH, TimeOut_Mn InTo inTimeHH, inTimeMN, vOutTimeHH, vOutTimeMN From SS_ShiftMast Where ShiftCode = Trim(pShiftCode);
      vTotalHrs := 0;
      i := 0;
      For C2 in C1 Loop
          i := vTHrs.Count + 1;
          If C2.Hrs > (vOutTimeHH * 60) + vOutTimeMN Then
              vTHrs(i).Hrs := (vOutTimeHH * 60) + vOutTimeMN ;
              Exit;
          Else
                If (C2.Hrs  < (inTimeHH * 60) + inTimeMN ) And i = 1 Then
                  vTHrs(i).Hrs := (inTimeHH * 60) + inTimeMN ;
                ElsIf C2.Hrs  >= (inTimeHH * 60) + inTimeMN  Then
                  vTHrs(i).Hrs := C2.Hrs;
                End If;
          End If;
      End Loop;
      
      
      vCntr := 0;
      vPrevHrs := 0;
      vTotalHrs := 0;
      If vTHrs.Count > 1 Then
          For i in vTHrs.First..vTHrs.Last Loop
              vCntr := vCntr + 1;
              If Mod(vCntr,2) = 0 Or vCntr = vTHrs.Count Then
                  vTotalHrs := vTotalHrs + (vTHrs(i).Hrs - vPrevHrs);
              End If;
              vPrevHrs := vTHrs(i).Hrs;
          End Loop;
          vAvailedLunchTime := AvailedLunchBreak(pEmpNum,p_Date, pShiftCode);
          vTotalHrs := vTotalHrs - vAvailedLunchTime;
      End If;
      Return vTotalHrs;
    /*Exception
        When Others Then Return 0;*/
    End WorkedHrs;
    /*********  F u n c t i o n    W o r k e d H r s  ***********/


    Function GetPunch(pEmpNo IN Varchar2 , p_Date IN DATE, pSelect IN Number) Return Number As
        vPunchTime Number;
    Begin
        If pSelect = SA.pFirstPunch Then
            Select Min( (HH*60) + mm ) InTo vPunchTime From SS_IntegratedPunch A
                Where Empno = pEmpNo And PDate = p_Date
                Order by a.hhsort, a.mmsort, a.hh,a.mm;
        ElsIf pSelect = SA.pLastPunch Then
            Select Max( (HH*60) + mm ) InTo vPunchTime From SS_IntegratedPunch A
                Where Empno = pEmpNo And PDate = p_Date
                Order by a.hhsort, a.mmsort, a.hh,a.mm;
        End If;
        Return vPunchTime;
    End GetPunch;
    
    Function FirstPunch Return Number As
    Begin
        Return SA.pFirstPunch;
    End;
        
    Function LastPunch Return Number As
    Begin
        Return SA.pLastPunch;
    End;

    Function GetPrevWrkDay(p_Date IN DATE) Return Date IS
        vDate Date := p_Date;
        vCntr Number;
    Begin
        Loop
            vDate := vDate - 1;
            Select Count(*) InTo vCntr From SS_Holidays Where SS_Holidays.holiday=vDate;
            If vCntr = 0 Then
                Exit;
            End If;
        End Loop;
        Return vDate;
    End GetPrevWrkDay;
    
    Procedure SetPunchDetails4Allowance(pMnth IN Varchar2) AS
        Cursor C1 is Select Holiday From SS_Holidays Where yyyymm = Trim(pMnth);
        vNum Number;
        vDate Date;
        vDay Number;
    Begin
        For C2 In C1 Loop
            vDate := GetPrevWrkDay(C2.Holiday);
            vDay := To_Number(To_Char(C2.Holiday,'dd'));
            dbms_output.put_line (vDay);
			UpDate SS_Muster_4Allowance Set Shift = SubStr(Shift,1,(vDay-1) * 2) || Trim(GetShift4Punch(EmpNo,vDate)) || SubStr(Shift,(vDay * 2)+1)
			Where MNTH = pMnth;
			
			Commit;
        End Loop;
    End SetPunchDetails4Allowance;
    
    Function isShift4Period(pEmpNo IN Varchar2, pBDate IN Date, pEDate IN Date) Return Number IS
        vCounter  Number;
        v_ReturnValue Number := 0;
    Begin
        Select Count(*) InTo vCounter From  (
        Select sa.getshift4allowance(pEmpNo,A.d_Date) As ShiftCode From SS_Days_Details A
          Where A.d_date >= pBDate And A.d_date <= pEDate ) B
          Where B.ShiftCode In (Select ShiftCode From SS_ShiftMast A where A.shift4allowance=1);
        If vCounter > 0 Then
            v_ReturnValue := 1;
        End If;
        Return v_ReturnValue;
    End isShift4Period;
    


--	UpDate SS_Muster Set S_Mrk = SubStr(S_Mrk,1,(v_FirstDay-1) * 2) || LTrim(RTrim(v_ShiftStr)) || SubStr(S_Mrk,(v_LastDay * 2)+1)
--		Where MNTH = To_Char(:Period.EDate,'yyyymm')
--		And EmpNo = LTrim(RTrim(:Period.EmpNo));

    
END;

/
