--------------------------------------------------------
--  DDL for Procedure GENERATE_AUTO_PUNCH
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."GENERATE_AUTO_PUNCH" (
    p_empno   In        Varchar2,
    p_pdate   In        Date
) As

    Cursor cur_punch_data Is
    Select
        a.hh,
        a.mm,
        a.ss,
        b.office
    From
        ss_integratedpunch   a,
        ss_swipe_mach_mast   b
    Where
        a.pdate = p_pdate
        And a.empno    = p_empno
        And a.mach     = b.mach_name (+)
        And falseflag  = 1
    Order By
        a.hh,
        a.mm,
        a.ss;

    v_pdate       Date;
    v_count       Number;
    Type rec_hrs Is Record (
        hh            Number,
        mm            Number,
        hhmm          Number,
        ss            Number,
        office        Char(10)
    );
    Type type_tab_hrs Is
        Table Of rec_hrs Index By Binary_Integer;
    o_tab_hrs     type_tab_hrs;
    v_thrs        Varchar2(10);
    v_cntr        Number;
    v_loop_cntr   Number;
Begin
  --reset_punch(p_empno,p_pdate);
    Select
        Count(*)
    Into v_count
    From
        ss_integratedpunch
    Where
        empno = p_empno
        And pdate = p_pdate;

    If v_count <= 2 Then
        return;
    End If;
    Delete From ss_punch_auto
    Where
        empno = p_empno
        And pdate = p_pdate;

    Commit;
    v_cntr := 1;
    For c1 In cur_punch_data Loop
        o_tab_hrs(v_cntr).hh       := c1.hh;
        o_tab_hrs(v_cntr).mm       := c1.mm;
        o_tab_hrs(v_cntr).hhmm     := ( c1.hh * 60 ) + c1.mm;

        o_tab_hrs(v_cntr).ss       := c1.ss;
        o_tab_hrs(v_cntr).office   := Nvl(c1.office, 'ODAP');
        v_cntr                     := v_cntr + 1;
    End Loop;

    For v_loop_cntr In 1..v_cntr - 1 Loop If Mod(
        v_loop_cntr,
        2
    ) = 0 And v_loop_cntr < v_cntr - 1 Then
        If ( o_tab_hrs(v_loop_cntr + 1).hhmm - o_tab_hrs(v_loop_cntr).hhmm ) <= 30 And ( o_tab_hrs(v_loop_cntr + 1).hhmm - o_tab_hrs
        (v_loop_cntr).hhmm ) > 0 Then
            If o_tab_hrs(v_loop_cntr).office <> o_tab_hrs(v_loop_cntr + 1).office Then
                insert_auto_punch(
                    p_empno,
                    p_pdate,
                    o_tab_hrs(v_loop_cntr).hh,
                    o_tab_hrs(v_loop_cntr).mm,
                    o_tab_hrs(v_loop_cntr).ss + 1,
                    o_tab_hrs(v_loop_cntr + 1).hh,
                    o_tab_hrs(v_loop_cntr + 1).mm,
                    o_tab_hrs(v_loop_cntr + 1).ss - 1,
                    2
                ); -- Inter Office Punch

            End If;

        End If;

    End If;
    End Loop;

End generate_auto_punch;


/
