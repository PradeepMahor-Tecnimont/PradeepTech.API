create or replace package body "RAP_REPORTS_PROJECT" as

   procedure rpt_proj_emp_typ_upd_tm11b(
      p_activeyear in  varchar2,
      p_yymm       in  varchar2,
      p_projno5    in Varchar2,
      p_rec        out sys_refcursor
   ) as
      p_insert_query varchar2(10000);
      p_success      varchar2(2);
      p_message      varchar2(1000);
   begin
      --Load GTT
      rap_gtt.get_insert_query_4_gtt(p_activeyear, 'PROJ_EMP_TYP_UPD_TM11B', p_insert_query, p_success, p_message);
      if p_success = 'OK' then
         execute immediate p_insert_query || ' where yymm = :p_yymm and projno5 = :p_projno5 '
            using p_yymm, p_projno5;
         open p_rec for
            select proj_emp_typ_upd_tm11b.newcostcode,
                   proj_emp_typ_upd_tm11b.emptype,
                   proj_emp_typ_upd_tm11b.yymm,
                   proj_emp_typ_upd_tm11b.costcode,
                   proj_emp_typ_upd_tm11b.activity,
                   proj_emp_typ_upd_tm11b.parent,
                   proj_emp_typ_upd_tm11b.parentname,
                   proj_emp_typ_upd_tm11b.tcmno,
                   proj_emp_typ_upd_tm11b.projno5,
                   proj_emp_typ_upd_tm11b.projno,
                   proj_emp_typ_upd_tm11b.PROJNAME,
                   proj_emp_typ_upd_tm11b.wpcode,
                   proj_emp_typ_upd_tm11b.empno,
                   proj_emp_typ_upd_tm11b.name emp_name,
                   proj_emp_typ_upd_tm11b.vendor,
                   proj_emp_typ_upd_tm11b.phasedescription,
                   proj_emp_typ_upd_tm11b.hours,
                   proj_emp_typ_upd_tm11b.othours,
                   proj_emp_typ_upd_tm11b.totalhrs
              from rap_gtt_proj_emp_typ_upd_tm11b proj_emp_typ_upd_tm11b
             order by proj_emp_typ_upd_tm11b.empno;
      end if;
   end;


  Procedure rpt_proj_emp_typ_upd(
        p_activeyear In  Varchar2,
        p_yymm       In  Varchar2,
        p_yearmode   In  Varchar2,
        p_costcode   In  Varchar2,
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
            Execute Immediate p_insert_query || ' where costcode = :p_costcode And yymm >= :p_start_yymm And yymm <= :p_yymm'
                Using p_costcode, p_start_yymm, p_yymm;
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
                    proj_emp_typ_upd.empno || ' - ' || proj_emp_typ_upd.name empno,                    
                    proj_emp_typ_upd.vendor,
                    proj_emp_typ_upd.hours,
                    proj_emp_typ_upd.othours,
                    proj_emp_typ_upd.totalhrs
                From
                    rap_gtt_proj_emp_typ_upd proj_emp_typ_upd
                Order By
                    proj_emp_typ_upd.yymm, proj_emp_typ_upd.projno, proj_emp_typ_upd.empno, proj_emp_typ_upd.wpcode;
        End If;
    End;

    Procedure rpt_proj_emp(
        p_yymm       In  Varchar2,
        p_projno     In  Varchar2,
        p_costcode   In  Varchar2,
        p_rec        Out Sys_Refcursor
    ) As
        p_insert_query Varchar2(10000);
        p_success      Varchar2(2);
        p_message      Varchar2(1000);
        p_start_yymm   Varchar2(6);
    Begin

            Open p_rec For
                Select
                    e.emptype,
                    ttc.yymm,
                    ttc.costcode,
                    Substr(ttc.projno,1,5) projno5,
                    ttc.projno,
                    p.name,
                    ttc.wpcode,
                    ttc.empno || ' - ' || e.name empno,      
                    ttc.hours,
                    ttc.othours,
                    nvl(ttc.hours,0) + nvl(ttc.othours,0) totalhrs
                From
                    timetran_combine ttc,
                    emplmast e,
                    projmast p
                Where e.empno = ttc.empno
                    And p.projno = ttc.projno
                    And ttc.projno = p_projno
                    And ttc.costcode = p_costcode
                    And ttc.yymm <= p_yymm
                Order By
                    ttc.yymm, ttc.projno, ttc.empno, ttc.wpcode;
       
    End;

end rap_reports_project;