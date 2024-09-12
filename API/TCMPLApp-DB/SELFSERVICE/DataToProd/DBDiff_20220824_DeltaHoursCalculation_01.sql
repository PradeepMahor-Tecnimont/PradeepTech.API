--------------------------------------------------------
--  File created - Wednesday-August-24-2022   
--------------------------------------------------------
---------------------------
--Changed PROCEDURE
--N_CFWD_LWD_DELTAHRS
---------------------------
CREATE OR REPLACE PROCEDURE "SELFSERVICE"."N_CFWD_LWD_DELTAHRS" (p_EmpNo IN Varchar2, p_PDate IN Date, p_SaveTot In Number,
													p_DeltaHrs Out Number, p_LWDDeltaHrs Out Number,
													p_LCAppCntr Out Number) IS

-- p_SaveTot - if '1' Then totals of Last Complete Week of the month are stored in the database.
-- p_SaveTot - if '0' Then totals of Last Complete Week of the month are retrived from the database.

		Cursor C1 (c_EmpNo IN Varchar2, c_Date IN Date) Is
				Select c_EmpNo As EmpNo, To_Number(D_DD) As Days,
						LateCome1(c_EmpNo,D_Date) AS LCome,
						D_Date AS PDate,
						GetShift1(c_EmpNo, D_Date) AS SCode,
						Get_Holiday(D_Date) As isSunday,
						EarlyGo1(c_EmpNo,D_Date) AS EGo,
						isLComeEGoApp(c_EmpNo,D_Date) AS LC_App,
						isSLeaveApp(c_EmpNo,D_Date) AS SL_App,
						isLastWorkDay1(c_EmpNo, D_Date) AS isLWD,
						Wk_Of_Year,
						D_Day
				From SS_Days_Details
				Where D_Date >= c_Date And D_Date <= Last_Day(c_Date)
				Order by D_Date;
				
		LC_AppCntr Number := 0;
		SL_AppCntr Number := 0;
		v_OpenLC_Cntr Number := 0;
		v_OpenMM Number :=0;
		v_SDate Date;
		v_Count Number :=0;
		v_DHrs Number :=0;
		v_SumDHrs Number :=0;
		v_CFwdHrs Number :=0;
		v_RetVal Number := 0;
		v_NumVar Number :=0;
		v_PHrs Number :=0;
		--v_CFwdSLAppCntr Number :=0;
		v_LastDay Varchar2(3) :='NON';
		v_MM Varchar2(2);
		v_YYYY Varchar2(4);
