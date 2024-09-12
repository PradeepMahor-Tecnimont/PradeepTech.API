--------------------------------------------------------
--  DDL for Procedure GENERATE_AUTO_PUNCH_4OD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."GENERATE_AUTO_PUNCH_4OD" (
    p_od_app In Varchar2
) As

    Cursor c1 Is
    With t As (
        Select
            p_od_app str
        From
            dual
    )
    Select
        Regexp_Substr(str, '[^,]+', 1, Level) appno
    From
        t
    Connect By
        Level <= (
            Select
                Length(Replace(str, ',', Null))
            From
                t
        );

    vempno   Char(5);
    vpdate   Date;
Begin
    For c2 In c1 Loop
        If Trim(c2.appno) Is Not Null Then
            Select Distinct
                empno,
                pdate
            Into
                vempno,
                vpdate
            From
                ss_onduty
            Where
                Trim(app_no) = Trim((c2.appno));

            generate_auto_punch(
                vempno,
                vpdate
            );
        End If;
    End Loop;
End generate_auto_punch_4od;


/
