--------------------------------------------------------
--  DDL for Package Body NGTS_PRADEEP_OLD
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."NGTS_PRADEEP_OLD" AS

    PROCEDURE ngts_getsubordinateemplist (
        p_empno                IN    VARCHAR2,
        p_dept                 IN    VARCHAR2,
        p_subordinateemplist   OUT   SYS_REFCURSOR
    ) AS
        v_stmt    VARCHAR2(1000) := NULL;
        v_count   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO v_count
        FROM
            --ngts_user_dept_roles
            timecurr.NGTS_VUSER_DEPT_ROLES
        WHERE
            deptno = p_dept
            AND empno = p_empno;
        --  roleid = 'R3'            AND 

        IF ( v_count > 0 ) THEN    
        -------For Proxy - HOD-------
            v_stmt := ' SELECT  DISTINCT  E.empno, E.name ,  E.email,    E.parent  ,E.COMPANY ,E.DESGCODE , E.GRADE , ';
            v_stmt := v_stmt || '  (SELECT desg FROM desgmast where desgcode = E.DESGCODE ) DESGName ,';
            v_stmt := v_stmt || '  (select DISTINCT abbr  from costmast where costcode  = E.parent ) parentabbr ';
            v_stmt := v_stmt || ' FROM    emplmast E ';
            v_stmt := v_stmt || ' where E.status=1 ';
            v_stmt := v_stmt
                      || ' and E.parent=''' || p_dept || ''' ';
        ELSE
        -------For HOD-------
           v_stmt := ' SELECT  DISTINCT  E.empno, E.name ,  E.email,    E.parent  ,E.COMPANY ,E.DESGCODE , E.GRADE , ';
            v_stmt := v_stmt || '  (SELECT desg FROM desgmast where desgcode = E.DESGCODE ) DESGName , ';
            v_stmt := v_stmt || '  (select DISTINCT abbr  from costmast where costcode =  E.parent ) parentabbr ';
            v_stmt := v_stmt || ' FROM    emplmast E ';
            v_stmt := v_stmt || ' where E.status=1 ';
            v_stmt := v_stmt || ' and E.parent=''' || p_dept || ''' ';
            --and E.emp_hod=''' || p_empno || '''

        END IF;

        OPEN p_subordinateemplist FOR v_stmt;

    END ngts_getsubordinateemplist;
    
   PROCEDURE ngts_getcostcode (
        p_dept           IN    VARCHAR2,
        p_costcodelist   OUT   SYS_REFCURSOR
    ) AS
        v_stmt    VARCHAR2(1000) := NULL;
        v_count   NUMBER;
    BEGIN
        v_stmt := ' SELECT  DISTINCT  costcode , name , abbr deptabbr ';
        --v_stmt := v_stmt || '  (select DISTINCT abbr  from costmast where costcode  = E.parent ) deptabbr ';
        v_stmt := v_stmt || '  FROM     costmast ';        
        v_stmt := v_stmt || ' where active =1 and costcode != ''' || p_dept || ''' ';
        v_stmt := v_stmt || ' and costcode like ''02%'' order by name , costcode ';
        OPEN p_costcodelist FOR v_stmt;

    END ngts_getcostcode; 
 ----Pradeep Mahor--------     

    PROCEDURE ngts_gettimesheet (
        p_empno         IN    VARCHAR2,
        p_costcode      IN    VARCHAR2,
        p_yymm          IN    VARCHAR2,
        p_time_master   OUT   SYS_REFCURSOR,
        p_time_daily    OUT   SYS_REFCURSOR,
        p_time_ot       OUT   SYS_REFCURSOR,
        p_Total   OUT   SYS_REFCURSOR
    ) AS

        v_mst_stmt     VARCHAR2(8000) := NULL;
        v_daily_stmt   VARCHAR2(8000) := NULL;
        v_ot_stmt      VARCHAR2(8000) := NULL;
        v_total_stmt     VARCHAR2(8000) := NULL;
        v_count        NUMBER;
    BEGIN
        v_mst_stmt := ' SELECT distinct TM.yymm, TM.empno, TM.parent, TM.assign, TM.posted, TM.approved, TM.locked, ';
        v_mst_stmt := v_mst_stmt || ' ngts_bulk_timesheet.getPMApprovalStatus(TM.yymm, TM.empno, TM.assign) PMApprovalStatus ,';
        v_mst_stmt := v_mst_stmt || ' case when TM.posted = 1 then 5 when TM.approved = 1 then 3   ';
        v_mst_stmt := v_mst_stmt || ' when TM.locked = 1 then 2  else 1 end as Status , TM.company, ';
        v_mst_stmt := v_mst_stmt || ' TM.grp, TM.tot_nhr, TM.tot_ohr, TM.remark  ';        
        v_mst_stmt := v_mst_stmt || ' FROM time_mast TM ';
        v_mst_stmt := v_mst_stmt || ' where TM.yymm=''' || p_yymm || ''' '; 
        v_mst_stmt := v_mst_stmt|| ' and TM.assign=''' || p_costcode || ''' ';
        v_mst_stmt := v_mst_stmt || ' and TM.empno=''' || p_empno || ''' ';
     
    --  v_Daily_stmt :=  ' SELECT  TD.yymm,    TD.empno,    TD.parent,    TD.assign,    TD.projno,    TD.wpcode,    TD.activity, ';
    --v_Daily_stmt := v_Daily_stmt || ' TD.d1,  TD.d2,  TD.d3,  TD.d4,  TD.d5,  TD.d6,  TD.d7,  TD.d8,  TD.d9,  TD.d10, TD.d11, TD.d12, TD.d13, TD.d14, TD.d15, ';
    --v_Daily_stmt := v_Daily_stmt || ' TD.d16, TD.d17, TD.d18, TD.d19, TD.d20, TD.d21, TD.d22, TD.d23, TD.d24, TD.d25, TD.d26, TD.d27, TD.d28, TD.d29, ';
        v_daily_stmt := ' SELECT    TD.projno,    TD.wpcode,   trim( TD.activity) activity , ';
        v_daily_stmt := v_daily_stmt || '   TD.total, TD.grp, TD.company,   ';
        v_daily_stmt := v_daily_stmt || '   CASE ';
        v_daily_stmt := v_daily_stmt || '      WHEN Nvl(P.timesheet_appr, 0) = 1 AND Nvl(TD.pmapproved, 0) = 1 THEN 1 ';
        v_daily_stmt := v_daily_stmt || '      WHEN Nvl(P.timesheet_appr, 0) = 1 AND Nvl(TD.pmapproved, 0) = 0 THEN 0 ';
        v_daily_stmt := v_daily_stmt || '      WHEN Nvl(P.timesheet_appr, 0) = 0 AND Nvl(TD.pmapproved, 0) = 0 THEN -1 ';
        v_daily_stmt := v_daily_stmt || '   END PMAPPROVED ' ;                    
        v_daily_stmt := v_daily_stmt || ' , ( SELECT  ''[''|| nvl(d1, ''0'') ||'',''||   nvl(d2, ''0'')  ||'',''||    nvl(d3, ''0'')  ||'',''||    nvl(d4, ''0'') ||'',''||    nvl(d5, ''0'')  ||'',''||   
     nvl(d6, ''0'') ||'',''||  nvl( d7, ''0'')  ||'',''|| 
     nvl(d8, ''0'')  ||'',''|| nvl(d9, ''0'')  ||'',''||   nvl(d10, ''0'')  ||'',''||   nvl(d11, ''0'')  ||'',''||  nvl(d12, ''0'') ||'',''||  
     nvl(d13, ''0'') ||'',''||    nvl(d14, ''0'') ||'',''||  nvl(d15, ''0'') ||'',''||
     nvl(d16, ''0'')  ||'',''||   nvl( d17, ''0'') ||'',''||   nvl( d18, ''0'') ||'',''||    nvl(d19, ''0'') ||'',''||    nvl(d20, ''0'') ||'',''|| nvl(d21, ''0'') ||'',''||  
     nvl(d22, ''0'') ||'',''||    nvl(d23, ''0'') ||'',''|| 
     nvl(d24, ''0'') ||'',''||   nvl( d25, ''0'') ||'',''||    nvl(d26, ''0'') ||'',''||    nvl(d27, ''0'') ||'',''||   nvl( d28, ''0'') ||'',''||
     nvl(d29, ''0'') ||'',''||   nvl( d30, ''0'') ||'',''||    nvl(d31, ''0'')  || '']''
        FROM    time_daily  where    yymm='''|| p_yymm || ''' and  WPCODE = TD.WPCODE and  ACTIVITY = TD.ACTIVITY and assign=''' || p_costcode || '''  and empno='''
                        || p_empno || '''  and projno = TD.projno ) as Daily_hours  ';

        v_daily_stmt := v_daily_stmt || ' FROM time_daily TD, projmast P ';
        v_daily_stmt := v_daily_stmt || ' where  TD.PROJNO = P.PROJNO AND TD.yymm=''' || p_yymm || ''' ';
        v_daily_stmt := v_daily_stmt || ' and   TD.assign=''' || p_costcode || ''' ';
        v_daily_stmt := v_daily_stmt || ' and    TD.empno=''' || p_empno || ''' ';
     
        v_ot_stmt := ' SELECT  OT.projno,    OT.wpcode,   trim( OT.activity) activity, ';
        v_ot_stmt := v_ot_stmt || '  OT.total, OT.grp, OT.company, ';
        v_ot_stmt := v_ot_stmt || '   CASE ';
        v_ot_stmt := v_ot_stmt || '      WHEN Nvl(P.timesheet_appr, 0) = 1 AND Nvl(OT.pmapproved, 0) = 1 THEN 1 ';
        v_ot_stmt := v_ot_stmt || '      WHEN Nvl(P.timesheet_appr, 0) = 1 AND Nvl(OT.pmapproved, 0) = 0 THEN 0 ';
        v_ot_stmt := v_ot_stmt || '      WHEN Nvl(P.timesheet_appr, 0) = 0 AND Nvl(OT.pmapproved, 0) = 0 THEN -1 ';
        v_ot_stmt := v_ot_stmt || '   END PMAPPROVED ' ;                            
        v_ot_stmt := v_ot_stmt || ' , ( SELECT  ''[''|| nvl(d1, ''0'') ||'',''||   nvl(d2, ''0'')  ||'',''||    nvl(d3, ''0'')  ||'',''||    nvl(d4, ''0'') ||'',''||    nvl(d5, ''0'')  ||'',''||   
     nvl(d6, ''0'') ||'',''||  nvl( d7, ''0'')  ||'',''|| 
     nvl(d8, ''0'')  ||'',''|| nvl(d9, ''0'')  ||'',''||   nvl(d10, ''0'')  ||'',''||   nvl(d11, ''0'')  ||'',''||  nvl(d12, ''0'') ||'',''||  
     nvl(d13, ''0'') ||'',''||    nvl(d14, ''0'') ||'',''||  nvl(d15, ''0'') ||'',''||
     nvl(d16, ''0'')  ||'',''||   nvl( d17, ''0'') ||'',''||   nvl( d18, ''0'') ||'',''||    nvl(d19, ''0'') ||'',''||    nvl(d20, ''0'') ||'',''|| nvl(d21, ''0'') ||'',''||  
     nvl(d22, ''0'') ||'',''||    nvl(d23, ''0'') ||'',''|| 
     nvl(d24, ''0'') ||'',''||   nvl( d25, ''0'') ||'',''||    nvl(d26, ''0'') ||'',''||    nvl(d27, ''0'') ||'',''||   nvl( d28, ''0'') ||'',''||
     nvl(d29, ''0'') ||'',''||   nvl( d30, ''0'') ||'',''||    nvl(d31, ''0'')  || '']''
        FROM    time_ot  where    yymm='''|| p_yymm || ''' and   WPCODE = OT.WPCODE and  ACTIVITY = OT.ACTIVITY   and assign=''' || p_costcode || '''  and empno='''
                        || p_empno || '''  and projno = OT.projno ) as OT_hours ';     
        v_ot_stmt := v_ot_stmt || ' FROM    time_ot  OT, projmast P ';
        v_ot_stmt := v_ot_stmt || ' where  OT.PROJNO = P.PROJNO AND  OT.yymm=''' || p_yymm || ''' ';
        v_ot_stmt := v_ot_stmt || ' and   OT.assign=''' || p_costcode || ''' ';
        v_ot_stmt := v_ot_stmt || ' and    OT.empno=''' || p_empno || ''' ';
        
            v_total_stmt := v_total_stmt || '
                    SELECT DISTINCT ( 
                                        (select NVL( sum(NT.TOTAL), ''0'') from time_daily NT where NT.yymm=TM.yymm and NT.empno= TM.empno and NT.assign =TM.assign ) +  
                                        (select NVL( sum(NT.TOTAL), ''0'') from time_daily NT where NT.yymm=TM.yymm and NT.empno= TM.empno and NT.assign != TM.assign ) 
                                    )   totalNormalHours  '; 
        v_total_stmt := v_total_stmt || ' FROM time_mast TM ';
        v_total_stmt := v_total_stmt || ' where TM.yymm=''' || p_yymm || ''' '; 
        v_total_stmt := v_total_stmt || ' and TM.empno=''' || p_empno || ''' ';
        
        OPEN p_time_master FOR v_mst_stmt;

        OPEN p_time_daily FOR v_daily_stmt;

        OPEN p_time_ot FOR v_ot_stmt;

        OPEN p_Total FOR v_total_stmt;
    END ngts_gettimesheet;

    FUNCTION ts_delete_status (
        p_year    IN   VARCHAR2,
        p_empno   IN   VARCHAR2
    ) RETURN NUMBER AS
        vntcount   NUMBER;
        votcount   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO vntcount
        FROM
            time_daily
        WHERE
            substr(yymm, 0, 4) = p_year
            AND empno = p_empno;

        SELECT
            COUNT(*)
        INTO votcount
        FROM
            time_ot
        WHERE
            substr(yymm, 0, 4) = p_year
            AND empno = p_empno;

        IF ( vntcount <= 0 AND votcount <= 0 ) THEN
            RETURN 1;
        END IF;

        RETURN 0;
    END ts_delete_status;

    FUNCTION get_total (
        p_total_for   IN   VARCHAR2,
        p_yymm        IN   VARCHAR2,
        p_empno       IN   VARCHAR2,
        p_parent      IN   VARCHAR2,
        p_assign      IN   VARCHAR2,
        p_project     IN   VARCHAR2
    ) RETURN NUMBER AS
        vrval      NUMBER;
        votcount   NUMBER;
    BEGIN
        IF ( p_total_for = 'NT' ) THEN
            SELECT
                nvl(SUM(nt.total), '0')
            INTO vrval
            FROM
                time_daily nt
            WHERE
                nt.yymm = p_yymm
                AND nt.empno = p_empno
                AND nt.parent = p_parent
                AND nt.assign = p_assign;

        END IF;

        IF ( p_total_for = 'OT' ) THEN
            SELECT
                nvl(SUM(ot.total), '0')
            INTO vrval
            FROM
                time_ot ot
            WHERE
                ot.yymm = p_yymm
                AND ot.empno = p_empno
                AND ot.parent = p_parent
                AND ot.assign = p_assign;

        END IF;

        RETURN vrval;
          ----------------------------------
    /*  if ( p_assign = p_parent and p_Total_FOR = 'NT') then 
         
              select NVL( sum(NT.TOTAL), '0') into vRval from time_daily NT 
              where NT.yymm=p_yymm 
              and NT.empno= p_empno and NT.parent = NT.assign ;
              
        end if;
        
          if ( p_assign != p_parent and p_Total_FOR = 'NT') then 
         
              select NVL(  sum(NT.TOTAL), '0') into vRval from time_daily NT 
              where NT.yymm=p_yymm 
              and NT.empno= p_empno and NT.parent =p_parent and  NT.assign =p_assign;
              
        end if;
        
       if ( p_assign = p_parent and p_Total_FOR = 'OT') then 
         
             select  NVL( sum(OT.TOTAL), '0') into vRval from time_OT OT 
              where OT.yymm=p_yymm 
              and OT.empno= p_empno and OT.parent = OT.assign ;
              
        end if;
        
          if ( p_assign != p_parent and p_Total_FOR = 'OT') then 
         
             select  NVL( sum(OT.TOTAL), '0') into vRval from time_OT OT 
              where OT.yymm=p_yymm 
              and OT.empno= p_empno and OT.parent != OT.assign ;
              
        end if;
        */
        RETURN vrval;
    END get_total;

    PROCEDURE ngts_get_emptimesheetlist (
        p_empno              IN    VARCHAR2,
        p_fromyear           IN    VARCHAR2,
        p_toyear             IN    VARCHAR2,
        p_emptimesheetlist   OUT   SYS_REFCURSOR
    ) AS
        v_stmt    VARCHAR2(1000) := NULL;
        v_count   NUMBER;
    BEGIN
        v_stmt := '   SELECT  DISTINCT  TT.yymm, trim(  to_char(to_date(SUBSTR(TT.yymm,5,6), ''MM''), ''Month'') )Month , ';
        v_stmt := v_stmt || '    TT.empno,    TT.parent,    TT.assign, ';
        v_stmt := v_stmt || ' ngts_bulk_timesheet.getPMApprovalStatus(TT.yymm, TT.empno, TT.assign) PMApprovalStatus ,';        
        v_stmt := v_stmt || '  (select DISTINCT abbr  from costmast where costcode  = TT.assign ) deptabbr , ';
        v_stmt := v_stmt || '       TT.locked,    TT.approved,    TT.posted,    ';
        v_stmt := v_stmt || '       case when TT.posted = 1 then 5 when TT.approved = 1 then 3 ';
        v_stmt := v_stmt || '       when TT.locked = 1 then 2  else 1 end as Status ,';
        v_stmt := v_stmt || '        TT.appr_on,           ';
 --  v_stmt := v_stmt || '        (select NVL( sum(NT.TOTAL), ''0'') from time_daily NT where NT.yymm=TT.yymm and NT.empno=''' || p_empNo || ''' ) NT_TOTAL ,  ';      
  -- v_stmt := v_stmt || '        (select  NVL( sum(OT.TOTAL), ''0'') from time_OT OT where OT.yymm=TT.yymm and OT.empno=''' || p_empNo || ''') OT_TOTAL , ';
        v_stmt := v_stmt || '       ngts_pradeep_old.Get_total(''NT'',TT.yymm,TT.empno, TT.parent,TT.assign,''Proj'')NT_TOTAL , ';
        v_stmt := v_stmt || '       ngts_pradeep_old.Get_total(''OT'',TT.yymm,TT.empno, TT.parent,TT.assign,''Proj'')OT_TOTAL , ';
  -- 
        v_stmt := v_stmt || '        TT.company,     case when TT.parent =  TT.assign then ''Normal'' else ''ODD'' end Type ,';
        v_stmt := v_stmt || '       TT.grp,  TT.tot_nhr,  TT.tot_ohr         ';
        v_stmt := v_stmt || '    FROM  ';
        v_stmt := v_stmt || '        time_mast TT where ';
        v_stmt := v_stmt || '     TT.yymm >= ''' || p_fromyear || '''  and TT.yymm <= ''' || p_toyear || '''  ';

        v_stmt := v_stmt || '   and  TT.empno=''' || p_empno || ''' ';
       -- v_stmt := v_stmt || '    and ngts_pradeep_old.TS_DELETE_STATUS(SUBSTR(''' || p_fromyear || ''',0,4),''' || p_empno || ''') = 0 ';

        v_stmt := v_stmt || '    order BY TT.yymm   ';
        OPEN p_emptimesheetlist FOR v_stmt;

    END ngts_get_emptimesheetlist;

    PROCEDURE ngts_GetListofTSForApprl (
        p_yymm             IN    VARCHAR2,
        p_dept             IN    VARCHAR2 DEFAULT NULL,
        p_empno            IN    VARCHAR2,
        p_status           IN    NUMBER DEFAULT NULL,
        p_Office           IN    VARCHAR2,
        p_projno           IN    VARCHAR2 DEFAULT NULL,
        p_WHlist           OUT   SYS_REFCURSOR,
        p_tsforapprllist   OUT   SYS_REFCURSOR
    ) AS
      
       
v_stmt    VARCHAR2(8000) := NULL;
        v_WH_stmt    VARCHAR2(8000) := NULL;
        v_count   NUMBER;
    BEGIN
        IF p_projno IS NOT NULL THEN                                                    
            p_whlist := ngts_getWorkingHours(p_yymm, p_empno);
            p_tsforapprllist := ngts_getProjTimeSheetDetails(p_yymm, p_empno, p_projno);           
        ELSE
             v_WH_stmt := '  SELECT        working_hrs Actual_Working_Hours FROM    wrkhours where yymm =''' || p_yymm || ''' and  office=''' || p_Office || '''    ';
       
            v_stmt := ' SELECT DISTINCT TT.yymm, trim(  to_char(to_date(SUBSTR(TT.yymm,5,6), ''MM''), ''Month'') )Month , ';
            v_stmt := v_stmt || ' ngts_pradeep_old.Get_emp_Name(TT.empno) Employee, ';
            v_stmt := v_stmt || ' ngts_bulk_timesheet.getPMApprovalStatus(TT.yymm, TT.empno, TT.assign) PMApprovalStatus , null assign, TT.empno , '; 
            v_stmt := v_stmt || ' case when ( TT.assign != trim(''' || p_dept || ''') and  TT.parent = trim(''' || p_dept || ''') ) then 7 ';
            v_stmt := v_stmt || '      when TT.posted = 1 then 5 ';
            v_stmt := v_stmt || '      when TT.approved = 1 then 3 ';
            v_stmt := v_stmt || '      when TT.locked = 1 then 2 ';
            v_stmt := v_stmt || '      else 1 end as Status ,  ' ;			
            v_stmt := v_stmt || ' (select NVL( sum(NT.TOTAL), ''0'') from time_daily NT where NT.yymm=TT.yymm and NT.empno= TT.empno and NT.assign =trim(''' || p_dept || ''') ) NT_TOTAL ,   ';
            v_stmt := v_stmt || ' (select NVL( sum(OT.TOTAL), ''0'') from time_OT OT where OT.yymm=TT.yymm and OT.empno= TT.empno and OT.assign = trim(''' || p_dept || ''') ) OT_TOTAL ,   ';
            v_stmt := v_stmt || ' (select NVL( sum(NT.TOTAL), ''0'') from time_daily NT where NT.yymm=TT.yymm and NT.empno= TT.empno and NT.assign != trim(''' || p_dept || ''') ) Others_NT_TOTAL , ';
            v_stmt := v_stmt || ' (select NVL( sum(OT.TOTAL), ''0'') from time_OT OT where OT.yymm=TT.yymm and OT.empno= TT.empno and OT.assign != trim(''' || p_dept || ''') ) Others_OT_TOTAL , ';				
			v_stmt := v_stmt || '  E.empno, E.name ,  E.email,    E.parent  ,E.COMPANY ,E.DESGCODE , E.GRADE ,(SELECT      desg FROM    desgmast where desgcode = E.DESGCODE ) DESGName , ';
			v_stmt := v_stmt || ' (select DISTINCT abbr  from costmast where costcode  = E.parent ) parentabbr   ';
			v_stmt := v_stmt || ' FROM   ngts_vtime_mast TT, emplmast E ';
			v_stmt := v_stmt || ' where TT.yymm = ''' || p_yymm || ''' and E.status=1 and E.empno=TT.empno  ';
            v_stmt := v_stmt || ' and TT.parent = trim(''' || p_dept || ''')  ';           			
			
            IF ( p_status = 1 ) THEN -- Open
                v_stmt := v_stmt || ' and TT.locked = 0 ';
            END IF;
            
            IF ( p_status = 2 ) THEN -- locked
              --  v_stmt := v_stmt || ' and TT.locked = 1 ';
                v_stmt := v_stmt || ' and TT.approved = 0  ';
                v_stmt := v_stmt || ' and TT.posted = 0 ';
            END IF;
            
            IF ( p_status = 3 ) THEN --
                --v_stmt := v_stmt || ' and TT.approved = 1  ';
                v_stmt := v_stmt || ' and TT.posted = 0 ';
            END IF;
            
            IF ( p_status = 4 ) THEN
                v_stmt := v_stmt || ' and TT.approved = 0  ';
            END IF;
            
            IF ( p_status = 5 ) THEN
               -- v_stmt := v_stmt || ' and TT.posted = 1 ';
               null;
            END IF;
            IF ( p_status = 6 ) THEN
              v_stmt := v_stmt || ' and TT.posted = 0 ';
            END IF;
    
    /* */
            v_stmt := v_stmt || ' UNION   All  ';
         v_stmt := v_stmt || ' SELECT ''' || p_yymm || ''' yymm , trim(  to_char(to_date(SUBSTR(''' || p_yymm || ''',5,6), ''MM''), ''Month'') ) Month, ';
         v_stmt := v_stmt || ' ngts_pradeep_old.Get_emp_Name(a.empno) Employee ,   ';
         v_stmt := v_stmt || ' -1 PMApprovalStatus , null assign ,  '; 
         v_stmt := v_stmt || ' a.empno ,  0 Status , 0 NT_TOTAL, 0 OT_TOTAL , 0 Others_NT_TOTAL , 0 Others_OT_TOTAL , ';
         
         
		 v_stmt := v_stmt || '    a.empno, a.name ,  a.email,    a.parent  ,a.COMPANY ,a.DESGCODE , a.GRADE ,(SELECT      desg FROM    desgmast where desgcode = a.DESGCODE ) DESGName ,  ';
		 v_stmt := v_stmt || ' ( select DISTINCT abbr  from costmast where costcode  = a.parent ) parentabbr    ';
		 --v_stmt := v_stmt || ' ( SELECT working_hrs Actual_Working_Hours FROM    wrkhours where yymm =''' || p_yymm || '''   and  office=''' || p_Office || ''' ) actuaL_WORKING_HOURS ';
		 
         v_stmt := v_stmt || '  FROM     emplmast a  ';
         v_stmt := v_stmt || ' WHERE  a.emptype IN ( SELECT emptype FROM emptypemast WHERE nvl(tm, 0) = 1 )   ';
         v_stmt := v_stmt || ' AND ( a.assign = trim(''' || p_dept || ''')   ) AND nvl(status, 0) = 1    AND NOT EXISTS ( SELECT * FROM time_mast WHERE empno = a.empno AND  yymm = ''' || p_yymm || '''  )  ';
         
            OPEN p_WHlist FOR v_WH_stmt;
             
            OPEN p_tsforapprllist FOR v_stmt;
            
        END IF;        
       
    END ngts_getlistoftsforapprl;

    FUNCTION get_emp_name (
        p_empno IN VARCHAR2
    ) RETURN VARCHAR2 AS
        vname VARCHAR2(180);
    BEGIN
        SELECT DISTINCT
            empno
            || ' : '
            || name
        INTO vname
        FROM
            emplmast
        WHERE
            empno = p_empno;

        RETURN vname;
    END get_emp_name;


      FUNCTION Func_emp_dept (
        p_empno VARCHAR2 , 
        p_dept VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor        SYS_REFCURSOR;
        nempdeptcount   NUMBER;
        v_stmt    VARCHAR2(1000) := NULL;
    BEGIN
     
            v_stmt := ' SELECT  DISTINCT E.empno, E.name ,  E.email,    E.parent  ,E.COMPANY ,E.DESGCODE , E.GRADE ,(SELECT      desg FROM    desgmast where desgcode = E.DESGCODE ) DESGName  ';
            v_stmt := v_stmt || ' , (select DISTINCT abbr  from costmast where costcode  = E.parent ) parentabbr ';
             v_stmt := v_stmt || ' FROM    emplmast E';
            v_stmt := v_stmt || ' where E.status=1 ';
            v_stmt := v_stmt || ' and E.empno=''' || p_empno || ''' ';
            --|| '''and parent=''' || p_dept || ''' ';

        OPEN o_cursor FOR v_stmt;   
        
     
          
        RETURN o_cursor;
      
    END Func_emp_dept;


  PROCEDURE ngts_getlistoftsforParent (
        p_yymm             IN    VARCHAR2,
        p_dept             IN    VARCHAR2,
        p_empno            IN    VARCHAR2,
        p_status           IN    NUMBER,
        p_Office             IN    VARCHAR2,
        p_WHlist   OUT   SYS_REFCURSOR,
        p_tsforapprllist   OUT   SYS_REFCURSOR
    ) AS
        v_stmt    VARCHAR2(8000) := NULL;
        v_WH_stmt    VARCHAR2(8000) := NULL;
        v_count   NUMBER;
    BEGIN
  
        v_WH_stmt := '  SELECT        working_hrs Actual_Working_Hours FROM    wrkhours where yymm =''' || p_yymm || ''' and  office=''' || p_Office || '''    ';
        
        v_stmt := ' SELECT  DISTINCT  TT.yymm, trim(to_char(to_date(SUBSTR(TT.yymm,5,6), ''MM''), ''Month'') ) Month , ';
        v_stmt := v_stmt || ' ngts_pradeep_old.Get_emp_Name(TT.empno) Employee, ';
        v_stmt := v_stmt || ' TT.empno , TT.locked,    TT.approved,    TT.posted,  case when TT.posted = 1 then 5 when TT.approved = 1 then 3    when TT.locked = 1 then 2  else 1 end as Status ,  ' ;
        v_stmt := v_stmt || ' (select NVL( sum(NT.TOTAL), ''0'') from time_daily NT where NT.yymm=TT.yymm and NT.empno= TT.empno and NT.Parent = trim('''
                  || p_dept
                  || ''') ) NT_TOTAL ,   ';
        v_stmt := v_stmt
                  || ' (select NVL( sum(OT.TOTAL), ''0'') from time_OT OT where OT.yymm=TT.yymm and OT.empno= TT.empno and OT.Parent = trim('''
                  || p_dept
                  || ''') ) OT_TOTAL ,   ';
        v_stmt := v_stmt
                  || '  (select NVL( sum(NT.TOTAL), ''0'') from time_daily NT where NT.yymm=TT.yymm and NT.empno= TT.empno and NT.Parent != trim('''
                  || p_dept
                  || ''') ) Others_NT_TOTAL , ';
        v_stmt := v_stmt
                  || '  (select NVL( sum(OT.TOTAL), ''0'') from time_OT OT where OT.yymm=TT.yymm and OT.empno= TT.empno and OT.Parent != trim('''
                  || p_dept
                  || ''') ) Others_OT_TOTAL  ';
        v_stmt := v_stmt
                  || ' FROM     time_mast TT     where TT.yymm = ''' || p_yymm || '''  and TT.Parent =trim(''' || p_dept || ''')   ';
        --v_stmt := v_stmt  || '  and TT.empno in  ( SELECT  DISTINCT  empno  FROM    emplmast   where status=1   and emp_hod= trim(''' || p_empno || ''') and parent=trim(''' || p_dept || ''')  )  ';
        v_stmt := v_stmt || '   ';
        IF ( p_status = 1 ) THEN -- Open
            v_stmt := v_stmt || ' and TT.locked = 0 ';
        END IF;
        
        IF ( p_status = 2 ) THEN -- locked
            v_stmt := v_stmt || ' and TT.locked = 1 ';
            v_stmt := v_stmt || ' and TT.approved = 0  ';
            v_stmt := v_stmt || ' and TT.posted = 0 ';
        END IF;
        
        IF ( p_status = 3 ) THEN --
             v_stmt := v_stmt || ' and TT.posted = 0 ';
        END IF;
        
        IF ( p_status = 4 ) THEN
            v_stmt := v_stmt || ' and TT.approved = 0  ';
        END IF;
        
        IF ( p_status = 5 ) THEN
            v_stmt := v_stmt || ' and TT.posted = 1 ';
        END IF;
        IF ( p_status = 6 ) THEN
          v_stmt := v_stmt || ' and TT.posted = 0 ';
        END IF;
        v_stmt := v_stmt || ' order BY TT.yymm   ';
        
        OPEN p_WHlist FOR v_WH_stmt;
        OPEN p_tsforapprllist FOR v_stmt;
 
    END ngts_getlistoftsforParent;    
    
    --GET WORKING (APPLICABLE) HOURS
    FUNCTION ngts_getWorkingHours (
        p_yymm    VARCHAR2,
        p_empno   VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
                            working_hrs actual_Working_Hours
                        FROM
                            wrkhours
                        WHERE
                            yymm = TRIM(p_yymm)
                            AND office = 'BO';

        RETURN o_cursor;
    END ngts_getWorkingHours;    
    
    --GET PROJECT TIMESHEET HOURS
    FUNCTION ngts_getProjTimeSheetDetails (
        p_yymm    VARCHAR2,
        p_empno   VARCHAR2,
        p_projno  VARCHAR2
    ) RETURN SYS_REFCURSOR is
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
                              tm.empno,
                              tm.assign,
                              CASE
                                  WHEN tm.posted = 1   THEN
                                      5
                                  WHEN tm.approved = 1 THEN
                                      3
                                  WHEN tm.locked = 1   THEN
                                      2
                                  ELSE
                                      1
                              END AS status,
                              getprojnopmapprovalstatus(tm.yymm, tm.empno, tm.assign, p_projno) pmapprovalstatus,
                              (
                                  SELECT
                                      nvl(SUM(nvl(total, 0)), 0)
                                  FROM
                                      time_daily
                                  WHERE
                                      substr(projno, 1, 5) = TRIM(p_projno)
                                      AND empno = TRIM(tm.empno)
                                      AND assign = TRIM(tm.assign)
                                      AND yymm = TRIM(tm.yymm)
                              ) nt_total,
                              (
                                  SELECT
                                      nvl(SUM(nvl(total, 0)), 0)
                                  FROM
                                      time_ot
                                  WHERE
                                      substr(projno, 1, 5) = TRIM(p_projno)
                                      AND empno = TRIM(tm.empno)
                                      AND assign = TRIM(tm.assign)
                                      AND yymm = TRIM(tm.yymm)
                              ) ot_total,
                              0 others_nt_total,
                              0 others_ot_total,
                              e.empno,
                              e.name,
                              e.email,
                              e.parent,
                              e.company,
                              e.desgcode,
                              e.grade,
                              d.desg   desgname,
                              c.abbr   parentabbr
                          FROM
                              time_mast   tm,
                              emplmast    e,
                              (
                                  SELECT DISTINCT
                                      abbr,
                                      costcode
                                  FROM
                                      costmast                                  
                              ) c,
                              (
                                  SELECT
                                      desg,
                                      desgcode
                                  FROM
                                      desgmast
                              ) d
                          WHERE
                              c.costcode = e.parent
                              AND d.desgcode = e.desgcode
                              AND tm.empno = e.empno
                              AND EXISTS (
                                  SELECT
                                      time_daily.*
                                  FROM
                                      time_daily
                                  WHERE
                                      substr(projno, 1, 5) = TRIM(p_projno)
                                      AND empno = TRIM(tm.empno)
                                      AND assign = TRIM(tm.assign)
                                      AND yymm = TRIM(tm.yymm)
                                      
                                  UNION ALL
                                  
                                  SELECT
                                      time_ot.*
                                  FROM
                                      time_ot
                                  WHERE
                                      substr(projno, 1, 5) = TRIM(p_projno)
                                      AND empno = TRIM(tm.empno)
                                      AND assign = TRIM(tm.assign)
                                      AND yymm = TRIM(tm.yymm)
                              )
                              AND EXISTS (
                                  SELECT
                                      projmast.*
                                  FROM
                                      timecurr.projmast                   p,
                                      timecurr.ngts_vuser_project_roles   u
                                  WHERE
                                      substr(p.projno, 1, 5) = u.projno
                                      AND u.empno = TRIM(p_empno)                                      
                                      AND to_number(to_char(p.revcdate, 'YYYYMM')) >= to_number(TRIM(p_yymm))
                                      AND nvl(p.timesheet_appr, 0) = 1
                                      AND substr(p.projno, 1, 5) = TRIM(p_projno)
                              )
                              AND tm.yymm = TRIM(p_yymm)
                          ORDER BY
                              tm.empno,
                              tm.assign;
        RETURN o_cursor;
    END;    
    
    --GET PM APPROVAL STATUS
    FUNCTION getProjnoPMApprovalStatus (
        p_yymm     VARCHAR2,
        p_empno    VARCHAR2,        
        p_assign   VARCHAR2,
        p_projno   VARCHAR2
    ) RETURN NUMBER IS
        npmapproved NUMBER(1);
    BEGIN
        SELECT
            pmapproved
        INTO npmapproved
        FROM
            (
                SELECT
                    projno,
                    pmapproved
                FROM
                    (
                        SELECT
                            projno,
                            nvl(td.pmapproved, 0) pmapproved
                        FROM
                            time_daily td
                        WHERE
                            SUBSTR(td.projno,1,5) = TRIM(p_projno)
                            AND td.assign = TRIM(p_assign)                            
                            AND td.empno = TRIM(p_empno)
                            AND td.yymm = TRIM(p_yymm)
                            
                        UNION ALL
                        
                        SELECT
                            projno,
                            nvl(ot.pmapproved, 0) pmapproved
                        FROM
                            time_ot ot
                        WHERE
                            SUBSTR(ot.projno,1,5) = TRIM(p_projno)
                            AND ot.assign = TRIM(p_assign)                            
                            AND ot.empno = TRIM(p_empno)
                            AND ot.yymm = TRIM(p_yymm)
                    ) tm
                WHERE
                    EXISTS (
                        SELECT
                            projmast.*
                        FROM
                            projmast p
                        WHERE                            
                            to_number(to_char(p.revcdate, 'YYYYMM')) >= to_number(TRIM(p_yymm))
                            AND nvl(p.timesheet_appr, 0) = 1
                            AND SUBSTR(p.projno,1,5) = p_projno
                    )
                ORDER BY
                    pmapproved
            )
        WHERE
            ROWNUM = 1;

        RETURN npmapproved;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1;
    END getProjnoPMApprovalStatus;      

PROCEDURE ngts_GetReasonCode (
        P_projno                IN    VARCHAR2,        
        p_ReasonCodelist   OUT   SYS_REFCURSOR
    ) AS
        v_stmt    VARCHAR2(1000) := NULL;
        v_count   NUMBER;
    BEGIN
    
            v_stmt := '
                SELECT   A.reasoncode code ,
                        (select DISTINCT REASONDESC  from ngts_reasoncode_mast where  REASONCODE  = A.reasoncode) as "desc" 
                FROM
                    ngts_proj_reasoncode A
                    
                where projno = ''' || P_projno || ''' 
                
                order by a.reasoncode ';
                        
        OPEN p_ReasonCodelist FOR v_stmt;

    END ngts_GetReasonCode;

END ngts_pradeep_old;

/