BEGIN
		If To_Number(To_Char(p_PDate,'dd')) = 1 Then
				Select Count(*) InTo v_Count From SS_DeltaHrsBal_OT Where EmpNo = lTrim(p_EmpNo);
				If v_Count = 0 Then
						--Select Nvl(doj,p_PDate) InTo v_SDate From SS_Emplmast Where EmpNo = Ltrim(Rtrim(p_EmpNo));
						v_SDate := Add_Months(p_PDate,-1) -1;
				Else

							Select MON, YYYY, Nvl(LC_AppCntr,0), Nvl(DELTAHRS,0), Nvl(LDAY_CFWD_DHRS,0), PDate
								InTo v_MM, v_YYYY, LC_AppCntr, v_SumDHrs, p_LWDDeltaHrs, v_SDate From SS_DeltaHrsBal_OT
								Where PDate < p_PDate
								And EmpNo = lTrim(p_EmpNo)
								And PDate = (Select Max(PDate) From SS_DeltaHrsBal_OT Where PDate < p_PDate And EmpNo = lTrim(p_EmpNo) Group By EmpNo);
							If Add_Months(v_SDate,1) + 1 < p_PDate Then
									v_SDate := Add_Months(p_PDate, -1) -1;
									v_MM := To_Char(v_SDate,'MM');
									v_YYYY := To_Char(v_SDate,'YYYY');
									LC_AppCntr := 0;
									v_SumDHrs := 0;
									v_CFwdHrs := 0;
							End If;
				End If;
				v_SDate := v_SDate + 1;
				If Add_Months(v_SDate,1)  = p_PDate Then
						--
						For C2 IN C1(p_EmpNo,v_SDate) Loop
								
								v_LastDay := C2.D_Day; --eg. 'MON', 'TEU' 'SUN' etc
								
								--------------------------------------
								--																	--
								-- 		Changes done on  05-June-2003	--
								--																	--
								--						S T A R T							--
								--Ref. Kotian mail dated 5.Jan.2004	--
								--------------------------------------
                                                                If v_LastDay = 'SUN' Then
                                                                    p_LWDDeltaHrs := Nvl(v_CFwdHrs,0);
                                                                End If;
                                                                If v_LastDay  ='MON' Then
                                                                    v_SumDHrs := v_CFwdHrs;
                                                                    v_CFwdHrs := 0;
                                                                End If;
								------------------------------------
								--																--
								-- Changes done on  05-June-2003	--
								--																--
								--						E N D								--
								--																--
								------------------------------------
								
								LC_AppCntr := LC_AppCntr + C2.LC_App;
								SL_AppCntr := SL_AppCntr + C2.SL_App;
								
                                --brought forward delta hrs incorrect calculation rectified
                                --
								--Select N_DeltaHrs(C2.EmpNo,C2.PDate,C2.SCode,PenaltyLeave1(C2.LCome,C2.EGo,C2.isLWD,LC_AppCntr,SL_AppCntr,C2.LC_App,C2.SL_App)) InTo v_DHrs From Dual;
                                v_DHrs := n_deltahrs_include_2nd_shift(
                                                p_empno       => C2.EmpNo,
                                                p_date        => C2.PDate,
                                                p_shiftcode   => C2.SCode,
                                                p_penalty_hrs => PenaltyLeave1(C2.LCome,C2.EGo,C2.isLWD,LC_AppCntr,SL_AppCntr,C2.LC_App,C2.SL_App)
                                            ) ;
                                -----****-----
                                
								v_SumDHrs := v_SumDHrs + v_DHrs ;
								
								If C2.isLWD = 1 Then
									
									If v_DHrs < 0 And C2.EGo <> 0 and (C2.SL_App = 1) Then
										v_CFwdHrs := v_DHrs;
									Else
										v_CFwdHrs := 0;
									End If;
									------------------------------------
									--																--
									-- Changes done on  05-June-2003	--
									--																--
									--					S T A R T							--
									--																--
									------------------------------------
											LC_AppCntr := 0;
		
											If v_SumDHrs >= 0 Or v_CFwdHrs >= 0 Then
													v_CFwdHRs := 0;
											ElsIf v_SumDHrs > v_CFwdHrs Then -- i.e v_sumDHrs < 0 And v_CFwdHRs < 0
													v_CFwdHrs	:= v_SumDHrs;			 -- and v_SumDHrs > v_CFwdHrs
																											 --     e.g   -20 > -25
											
											ElsIf v_SumDHrs < v_CFwdHrs Then 							--i.e v_sumDHrs < 0 And v_CFwdHRs < 0
													v_NumVar := v_SumDHrs + (v_CFwdHrs *-1);		-- and v_SumDHrs < v_CFwdHrs
													v_NumVar :=	v_NumVar *-1;		 							--     e.g   -25 < -20
													v_PHrs := Floor(v_NumVar/60);
													If v_PHrs < (v_NumVar/60) Then
															v_PHrs := v_PHrs + 1;
													End If;
													v_NumVar := v_SumDHrs + (v_PHrs * 60);
													If v_NumVar < 0 Then
                                                                                                            If v_CFwdHrs < v_NumVar Then
                                                                                                                v_CFwdHrs := v_NumVar;
                                                                                                            End If;
													Else
                                                                                                            v_CFwdHrs := 0;
													End If;
											End If;
                                                                                        
											--p_LWDDeltaHrs := Nvl(v_CFwdHrs,0);
											v_SumDHrs := 0;

									------------------------------------
									--																--
									-- Changes done on  05-June-2003	--
									--																--
									--					  E N D  							--
									--																--
									------------------------------------
										
								End If;
										--Select Least(Greatest(v_SumDHrs,v_CFwdHrs),0) InTo v_SumDHrs From Dual;
								/*If C2.isLDM = 1 And C2.isLWD = 0 Then
										Null;
								End If;*/
								
								        /*
								If C2.isSunday = 2 Then

										LC_AppCntr := 0;

										If v_SumDHrs >= 0 Or v_CFwdHrs >= 0 Then
												v_CFwdHRs := 0;
										ElsIf v_SumDHrs > v_CFwdHrs Then -- i.e v_sumDHrs < 0 And v_CFwdHRs < 0
												v_CFwdHrs	:= v_SumDHrs;			 -- and v_SumDHrs > v_CFwdHrs
																										 --     e.g   -20 > -25
										
										ElsIf v_SumDHrs < v_CFwdHrs Then 							--i.e v_sumDHrs < 0 And v_CFwdHRs < 0
												v_NumVar := v_SumDHrs + (v_CFwdHrs *-1);		-- and v_SumDHrs < v_CFwdHrs
												v_NumVar :=	v_NumVar *-1;		 							--     e.g   -25 < -20
												v_PHrs := Floor(v_NumVar/60);
												If v_PHrs < (v_NumVar/60) Then
														v_PHrs := v_PHrs + 1;
												End If;
												v_NumVar := v_SumDHrs + (v_PHrs * 60);
												If v_NumVar < 0 Then
														If v_CFwdHrs < v_NumVar Then
																v_CFwdHrs := v_NumVar;
														End If;
												Else
														v_CFwdHrs := 0;
												End If;
										End If;
										v_SumDHrs := 0;
								End If;*/
						End Loop;
						If p_SaveTot = 1 Then
								/*If v_LastDay = 'SUN' Then
										Delete From SS_DeltaHrsBal_OT where EmpNo = p_EmpNo And Mon = To_Char(v_SDate,'MM') And YYYY = To_Char(v_SDate, 'yyyy');
										Insert InTo SS_DeltaHrsBal_OT (EmpNo,Mon,YYYY,LDay_CFwd_DHrs, PDate, LC_AppCntr) Values (p_EmpNo,LPad(To_Char(v_SDate,'MM'),2,'0'),LPad(To_Char(v_SDate,'YYYY'),4,'0'),p_LWDDeltaHrs, Last_Day(v_SDate), 0 );
								Else*/
								        /*
										If v_CFwdHrs < 0 Then
												v_SumDHrs := v_SumDHrs + (v_CFwdHrs * -1);
										End If;
										*/
										Delete From SS_DeltaHrsBal_OT where EmpNo = p_EmpNo And Mon = To_Char(v_SDate,'MM') And YYYY = To_Char(v_SDate, 'yyyy');
										Insert InTo SS_DeltaHrsBal_OT (EmpNo,Mon,YYYY,DeltaHrs,LDay_CFwd_DHrs, PDate, LC_AppCntr) Values (p_EmpNo,LPad(To_Char(v_SDate,'MM'),2,'0'),LPad(To_Char(v_SDate,'YYYY'),4,'0'),v_SumDHrs,p_LWDDeltaHrs, Last_Day(v_SDate), p_LCAppCntr );
								/*End If;*/
								
								Commit;
						End If;
						p_DeltaHrs := Nvl(v_SumDHrs,0);
						--p_LCAppCntr := LC_AppCntr;
				Else
						p_DeltaHrs := Nvl(v_SumDHrs,0);
				End If;
		End If;
		p_DeltaHrs := Nvl(p_DeltaHrs,0);
		p_LWDDeltaHrs := Nvl(p_LWDDeltaHrs,0);
		p_LCAppCntr := Nvl(LC_AppCntr,0);
