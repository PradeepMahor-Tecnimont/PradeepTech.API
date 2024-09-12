--------------------------------------------------------
--  DDL for Package Body RAP_TIMESHEET
--------------------------------------------------------

Create Or Replace Package Body "TIMECURR"."RAP_TIMESHEET" As

    Procedure get_timesheet(
        p_empno       In  Varchar2,
        p_costcode    In  Varchar2,
        p_yymm        In  Varchar2,
        p_time_master Out Sys_Refcursor,
        p_time_daily  Out Sys_Refcursor,
        p_time_ot     Out Sys_Refcursor,
        p_total       Out Sys_Refcursor
    ) As
        v_mst_stmt   Varchar2(8000) := Null;
        v_daily_stmt Varchar2(8000) := Null;
        v_ot_stmt    Varchar2(8000) := Null;
        v_total_stmt Varchar2(8000) := Null;
        v_count      Number;
        vschema      Varchar(10)    := 'TIME' || substr(p_yymm, 0, 4) || '.';
        vyear        Varchar(5);
    Begin

        Select
            Case
                When to_char(substr(p_yymm, 5, 2)) > '03' Then
                    to_char(substr(p_yymm, 0, 4))
                Else
                    to_char(To_Number(substr(p_yymm, 0, 4)) - 1)
            End As fy
        Into
            vyear
        From
            dual;

        vschema      := 'TIME' || substr(vyear, 0, 4) || '.';

        If substr(vyear, 0, 4) = substr(to_char(sysdate, 'YYYYMM'), 0, 4) Then
            vschema := '';
        ElsIf substr(vyear, 0, 4) + 1 = substr(to_char(sysdate, 'YYYYMM'), 0, 4) Then
            vschema := '';
        End If;

        v_mst_stmt   := ' SELECT distinct TM.yymm, TM.empno, TM.parent, TM.assign, TM.posted, TM.approved, TM.locked, Nvl(TM.exceed,0) exceed,';
        v_mst_stmt   := v_mst_stmt || ' case when TM.posted = 1 then 5 when TM.approved = 1 then 3   ';
        v_mst_stmt   := v_mst_stmt || ' when TM.locked = 1 then 2  else 1 end as Status , TM.company, ';
        v_mst_stmt   := v_mst_stmt || ' TM.grp, TM.tot_nhr, TM.tot_ohr, TM.remark ';
        v_mst_stmt   := v_mst_stmt || ' FROM ' || vschema || 'VU_time_mast TM ';
        v_mst_stmt   := v_mst_stmt || ' where TM.yymm=''' || p_yymm || ''' ';
        v_mst_stmt   := v_mst_stmt || ' and TM.assign=''' || p_costcode || ''' ';
        v_mst_stmt   := v_mst_stmt || ' and TM.empno=''' || p_empno || ''' ';

        v_daily_stmt := ' SELECT    TD.projno,    TD.wpcode,   rpad(trim( TD.activity),7,'' '') activity , ';
        v_daily_stmt := v_daily_stmt || '   TD.total, TD.grp, TD.company,   ';
        v_daily_stmt := v_daily_stmt || '   CASE ';
        v_daily_stmt := v_daily_stmt || '      WHEN Nvl(P.timesheet_appr, 0) = 1  THEN 1 ';
        v_daily_stmt := v_daily_stmt || '      WHEN Nvl(P.timesheet_appr, 0) = 0  THEN -1 ';
        v_daily_stmt := v_daily_stmt || '   END PMAPPROVED ';
        v_daily_stmt := v_daily_stmt || ' , (
		SELECT  ''[''||
			nvl(d1 ,''0'') ||'',''|| nvl(d2 ,''0'') ||'',''|| nvl(d3 ,''0'') ||'',''|| nvl(d4 ,''0'') ||'',''|| nvl(d5 ,''0'') ||'',''||
			nvl(d6 ,''0'') ||'',''|| nvl(d7 ,''0'') ||'',''|| nvl(d8 ,''0'') ||'',''|| nvl(d9 ,''0'') ||'',''|| nvl(d10,''0'') ||'',''||
			nvl(d11,''0'') ||'',''|| nvl(d12,''0'') ||'',''|| nvl(d13,''0'') ||'',''|| nvl(d14,''0'') ||'',''|| nvl(d15,''0'') ||'',''||
			nvl(d16,''0'') ||'',''|| nvl(d17,''0'') ||'',''|| nvl(d18,''0'') ||'',''|| nvl(d19,''0'') ||'',''|| nvl(d20,''0'') ||'',''||
			nvl(d21,''0'') ||'',''|| nvl(d22,''0'') ||'',''|| nvl(d23,''0'') ||'',''|| nvl(d24,''0'') ||'',''|| nvl(d25,''0'') ||'',''||
			nvl(d26,''0'') ||'',''|| nvl(d27,''0'') ||'',''|| nvl(d28,''0'') ||'',''|| nvl(d29,''0'') ||'',''|| nvl(d30,''0'') ||'',''||
			nvl(d31,''0'') || '']''
        FROM    ' || vschema || 'VU_time_daily
		where    projno = TD.projno and   WPCODE = TD.WPCODE and  ACTIVITY = TD.ACTIVITY and
				yymm=''' || p_yymm || ''' and
				assign=''' || p_costcode ||
        '''  and
				empno=''' || p_empno || '''
				) as Daily_hours ';

        v_daily_stmt := v_daily_stmt || ' FROM ' || vschema || 'VU_time_daily TD, projmast P '; --' || Vschema || '

        v_daily_stmt := v_daily_stmt || ' where TD.PROJNO = P.PROJNO AND TD.yymm=''' || p_yymm || ''' ';
        v_daily_stmt := v_daily_stmt || ' and  TD.assign=''' || p_costcode || ''' ';
        v_daily_stmt := v_daily_stmt || ' and  TD.empno=''' || p_empno || ''' ';

        v_ot_stmt    := ' SELECT  OT.projno,    OT.wpcode,   rpad(trim( OT.activity), 7, '' '') activity, ';
        v_ot_stmt    := v_ot_stmt || '  OT.total, OT.grp, OT.company, ';
        v_ot_stmt    := v_ot_stmt || '   CASE ';
        v_ot_stmt    := v_ot_stmt || '      WHEN Nvl(P.timesheet_appr, 0) = 1 THEN 1 ';
        v_ot_stmt    := v_ot_stmt || '      WHEN Nvl(P.timesheet_appr, 0) = 0 THEN -1 ';
        v_ot_stmt    := v_ot_stmt || '   END PMAPPROVED ';
        v_ot_stmt    := v_ot_stmt || ' , (
		SELECT  ''[''||
			nvl(d1 ,''0'') ||'',''|| nvl(d2 , ''0'') ||'',''|| nvl(d3 ,''0'') ||'',''|| nvl(d4 ,''0'') ||'',''|| nvl(d5 ,''0'') ||'',''||
			nvl(d6 ,''0'') ||'',''|| nvl(d7 , ''0'') ||'',''|| nvl(d8 ,''0'') ||'',''|| nvl(d9 ,''0'') ||'',''|| nvl(d10,''0'') ||'',''||
			nvl(d11,''0'') ||'',''|| nvl(d12, ''0'') ||'',''|| nvl(d13,''0'') ||'',''|| nvl(d14,''0'') ||'',''|| nvl(d15,''0'') ||'',''||
			nvl(d16,''0'') ||'',''|| nvl(d17, ''0'') ||'',''|| nvl(d18,''0'') ||'',''|| nvl(d19,''0'') ||'',''|| nvl(d20,''0'') ||'',''||
			nvl(d21,''0'') ||'',''|| nvl(d22, ''0'') ||'',''|| nvl(d23,''0'') ||'',''|| nvl(d24,''0'') ||'',''|| nvl(d25,''0'') ||'',''||
			nvl(d26,''0'') ||'',''|| nvl(d27, ''0'') ||'',''|| nvl(d28,''0'') ||'',''|| nvl(d29,''0'') ||'',''|| nvl(d30,''0'') ||'',''||
			nvl(d31,''0'') || '']''
        FROM    ' || vschema || 'VU_time_ot
		where   projno = OT.projno and   WPCODE = OT.WPCODE and  ACTIVITY = OT.ACTIVITY   and
				yymm=''' || p_yymm || ''' and
				assign=''' || p_costcode ||
        '''  and
				empno=''' || p_empno || '''
				) as OT_hours  ';
        v_ot_stmt    := v_ot_stmt || ' FROM    ' || vschema || 'VU_time_ot  OT,  projmast P ';

        v_ot_stmt    := v_ot_stmt || ' where  OT.PROJNO = P.PROJNO AND  OT.yymm=''' || p_yymm || ''' ';
        v_ot_stmt    := v_ot_stmt || ' and   OT.assign=''' || p_costcode || ''' ';
        v_ot_stmt    := v_ot_stmt || ' and    OT.empno=''' || p_empno || ''' ';

        /*
        v_ot_stmt := v_ot_stmt || ' where  OT.PROJNO = P.PROJNO AND  OT.yymm=''' || p_yymm || ''' ';
         v_ot_stmt := v_ot_stmt || ' and   OT.assign=''' || p_costcode || ''' ';
         v_ot_stmt := v_ot_stmt || ' and    OT.empno=''' || p_empno || ''' ';
        */

        v_total_stmt := v_total_stmt || '
                    SELECT DISTINCT (
                        (	select NVL( sum(NT.TOTAL), ''0'')
								from ' || vschema || 'VU_time_daily NT
								where NT.yymm=TM.yymm and NT.empno= TM.empno and NT.assign =TM.assign

					) + (
							select NVL( sum(NT.TOTAL), ''0'')
								from ' || vschema || 'VU_time_daily NT
								where NT.yymm=TM.yymm and NT.empno= TM.empno and  NT.assign != TM.assign
						)
                                    )   totalNormalHours  ';
        v_total_stmt := v_total_stmt || ' FROM ' || vschema || 'VU_time_mast TM ';
        v_total_stmt := v_total_stmt || ' where TM.yymm=''' || p_yymm || ''' ';
        v_total_stmt := v_total_stmt || ' and TM.empno=''' || p_empno || ''' ';

        Open p_time_master For v_mst_stmt;

        Open p_time_daily For v_daily_stmt;

        Open p_time_ot For v_ot_stmt;

        Open p_total For v_total_stmt;
    End get_timesheet;

    Procedure get_holidays(p_yyyymm   In  Varchar2,
                           p_dayslist Out Sys_Refcursor) As
        v_stmt Varchar2(1000) := Null;
    Begin
        v_stmt := ' select listagg(days, '','') within group (order by days) as days from ';
        v_stmt := v_stmt || ' (select to_char(to_date(holiday,''dd-mm-yy'') + (level - 1),''dd'') days from holidays ';
        v_stmt := v_stmt || ' where yyyymm = ''' || p_yyyymm || ''' ';
        v_stmt := v_stmt || ' connect by level <= 1 order by holiday) ';
        Open p_dayslist For v_stmt;
    End get_holidays;

    Procedure get_costcode(
        p_empno    In  Varchar2,
        p_yymm     In  Varchar2,
        p_costcode Out Sys_Refcursor
    ) As
        v_mst_stmt Varchar2(8000) := Null;
        vschema    Varchar(10)    := 'TIME' || substr(p_yymm, 0, 4) || '.';
        vyear      Varchar(5);
    Begin

        Select
            Case
                When to_char(substr(p_yymm, 5, 2)) > '03' Then
                    to_char(substr(p_yymm, 0, 4))
                Else
                    to_char(To_Number(substr(p_yymm, 0, 4)) - 1)
            End As fy
        Into
            vyear
        From
            dual;

        vschema    := 'TIME' || substr(vyear, 0, 4) || '.';

        If substr(vyear, 0, 4) = substr(to_char(sysdate, 'YYYYMM'), 0, 4) Then
            vschema := '';
        ElsIf substr(vyear, 0, 4) + 1 = substr(to_char(sysdate, 'YYYYMM'), 0, 4) Then
            vschema := '';
        End If;

        v_mst_stmt := ' SELECT distinct td.assign assign ';
        v_mst_stmt := v_mst_stmt || ' FROM ' || vschema || 'VU_time_daily td ';
        v_mst_stmt := v_mst_stmt || ' where td.yymm=''' || p_yymm || ''' ';
        v_mst_stmt := v_mst_stmt || ' and td.empno=''' || p_empno || ''' ';

        Open p_costcode For v_mst_stmt;
    End get_costcode;

End rap_timesheet;