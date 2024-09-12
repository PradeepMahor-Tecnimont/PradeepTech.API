--------------------------------------------------------
--  DDL for Procedure N_CFWDDELTAHRS1_20060428
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."N_CFWDDELTAHRS1_20060428" (p_EmpNo IN Varchar2, p_PDate IN Date, p_SaveTot In Number,
													p_DeltaHrs Out Number, p_CFwdDeltaHrs Out Number,
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
								InTo v_MM, v_YYYY, LC_AppCntr, v_SumDHrs, v_CFwdHrs, v_SDate From SS_DeltaHrsBal_OT
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

								Select N_DeltaHrs(C2.EmpNo,C2.PDate,C2.SCode,PenaltyLeave1(C2.LCome,C2.EGo,C2.isLWD,LC_AppCntr,SL_AppCntr,C2.LC_App,C2.SL_App)) InTo v_DHrs From Dual;
								v_SumDHrs := v_SumDHrs + v_DHrs ;

								If C2.isLWD = 1 Then

									If v_DHrs < 0 Then
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
											--v_SumDHrs := 0;

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
								End If;
						End Loop;
						If p_SaveTot = 1 Then
								If v_LastDay = 'SUN' Then
										Delete From SS_DeltaHrsBal_OT where EmpNo = p_EmpNo And Mon = To_Char(v_SDate,'MM') And YYYY = To_Char(v_SDate, 'yyyy');
										Insert InTo SS_DeltaHrsBal_OT (EmpNo,Mon,YYYY,LDay_CFwd_DHrs, PDate, LC_AppCntr) Values (p_EmpNo,LPad(To_Char(v_SDate,'MM'),2,'0'),LPad(To_Char(v_SDate,'YYYY'),4,'0'),v_CFwdHrs, Last_Day(v_SDate), 0 );
								Else
										If v_CFwdHrs < 0 Then
												v_SumDHrs := v_SumDHrs + (v_CFwdHrs * -1);
										End If;
										Delete From SS_DeltaHrsBal_OT where EmpNo = p_EmpNo And Mon = To_Char(v_SDate,'MM') And YYYY = To_Char(v_SDate, 'yyyy');
										Insert InTo SS_DeltaHrsBal_OT (EmpNo,Mon,YYYY,DeltaHrs,LDay_CFwd_DHrs, PDate, LC_AppCntr) Values (p_EmpNo,LPad(To_Char(v_SDate,'MM'),2,'0'),LPad(To_Char(v_SDate,'YYYY'),4,'0'),v_SumDHrs,v_CFwdHrs, Last_Day(v_SDate), LC_AppCntr );
								End If;

								Commit;
						End If;
						p_DeltaHrs := Nvl(v_SumDHrs,0);
						p_CFwdDeltaHrs := Nvl(v_CFwdHrs,0);
						p_LCAppCntr := LC_AppCntr;
				Else
						p_DeltaHrs := Nvl(v_SumDHrs,0);
						p_CFwdDeltaHrs := Nvl(v_CFwdHrs,0);
				End If;
		End If;
Exception
		When NO_DATA_FOUND Then
													p_DeltaHrs := 0;
													p_CFwdDeltaHrs := 0;
													p_LCAppCntr :=0;

END
;


/