Exception
		When NO_DATA_FOUND Then
													p_DeltaHrs := 0;
													p_LWDDeltaHrs := 0;
													p_LCAppCntr :=0;
END;
/
---------------------------
--Changed PACKAGE BODY
--PN
---------------------------
CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PN" --4 PENALTY LEAVE DEDUCTION           
Is
    --   
    -- To modify this template, edit file PKGBODY.TXT in TEMPLATE 
    -- directory of SQL Navigator
    --
    -- Purpose: Briefly explain the functionality of the package body
    --
    -- MODIFICATION HISTORY
    -- Person      Date    Comments
    -- ---------   ------  ------------------------------------------      
    -- Enter procedure, function bodies as shown below

    Function getstartdate(p_mm   In Varchar2,
                          p_yyyy In Varchar2) Return Date Is
    Begin
        If Not (p_mm = '01' And p_yyyy = '2007') Then
            Return n_getstartdate(p_mm, p_yyyy);
        Else
            Return To_Date('1-Jan-2007');
        End If;
    End getstartdate;

    Function getenddate(p_mm   In Varchar2,
                        p_yyyy In Varchar2) Return Date Is
    Begin
        Return n_getenddate(p_mm, p_yyyy);
    End getenddate;

    --procedure to save / calculate CFwd Delta Hrs of Last Working Day (Used in punch details and Penalty Leave calculation)
    Procedure n_cfwd_lwd_deltahrs(p_empno       In  Varchar2,
                                  p_pdate       In  Date,
                                  p_savetot     In  Number,
                                  p_deltahrs    Out Number,
                                  p_lwddeltahrs Out Number,
                                  p_lcappcntr   Out Number) Is

        -- p_SaveTot - if '1' Then totals of Last Complete Week of the month are stored in the database.
        -- p_SaveTot - if '0' Then totals of Last Complete Week of the month are retrived from the database.

        Cursor c1(c_empno In Varchar2,
                  c_date  In Date) Is
            Select
                c_empno                         As empno,
                To_Number(d_dd)                 As days,
                latecome1(c_empno, d_date)      As lcome,
                d_date                          As pdate,
                getshift1(c_empno, d_date)      As scode,
                get_holiday(d_date)             As issunday,
                earlygo1(c_empno, d_date)       As ego,
                islcomeegoapp(c_empno, d_date)  As lc_app,
                issleaveapp(c_empno, d_date)    As sl_app,
                islastworkday1(c_empno, d_date) As islwd,
                wk_of_year,
                d_day
            From
                ss_days_details
            Where
                d_date >= pn.getstartdate(to_char(c_date, 'MM'), to_char(c_date, 'YYYY'))
                And d_date <= pn.getenddate(to_char(c_date, 'MM'), to_char(c_date, 'YYYY'))
            Order By
                d_date;

        lc_appcntr    Number      := 0;
        sl_appcntr    Number      := 0;
        v_openlc_cntr Number      := 0;
        v_openmm      Number      := 0;
        v_sdate       Date;
        v_count       Number      := 0;
        v_dhrs        Number      := 0;
        v_sumdhrs     Number      := 0;
        v_cfwdhrs     Number      := 0;
        v_retval      Number      := 0;
        v_numvar      Number      := 0;
        v_phrs        Number      := 0;
        --v_CFwdSLAppCntr Number :=0;
        v_lastday     Varchar2(3) := 'NON';
        v_mm          Varchar2(2);
        v_yyyy        Varchar2(4);
    Begin
        If To_Number(to_char(p_pdate, 'dd')) = 1 Then
            Select
                Count(*)
            Into
                v_count
            From
                ss_deltahrsbal_ot
            Where
                empno = ltrim(p_empno);
            If v_count = 0 Then
                --Select Nvl(doj,p_PDate) InTo v_SDate From SS_Emplmast Where EmpNo = Ltrim(Rtrim(p_EmpNo));
                v_sdate := add_months(p_pdate, -1) - 1; -- Add_Montsh(1-Feb-2001,-1) = 1-Jan-2001 - 1 = 31-Dec-2000
            Else
                Select
                    mon,
                    yyyy, --Nvl(LC_AppCntr,0),
                    nvl(deltahrs, 0),
                    nvl(lday_cfwd_dhrs, 0),
                    pdate
                Into
                    v_mm,
                    v_yyyy, --LC_AppCntr,
                    v_sumdhrs,
                    p_lwddeltahrs,
                    v_sdate
                From
                    ss_deltahrsbal_ot
                Where
                    pdate < p_pdate
                    And empno = ltrim(p_empno)
                    And pdate = (
                        Select
                            Max(pdate)
                        From
                            ss_deltahrsbal_ot
                        Where
                            pdate < p_pdate
                            And empno = ltrim(p_empno)
                        Group By
                            empno
                    );

                If add_months(v_sdate, 1) + 1 < p_pdate Then
                    v_sdate    := add_months(p_pdate, -1) - 1;
                    v_mm       := to_char(v_sdate, 'MM');
                    v_yyyy     := to_char(v_sdate, 'YYYY');
                    lc_appcntr := 0;
                    v_sumdhrs  := 0;
                    v_cfwdhrs  := 0;
                End If;
            End If;
            v_sdate := v_sdate + 1; -- 1st of the Month
            If add_months(v_sdate, 1) = p_pdate Then
                --
                For c2 In c1(p_empno, v_sdate)
                Loop

                    v_lastday  := c2.d_day; --eg. 'MON', 'TEU' 'SUN' etc

                    If v_lastday = 'SUN' Then
                        p_lwddeltahrs := nvl(v_cfwdhrs, 0);
                    End If;
                    If v_lastday = 'MON' Then
                        v_sumdhrs := v_cfwdhrs;
                        v_cfwdhrs := 0;
                    End If;

                    lc_appcntr := lc_appcntr + c2.lc_app;
                    sl_appcntr := sl_appcntr + c2.sl_app;

                    --If c2.pdate >= To_Date('27-Jun-2022') Then
                    If c2.pdate >= To_Date('1-Mar-2022') Then
                        v_dhrs := n_deltahrs_include_2nd_shift(
                                      c2.empno,
                                      c2.pdate,
                                      c2.scode,
                                      penaltyleave1(
                                          c2.lcome,
                                          c2.ego,
                                          c2.islwd,
                                          lc_appcntr,
                                          sl_appcntr,
                                          c2.lc_app,
                                          c2.sl_app
                                      )
                                  );
                    Else

                        v_dhrs := n_deltahrs(
                                      c2.empno,
                                      c2.pdate,
                                      c2.scode,
                                      penaltyleave1(
                                          c2.lcome,
                                          c2.ego,
                                          c2.islwd,
                                          lc_appcntr,
                                          sl_appcntr,
                                          c2.lc_app,
                                          c2.sl_app
                                      )
                                  );
                    End If;
                    v_sumdhrs  := v_sumdhrs + v_dhrs;

                    If c2.islwd = 1 Then

                        If v_dhrs < 0 And c2.ego <> 0 And (c2.sl_app = 1) Then
                            v_cfwdhrs := v_dhrs;
                        Else
                            v_cfwdhrs := 0;
                        End If;
                        lc_appcntr := 0;

                        If v_sumdhrs >= 0 Or v_cfwdhrs >= 0 Then
                            v_cfwdhrs := 0;
                        Elsif v_sumdhrs > v_cfwdhrs Then                    -- i.e v_sumDHrs < 0 And v_CFwdHRs < 0
                            v_cfwdhrs := v_sumdhrs;	            		-- and v_SumDHrs > v_CFwdHrs
                            --     e.g   -20 > -25
                        Elsif v_sumdhrs < v_cfwdhrs Then 					-- i.e v_sumDHrs < 0 And v_CFwdHRs < 0
                            v_numvar := v_sumdhrs + (v_cfwdhrs * -1);		-- and v_SumDHrs < v_CFwdHrs
                            v_numvar := v_numvar * -1;		 				-- e.g   -25 < -20
                            v_phrs   := floor(v_numvar / 60);
                            If v_phrs < (v_numvar / 60) Then
                                v_phrs := v_phrs + 1;
                            End If;
                            v_numvar := v_sumdhrs + (v_phrs * 60);
                            If v_numvar < 0 Then
                                If v_cfwdhrs < v_numvar Then
                                    v_cfwdhrs := v_numvar;
                                End If;
                            Else
                                v_cfwdhrs := 0;
                            End If;
                        End If;

                        --p_LWDDeltaHrs := Nvl(v_CFwdHrs,0);
                        v_sumdhrs  := 0;
                    End If;
                End Loop;
                If p_savetot = 1 Then
                    p_lcappcntr := nvl(p_lcappcntr, 0);
                    Delete
                        From ss_deltahrsbal_ot
                    Where
                        empno    = p_empno
                        And mon  = to_char(v_sdate, 'MM')
                        And yyyy = to_char(v_sdate, 'yyyy');
                    Insert Into ss_deltahrsbal_ot (empno, mon, yyyy, deltahrs, lday_cfwd_dhrs, pdate, lc_appcntr)
                    Values (
                        p_empno, lpad(to_char(v_sdate, 'MM'), 2, '0'), lpad(to_char(v_sdate, 'YYYY'), 4, '0'), v_sumdhrs,
                        p_lwddeltahrs,
                        last_day(v_sdate), p_lcappcntr);

                    Commit;
                End If;
                p_deltahrs := nvl(v_sumdhrs, 0);
                --p_LCAppCntr := LC_AppCntr;
            Else
                p_deltahrs := nvl(v_sumdhrs, 0);
            End If;
        End If;
        p_deltahrs    := nvl(p_deltahrs, 0);
        p_lwddeltahrs := nvl(p_lwddeltahrs, 0);
        p_lcappcntr   := nvl(lc_appcntr, 0);
    Exception
        When no_data_found Then
            p_deltahrs    := 0;
            p_lwddeltahrs := 0;
            p_lcappcntr   := 0;
    End;

    -- Enter further code below as specified in the Package spec.
