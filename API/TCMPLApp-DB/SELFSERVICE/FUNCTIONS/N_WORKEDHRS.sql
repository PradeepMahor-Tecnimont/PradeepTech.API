--------------------------------------------------------
--  DDL for Function N_WORKEDHRS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_WORKEDHRS" (
    v_code        In            Varchar2,
    v_pdate       In            Date,
    v_shiftcode   In            Varchar2
) Return Number Is

    Cursor c1 Is
    Select
        *
    From
        ss_integratedpunch
    Where
        empno = Ltrim(Rtrim(v_code))
        And pdate      = v_pdate
        And falseflag  = 1
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
    v_tabhrs             tabhrs;
    v_tabodappl          tabodappl;
    cntr                 Number;
    thrs                 Varchar2(10);
    totalhrs             Number;
    v_i_hh               Number;
    v_i_mm               Number;
    v_o_hh               Number;
    v_o_mm               Number;
    v_intime             Number;
    v_outtime            Number;
    v_count              Number;
    v_availedlunchtime   Number := 0;
Begin
    If v_shiftcode <> 'OO' And v_shiftcode <> 'HH' Then
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
            shiftcode = Ltrim(Rtrim(v_shiftcode));

        v_intime    := ( v_i_hh * 60 ) + v_i_mm;
        v_outtime   := ( v_o_hh * 60 ) + v_o_mm;
    Else
        v_intime := 0 + 15;
    End If;
--	New

  	/*Select Count(*) InTo v_Count From SS_BusLate_LayOff_Detail 
  			Where EmpNo=Ltrim(Rtrim(v_Code)) And PDate = v_PDate;*/
  	--If v_Count = 1 Then

    Begin
        Select
            timein_hh,
            timein_mm,
            timeout_hh,
            timeout_mm
        Into
            v_i_hh,
            v_i_mm,
            v_o_hh,
            v_o_mm
        From
            ss_buslate_layoff_mast
        Where
            pdate = v_pdate
            And code = (
                Select
                    code
                From
                    ss_buslate_layoff_detail
                Where
                    empno = Ltrim(Rtrim(v_code))
                    And pdate = v_pdate
            );

        v_intime    := ( v_i_hh * 60 ) + v_i_mm;
        v_outtime   := ( v_o_hh * 60 ) + v_o_mm;
    Exception
        When no_data_found Then
            Null;
    End;
  	--End If;

-- End Of New

/*		Select 
					GetShiftInTime(v_Code,v_PDate,v_ShiftCode ),
					GetShiftOutTime(v_Code,v_PDate,v_ShiftCode )
				InTo 
					V_InTime, 
					V_OutTime
		From SS_ShiftMast Where ShiftCode = LTrim(Rtrim(V_ShiftCode));
*/

    totalhrs   := 0;
    cntr       := 1;
    For c2 In c1 Loop
        v_tabodappl(cntr) := c2.odtype;
        If ( ( c2.hh * 60 ) + c2.mm ) < ( v_intime - 15 ) And cntr = 1 Then
            v_tabhrs(cntr)   := ( v_intime - 15 );
            cntr             := cntr + 1;
        Elsif ( ( c2.hh * 60 ) + c2.mm ) >= ( v_intime - 15 ) Then
            If cntr > 1 Then
                If v_tabhrs(cntr - 1) > ( ( c2.hh * 60 ) + c2.mm ) Then
                    v_tabhrs(cntr) := v_tabhrs(cntr - 1);
                Elsif ( ( ( c2.hh * 60 ) + c2.mm ) - v_tabhrs(cntr - 1) ) <= 60 And Mod(cntr, 2) = 1 And ( v_tabodappl(cntr) <> 0
                Or v_tabodappl(cntr - 1) <> 0 ) Then
                    v_tabhrs(cntr) := v_tabhrs(cntr - 1);
                Else
                    v_tabhrs(cntr) := ( c2.hh * 60 ) + c2.mm;
                End If;
            Else
                v_tabhrs(cntr) := ( c2.hh * 60 ) + c2.mm;
            End If;

            cntr := cntr + 1;
        End If;

    End Loop;

    cntr       := cntr - 1;
    If cntr > 1 Then
        For i In 1..cntr Loop If Mod(i, 2) <> 0 Then
            If i = cntr Then
                totalhrs   := totalhrs - ( v_tabhrs(i - 1) - v_tabhrs(i - 2) );

                totalhrs   := totalhrs + ( v_tabhrs(i) - v_tabhrs(i - 2) );

            Elsif i < cntr Then
                totalhrs := totalhrs + ( v_tabhrs(i + 1) - v_tabhrs(i) );
            End If;

        End If;
        End Loop;

        v_availedlunchtime   := availedlunchtime1(
            v_code,
            v_pdate,
            v_shiftcode
        );
        totalhrs             := totalhrs - v_availedlunchtime;
    End If;

    Return totalhrs;
Exception
    When Others Then
        Return 0;
End;


/
