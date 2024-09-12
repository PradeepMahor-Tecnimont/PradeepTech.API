--------------------------------------------------------
--  DDL for Function N_OTPERIOD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."N_OTPERIOD" (
    v_code         In             Varchar2,
    v_pdate        In             Date,
    scode          In             Varchar2,
    v_deltahrs     In             Number,
    v_compoffhrs   In             Number Default 0
) Return Number Is

    totalhrs        Number;
    Cursor c1 (
        ohrs In Number
    ) Is
    Select
        *
    From
        ss_integratedpunch
    Where
        empno = Ltrim(Rtrim(v_code))
        And pdate      = v_pdate
        And ( ( hh * 60 ) + mm ) > ohrs
        And falseflag  = 1
        And Trim(mach) <> 'WFH0'
    Order By
        pdate,
        hhsort,
        mmsort,
        hh,
        mm;

    Type tabhrs Is
        Table Of Number Index By Binary_Integer;
    v_tabhrs        tabhrs;
    cntr            Number;
    thrs            Varchar2(10);
    v_shiftout      Number;
    v_cntr          Number;
    v_punchnos      Number;
    vtrno           Char(5);
    v4ot            Boolean := true;
    v_is_train_ot   Number;
Begin
    If scode = 'TN' Or scode = 'PA' Or scode = 'GE' Or scode = 'GV' Then
        Return 0;
    End If;

    Select
        Count(*)
    Into v_cntr
    From
        ss_shiftmast
    Where
        shiftcode = Trim(scode)
        And Nvl(ot_applicable, 0) = 1;

    If Trunc(v_pdate) In (
        Trunc(To_Date('21-FEB-2017', 'dd-MON-yyyy')),
        Trunc(To_Date('28-SEP-2017', 'dd-MON-yyyy'))
    ) Then
        Return 0;
    End If;

    If v_cntr = 0 And Trim(scode) <> 'HH' And Trim(scode) <> 'OO' Then
        Return 0;
    End If;

  --Training

    v_is_train_ot   := n_ot_4_training(
        v_code,
        v_pdate
    );
    If v_is_train_ot = ss.ss_false Then
        Return 0;
    End If;
    totalhrs        := 0;
  --Training
    Select
        missedpunch(
            v_code,
            v_pdate
        )
    Into v_punchnos
    From
        dual;

    If ( v_punchnos Mod 2 ) = 0 Then
        If Ltrim(Rtrim(scode)) = 'OO' Or Ltrim(Rtrim(scode)) = 'HH' Then
            v_shiftout   := 0;
            cntr         := 1;
        Else
       --SELECT GetShiftOutTime(V_Code,V_PDate,SCode,v4OT  ) INTO V_ShiftOut FROM Dual;
            v_shiftout := getshiftouttime(
                v_code,
                v_pdate,
                scode,
                v4ot
            );
      --V_TabHrs(1) := V_ShiftOut ;



      --Cntr        := 2;
            Select
                Count(*)
            Into cntr
            From
                ss_integratedpunch
            Where
                empno = Ltrim(Rtrim(v_code))
                And pdate      = v_pdate
                And ( ( hh * 60 ) + mm ) > v_shiftout
                And falseflag  = 1;

            If Mod(cntr, 2) <> 0 Then
                v_tabhrs(1)   := v_shiftout;
                cntr          := 2;
            Else
                cntr := 1;
            End If;

        End If;

        totalhrs   := 0;
        For c2 In c1(v_shiftout) Loop
      --  If Cntr > 1 Then



      /*If (V_TabHrs(Cntr-1) > (C2.HH * 60) + C2.MM) Or (((C2.HH * 60) + C2.MM) - v_TabHrs(Cntr-1) <= 60) Then
      V_TabHrs(Cntr) := V_TabHrs(Cntr-1);
      Else*/
            v_tabhrs(cntr)   := ( c2.hh * 60 ) + c2.mm;
      --End If;



      /* Else
      V_TabHrs(Cntr) := (C2.HH * 60) + C2.MM;
      End If;*/
            cntr             := cntr + 1;
        End Loop;

        cntr       := cntr - 1;
        If cntr > 1 Then
            For i In 1..cntr Loop
                If Mod(i, 2) <> 0 Then
                    If i = cntr Then
                        totalhrs   := totalhrs - ( v_tabhrs(i - 1) - v_tabhrs(i - 2) );

                        totalhrs   := totalhrs + ( v_tabhrs(i) - v_tabhrs(i - 2) );

                    Elsif i < cntr Then
                        totalhrs := totalhrs + ( v_tabhrs(i + 1) - v_tabhrs(i) );
                    End If;

                End If;
            End Loop;
      --TotalHrs := (((V_TabHrs(Cntr).TabHrs * 60) + V_TabHrs(Cntr).TabMns) - ((V_TabHrs(1).TabHrs * 60) + V_TabHrs(1).TabMns));
        End If;

    End If;

    If scode <> 'OO' And scode <> 'HH' Then
        Select
            Least(v_deltahrs, totalhrs)
        Into totalhrs
        From
            dual;

    Elsif scode = 'OO' Or scode = 'HH' Then
        totalhrs := totalhrs - availedlunchtime1(
            v_code,
            v_pdate,
            scode
        );
    End If;

    If v_compoffhrs = 1 Then
        If totalhrs >= 120 Then
            totalhrs := ( Floor(totalhrs / 60) * 60 );
        Else
            totalhrs := 0;
        End If;
    Else
        If v_pdate >= To_Date('31-Oct-2011', 'dd-Mon-yyyy') Then
            If scode = 'OO' Or scode = 'HH' Then
                If totalhrs >= 240 Then
                    totalhrs := ( Floor(totalhrs / 60) * 60 );
                Else
                    totalhrs := 0;
                End If;

            Else
                If totalhrs >= 120 Then
                    totalhrs := 120;
                Else
                    totalhrs := 0;
                End If;
            End If;

        Else
            If totalhrs >= 30 Then
                totalhrs := ( Floor(totalhrs / 15) * 15 );
            Else
                totalhrs := 0;
            End If;
        End If;
    End If;

    Return totalhrs;
End;

/
