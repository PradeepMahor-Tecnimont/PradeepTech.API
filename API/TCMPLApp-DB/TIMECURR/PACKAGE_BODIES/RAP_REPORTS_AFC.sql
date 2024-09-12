Create Or Replace Package Body "TIMECURR"."RAP_REPORTS_AFC" As

    Procedure rpt_auditor(
        p_activeyear In  Varchar2,
        p_yymm       In  Varchar2,
        p_yearmode   In  Varchar2,
        p_rec        Out Sys_Refcursor
    ) As
        p_insert_query Varchar2(10000);
        p_success      Varchar2(2);
        p_message      Varchar2(1000);
        p_start_yymm   Varchar2(6);
    Begin
        p_start_yymm := rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode);
        --Load GTT
        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'AUDITOR', p_insert_query, p_success, p_message);
        If p_success = 'OK' Then
            Execute Immediate p_insert_query || ' where yymm >= :p_start_yymm And yymm <= :p_yymm'
                Using p_start_yymm, p_yymm;
            Open p_rec For
                Select
                    Trim(auditor.company) company,
                    Trim(auditor.tmagrp) tmagrp,
                    Trim(auditor.emptype) emptype,
                    Trim(auditor.location) location,
                    auditor.yymm,
                    auditor.parent,
                    auditor.costcode,
                    auditor.tcm_jobs,
                    auditor.projno5,
                    auditor.projno,
                    auditor.name projname,
                    auditor.hours,
                    auditor.othours,
                    auditor.tothours
                From
                    rap_gtt_auditor auditor
                Order By
                    auditor.yymm Desc;
        End If;
    End;

    Procedure rpt_finance_ts(
        p_activeyear In  Varchar2,
        p_yymm       In  Varchar2,
        p_yearmode   In  Varchar2,
        p_rec        Out Sys_Refcursor
    ) As
        p_insert_query Varchar2(10000);
        p_success      Varchar2(2);
        p_message      Varchar2(1000);
        p_start_yymm   Varchar2(6);
    Begin
        p_start_yymm := rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode);
        --Load GTT
        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'FINANCE_TS', p_insert_query, p_success, p_message);
        If p_success = 'OK' Then
            Execute Immediate p_insert_query || ' where yymm >= :p_start_yymm And yymm <= :p_yymm'
                Using p_start_yymm, p_yymm;
            Open p_rec For
                Select
                    finance_ts.tmagroup,
                    finance_ts.emptype,
                    finance_ts.empno,
                    finance_ts.name,
                    finance_ts.tcmno,
                    finance_ts.projno5,
                    finance_ts.projno,
                    finance_ts.projname,
                    finance_ts.yymm,
                    finance_ts.costcode,
                    finance_ts.parent,
                    finance_ts.hours,
                    finance_ts.othours,
                    (finance_ts.hours + finance_ts.othours) totalhours
                From
                    rap_gtt_finance_ts finance_ts
                Order By
                    finance_ts.yymm Desc;
        End If;
    End;

    Procedure rpt_proj_emp_typ_upd(
        p_activeyear In  Varchar2,
        p_yymm       In  Varchar2,
        p_yearmode   In  Varchar2,
        p_rec        Out Sys_Refcursor
    ) As
        p_insert_query Varchar2(10000);
        p_success      Varchar2(2);
        p_message      Varchar2(1000);
        p_start_yymm   Varchar2(6);
    Begin
        p_start_yymm := rap_reports_gen.get_yymm_begin(p_yymm, p_yearmode);
        --Load GTT
        rap_gtt.get_insert_query_4_gtt(p_activeyear, 'PROJ_EMP_TYP_UPD', p_insert_query, p_success, p_message);
        If p_success = 'OK' Then
            Execute Immediate p_insert_query || ' where yymm >= :p_start_yymm And yymm <= :p_yymm'
                Using p_start_yymm, p_yymm;
            Open p_rec For
                Select
                    proj_emp_typ_upd.tmagrp,
                    proj_emp_typ_upd.emptype,
                    proj_emp_typ_upd.yymm,
                    proj_emp_typ_upd.costcode,
                    proj_emp_typ_upd.tcmno,
                    proj_emp_typ_upd.projno5,
                    proj_emp_typ_upd.projno,
                    proj_emp_typ_upd.projname,
                    proj_emp_typ_upd.wpcode,
                    proj_emp_typ_upd.empno,
                    proj_emp_typ_upd.name emp_name,
                    proj_emp_typ_upd.vendor,
                    proj_emp_typ_upd.hours,
                    proj_emp_typ_upd.othours,
                    proj_emp_typ_upd.totalhrs
                From
                    rap_gtt_proj_emp_typ_upd proj_emp_typ_upd
                Order By
                    proj_emp_typ_upd.yymm Desc;
        End If;
    End;

    Procedure rpt_manhour_export_to_sap(
        p_yymm       In  Varchar2,
        p_reporttype In  Varchar2,
        p_costcode   In  Varchar2,
        p_projno     In  Varchar2,
        p_emptype    In  Varchar2,
        p_all        Out Sys_Refcursor,
        p_all_neg    Out Sys_Refcursor,
        p_dept       Out Sys_Refcursor,
        p_dept_neg   Out Sys_Refcursor,
        p_custom     Out Sys_Refcursor,
        p_custom_ng  Out Sys_Refcursor
    ) As
        p_query   Varchar2(4000);
        p_query_1 Varchar2(4000);
        p_query_2 Varchar2(4000);
        p_query_3 Varchar2(4000);
        p_order   Varchar2(1000);
    Begin
        p_query   := 'select rpad(recordtype,1) || rpad(workingdept,10) || rpad(period,6) || 
                        rpad(empno,6) || rpad(deptofemployee,10) || rpad(companycode,6) || 
                        rpad(project,16) ||rpad(gt,1)|| rpad(pt,2) || rpad(dt,3) || 
                        lpad(activity,1) || lpad(ordernumber,10) || lpad(hours!#!,6)||
                        lpad(siteactivity,1) || lpad(orderline,5) || ''+'' || lpad(qty,4,''0'' ) ||
                        ''.00'' || lpad(itemserviceno,20) || rpad(name,20)  || lpad(penalty,3,''0'') || 
                        lpad(forcingcode,1,'' '') as line1 
                    from 
                        sap_tcm        
                    where 
                        yymm = ''' || p_yymm || ''' and substr(empno,1,2) <> ''CE'' ';
        p_order   := ' order by workingdept, period ';
                
        -->>>> rpt 1 
        -- All Dept +  All GRP + All Emptype
        p_query_1 := p_query;
        
        -->>>> rpt 2
        -- GRP <> D
        -- Dept 0238, 0245, 0291 + GRP = D + All emptype
        -- Dept other than 0238, 0245, 0291 + GRP = D + Emptype = R, F
        p_query_2 := p_query || ' and grp <> ''D'' UNION ALL ';
        p_query_2 := p_query_2 || p_query || ' and workingdept in (select sapcc from costmast where costcode in (''0238'', ''0245'', ''0291'')) and grp = ''D'' UNION ALL ';
        p_query_2 := p_query_2 || p_query || ' and workingdept not in (select sapcc from costmast where costcode in (''0238'', ''0245'', ''0291'')) and grp = ''D'' and emptype in (''R'', ''F'')';

        p_query_2 := p_query_2;
        
        -->>>> rpt 3 
        -- Costcode or Project        
        If p_reporttype = 'C' Or p_reporttype = 'P' Then
            If p_reporttype = 'C' Then
                p_query := p_query || ' and workingdept = rap_reports_gen.get_sap_codecode(''' || p_costcode || ''') ';
            End If;

            If p_reporttype = 'P' Then
                p_query := p_query || ' and projno = ''' || p_projno || ''' ';
            End If;

            p_query   := p_query || ' and emptype in (select regexp_substr(''' || p_emptype || ''',''[^,]+'', 1, level) 
                                    from dual connect by
                                    regexp_substr(''' ||
                         p_emptype || ''', ''[^,]+'', 1, level) is not null) ';
            p_query_3 := p_query;
        End If;
                
        --DBMS_OUTPUT.PUT_LINE(replace(p_query_2,'!#!','*-1'));

        Open p_all For replace(p_query_1, '!#!', '');
        Open p_all_neg For replace(p_query_1, '!#!', '*-1');
        Open p_dept For replace(p_query_2, '!#!', '');
        Open p_dept_neg For replace(p_query_2, '!#!', '*-1');

        If p_reporttype = 'C' Or p_reporttype = 'P' Then
            Open p_custom For replace(p_query_3, '!#!', '');
            Open p_custom_ng For replace(p_query_3, '!#!', '*-1');
        End If;

    End rpt_manhour_export_to_sap;
End rap_reports_afc;