Create Or Replace Package Body "SELFSERVICE"."PN" --4 PENALTY LEAVE DEDUCTION           
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