End;
/
---------------------------
--Changed PACKAGE BODY
--IOT_SWP_PRIMARY_WORKSPACE
---------------------------
CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_WORKEDHRS_INCLUDE_2ND_SHIFT" (
    p_empno      In Varchar2,
    p_date       In Date,
    p_shift_code In Varchar2
) Return Number Is

    Cursor c1 Is
        Select
            *
        From
            ss_integratedpunch
        Where
            empno         = ltrim(rtrim(p_empno))
            And pdate     = p_date
            And falseflag = 1
        Order By
            pdate,
            hhsort,
            mmsort,
            hh,
            mm;

    Type tabhrs Is
        Table Of Number Index By Binary_Integer;
    Type tabodappl Is
        Table Of Number Index By Binary_Integer;
    v_tabhrs           tabhrs;
    v_tabodappl        tabodappl;
    cntr               Number;
    thrs               Varchar2(10);
    totalhrs           Number;
    v_i_hh             Number;
    v_i_mm             Number;
    v_o_hh             Number;
    v_o_mm             Number;
    v_intime           Number;
    v_outtime          Number;
    v_count            Number;
    v_availedlunchtime Number := 0;
    v_first_punch_min  Number;
Begin
    If p_shift_code = 'OO' And p_shift_code = 'HH' Then
        v_intime := 0 + 15;

    Else
        Select
            timein_hh,
            timein_mn,
            timeout_hh,
            timeout_mn
        Into
            v_i_hh,
            v_i_mm,
            v_o_hh,
            v_o_mm
        From
            ss_shiftmast
        Where
            shiftcode = ltrim(rtrim(p_shift_code));

        v_intime  := (v_i_hh * 60) + v_i_mm;
        v_outtime := (v_o_hh * 60) + v_o_mm;

        If v_intime > (12 * 60) And p_date >= To_Date('1-Mar-2022', 'dd-Mon-yyyy') Then -- After 12:00  noon
            v_intime := 0 + 15;
            If p_date >= To_Date('27-Jun-2022') Then
                Begin
                    Select
                        *
                    Into
                        v_first_punch_min
                    From
                        (
                            Select
                                ((hh * 60) + mm) As punch_min
                            From
                                ss_integratedpunch
                            Where
                                empno         = ltrim(rtrim(p_empno))
                                And pdate     = p_date
                                And falseflag = 1
                            Order By pdate,
                                hhsort,
                                mmsort,
                                hh,
                                mm
                        )
                    Where
                        Rownum = 1;
                    If v_intime < v_first_punch_min Then
                        v_intime := (v_i_hh * 60) + v_i_mm;
                    End If;
                Exception
                    When Others Then
                        Null;
                End;
            End If;
        End If;

    End If;

    totalhrs := 0;
    cntr     := 1;
    For c2 In c1
    Loop

        v_tabodappl(cntr) := c2.odtype;
        If ((c2.hh * 60) + c2.mm) < (v_intime - 15) And cntr = 1 Then
            v_tabhrs(cntr) := (v_intime - 15);
            cntr           := cntr + 1;
        Elsif ((c2.hh * 60) + c2.mm) >= (v_intime - 15) Then
            If cntr > 1 Then
                If v_tabhrs(cntr - 1) > ((c2.hh * 60) + c2.mm) Then
                    v_tabhrs(cntr) := v_tabhrs(cntr - 1);
                Elsif (((c2.hh * 60) + c2.mm) - v_tabhrs(cntr - 1)) <= 60 And Mod(cntr, 2) = 1 And (v_tabodappl(cntr) <> 0
                Or v_tabodappl(cntr - 1) <> 0) Then
                    v_tabhrs(cntr) := v_tabhrs(cntr - 1);
                Else
                    v_tabhrs(cntr) := (c2.hh * 60) + c2.mm;
                End If;
            Else
                v_tabhrs(cntr) := (c2.hh * 60) + c2.mm;
            End If;

            cntr := cntr + 1;
        End If;

    End Loop;

    cntr     := cntr - 1;
    If cntr > 1 Then
        For i In 1..cntr
        Loop
            If Mod(i, 2) <> 0 Then
                If i = cntr Then
                    totalhrs := totalhrs - (v_tabhrs(i - 1) - v_tabhrs(i - 2));

                    totalhrs := totalhrs + (v_tabhrs(i) - v_tabhrs(i - 2));

                Elsif i < cntr Then
                    totalhrs := totalhrs + (v_tabhrs(i + 1) - v_tabhrs(i));
                End If;

            End If;
        End Loop;

        v_availedlunchtime := availedlunchtime1(p_empno, p_date, p_shift_code);
        totalhrs           := totalhrs - v_availedlunchtime;
    End If;

    Return totalhrs;
Exception
    When Others Then
        Return 0;
End;
/
