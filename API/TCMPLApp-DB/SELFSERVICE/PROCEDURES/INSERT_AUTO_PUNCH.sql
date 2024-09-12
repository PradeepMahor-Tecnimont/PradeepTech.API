--------------------------------------------------------
--  DDL for Procedure INSERT_AUTO_PUNCH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."INSERT_AUTO_PUNCH" (
    p_empno             Varchar2,
    p_pdate             Date,
    p_hh                Number,
    p_mm                Number,
    p_ss                Number,
    p_hh_1              Number,
    p_mm_1              Number,
    p_ss_1              Number,
    p_auto_punch_type   Number
) As
    v_count Number;
Begin
    If p_auto_punch_type = 1 Then -- Auto Punch Type ----->>>>> Lunch
        Select
            Count(*)
        Into v_count
        From
            ss_punch_auto
        Where
            empno = p_empno
            And Trunc(pdate)     = Trunc(p_pdate)
            And auto_punch_type  = 1;

        If v_count <> 0 Then
            return;
        End If;
    End If;

    Insert Into ss_punch_auto (
        empno,
        pdate,
        hh,
        mm,
        ss,
        dd,
        mon,
        yyyy,
        mach,
        auto_punch_type,
        falseflag
    ) Values (
        p_empno,
        p_pdate,
        p_hh,
        p_mm,
        p_ss,
        To_Char(p_pdate, 'dd'),
        To_Char(p_pdate, 'mm'),
        To_Char(p_pdate, 'yyyy'),
        'SYS',
        p_auto_punch_type,
        1
    );

    Insert Into ss_punch_auto (
        empno,
        pdate,
        hh,
        mm,
        ss,
        dd,
        mon,
        yyyy,
        mach,
        auto_punch_type,
        falseflag
    ) Values (
        p_empno,
        p_pdate,
        p_hh_1,
        p_mm_1,
        p_ss_1,
        To_Char(p_pdate, 'dd'),
        To_Char(p_pdate, 'mm'),
        To_Char(p_pdate, 'yyyy'),
        'SYS',
        p_auto_punch_type,
        1
    );

End insert_auto_punch;


/
