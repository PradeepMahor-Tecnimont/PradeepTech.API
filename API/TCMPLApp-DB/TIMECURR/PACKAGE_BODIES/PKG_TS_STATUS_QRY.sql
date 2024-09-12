create or replace package body "TIMECURR"."PKG_TS_STATUS_QRY" as
  
  c_action_id_proco Constant Char(4) := 'A132';
  c_action_id_sec Constant Char(4) := 'A216';
    
  function fn_get_timesheet_status(
        p_yymm           Varchar2,
        p_empno          Varchar2,
        p_costcode       Varchar2
    ) Return Varchar2 as
        v_count          Number;
        v_status         Varchar2(20);
      begin
        select 
            count(*)
        Into
            v_count        
        from
            (select 
                yymm, 
                empno, 
                assign 
            from 
                ts_osc_mhrs_master
            union
            select 
                yymm, 
                empno, 
                assign 
            from 
                 time_mast)
        where
            yymm = p_yymm 
            and empno = p_empno 
            and assign = p_costcode;
         
         if v_count > 0 then         
            select 
                case 
                    when nvl(locked, 0) = 0 and nvl(approved, 0) = 0 and nvl(posted, 0) = 0 then 'Not locked'
                    when nvl(locked, 0) = 1 and nvl(approved, 0) = 0 and nvl(posted, 0) = 0 then 'Locked'
                    when nvl(locked, 0) = 1 and nvl(approved, 0) = 1 and nvl(posted, 0) = 0 then 'Approved'
                    when nvl(locked, 0) = 1 and nvl(approved, 0) = 1 and nvl(posted, 0) = 1 then 'Posted'        
                    else 'Not filled'
                end 
            Into
                v_status        
            from 
                (select 
                    yymm, 
                    empno, 
                    parent, 
                    assign, 
                    locked, 
                    approved, 
                    posted 
                from 
                    time_mast 
                where 
                    yymm = p_yymm
                Union
                select 
                    yymm, 
                    empno, 
                    parent, 
                    assign, 
                    Case is_lock
                    When 'OK' Then 1
                            else 0
                    End                    locked,
                    Case is_hod_approve
                        When 'OK' Then 1
                            else 0
                    End                    approved,
                    Case is_post
                        When 'OK' Then 1
                            else 0
                    End                    posted
                from 
                    ts_osc_mhrs_master
                where 
                    yymm = p_yymm)
            where 
                yymm = p_yymm 
                and empno = p_empno 
                and assign = p_costcode;
        else
            v_status := 'Not filled';
        end if;       
        
        Return v_status;
    end fn_get_timesheet_status; 
    
  function fn_get_outsource_timesheet_status(
        p_yymm           Varchar2,
        p_empno          Varchar2,
        p_costcode       Varchar2
    ) Return Varchar2 as
        v_count          Number;
        v_status         Varchar2(20);
      begin
        select    
            count(*) 
        Into
            v_count
        from 
            ts_osc_mhrs_master tomm
        where tomm.yymm = p_yymm 
            And tomm.assign = p_costcode;        
         
        if v_count > 0 then         
            select 
                case 
                    when is_lock <> 'OK' and is_hod_approve <> 'OK' and is_post <> 'OK' then 'Not locked'
                    when is_lock = 'OK' and is_hod_approve <> 'OK' and is_post <> 'OK' then 'Locked'
                    when is_lock = 'OK' and is_hod_approve = 'OK' and is_post <> 'OK' then 'Approved'
                    when is_lock = 'OK' and is_hod_approve = 'OK' and is_post = 'OK' then 'Posted'        
                    else 'Not filled'
                end 
            Into
                v_status        
            from 
                ts_osc_mhrs_master
            where 
                yymm = p_yymm 
                and empno = p_empno 
                and assign = p_costcode;
        else
            v_status := 'Not filled';
        end if;       
        
        Return v_status;
   end fn_get_outsource_timesheet_status; 
    
  function fn_employee_status_list(
        p_person_id      varchar2,
        p_meta_id        varchar2,
        
        p_generic_search varchar2 default null,
        p_action_id      varchar2,
        p_yymm           varchar2,
        p_row_number     number,
        p_page_length    number
    ) return sys_refcursor as
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
      c                    Sys_Refcursor;
  begin
      v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'ERRRR' Then
        Raise e_employee_not_found;
        Return Null;
      End If;
      
      if p_action_id = c_action_id_sec then
        Open c For
            Select
                *
            From
                (                    
                Select
                    yymm,
                    empno,
                    empname,
                    emptype,
                    parent,
                    assign,
                    hours,
                    ot_hours,
                    ts_filled,
                    ts_locked,
                    ts_approved,
                    ts_posted,
                    cc_hours,
                    cc_ot_hours,
                    Row_Number() Over(Order By empno)    row_number,
                    Count(*) Over()                      total_row
                From
                    (Select 
                        tm.yymm,
                        tm.empno,
                        initcap(e.name)                         empname,
                        e.emptype                               emptype,
                        tm.parent,
                        tm.assign,
                        nvl(tm.tot_nhr, 0)                      hours,
                        nvl(tm.tot_ohr, 0)                      ot_hours,
                        0                                       ts_filled,
                        nvl(tm.locked, 0)                       ts_locked,
                        nvl(tm.approved, 0)                     ts_approved,
                        nvl(tm.posted, 0)                       ts_posted,
                        pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                        pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours
                    From 
                        time_mast           tm,
                        emplmast            e
                    Where
                        tm.empno = e.empno
                        And (tm.assign In (
                                Select
                                    costcode
                                From
                                    costmast
                                Where
                                    hod          = Trim(v_empno)
                                    Or secretary = Trim(v_empno)
                                Union All
                                Select
                                    costcode
                                From
                                    time_secretary
                                Where
                                    empno = Trim(v_empno)
                            )
                            Or (e.empno  = Trim(v_empno)
                                Or e.do  = Trim(v_empno)))
                        And tm.yymm    = Trim(p_yymm)
                    Union
                    Select tomm.yymm,
                        e.empno,
                        initcap(e.name)                  empname,
                        e.emptype                        emptype,
                        e.parent,
                        tomm.assign,
                        tomm.hours                       hours,
                        0                                ot_hours,
                        0                                ts_filled,
                        Case tomm.is_lock
                            When 'OK' Then 1
                                else 0
                        End                             ts_locked,
                        Case tomm.is_hod_approve
                            When 'OK' Then 1
                                else 0
                        End                             ts_approved,
                        Case tomm.is_post
                            When 'OK' Then 1
                                else 0
                        End                             ts_posted,
                        null                            cc_hours,
                        null                            cc_ot_hours
                    From 
                        ts_osc_mhrs_master tomm,
                        emplmast e
                    Where tomm.empno = e.empno
                        And tomm.yymm = p_yymm 
                        And (tomm.assign In (
                                Select
                                    costcode
                                From
                                    costmast
                                Where
                                    hod          = Trim(v_empno)
                                    Or secretary = Trim(v_empno)
                                Union All
                                Select
                                    costcode
                                From
                                    time_secretary
                                Where
                                    empno = Trim(v_empno)
                            )
                            Or (e.empno  = Trim(v_empno)
                                Or e.do  = Trim(v_empno)))
                     )
                Where
                    upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                    OR upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                Order by 
                    empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      End if;
      
      if p_action_id = c_action_id_proco then
        Open c For
            Select
                *
            From
                (                    
                    Select
                    yymm,
                    empno,
                    empname,
                    emptype,
                    parent,
                    assign,
                    hours,
                    ot_hours,
                    ts_filled,
                    ts_locked,
                    ts_approved,
                    ts_posted,
                    cc_hours,
                    cc_ot_hours,
                    Row_Number() Over(Order By empno)    row_number,
                    Count(*) Over()                      total_row
                From
                    (Select 
                        tm.yymm,
                        tm.empno,
                        initcap(e.name)                         empname,
                        e.emptype                               emptype,
                        tm.parent,
                        tm.assign,
                        nvl(tm.tot_nhr, 0)                      hours,
                        nvl(tm.tot_ohr, 0)                      ot_hours,
                        0                                       ts_filled,
                        nvl(tm.locked, 0)                       ts_locked,
                        nvl(tm.approved, 0)                     ts_approved,
                        nvl(tm.posted, 0)                       ts_posted,
                        pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                        pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours
                    From 
                        time_mast           tm,
                        emplmast            e
                    Where
                        tm.empno = e.empno                        
                        And tm.yymm    = Trim(p_yymm)
                    Union
                    Select tomm.yymm,
                        e.empno,
                        initcap(e.name)                  empname,
                        e.emptype                        emptype,
                        e.parent,
                        tomm.assign,
                        tomm.hours                       hours,
                        0                                ot_hours,
                        0                                ts_filled,
                        Case tomm.is_lock
                            When 'OK' Then 1
                                else 0
                        End                             ts_locked,
                        Case tomm.is_hod_approve
                            When 'OK' Then 1
                                else 0
                        End                             ts_approved,
                        Case tomm.is_post
                            When 'OK' Then 1
                                else 0
                        End                             ts_posted,
                        null                            cc_hours,
                        null                            cc_ot_hours
                    From 
                        ts_osc_mhrs_master tomm,
                        emplmast e
                    Where tomm.empno = e.empno
                        And tomm.yymm = p_yymm                         
                     )
                Where
                    upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                    OR upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                Order by 
                    empno                    
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        End if;

        Return c;    
  end fn_employee_status_list;

  function fn_employee_locked_list(
        p_person_id      varchar2,
        p_meta_id        varchar2,
        
        p_generic_search varchar2 default null,
        p_action_id      varchar2,
        p_yymm           varchar2,
        p_row_number     number,
        p_page_length    number
    ) return sys_refcursor as
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
      c                    Sys_Refcursor;
      v_proc_mnth          Varchar2(6);
      v_action_visible     Number(1) := 0;
      v_ts_freeze          Number(1) := 0;
  begin
    v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'ERRRR' Then
        Raise e_employee_not_found;
        Return Null;
      End If;
      
      Select
        pros_month
      Into
        v_proc_mnth
      From
        tsconfig;
      
      if p_yymm = v_proc_mnth then
        v_action_visible := 1;
      end if;
      
      select 
            status
        into
            v_ts_freeze
        from 
            tsconfig
        Where
            Trim(schemaname) = 'TIMECURR'
            And Trim(username) = 'TIMECURR';      
        
      if p_action_id = c_action_id_sec then
      Open c For
            Select
                *
            From
                (                    
                    Select
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,
                        hours,
                        ot_hours,
                        ts_locked,
                        ts_approved,
                        cc_hours,
                        cc_ot_hours,
                        is_action_visible,
                        is_ts_freeze,
                        Row_Number() Over(Order By empno)    row_number,
                        Count(*) Over()                      total_row
                    From
                        (Select 
                            tm.yymm,
                            tm.empno,
                            initcap(e.name)                         empname,
                            e.emptype                               emptype,
                            tm.parent,
                            tm.assign,
                            nvl(tm.tot_nhr, 0)                      hours,
                            nvl(tm.tot_ohr, 0)                      ot_hours,
                            nvl(tm.locked, 0)                       ts_locked,
                            nvl(tm.approved, 0)                     ts_approved,
                            pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                            pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                            v_action_visible                        is_action_visible,
                            v_ts_freeze                             is_ts_freeze
                        From 
                            time_mast           tm,
                            emplmast            e
                        Where
                            tm.empno = e.empno
                            And (tm.assign In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod          = Trim(v_empno)
                                        Or secretary = Trim(v_empno)
                                    Union All
                                    Select
                                        costcode
                                    From
                                        time_secretary
                                    Where
                                        empno = Trim(v_empno)
                                )
                                Or (e.empno  = Trim(v_empno)
                                    Or e.do  = Trim(v_empno)))
                            And tm.yymm             = Trim(p_yymm)
                            And nvl(tm.locked, 0)   in (0, 1) 
                        Union
                        Select tomm.yymm,
                            e.empno,
                            initcap(e.name)                  empname,
                            e.emptype                        emptype,
                            e.parent,
                            tomm.assign,
                            tomm.hours                       hours,
                            0                                ot_hours,                        
                            Case tomm.is_lock
                                When 'OK' Then 1
                                    else 0
                            End                             ts_locked, 
                            Case tomm.is_hod_approve
                                    When 'OK' Then 1
                                        else 0
                            End                             ts_approved,
                            null                            cc_hours,
                            null                            cc_ot_hours,
                            v_action_visible                is_action_visible,
                            v_ts_freeze                     is_ts_freeze
                        From 
                            ts_osc_mhrs_master tomm,
                            emplmast e
                        Where tomm.empno = e.empno
                            And tomm.yymm = p_yymm                             
                            And (tomm.assign In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod          = Trim(v_empno)
                                        Or secretary = Trim(v_empno)
                                    Union All
                                    Select
                                        costcode
                                    From
                                        time_secretary
                                    Where
                                        empno = Trim(v_empno)
                                )
                                Or (e.empno  = Trim(v_empno)
                                    Or e.do  = Trim(v_empno)))
                        )
                    Where
                        upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Order by 
                        empno                    
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      end if;
      
      if p_action_id = c_action_id_proco then
      Open c For
            Select
                *
            From
                (                    
                    Select
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,
                        hours,
                        ot_hours,
                        ts_locked,
                        cc_hours,
                        cc_ot_hours,
                        is_action_visible,
                        is_ts_freeze,
                        Row_Number() Over(Order By empno)    row_number,
                        Count(*) Over()                      total_row
                    From
                        (Select 
                            tm.yymm,
                            tm.empno,
                            initcap(e.name)                         empname,
                            e.emptype                               emptype,
                            tm.parent,
                            tm.assign,
                            nvl(tm.tot_nhr, 0)                      hours,
                            nvl(tm.tot_ohr, 0)                      ot_hours,
                            nvl(tm.locked, 0)                       ts_locked,
                            pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                            pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                            v_action_visible                        is_action_visible,
                            v_ts_freeze                             is_ts_freeze         
                        From 
                            time_mast           tm,
                            emplmast            e
                        Where
                            tm.empno = e.empno    
                            And tm.yymm             = Trim(p_yymm)
                            And nvl(tm.locked, 0)   in (0, 1) 
                        Union
                        Select tomm.yymm,
                            e.empno,
                            initcap(e.name)                  empname,
                            e.emptype                        emptype,
                            e.parent,
                            tomm.assign,
                            tomm.hours                       hours,
                            0                                ot_hours,                        
                            Case tomm.is_lock
                                When 'OK' Then 1
                                    else 0
                            End                             ts_locked,                        
                            null                            cc_hours,
                            null                            cc_ot_hours,
                            v_action_visible                is_action_visible,
                            v_ts_freeze                             is_ts_freeze
                        From 
                            ts_osc_mhrs_master tomm,
                            emplmast e
                        Where tomm.empno = e.empno                            
                            And tomm.yymm = p_yymm 
                        )
                    Where
                        upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Order by 
                        empno                    
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      end if;
      
      Return c; 
  end fn_employee_locked_list;

  function fn_employee_approved_list(
        p_person_id      varchar2,
        p_meta_id        varchar2,

        p_generic_search varchar2 default null,
        p_action_id      varchar2,
        p_yymm           varchar2,
        p_row_number     number,
        p_page_length    number
    ) return sys_refcursor as
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
      c                    Sys_Refcursor;
      v_proc_mnth          Varchar2(6);
      v_action_visible     Number(1) := 0;
      v_ts_freeze          Number(1) := 0;
  begin
    v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'ERRRR' Then
        Raise e_employee_not_found;
        Return Null;
      End If;
      
      Select
        pros_month
      Into
        v_proc_mnth
      From
        tsconfig;
        
      if p_yymm = v_proc_mnth then
        v_action_visible := 1;
      end if;
      
      select 
            status
        into
            v_ts_freeze
        from 
            tsconfig
        Where
            Trim(schemaname) = 'TIMECURR'
            And Trim(username) = 'TIMECURR'; 
    
      if p_action_id = c_action_id_sec then
      Open c For
            Select
                *
            From
                (                    
                    Select
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,
                        hours,
                        ot_hours,
                        ts_approved,
                        ts_posted,
                        cc_hours,
                        cc_ot_hours,
                        is_action_visible,
                        is_ts_freeze,
                        Row_Number() Over(Order By empno)    row_number,
                        Count(*) Over()                      total_row
                    From
                        (
                            Select 
                                tm.yymm,
                                tm.empno,
                                initcap(e.name)                         empname,
                                e.emptype                               emptype,
                                tm.parent,
                                tm.assign,
                                nvl(tm.tot_nhr, 0)                      hours,
                                nvl(tm.tot_ohr, 0)                      ot_hours,
                                nvl(tm.approved, 0)                     ts_approved,
                                nvl(tm.posted, 0)                       ts_posted,
                                pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                                pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                                v_action_visible                        is_action_visible ,
                                v_ts_freeze                             is_ts_freeze
                            From 
                                time_mast           tm,
                                emplmast            e
                            Where
                                tm.empno = e.empno
                                And (tm.assign In (
                                        Select
                                            costcode
                                        From
                                            costmast
                                        Where
                                            hod          = Trim(v_empno)
                                            Or secretary = Trim(v_empno)
                                        Union All
                                        Select
                                            costcode
                                        From
                                            time_secretary
                                        Where
                                            empno = Trim(v_empno)
                                    )
                                    Or (e.empno  = Trim(v_empno)
                                        Or e.do  = Trim(v_empno)))
                                And tm.yymm    = Trim(p_yymm)
                                And nvl(tm.locked, 0)   = 1
                                And nvl(tm.approved, 0) in (0, 1)
                            Union
                            Select tomm.yymm,
                                e.empno,
                                initcap(e.name)                  empname,
                                e.emptype                        emptype,
                                e.parent,
                                tomm.assign,
                                tomm.hours                       hours,
                                0                                ot_hours,
                                Case tomm.is_hod_approve
                                    When 'OK' Then 1
                                        else 0
                                End                             ts_approved,
                                Case tomm.is_post
                                    When 'OK' Then 1
                                        else 0
                                End                             ts_posted,
                                null                            cc_hours,
                                null                            cc_ot_hours,
                                v_action_visible                is_action_visible,
                                v_ts_freeze                     is_ts_freeze
                            From 
                                ts_osc_mhrs_master tomm,
                                emplmast e
                            Where tomm.empno = e.empno
                                And tomm.yymm = p_yymm 
                                And tomm.is_lock = 'OK'
                                And (tomm.assign In (
                                        Select
                                            costcode
                                        From
                                            costmast
                                        Where
                                            hod          = Trim(v_empno)
                                            Or secretary = Trim(v_empno)
                                        Union All
                                        Select
                                            costcode
                                        From
                                            time_secretary
                                        Where
                                            empno = Trim(v_empno)
                                    )
                                    Or (e.empno  = Trim(v_empno)
                                        Or e.do  = Trim(v_empno)))
                        )
                    Where
                        upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Order by 
                        empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      end if;
      
      if p_action_id = c_action_id_proco then
      Open c For
            Select
                *
            From
                (                    
                    Select
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,
                        hours,
                        ot_hours,
                        ts_approved,
                        cc_hours,
                        cc_ot_hours,
                        is_action_visible,
                        is_ts_freeze,
                        Row_Number() Over(Order By empno)    row_number,
                        Count(*) Over()                      total_row
                    From
                        (
                            Select 
                                tm.yymm,
                                tm.empno,
                                initcap(e.name)                         empname,
                                e.emptype                               emptype,
                                tm.parent,
                                tm.assign,
                                nvl(tm.tot_nhr, 0)                      hours,
                                nvl(tm.tot_ohr, 0)                      ot_hours,
                                nvl(tm.approved, 0)                     ts_approved,
                                pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                                pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                                v_action_visible                        is_action_visible,
                                v_ts_freeze                             is_ts_freeze
                            From 
                                time_mast           tm,
                                emplmast            e
                            Where
                                tm.empno = e.empno                        
                                And tm.yymm             = Trim(p_yymm)
                                And nvl(tm.locked, 0)   = 1
                                And nvl(tm.approved, 0) in (0, 1) 
                            Union
                            Select tomm.yymm,
                                e.empno,
                                initcap(e.name)                  empname,
                                e.emptype                        emptype,
                                e.parent,
                                tomm.assign,
                                tomm.hours                       hours,
                                0                                ot_hours,
                                Case tomm.is_hod_approve
                                    When 'OK' Then 1
                                        else 0
                                End                              ts_approved,
                                null                             cc_hours,
                                null                             cc_ot_hours,
                                v_action_visible                 is_action_visible,
                                v_ts_freeze                      is_ts_freeze
                            From 
                                ts_osc_mhrs_master tomm,
                                emplmast e
                            Where tomm.empno = e.empno                            
                                And tomm.yymm = p_yymm
                                And tomm.is_lock = 'OK'
                        )
                    Where
                        upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Order by 
                        empno                    
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      end if;
      Return c; 
  end fn_employee_approved_list;

  function fn_employee_posted_list(
        p_person_id      varchar2,
        p_meta_id        varchar2,
        
        p_generic_search varchar2 default null,
        p_action_id      varchar2,
        p_yymm           varchar2,
        p_row_number     number,
        p_page_length    number
    ) return sys_refcursor as
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
      c                    Sys_Refcursor;
      v_proc_mnth          Varchar2(6);
      v_action_visible     Number(1) := 0;      
      v_ts_freeze          Number(1) := 0;
  begin
    v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'ERRRR' Then
        Raise e_employee_not_found;
        Return Null;
      End If;
      
      Select
        pros_month
      Into
        v_proc_mnth
      From
        tsconfig;
        
      if p_yymm = v_proc_mnth then
        v_action_visible := 1;
      end if;
      
      select 
            status
        into
            v_ts_freeze
        from 
            tsconfig
        Where
            Trim(schemaname) = 'TIMECURR'
            And Trim(username) = 'TIMECURR'; 
            
      if p_action_id = c_action_id_sec then
      Open c For
            Select
                *
            From
                (                    
                   Select
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,
                        hours,
                        ot_hours,
                        ts_posted,
                        cc_hours,
                        cc_ot_hours,
                        is_action_visible,
                        is_ts_freeze,
                        Row_Number() Over(Order By empno)    row_number,
                        Count(*) Over()                      total_row
                    From
                        (
                            Select 
                                tm.yymm,
                                tm.empno,
                                initcap(e.name)                         empname,
                                e.emptype                               emptype,
                                tm.parent,
                                tm.assign,
                                nvl(tm.tot_nhr, 0)                      hours,
                                nvl(tm.tot_ohr, 0)                      ot_hours,
                                nvl(tm.posted, 0)                       ts_posted,
                                pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                                pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                                v_action_visible                        is_action_visible,
                                v_ts_freeze                             is_ts_freeze
                            From 
                                time_mast           tm,
                                emplmast            e
                            Where
                                tm.empno = e.empno
                                And (tm.assign In (
                                        Select
                                            costcode
                                        From
                                            costmast
                                        Where
                                            hod          = Trim(v_empno)
                                            Or secretary = Trim(v_empno)
                                        Union All
                                        Select
                                            costcode
                                        From
                                            time_secretary
                                        Where
                                            empno = Trim(v_empno)
                                    )
                                    Or (e.empno  = Trim(v_empno)
                                        Or e.do  = Trim(v_empno)))
                                And tm.yymm    = Trim(p_yymm)
                                And nvl(tm.locked, 0)   = 1
                                And nvl(tm.approved, 0) = 1
                                And nvl(tm.posted, 0) in (0, 1)
                            Union
                            Select tomm.yymm,
                                e.empno,
                                initcap(e.name)                  empname,
                                e.emptype                        emptype,
                                e.parent,
                                tomm.assign,
                                tomm.hours                       hours,
                                0                                ot_hours,
                                Case tomm.is_post
                                    When 'OK' Then 1
                                        else 0
                                End                             ts_posted,
                                null                            cc_hours,
                                null                            cc_ot_hours,
                                v_action_visible                is_action_visible,
                                v_ts_freeze                     is_ts_freeze
                            From 
                                ts_osc_mhrs_master tomm,
                                emplmast e
                            Where tomm.empno = e.empno
                                And tomm.yymm = p_yymm 
                                And tomm.is_lock = 'OK'
                                And tomm.is_hod_approve = 'OK'
                                And (tomm.assign In (
                                        Select
                                            costcode
                                        From
                                            costmast
                                        Where
                                            hod          = Trim(v_empno)
                                            Or secretary = Trim(v_empno)
                                        Union All
                                        Select
                                            costcode
                                        From
                                            time_secretary
                                        Where
                                            empno = Trim(v_empno)
                                    )
                                    Or (e.empno  = Trim(v_empno)
                                        Or e.do  = Trim(v_empno)))
                        )
                    Where
                        upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Order by 
                        empno                   
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      end if;
      
      if p_action_id = c_action_id_proco then
      Open c For
            Select
                *
            From
                (                    
                    Select
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,
                        hours,
                        ot_hours,
                        ts_posted,
                        cc_hours,
                        cc_ot_hours,
                        is_action_visible,
                        is_ts_freeze,
                        Row_Number() Over(Order By empno)    row_number,
                        Count(*) Over()                      total_row
                    From
                        (
                            Select 
                                tm.yymm,
                                tm.empno,
                                initcap(e.name)                         empname,
                                e.emptype                               emptype,
                                tm.parent,
                                tm.assign,
                                nvl(tm.tot_nhr, 0)                      hours,
                                nvl(tm.tot_ohr, 0)                      ot_hours,
                                nvl(tm.posted, 0)                       ts_posted,
                                pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                                pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                                v_action_visible                        is_action_visible,
                                v_ts_freeze                             is_ts_freeze
                            From 
                                time_mast           tm,
                                emplmast            e
                            Where
                                tm.empno = e.empno                        
                                And tm.yymm             = Trim(p_yymm)
                                And nvl(tm.locked, 0)   = 1
                                And nvl(tm.approved, 0) = 1
                                And nvl(tm.posted, 0) in (0, 1) 
                            Union
                            Select tomm.yymm,
                                e.empno,
                                initcap(e.name)                  empname,
                                e.emptype                        emptype,
                                e.parent,
                                tomm.assign,
                                tomm.hours                       hours,
                                0                                ot_hours,
                                Case tomm.is_post
                                    When 'OK' Then 1
                                        else 0
                                End                              ts_posted,
                                null                             cc_hours,
                                null                             cc_ot_hours,
                                v_action_visible                 is_action_visible,
                                v_ts_freeze                      is_ts_freeze
                            From 
                                ts_osc_mhrs_master tomm,
                                emplmast e
                            Where tomm.empno = e.empno                            
                                And tomm.yymm = p_yymm
                                And tomm.is_lock = 'OK'
                                And tomm.is_hod_approve = 'OK'
                        )
                    Where
                        upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                    Order by 
                        empno                    
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      end if;

      Return c; 
  end fn_employee_posted_list;
  
  function fn_employee_notfilled_list(
        p_person_id      varchar2,
        p_meta_id        varchar2,
        
        p_generic_search varchar2 default null,
        p_action_id      varchar2,
        p_yymm           varchar2,
        p_row_number     number,
        p_page_length    number
    ) return sys_refcursor as
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
      c                    Sys_Refcursor;
  begin
    v_empno := get_empno_from_meta_id(p_meta_id);
      If v_empno = 'ERRRR' Then
        Raise e_employee_not_found;
        Return Null;
      End If;
      
      if p_action_id = c_action_id_sec then
        Open c For
            Select
                *
            From
                (                    
                 select 
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,                       
                        Row_Number() Over(Order By empno)    row_number,
                        Count(*) Over()                      total_row
                from
                (
                    Select                           
                        p_yymm                                 yymm,
                        e.empno,
                        initcap(e.name)                         empname,
                        e.emptype,
                        e.parent,
                        e.assign,
                        pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, e.empno, e.assign)    status_name                        
                    From                        
                        emplmast           e,                      
                        deptphase          dp
                    Where
                        e.assign            = dp.costcode 
                        And (e.assign In (
                                Select
                                    costcode
                                From
                                    costmast
                                Where
                                    hod          = Trim(v_empno)
                                    Or secretary = Trim(v_empno)
                                Union All
                                Select
                                    costcode
                                From
                                    time_secretary
                                Where
                                    empno = Trim(v_empno)
                            )
                            Or (e.empno  = Trim(v_empno)
                                Or e.do  = Trim(v_empno)))
                        And dp.isprimary    = 1
                        And e.emptype       in ('R','F','S','C')
                        And e.status        = 1                                                
                    Union
                    select 
                       tm.yymm,
                       tm.empno,
                       initcap(em.name)                         empname,
                       em.emptype                               emptype,
                       tm.parent,
                       tm.assign,
                       pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, em.empno, tm.assign)    status_name
                    from 
                        time_mast tm,
                        emplmast em
                    where 
                        tm.empno = em.empno  
                        And (em.assign In (
                                Select
                                    costcode
                                From
                                    costmast
                                Where
                                    hod          = Trim(v_empno)
                                    Or secretary = Trim(v_empno)
                                Union All
                                Select
                                    costcode
                                From
                                    time_secretary
                                Where
                                    empno = Trim(v_empno)
                            )
                            Or (em.empno  = Trim(v_empno)
                                Or em.do  = Trim(v_empno)))
                        And tm.yymm = p_yymm
                        And Not Exists (select empno from                      
                                        emplmast           e,                      
                                        deptphase          dp
                                    Where
                                        e.assign            = dp.costcode              
                                        And dp.isprimary    = 1
                                        And e.emptype       in ('R','F','S','C')
                                        And e.status        = 1                                        
                                        And e.assign        = tm.assign
                                        And e.empno         = tm.empno)
                )
                where
                    status_name = 'Not filled'
                    And (upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%')                       
                    Order by 
                        assign, empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      end if;
      
      if p_action_id =  c_action_id_proco then
        Open c For
            Select
                *
            From
                (                    
                 select 
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,                       
                        Row_Number() Over(Order By empno)    row_number,
                        Count(*) Over()                      total_row
                from
                (
                    Select                           
                        p_yymm                                 yymm,
                        e.empno,
                        initcap(e.name)                         empname,
                        e.emptype,
                        e.parent,
                        e.assign,
                        pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, e.empno, e.assign)    status_name                        
                    From                        
                        emplmast           e,                      
                        deptphase          dp
                    Where
                        e.assign            = dp.costcode                         
                        And dp.isprimary    = 1
                        And e.emptype       in ('R','F','S','C')
                        And e.status        = 1                                                
                    Union
                    select 
                       tm.yymm,
                       tm.empno,
                       initcap(em.name)                         empname,
                       em.emptype                               emptype,
                       tm.parent,
                       tm.assign,
                       pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, em.empno, tm.assign)    status_name
                    from 
                        time_mast tm,
                        emplmast em
                    where 
                        tm.empno = em.empno                          
                        And tm.yymm = p_yymm
                        And Not Exists (select empno from                      
                                        emplmast           e,                      
                                        deptphase          dp
                                    Where
                                        e.assign            = dp.costcode              
                                        And dp.isprimary    = 1
                                        And e.emptype       in ('R','F','S','C')
                                        And e.status        = 1                                        
                                        And e.assign        = tm.assign
                                        And e.empno         = tm.empno)
                )
                where
                    status_name = 'Not filled'
                    And (upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%')                       
                    Order by 
                        assign, empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      end if;

     Return c; 
  end fn_employee_notfilled_list;
  
  
  function fn_employee_status_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,
        p_action_id      varchar2,
        p_yymm           Varchar2        
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        if p_action_id = c_action_id_sec  then
            Open c For            
                Select
                    *
                From
                    (                    
                        Select
                            yymm,
                            empno,
                            empname,
                            emptype,
                            parent,
                            assign,
                            hours,
                            ot_hours,                           
                            cc_hours,
                            cc_ot_hours,                            
                            ts_locked,
                            ts_approved,
                            ts_posted
                        From
                            (Select 
                                tm.yymm,
                                tm.empno,
                                initcap(e.name)                         empname,
                                e.emptype                               emptype,
                                tm.parent,
                                tm.assign,
                                nvl(tm.tot_nhr, 0)                      hours,
                                nvl(tm.tot_ohr, 0)                      ot_hours,                                
                                pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                                pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                                case nvl(tm.locked, 0)                       
                                    when 1 then 'Yes'
                                        else ''
                                end                                     ts_locked,
                                case nvl(tm.approved, 0)                     
                                    when 1 then 'Yes'
                                        else ''
                                end                                     ts_approved,
                                case nvl(tm.posted, 0) 
                                    when 1 then 'Yes'
                                        else ''
                                end                                     ts_posted
                            From 
                                time_mast           tm,
                                emplmast            e
                            Where
                                tm.empno                = e.empno    
                                And tm.yymm             = Trim(p_yymm)
                                And (tm.assign In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod          = Trim(v_empno)
                                        Or secretary = Trim(v_empno)
                                    Union All
                                    Select
                                        costcode
                                    From
                                        time_secretary
                                    Where
                                        empno = Trim(v_empno)
                                )
                                Or (e.empno  = Trim(v_empno)
                                    Or e.do  = Trim(v_empno)))
                            Union
                            Select tomm.yymm,
                                e.empno,
                                initcap(e.name)                  empname,
                                e.emptype                        emptype,
                                e.parent,
                                tomm.assign,
                                tomm.hours                       hours,
                                0                                ot_hours,
                                null                            cc_hours,
                                null                            cc_ot_hours,
                                Case tomm.is_lock
                                    When 'OK' Then 'Yes'
                                        else ''
                                End                             ts_locked,
                                Case tomm.is_hod_approve
                                    When 'OK' Then 'Yes'
                                        else ''
                                End                             ts_approved,
                                Case tomm.is_post
                                    When 'OK' Then 'Yes'
                                        else ''
                                End                             ts_posted
                            From 
                                ts_osc_mhrs_master tomm,
                                emplmast e
                            Where tomm.empno = e.empno                            
                                And tomm.yymm = p_yymm 
                                And (tomm.assign In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod          = Trim(v_empno)
                                        Or secretary = Trim(v_empno)
                                    Union All
                                    Select
                                        costcode
                                    From
                                        time_secretary
                                    Where
                                        empno = Trim(v_empno)
                                )
                                Or (e.empno  = Trim(v_empno)
                                    Or e.do  = Trim(v_empno)))
                            )             
                    )
                Where
                    upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                Order by 
                    empno;                
        end if;
        
        if p_action_id = c_action_id_proco then
           Open c For            
                Select
                    *
                From
                    (                    
                        Select
                            yymm,
                            empno,
                            empname,
                            emptype,
                            parent,
                            assign,
                            hours,
                            ot_hours,                            
                            cc_hours,
                            cc_ot_hours,                            
                            ts_locked,
                            ts_approved,
                            ts_posted
                        From
                            (Select 
                                tm.yymm,
                                tm.empno,
                                initcap(e.name)                         empname,
                                e.emptype                               emptype,
                                tm.parent,
                                tm.assign,
                                nvl(tm.tot_nhr, 0)                      hours,
                                nvl(tm.tot_ohr, 0)                      ot_hours,                                
                                pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                                pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                                case nvl(tm.locked, 0)                       
                                    when 1 then 'Yes'
                                        else ''
                                end                                     ts_locked,
                                case nvl(tm.approved, 0)                     
                                    when 1 then 'Yes'
                                        else ''
                                end                                     ts_approved,
                                case nvl(tm.posted, 0) 
                                    when 1 then 'Yes'
                                        else ''
                                end                                     ts_posted
                            From 
                                time_mast           tm,
                                emplmast            e
                            Where
                                tm.empno                = e.empno    
                                And tm.yymm             = Trim(p_yymm)
                            Union
                            Select tomm.yymm,
                                em.empno,
                                initcap(em.name)                  empname,
                                em.emptype                        emptype,
                                em.parent,
                                tomm.assign,
                                tomm.hours                       hours,
                                0                                ot_hours,
                                null                            cc_hours,
                                null                            cc_ot_hours,
                                Case tomm.is_lock
                                    When 'OK' Then 'Yes'
                                        else ''
                                End                             ts_locked,
                                Case tomm.is_hod_approve
                                    When 'OK' Then 'Yes'
                                        else ''
                                End                             ts_approved,
                                Case tomm.is_post
                                    When 'OK' Then 'Yes'
                                        else ''
                                End                             ts_posted
                            From 
                                ts_osc_mhrs_master tomm,
                                emplmast em
                            Where tomm.empno = em.empno                            
                                And tomm.yymm = p_yymm 
                            )             
                    )
                Where
                    upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                Order by 
                    empno;                
        end if;
        
        Return c;
  end fn_employee_status_excel;        
    
  function fn_employee_locked_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,
        p_action_id      varchar2,
        p_yymm           Varchar2        
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        if p_action_id = c_action_id_sec then
            Open c For
              Select
                *
              From
               (
                Select
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,
                        hours,
                        ot_hours,                        
                        cc_hours,
                        cc_ot_hours,
                        ts_locked
                    From
                        (Select 
                            tm.yymm,
                            tm.empno,
                            initcap(e.name)                         empname,
                            e.emptype                               emptype,
                            tm.parent,
                            tm.assign,
                            nvl(tm.tot_nhr, 0)                      hours,
                            nvl(tm.tot_ohr, 0)                      ot_hours,                            
                            pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                            pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,                            
                            Case nvl(tm.locked, 0)
                                When 1 Then 'Yes'
                                    else ''
                            End                                     ts_locked
                        From 
                            time_mast           tm,
                            emplmast            e
                        Where
                            tm.empno = e.empno                            
                            And (tm.assign In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod          = Trim(v_empno)
                                        Or secretary = Trim(v_empno)
                                    Union All
                                    Select
                                        costcode
                                    From
                                        time_secretary
                                    Where
                                        empno = Trim(v_empno)
                                )
                                Or (e.empno  = Trim(v_empno)
                                    Or e.do  = Trim(v_empno)))
                            And tm.yymm             = Trim(p_yymm)
                            And nvl(tm.locked, 0)   in (0, 1) 
                        Union
                        Select tomm.yymm,
                            e.empno,
                            initcap(e.name)                  empname,
                            e.emptype                        emptype,
                            e.parent,
                            tomm.assign,
                            tomm.hours                       hours,
                            0                                ot_hours,
                            null                            cc_hours,
                            null                            cc_ot_hours,
                            Case tomm.is_lock
                                When 'OK' Then 'Yes'
                                    else ''
                            End                             ts_locked
                        From 
                            ts_osc_mhrs_master tomm,
                            emplmast e
                        Where tomm.empno = e.empno
                            And tomm.yymm = p_yymm                            
                            And (tomm.assign In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod          = Trim(v_empno)
                                        Or secretary = Trim(v_empno)
                                    Union All
                                    Select
                                        costcode
                                    From
                                        time_secretary
                                    Where
                                        empno = Trim(v_empno)
                                )
                                Or (e.empno  = Trim(v_empno)
                                    Or e.do  = Trim(v_empno)))
                        )                      
               )
               Where
                    upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                Order by 
                    empno;              
        end if;
        
        if p_action_id = c_action_id_proco then
            Open c For
                Select
                *
                From
                    (                    
                        Select
                            yymm,
                            empno,
                            empname,
                            emptype,
                            parent,
                            assign,
                            hours,
                            ot_hours,                            
                            cc_hours,
                            cc_ot_hours,                            
                            ts_locked
                        From
                            (Select 
                                tm.yymm,
                                tm.empno,
                                initcap(e.name)                         empname,
                                e.emptype                               emptype,
                                tm.parent,
                                tm.assign,
                                nvl(tm.tot_nhr, 0)                      hours,
                                nvl(tm.tot_ohr, 0)                      ot_hours,                                
                                pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                                pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                                case nvl(tm.locked, 0)                       
                                    when 1 then 'Yes'
                                        else ''
                                end                                     ts_locked
                            From 
                                time_mast           tm,
                                emplmast            e
                            Where
                                tm.empno                = e.empno    
                                And tm.yymm             = Trim(p_yymm) 
                                And nvl(tm.locked, 0)   in (0, 1) 
                            Union
                            Select tomm.yymm,
                                e.empno,
                                initcap(e.name)                  empname,
                                e.emptype                        emptype,
                                e.parent,
                                tomm.assign,
                                tomm.hours                       hours,
                                0                                ot_hours,
                                null                            cc_hours,
                                null                            cc_ot_hours,
                                Case tomm.is_lock
                                    When 'OK' Then 'Yes'
                                        else ''
                                End                             ts_locked
                            From 
                                ts_osc_mhrs_master tomm,
                                emplmast e
                            Where tomm.empno = e.empno                            
                                And tomm.yymm = p_yymm                                 
                            )             
                    )
                Where
                    upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                Order by 
                    empno;            
        end if;        
        
        Return c;
   end fn_employee_locked_excel;
    
  function fn_employee_approved_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_action_id      varchar2,
        p_yymm           Varchar2        
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;    
        
        if p_action_id = c_action_id_sec then
            Open c For
            Select
                *
              From
               (
                Select
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,
                        hours,
                        ot_hours,                        
                        cc_hours,
                        cc_ot_hours,
                        'Yes'  ts_locked,
                        ts_approved
                    From
                        (Select 
                            tm.yymm,
                            tm.empno,
                            initcap(e.name)                         empname,
                            e.emptype                               emptype,
                            tm.parent,
                            tm.assign,
                            nvl(tm.tot_nhr, 0)                      hours,
                            nvl(tm.tot_ohr, 0)                      ot_hours,                            
                            pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                            pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,                            
                            case nvl(tm.approved, 0) 
                                When 1 Then 'Yes'
                                    else ''
                            End                                     ts_approved
                        From 
                            time_mast           tm,
                            emplmast            e
                        Where
                            tm.empno = e.empno
                            And nvl(tm.locked, 0)   = 1
                            And nvl(tm.approved, 0) in (0, 1) 
                            And (tm.assign In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod          = Trim(v_empno)
                                        Or secretary = Trim(v_empno)
                                    Union All
                                    Select
                                        costcode
                                    From
                                        time_secretary
                                    Where
                                        empno = Trim(v_empno)
                                )
                                Or (e.empno  = Trim(v_empno)
                                    Or e.do  = Trim(v_empno)))
                            And tm.yymm             = Trim(p_yymm)                            
                        Union
                        Select tomm.yymm,
                            e.empno,
                            initcap(e.name)                  empname,
                            e.emptype                        emptype,
                            e.parent,
                            tomm.assign,
                            tomm.hours                       hours,
                            0                                ot_hours,
                            null                            cc_hours,
                            null                            cc_ot_hours,
                            Case tomm.is_hod_approve
                                When 'OK' Then 'Yes'
                                    else ''
                            End                             ts_approved
                        From 
                            ts_osc_mhrs_master tomm,
                            emplmast e
                        Where tomm.empno = e.empno
                            And tomm.yymm = p_yymm 
                            And tomm.is_lock = 'OK'
                            And (tomm.assign In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod          = Trim(v_empno)
                                        Or secretary = Trim(v_empno)
                                    Union All
                                    Select
                                        costcode
                                    From
                                        time_secretary
                                    Where
                                        empno = Trim(v_empno)
                                )
                                Or (e.empno  = Trim(v_empno)
                                    Or e.do  = Trim(v_empno)))
                        )                      
               )
               Where
                    upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                Order by 
                    empno; 
                    
        end if;
        
        if p_action_id = c_action_id_proco then
            Open c For
                Select
                *
                From
                    (                    
                        Select
                            yymm,
                            empno,
                            empname,
                            emptype,
                            parent,
                            assign,
                            hours,
                            ot_hours,                            
                            cc_hours,
                            cc_ot_hours, 
                            'Yes'  ts_locked,
                            ts_approved
                        From
                            (Select 
                                tm.yymm,
                                tm.empno,
                                initcap(e.name)                         empname,
                                e.emptype                               emptype,
                                tm.parent,
                                tm.assign,
                                nvl(tm.tot_nhr, 0)                      hours,
                                nvl(tm.tot_ohr, 0)                      ot_hours,                                
                                pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                                pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                                case nvl(tm.approved, 0)                       
                                    when 1 then 'Yes'
                                        else ''
                                end                                     ts_approved
                            From 
                                time_mast           tm,
                                emplmast            e
                            Where
                                tm.empno                = e.empno    
                                And tm.yymm             = Trim(p_yymm) 
                                And nvl(tm.locked, 0)   = 1
                                And nvl(tm.approved, 0) in (0, 1)  
                            Union
                            Select tomm.yymm,
                                e.empno,
                                initcap(e.name)                  empname,
                                e.emptype                        emptype,
                                e.parent,
                                tomm.assign,
                                tomm.hours                       hours,
                                0                                ot_hours,
                                null                             cc_hours,
                                null                             cc_ot_hours,
                                Case tomm.is_hod_approve
                                    When 'OK' Then 'Yes'
                                        else ''
                                End                              ts_approved
                            From 
                                ts_osc_mhrs_master tomm,
                                emplmast e
                            Where tomm.empno = e.empno                            
                                And tomm.yymm = p_yymm
                                And tomm.is_lock = 'OK'
                            )             
                    )
                Where
                    upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                Order by 
                    empno;             
        end if;       
        
        Return c;
   end fn_employee_approved_excel;
    
  function fn_employee_posted_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,
        p_action_id      varchar2,
        p_yymm           Varchar2        
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        if p_action_id = c_action_id_sec then
            Open c For
            Select
                *
              From
               (
                Select
                        yymm,
                        empno,
                        empname,
                        emptype,
                        parent,
                        assign,
                        hours,
                        ot_hours,                        
                        cc_hours,
                        cc_ot_hours,
                        'Yes'  ts_locked,
                        'Yes'  ts_approved,
                        ts_posted
                    From
                        (Select 
                            tm.yymm,
                            tm.empno,
                            initcap(e.name)                         empname,
                            e.emptype                               emptype,
                            tm.parent,
                            tm.assign,
                            nvl(tm.tot_nhr, 0)                      hours,
                            nvl(tm.tot_ohr, 0)                      ot_hours,                            
                            pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                            pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,                            
                            case nvl(tm.posted, 0)                       
                                when 1 then 'Yes'
                                    else ''
                            end                                     ts_posted
                        From 
                            time_mast           tm,
                            emplmast            e
                        Where
                            tm.empno = e.empno
                            And nvl(tm.locked, 0)    = 1
                            And nvl(tm.approved, 0)  = 1
                            And nvl(tm.posted, 0)    in (0, 1)
                            And (tm.assign In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod          = Trim(v_empno)
                                        Or secretary = Trim(v_empno)
                                    Union All
                                    Select
                                        costcode
                                    From
                                        time_secretary
                                    Where
                                        empno = Trim(v_empno)
                                )
                                Or (e.empno  = Trim(v_empno)
                                    Or e.do  = Trim(v_empno)))
                            And tm.yymm             = Trim(p_yymm)                            
                        Union
                        Select tomm.yymm,
                            e.empno,
                            initcap(e.name)                  empname,
                            e.emptype                        emptype,
                            e.parent,
                            tomm.assign,
                            tomm.hours                       hours,
                            0                                ot_hours,
                            null                            cc_hours,
                            null                            cc_ot_hours,
                            case nvl(tomm.is_post, 0)                       
                                when 'OK' then 'Yes'
                                    else ''
                            end                             ts_posted
                        From 
                            ts_osc_mhrs_master tomm,
                            emplmast e
                        Where tomm.empno = e.empno
                            And tomm.yymm = p_yymm 
                            And tomm.is_lock = 'OK'
                            And tomm.is_hod_approve = 'OK'
                            And (tomm.assign In (
                                    Select
                                        costcode
                                    From
                                        costmast
                                    Where
                                        hod          = Trim(v_empno)
                                        Or secretary = Trim(v_empno)
                                    Union All
                                    Select
                                        costcode
                                    From
                                        time_secretary
                                    Where
                                        empno = Trim(v_empno)
                                )
                                Or (e.empno  = Trim(v_empno)
                                    Or e.do  = Trim(v_empno)))
                        )                      
               )
               Where
                    upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                Order by 
                    empno;            
        end if;
        
        if p_action_id = c_action_id_proco then
            Open c For
            Select
                *
                From
                    (                    
                        Select
                            yymm,
                            empno,
                            empname,
                            emptype,
                            parent,
                            assign,
                            hours,
                            ot_hours,                            
                            cc_hours,
                            cc_ot_hours, 
                            'Yes'  ts_locked,
                            'Yes'  ts_approved,
                            ts_posted
                        From
                            (Select 
                                tm.yymm,
                                tm.empno,
                                initcap(e.name)                         empname,
                                e.emptype                               emptype,
                                tm.parent,
                                tm.assign,
                                nvl(tm.tot_nhr, 0)                      hours,
                                nvl(tm.tot_ohr, 0)                      ot_hours,                                
                                pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, tm.assign, tm.empno)    cc_hours,
                                pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, tm.assign, tm.empno)        cc_ot_hours,
                                case nvl(tm.posted, 0)                       
                                    when 1 then 'Yes'
                                        else ''
                                end                                     ts_posted
                            From 
                                time_mast           tm,
                                emplmast            e
                            Where
                                tm.empno                = e.empno    
                                And tm.yymm             = Trim(p_yymm) 
                                And nvl(tm.locked, 0)   = 1
                                And nvl(tm.approved, 0)   = 1
                                And nvl(tm.posted, 0) in (0, 1)  
                            Union
                            Select tomm.yymm,
                                e.empno,
                                initcap(e.name)                  empname,
                                e.emptype                        emptype,
                                e.parent,
                                tomm.assign,
                                tomm.hours                       hours,
                                0                                ot_hours,
                                null                             cc_hours,
                                null                             cc_ot_hours,
                                case nvl(tomm.is_post, 0)                       
                                    when 'OK' then 'Yes'
                                        else ''
                                end                             ts_posted
                            From 
                                ts_osc_mhrs_master tomm,
                                emplmast e
                            Where tomm.empno = e.empno                            
                                And tomm.yymm = p_yymm
                                 And tomm.is_lock = 'OK'
                                 And tomm.is_hod_approve = 'OK'
                            )             
                    )
                Where
                    upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(assign) Like '%' || upper(Trim(p_generic_search)) || '%'
                Order by 
                    empno;             
        end if;       
        
        Return c;
   end fn_employee_posted_excel;
  
  function fn_employee_notfilled_excel(
        p_person_id      varchar2,
        p_meta_id        varchar2,        
        p_generic_search varchar2 default null,
        p_action_id      varchar2,
        p_yymm           varchar2
    ) return sys_refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        if p_action_id = c_action_id_sec then
            Open c For
            select 
                    yymm,
                    empno,
                    empname,
                    emptype,
                    parent,
                    assign,
                    status_name
            from
            (
                Select                           
                    p_yymm                                 yymm,
                    e.empno,
                    initcap(e.name)                         empname,
                    e.emptype,
                    e.parent,
                    e.assign,
                    pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, e.empno, e.assign)    status_name                        
                From                        
                    emplmast           e,                      
                    deptphase          dp
                Where
                    e.assign            = dp.costcode 
                    And (e.assign In (
                        Select
                            costcode
                        From
                            costmast
                        Where
                            hod          = Trim(v_empno)
                            Or secretary = Trim(v_empno)
                        Union All
                        Select
                            costcode
                        From
                            time_secretary
                        Where
                            empno = Trim(v_empno)
                    )
                    Or (e.empno  = Trim(v_empno)
                        Or e.do  = Trim(v_empno)))
                    And dp.isprimary    = 1
                    And e.emptype       in ('R','F','S','C')
                    And e.status        = 1                                        
                Union
                select 
                   tm.yymm,
                   tm.empno,
                   initcap(em.name)                         empname,
                   em.emptype                               emptype,
                   tm.parent,
                   tm.assign,
                   pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, em.empno, tm.assign)    status_name
                from 
                    time_mast tm,
                    emplmast em
                where 
                    tm.empno = em.empno                       
                    And tm.yymm = p_yymm
                    And (tm.assign In (
                        Select
                            costcode
                        From
                            costmast
                        Where
                            hod          = Trim(v_empno)
                            Or secretary = Trim(v_empno)
                        Union All
                        Select
                            costcode
                        From
                            time_secretary
                        Where
                            empno = Trim(v_empno)
                    )
                    Or (em.empno  = Trim(v_empno)
                        Or em.do  = Trim(v_empno)))
                    And Not Exists (select empno from                      
                                    emplmast           e,                      
                                    deptphase          dp
                                Where
                                    e.assign            = dp.costcode              
                                    And dp.isprimary    = 1
                                    And e.emptype       in ('R','F','S','C')
                                    And e.status        = 1                                    
                                    And e.assign        = tm.assign
                                    And e.empno         = tm.empno)
            )
            where
                status_name = 'Not filled'
                And (upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(assign)   Like '%' || upper(Trim(p_generic_search)) || '%')                       
                Order by 
                    assign, empno;
        end if;
        
        if p_action_id = c_action_id_proco then
            Open c For
            select 
                    yymm,
                    empno,
                    empname,
                    emptype,
                    parent,
                    assign,
                    status_name
            from
            (
                Select                           
                    p_yymm                                 yymm,
                    e.empno,
                    initcap(e.name)                         empname,
                    e.emptype,
                    e.parent,
                    e.assign,
                    pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, e.empno, e.assign)    status_name                        
                From                        
                    emplmast           e,                      
                    deptphase          dp
                Where
                    e.assign            = dp.costcode                     
                    And dp.isprimary    = 1
                    And e.emptype       in ('R','F','S','C')
                    And e.status        = 1                                        
                Union
                select 
                   tm.yymm,
                   tm.empno,
                   initcap(em.name)                         empname,
                   em.emptype                               emptype,
                   tm.parent,
                   tm.assign,
                   pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, em.empno, tm.assign)    status_name
                from 
                    time_mast tm,
                    emplmast em
                where 
                    tm.empno = em.empno                       
                    And tm.yymm = p_yymm                    
                    And Not Exists (select empno from                      
                                    emplmast           e,                      
                                    deptphase          dp
                                Where
                                    e.assign            = dp.costcode              
                                    And dp.isprimary    = 1
                                    And e.emptype       in ('R','F','S','C')
                                    And e.status        = 1                                    
                                    And e.assign        = tm.assign
                                    And e.empno         = tm.empno)
            )
            where
                status_name = 'Not filled'
                And (upper(empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(assign)   Like '%' || upper(Trim(p_generic_search)) || '%')                       
                Order by 
                    assign, empno;
        end if;
        
        Return c;
  end fn_employee_notfilled_excel;
  
  
  Function fn_total_employee_submit(
        p_costcode       Varchar2,
        p_yymm           Varchar2
    ) Return Number as
        v_count          Number := 0;
    begin    
        Select                           
            Count(*)
        Into
            v_count
        From                        
            emplmast           e,                      
            deptphase          dp
        Where
            e.assign            = dp.costcode                        
            And dp.isprimary    = 1
            And e.emptype       in ('R','F','S','C')
            And e.status        = 1            
            And e.assign        = p_costcode;
        return v_count;
  end fn_total_employee_submit;
  
  Function fn_filled_partial_status_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
      
      Open c For
            Select
                *
            From
                (                    
                    Select
                        t.*,
                        Row_Number() Over(Order By t.empno)         row_number,
                        Count(*) Over()                             total_row
                    From
                    ( 
                        Select 
                            em.empno,
                            initcap(em.name)                        empname,
                            tomm.parent,
                            tomm.assign,
                            em.emptype,
                            nvl(tomm.hours,0)                       hours,
                            0                                       ot_hours,                        
                            0                                       cc_hours,
                            0                                       cc_ot_hours,
                            case                        
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) < nvl(tomm.hours,0) then 'text-red'
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) > nvl(tomm.hours,0) then 'text-blue'
                                else ''
                            end                                     txt_color,
                            pkg_ts_status_qry.fn_get_timesheet_status(tomm.yymm, em.empno, tomm.assign)    current_status
                        from 
                            ts_osc_mhrs_master tomm,
                            emplmast            em
                        where  
                            tomm.empno = em.empno
                            And tomm.assign           = p_costcode
                            And tomm.yymm             = Trim(p_yymm)                    
                        Union All
                        Select 
                            tm.empno,
                            initcap(e.name)                         empname,
                            tm.parent,
                            tm.assign,
                            e.emptype,
                            nvl(tm.tot_nhr,0)                       hours,
                            nvl(tm.tot_ohr,0)                       ot_hours,                        
                            pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, p_costcode, tm.empno)    cc_hours,
                            pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, p_costcode, tm.empno)        cc_ot_hours,
                            case                        
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) < nvl(tm.tot_nhr,0) then 'text-red'
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) > nvl(tm.tot_nhr,0) then 'text-blue'
                                else ''
                            end                                     txt_color,
                            pkg_ts_status_qry.fn_get_timesheet_status(tm.yymm, tm.empno, tm.assign)        current_status
                        From 
                            time_mast           tm,
                            emplmast            e
                        Where
                            tm.empno = e.empno
                            And tm.assign           = p_costcode
                            And tm.yymm             = Trim(p_yymm)                        
                    ) t
                    Where
                        (upper(t.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(t.empname)   Like '%' || upper(Trim(p_generic_search)) || '%')
                    Order by 
                        t.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c; 
  end fn_filled_partial_status_list;
  
  Function fn_locked_partial_status_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
      
      Open c For
            Select
                *
            From
                (                    
                    Select
                        t.*,
                        Row_Number() Over(Order By t.empno)         row_number,
                        Count(*) Over()                             total_row
                    From
                    (   
                        Select 
                            em.empno,
                            initcap(em.name)                        empname,
                            tomm.parent,
                            tomm.assign,
                            em.emptype,
                            nvl(tomm.hours,0)                       hours,
                            0                                       ot_hours,                        
                            0                                       cc_hours,
                            0                                       cc_ot_hours,
                            case tomm.is_lock
                                when 'OK' then  1
                                else            0
                            end                                     is_status_true,          
                            case                        
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) < nvl(tomm.hours,0) then 'text-red'
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) > nvl(tomm.hours,0) then 'text-blue'
                                else ''
                            end                                     txt_color,
                            pkg_ts_status_qry.fn_get_timesheet_status(tomm.yymm, em.empno, tomm.assign)    current_status
                        from 
                            ts_osc_mhrs_master tomm,
                            emplmast            em
                        where  
                            tomm.empno = em.empno
                            And tomm.assign           = p_costcode
                            And tomm.yymm             = Trim(p_yymm)   
                            And tomm.is_lock          = 'OK'
                        Union All
                        Select 
                            tm.empno,
                            initcap(e.name)                         empname,
                            tm.parent,
                            tm.assign,
                            e.emptype,
                            nvl(tm.tot_nhr,0)                       hours,
                            nvl(tm.tot_ohr,0)                       ot_hours,
                            pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, p_costcode, tm.empno)    cc_hours,
                            pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, p_costcode, tm.empno)        cc_ot_hours,
                            --nvl(tm.tot_nhr,0) + nvl(tm.tot_ohr,0)   tot_hours,
                            nvl(tm.locked, 0)                     is_status_true,
                            case                        
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) < nvl(tm.tot_nhr,0) then 'text-red'
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) > nvl(tm.tot_nhr,0) then 'text-blue'
                                else ''
                            end                                     txt_color,
                            pkg_ts_status_qry.fn_get_timesheet_status(tm.yymm, tm.empno, tm.assign)        current_status
                        From 
                            time_mast           tm,
                            emplmast            e
                        Where
                            tm.empno = e.empno
                            And tm.assign           = p_costcode
                            And tm.yymm             = Trim(p_yymm)
                            And nvl(tm.locked, 0)   = 1
                     ) t
                    Where
                        (upper(t.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(t.empname)   Like '%' || upper(Trim(p_generic_search)) || '%')                       
                    Order by 
                        t.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c; 
  end fn_locked_partial_status_list;
   
  Function fn_approved_partial_status_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
      
      Open c For
            Select
                *
            From
                (                    
                    Select
                        t.*,
                        Row_Number() Over(Order By t.empno)         row_number,
                        Count(*) Over()                             total_row
                    From
                    (                             
                        Select 
                            em.empno,
                            initcap(em.name)                        empname,
                            tomm.parent,
                            tomm.assign,
                            em.emptype,
                            nvl(tomm.hours,0)                       hours,
                            0                                       ot_hours,                        
                            0                                       cc_hours,
                            0                                       cc_ot_hours,
                            case tomm.is_hod_approve
                                when 'OK' then  1
                                else            0
                            end                                     is_status_true,          
                            case                        
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) < nvl(tomm.hours,0) then 'text-red'
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) > nvl(tomm.hours,0) then 'text-blue'
                                else ''
                            end                                     txt_color,
                            pkg_ts_status_qry.fn_get_timesheet_status(tomm.yymm, em.empno, tomm.assign)    current_status
                        from 
                            ts_osc_mhrs_master tomm,
                            emplmast            em
                        where  
                            tomm.empno = em.empno
                            And tomm.assign           = p_costcode
                            And tomm.yymm             = Trim(p_yymm)   
                            And tomm.is_hod_approve   = 'OK'
                        Union All
                        Select 
                            tm.empno,
                            initcap(e.name)                         empname,
                            tm.parent,
                            tm.assign,
                            e.emptype,
                            nvl(tm.tot_nhr,0)                       hours,
                            nvl(tm.tot_ohr,0)                       ot_hours,
                            pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, p_costcode, tm.empno)    cc_hours,
                            pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, p_costcode, tm.empno)        cc_ot_hours,
                            --nvl(tm.tot_nhr,0) + nvl(tm.tot_ohr,0)   tot_hours,
                            nvl(tm.approved, 0)                     is_status_true,
                            case                        
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) < nvl(tm.tot_nhr,0) then 'text-red'
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) > nvl(tm.tot_nhr,0) then 'text-blue'
                                else ''
                            end                                     txt_color,
                            pkg_ts_status_qry.fn_get_timesheet_status(tm.yymm, tm.empno, tm.assign)        current_status
                        From 
                            time_mast           tm,
                            emplmast            e
                        Where
                            tm.empno = e.empno
                            And tm.assign           = p_costcode
                            And tm.yymm             = Trim(p_yymm)
                            And nvl(tm.approved, 0) = 1
                    ) t
                    Where 
                        (upper(t.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(t.empname)   Like '%' || upper(Trim(p_generic_search)) || '%')                       
                    Order by 
                        t.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c; 
  end fn_approved_partial_status_list;
  
  Function fn_posted_partial_status_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
      
      Open c For
            Select
                *
            From
                (                    
                    Select
                        t.*,
                        Row_Number() Over(Order By t.empno)         row_number,
                        Count(*) Over()                             total_row
                    From
                    (
                        Select 
                            em.empno,
                            initcap(em.name)                        empname,
                            tomm.parent,
                            tomm.assign,
                            em.emptype,
                            nvl(tomm.hours,0)                       hours,
                            0                                       ot_hours,                        
                            0                                       cc_hours,
                            0                                       cc_ot_hours,
                            case tomm.is_post
                                when 'OK' then  1
                                else            0
                            end                                     is_status_true,          
                            case                        
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) < nvl(tomm.hours,0) then 'text-red'
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) > nvl(tomm.hours,0) then 'text-blue'
                                else ''
                            end                                     txt_color,
                            pkg_ts_status_qry.fn_get_timesheet_status(tomm.yymm, em.empno, tomm.assign)    current_status
                        from 
                            ts_osc_mhrs_master tomm,
                            emplmast            em
                        where  
                            tomm.empno = em.empno
                            And tomm.assign           = p_costcode
                            And tomm.yymm             = Trim(p_yymm)   
                            And tomm.is_post          = 'OK'
                        Union All                    
                        Select 
                            tm.empno,
                            initcap(e.name)                         empname,
                            tm.parent,
                            tm.assign,
                            e.emptype,
                            nvl(tm.tot_nhr,0)                       hours,
                            nvl(tm.tot_ohr,0)                       ot_hours,
                            pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, p_costcode, tm.empno)    cc_hours,
                            pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, p_costcode, tm.empno)        cc_ot_hours,                            
                            nvl(tm.posted, 0)                       is_status_true,
                            case                        
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) < nvl(tm.tot_nhr,0) then 'text-red'
                                when pkg_ts_status_qry.fn_monthly_normal_hours(p_yymm) > nvl(tm.tot_nhr,0) then 'text-blue'
                                else ''
                            end                                     txt_color,
                            pkg_ts_status_qry.fn_get_timesheet_status(tm.yymm, tm.empno, tm.assign)        current_status
                        From 
                            time_mast           tm,
                            emplmast            e
                        Where
                            tm.empno = e.empno
                            And tm.assign           = p_costcode
                            And tm.yymm             = Trim(p_yymm)
                            And nvl(tm.posted, 0)   = 1
                    ) t
                    Where
                        (upper(t.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(t.empname)   Like '%' || upper(Trim(p_generic_search)) || '%')                       
                    Order by 
                        t.empno
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c; 
  end fn_posted_partial_status_list;
  
    
  Function fn_filled_partial_status_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        Open c For
            Select
                *
            From
            (
                Select 
                    tomm.yymm,
                    em.empno,
                    initcap(em.name)                        empname,
                    tomm.parent,
                    tomm.assign,                    
                    nvl(tomm.hours,0)                       hours,
                    0                                       ot_hours, 
                    nvl(tomm.hours,0)                       tot_hours,
                    0                                       cc_hours,
                    0                                       cc_ot_hours,
                    pkg_ts_status_qry.fn_get_timesheet_status(tomm.yymm, em.empno, tomm.assign)   status_name     
                from 
                    ts_osc_mhrs_master tomm,
                    emplmast            em
                where  
                    tomm.empno = em.empno
                    And tomm.assign           = p_costcode
                    And tomm.yymm             = Trim(p_yymm)            
                Union All
                Select 
                    tm.yymm,
                    tm.empno,
                    initcap(e.name)                         empname,
                    tm.parent,
                    tm.assign,
                    nvl(tm.tot_nhr,0)                       hours,
                    nvl(tm.tot_ohr,0)                       ot_hours,
                    nvl(tm.tot_nhr,0) + nvl(tm.tot_ohr,0)   tot_hours,
                    pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, p_costcode, tm.empno)    cc_hours,
                    pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, p_costcode, tm.empno)        cc_ot_hours,
                    pkg_ts_status_qry.fn_get_timesheet_status(tm.yymm, tm.empno, tm.assign)       status_name
                From 
                    time_mast           tm,
                    emplmast            e
                Where
                    tm.empno = e.empno
                    And tm.assign           = p_costcode
                    And tm.yymm             = Trim(p_yymm)                    
            ) t
            Where
                (upper(t.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                  Or upper(t.empname)   Like '%' || upper(Trim(p_generic_search)) || '%')                       
            Order by 
                t.empno;
        Return c;
   end fn_filled_partial_status_excel;
   
  Function fn_locked_partial_status_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        Open c For
            Select
                *
            From
            (
                Select 
                    tomm.yymm,
                    em.empno,
                    initcap(em.name)                        empname,
                    tomm.parent,
                    tomm.assign,                    
                    nvl(tomm.hours,0)                       hours,
                    0                                       ot_hours, 
                    nvl(tomm.hours,0)                       tot_hours,
                    0                                       cc_hours,
                    0                                       cc_ot_hours,
                    pkg_ts_status_qry.fn_get_timesheet_status(tomm.yymm, em.empno, tomm.assign)  status_name     
                from 
                    ts_osc_mhrs_master tomm,
                    emplmast            em
                where  
                    tomm.empno = em.empno
                    And tomm.assign           = p_costcode
                    And tomm.yymm             = Trim(p_yymm)
                    And tomm.is_lock = 'OK'            
                Union All
                Select 
                    tm.yymm,
                    tm.empno,
                    initcap(e.name)                         empname,
                    tm.parent,
                    tm.assign,
                    nvl(tm.tot_nhr,0)                       hours,
                    nvl(tm.tot_ohr,0)                       ot_hours,
                    nvl(tm.tot_nhr,0) + nvl(tm.tot_ohr,0)   tot_hours,
                    pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, p_costcode, tm.empno)    cc_hours,
                    pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, p_costcode, tm.empno)        cc_ot_hours,
                    pkg_ts_status_qry.fn_get_timesheet_status(tm.yymm, tm.empno, tm.assign)       status_name
                From 
                    time_mast           tm,
                    emplmast            e
                Where
                    tm.empno = e.empno
                    And tm.assign           = p_costcode
                    And tm.yymm             = Trim(p_yymm)
                    And nvl(tm.locked, 0)   = 1
            ) t
            Where
                (upper(t.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                  Or upper(t.empname)   Like '%' || upper(Trim(p_generic_search)) || '%')                       
            Order by 
                t.empno;
        Return c;
   end fn_locked_partial_status_excel;
    
  Function fn_approved_partial_status_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        Open c For
            Select
                *
            From
            (
                Select 
                    tomm.yymm,
                    em.empno,
                    initcap(em.name)                        empname,
                    tomm.parent,
                    tomm.assign,                    
                    nvl(tomm.hours,0)                       hours,
                    0                                       ot_hours, 
                    nvl(tomm.hours,0)                       tot_hours,
                    0                                       cc_hours,
                    0                                       cc_ot_hours,
                    pkg_ts_status_qry.fn_get_timesheet_status(tomm.yymm, em.empno, tomm.assign)  status_name     
                from 
                    ts_osc_mhrs_master tomm,
                    emplmast            em
                where  
                    tomm.empno = em.empno
                    And tomm.assign           = p_costcode
                    And tomm.yymm             = Trim(p_yymm)
                    And tomm.is_lock = 'OK'            
                Union All            
                Select 
                    tm.yymm,
                    tm.empno,
                    initcap(e.name)                         empname,
                    tm.parent,
                    tm.assign,
                    nvl(tm.tot_nhr,0)                       hours,
                    nvl(tm.tot_ohr,0)                       ot_hours,
                    nvl(tm.tot_nhr,0) + nvl(tm.tot_ohr,0)   tot_hours,
                    pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, p_costcode, tm.empno)    cc_hours,
                    pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, p_costcode, tm.empno)        cc_ot_hours,
                    pkg_ts_status_qry.fn_get_timesheet_status(tm.yymm, tm.empno, tm.assign)       status_name
                From 
                    time_mast           tm,
                    emplmast            e
                Where
                    tm.empno = e.empno
                    And tm.assign           = p_costcode
                    And tm.yymm             = Trim(p_yymm)
                    And nvl(tm.approved, 0) = 1
           ) t
           Where     
                (upper(t.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                  Or upper(t.empname)   Like '%' || upper(Trim(p_generic_search)) || '%')                       
            Order by 
                t.empno;
        Return c;
   end fn_approved_partial_status_excel;
    
  Function fn_posted_partial_status_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        Open c For
            Select
                *
            From
            (            
                Select 
                    tomm.yymm,
                    em.empno,
                    initcap(em.name)                        empname,
                    tomm.parent,
                    tomm.assign,                    
                    nvl(tomm.hours,0)                       hours,
                    0                                       ot_hours, 
                    nvl(tomm.hours,0)                       tot_hours,
                    0                                       cc_hours,
                    0                                       cc_ot_hours,
                    pkg_ts_status_qry.fn_get_timesheet_status(tomm.yymm, em.empno, tomm.assign)  status_name     
                from 
                    ts_osc_mhrs_master tomm,
                    emplmast            em
                where  
                    tomm.empno = em.empno
                    And tomm.assign           = p_costcode
                    And tomm.yymm             = Trim(p_yymm)
                    And tomm.is_lock = 'OK'            
                Union All 
                Select 
                    tm.yymm,
                    tm.empno,
                    initcap(e.name)                         empname,
                    tm.parent,
                    tm.assign,
                    nvl(tm.tot_nhr,0)                       hours,
                    nvl(tm.tot_ohr,0)                       ot_hours,
                    nvl(tm.tot_nhr,0) + nvl(tm.tot_ohr,0)   tot_hours,
                    pkg_ts_status_qry.fn_get_other_cc_normal_hrs(p_yymm, p_costcode, tm.empno)    cc_hours,
                    pkg_ts_status_qry.fn_get_other_cc_ot_hrs(p_yymm, p_costcode, tm.empno)        cc_ot_hours,
                    pkg_ts_status_qry.fn_get_timesheet_status(tm.yymm, tm.empno, tm.assign)       status_name
                From 
                    time_mast           tm,
                    emplmast            e
                Where
                    tm.empno = e.empno
                    And tm.assign           = p_costcode
                    And tm.yymm             = Trim(p_yymm)
                    And nvl(tm.posted, 0)   = 1
            ) t
            Where
                 (upper(t.empno) Like '%' || upper(Trim(p_generic_search)) || '%'
                  Or upper(t.empname)   Like '%' || upper(Trim(p_generic_search)) || '%')                       
            Order by 
                t.empno;
        Return c;
   end fn_posted_partial_status_excel;
    

  Function fn_employee_project_hours_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_empno          Varchar2, 
        p_costcode       Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
       
        Open c For
            Select
                *
            From
                ( 
                    select 
                        p_yymm                                              yymm,
                        projno,
                        pkg_ts_status_qry.fn_get_project_name(projno)       name,
                        hours,
                        ot_hours,
                        tot_hours,
                        Row_Number() Over(Order By projno)                  row_number,
                        Count(*) Over()                                     total_row
                    from 
                        (                            
                            select
                                t.projno,
                                nvl(sum(t.hours),0)                          hours,
                                nvl(sum(t.othours),0)                        ot_hours,
                                nvl(sum(t.hours),0) + nvl(sum(t.othours),0)  tot_hours
                            from
                                    (Select
                                            substr(td.projno,1,5)           projno,                                                                        
                                            sum(nvl(td.total,0))            hours,
                                            0                               othours
                                        From                                     
                                            time_daily      td
                                        Where                                    
                                            td.yymm         = Trim(p_yymm)
                                            And td.empno    = p_empno
                                            And td.assign   = Trim(p_costcode) 
                                        Group by 
                                            substr(td.projno,1,5)                                    
                                   Union all         
                                        Select
                                            substr(ot.projno,1,5)           projno, 
                                            0                               hours,
                                            sum(nvl(ot.Total,0))            othours
                                        From                                     
                                            time_ot      ot
                                        Where                                    
                                            ot.yymm         = Trim(p_yymm) 
                                            And ot.empno    = p_empno
                                            And ot.assign   = Trim(p_costcode)
                                        Group by 
                                            substr(ot.projno,1,5)
                                   Union all
                                        Select                                             
                                            substr(tomd.projno,1,5)      projno,                                                                        
                                            sum(nvl(tomd.hours,0))       hours,
                                            0                            othours 
                                        From 
                                            ts_osc_mhrs_master  tomm,
                                            ts_osc_mhrs_detail  tomd
                                        Where
                                            tomd.oscm_id      = tomm.oscm_id
                                            And tomm.empno    = p_empno
                                            And tomm.yymm     = Trim(p_yymm) 
                                            And tomm.assign   = Trim(p_costcode)
                                        Group by                                            
                                            substr(tomd.projno,1,5)
                                    
                                ) t                             
                            group by                    
                                t.projno
                          ) 
                    where
                        (upper(projno)  Like '%' || upper(Trim(p_generic_search)) || '%'
                         Or upper(pkg_ts_status_qry.fn_get_project_name(projno))   Like '%' || upper(Trim(p_generic_search)) || '%' ) 
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order by
                projno;

        Return c; 
   end fn_employee_project_hours_list; 
      
  Function fn_project_hours_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
       
        Open c For
            Select
                *
            From
                ( 
                    select 
                        p_yymm                                              yymm,
                        projno,
                        pkg_ts_status_qry.fn_get_project_name(projno)       name,
                        hours,
                        ot_hours,
                        tot_hours,
                        Row_Number() Over(Order By projno)                  row_number,
                        Count(*) Over()                                     total_row
                    from 
                        (                            
                            select
                                t.projno,
                                nvl(sum(t.hours),0)                          hours,
                                nvl(sum(t.othours),0)                        ot_hours,
                                nvl(sum(t.hours),0) + nvl(sum(t.othours),0)  tot_hours
                            from
                                (
                                    Select
                                        substr(td.projno,1,5)           projno,                                                                        
                                        sum(nvl(td.total,0))            hours,
                                        0                               othours
                                    From                                     
                                        time_daily      td
                                    Where                                    
                                        td.yymm     = Trim(p_yymm) 
                                        And td.assign   = Trim(p_costcode) 
                                    Group by 
                                        substr(td.projno,1,5)                                    
                                   Union all         
                                    Select
                                        substr(ot.projno,1,5)           projno, 
                                        0                               hours,
                                        sum(nvl(ot.Total,0))            othours
                                    From                                     
                                        time_ot      ot
                                    Where                                    
                                        ot.yymm     = Trim(p_yymm) 
                                        And ot.assign   = Trim(p_costcode)
                                    Group by 
                                        substr(ot.projno,1,5) 
                                   Union all
                                    Select 
                                        substr(tomd.projno,1,5)         projno,                                                                        
                                           sum(nvl(tomd.hours,0))       hours,
                                           0                            othours 
                                    From 
                                        ts_osc_mhrs_master  tomm,
                                        ts_osc_mhrs_detail  tomd
                                    Where
                                        tomd.oscm_id = tomm.oscm_id
                                        And tomm.yymm     = Trim(p_yymm) 
                                        And tomm.assign   = Trim(p_costcode)
                                    Group by 
                                        substr(tomd.projno,1,5)
                                ) t                             
                            group by                    
                                t.projno
                          ) 
                    where
                        (upper(projno)  Like '%' || upper(Trim(p_generic_search)) || '%'
                         Or upper(pkg_ts_status_qry.fn_get_project_name(projno))   Like '%' || upper(Trim(p_generic_search)) || '%' ) 
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order by
                projno;

        Return c; 
   end fn_project_hours_list;
  
  Function fn_project_timesheet_status_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_projno         Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
      
      Open c For
         select
            *
         from            
            (Select
                empno,
                empname,
                parent,
                assign,
                projno,
                hours,
                ot_hours,
                tot_hours,
                Row_Number() Over(Order By empno)          row_number,
                Count(*) Over()                              total_row
            From
                (                    
                    select
                        t.empno,
                        e.name                                      empname,
                        t.parent,
                        t.assign,
                        t.projno,
                        nvl(sum(t.hours),0)                          hours,
                        nvl(sum(t.othours),0)                        ot_hours,
                        nvl(sum(t.hours),0) + nvl(sum(t.othours),0)  tot_hours
                    from
                            (Select
                                    td.empno,
                                    td.parent,
                                    td.assign,
                                    substr(td.projno,1,5)           projno,
                                    sum(nvl(td.total,0))            hours,
                                    0                               othours
                                From                                     
                                    time_daily      td
                                Where                                    
                                    td.yymm     = Trim(p_yymm) 
                                    And td.assign   = Trim(p_costcode)
                                    And substr(td.projno,1,5) = Trim(p_projno)                                    
                                Group by 
                                    td.empno,
                                    td.parent,
                                    td.assign,
                                    substr(td.projno,1,5)
                           Union all         
                                Select                         
                                   
                                    ot.empno,
                                    ot.parent,
                                    ot.assign,
                                    substr(ot.projno,1,5)           projno,
                                    0                               hours,
                                    sum(nvl(ot.total,0))            othours
                                From                                     
                                    time_ot      ot
                                Where                                    
                                    ot.yymm     = Trim(p_yymm) 
                                    And ot.assign   = Trim(p_costcode)
                                    And substr(ot.projno,1,5) = Trim(p_projno)                                    
                                Group by 
                                    ot.empno,
                                    ot.parent,
                                    ot.assign,
                                    substr(ot.projno,1,5)
                            Union all
                                    Select 
                                        tomm.empno,
                                        tomm.parent,
                                        tomm.assign,
                                        substr(tomd.projno,1,5)      projno,                                                                        
                                        sum(nvl(tomd.hours,0))       hours,
                                        0                            othours 
                                    From 
                                        ts_osc_mhrs_master  tomm,
                                        ts_osc_mhrs_detail  tomd
                                    Where
                                        tomd.oscm_id = tomm.oscm_id
                                        And tomm.yymm     = Trim(p_yymm) 
                                        And tomm.assign   = Trim(p_costcode)
                                    Group by
                                        tomm.empno,
                                        tomm.parent,
                                        tomm.assign,
                                        substr(tomd.projno,1,5)
                        ) t,
                        emplmast e
                    where
                        e.empno = t.empno
                        And (upper(t.empno)  Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(e.name)   Like '%' || upper(Trim(p_generic_search)) || '%'
                          Or upper(t.projno) Like '%' || upper(Trim(p_generic_search)) || '%')  
                    group by 
                        t.empno,
                        e.name,
                        t.parent,
                        t.assign,
                        t.projno)
                    
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c; 
  end fn_project_timesheet_status_list;  
  
  
  Function fn_project_hours_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
       
        Open c For
            select 
                p_yymm                                              yymm,
                projno,
                pkg_ts_status_qry.fn_get_project_name(projno)       name,
                hours,
                ot_hours,
                tot_hours
            from 
                (                            
                    select
                        t.projno,
                        nvl(sum(t.hours),0)                          hours,
                        nvl(sum(t.othours),0)                        ot_hours,
                        nvl(sum(t.hours),0) + nvl(sum(t.othours),0)  tot_hours
                    from
                            (Select
                                    substr(td.projno,1,5)           projno,                                                                        
                                    sum(nvl(td.total,0))            hours,
                                    0                               othours
                                From                                     
                                    time_daily      td
                                Where                                    
                                    td.yymm     = Trim(p_yymm) 
                                    And td.assign   = Trim(p_costcode) 
                                Group by 
                                    substr(td.projno,1,5)                                    
                           Union all         
                                Select
                                    substr(ot.projno,1,5)           projno, 
                                    0                               hours,
                                    sum(nvl(ot.Total,0))            othours
                                From                                     
                                    time_ot      ot
                                Where                                    
                                    ot.yymm     = Trim(p_yymm) 
                                    And ot.assign   = Trim(p_costcode)
                                Group by 
                                    substr(ot.projno,1,5)
                            Union all
                                    Select 
                                        substr(tomd.projno,1,5)         projno,                                                                        
                                           sum(nvl(tomd.hours,0))       hours,
                                           0                            othours 
                                    From 
                                        ts_osc_mhrs_master  tomm,
                                        ts_osc_mhrs_detail  tomd
                                    Where
                                        tomd.oscm_id = tomm.oscm_id
                                        And tomm.yymm     = Trim(p_yymm) 
                                        And tomm.assign   = Trim(p_costcode)
                                    Group by 
                                        substr(tomd.projno,1,5)
                        ) t                             
                    group by                    
                        t.projno
                  ) 
            where
                (upper(projno)  Like '%' || upper(Trim(p_generic_search)) || '%'
                 Or upper(pkg_ts_status_qry.fn_get_project_name(projno))   Like '%' || upper(Trim(p_generic_search)) || '%' )                 
            Order by
                projno;

        Return c; 
   end fn_project_hours_excel;
    
  Function fn_project_timesheet_status_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,        
        p_generic_search Varchar2 Default Null,       
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_projno         Varchar2
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
      
      Open c For          
            select
                p_yymm                                      yymm,
                t.empno,
                e.name                                      empname,
                t.parent,
                t.assign,
                t.projno,
                nvl(sum(t.hours),0)                          hours,
                nvl(sum(t.othours),0)                        ot_hours,
                nvl(sum(t.hours),0) + nvl(sum(t.othours),0)  tot_hours
            from
                    (Select
                            td.empno,
                            td.parent,
                            td.assign,
                            substr(td.projno,1,5)           projno,
                            sum(nvl(td.total,0))            hours,
                            0                               othours
                        From                                     
                            time_daily      td
                        Where                                    
                            td.yymm     = Trim(p_yymm) 
                            And td.assign   = Trim(p_costcode)
                            And substr(td.projno,1,5) = Trim(p_projno)                                    
                        Group by 
                            td.empno,
                            td.parent,
                            td.assign,
                            substr(td.projno,1,5)
                   Union all         
                        Select
                            ot.empno,
                            ot.parent,
                            ot.assign,
                            substr(ot.projno,1,5)           projno,
                            0                               hours,
                            sum(nvl(ot.total,0))            othours
                        From                                     
                            time_ot      ot
                        Where                                    
                            ot.yymm     = Trim(p_yymm) 
                            And ot.assign   = Trim(p_costcode)
                            And substr(ot.projno,1,5) = Trim(p_projno)                                    
                        Group by 
                            ot.empno,
                            ot.parent,
                            ot.assign,
                            substr(ot.projno,1,5)
                    Union all
                            Select 
                                tomm.empno,
                                tomm.parent,
                                tomm.assign,
                                substr(tomd.projno,1,5)      projno,                                                                        
                                sum(nvl(tomd.hours,0))       hours,
                                0                            othours 
                            From 
                                ts_osc_mhrs_master  tomm,
                                ts_osc_mhrs_detail  tomd
                            Where
                                tomd.oscm_id = tomm.oscm_id
                                And tomm.yymm     = Trim(p_yymm) 
                                And tomm.assign   = Trim(p_costcode)
                            Group by
                                tomm.empno,
                                tomm.parent,
                                tomm.assign,
                                substr(tomd.projno,1,5)
                ) t,
                emplmast e
            where
                e.empno = t.empno
                And (upper(t.empno)  Like '%' || upper(Trim(p_generic_search)) || '%'
                  Or upper(e.name)   Like '%' || upper(Trim(p_generic_search)) || '%'
                  Or upper(t.projno) Like '%' || upper(Trim(p_generic_search)) || '%')  
            group by 
                t.empno,
                e.name,
                t.parent,
                t.assign,
                t.projno;
        Return c; 
   end fn_project_timesheet_status_excel;
  
   
  Function fn_department_timesheet_status_excel(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_yymm           Varchar2,
        p_costcode       Varchar2        
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
          
        Open c For            
            Select 
                tm.yymm,
                tm.empno,
                initcap(e.name)                         empname,
                ''                                      emptype,
                tm.parent,
                tm.assign,
                nvl(tm.tot_nhr, 0)                      hours,
                nvl(tm.tot_ohr, 0)                      ot_hours,
                0                                       ts_filled,
                nvl(tm.locked, 0)                       ts_locked,
                nvl(tm.approved, 0)                     ts_approved,
                nvl(tm.posted, 0)                       ts_posted
            From 
                time_mast           tm,
                emplmast            e
            Where
                tm.empno = e.empno                
                And tm.yymm    = Trim(p_yymm)
                And tm.assign  = Trim(p_costcode)                   
            Order by 
                tm.empno;
        Return c;
    
   end fn_department_timesheet_status_excel;
  
  Function fn_get_reminder_mail_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_statusstring   varchar2
    ) Return Sys_Refcursor as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;        
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        If p_statusstring = 'Filled' Then
            Open c For
                select 
                    listagg (email,'; ' on overflow truncate with count)    recepient_mail
                from
                (
                    Select                           
                        e.empno,
                        e.email,
                        pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, e.empno, e.assign)    status_name
                    From                        
                        emplmast           e,                      
                        deptphase          dp
                    Where
                        e.assign            = dp.costcode                        
                        And dp.isprimary    = 1
                        And e.emptype       in ('R','F','S','C')
                        And e.status        = 1                        
                        And e.assign        = p_costcode
                    Union
                    select 
                       em.empno,
                       em.email,
                       pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, em.empno, tm.assign)    status_name
                    from 
                        time_mast tm,
                        emplmast em
                    where 
                        tm.empno = em.empno
                        And tm.assign = p_costcode
                        And tm.yymm = p_yymm
                        And Not Exists (select empno from                      
                                        emplmast           e,                      
                                        deptphase          dp
                                    Where
                                        e.assign            = dp.costcode              
                                        And dp.isprimary    = 1
                                        And e.emptype       in ('R','F','S','C')
                                        And e.status        = 1                                        
                                        And e.assign        = p_costcode
                                        And e.empno         = tm.empno)
                )
                where
                    status_name = 'Not filled';
        End If;
        
        
        If p_statusstring = 'Locked' Then
            Open c For
                Select
                    listagg (e.email,'; ' on overflow truncate with count)    recepient_mail
                From                        
                    emplmast           e,                      
                    deptphase          dp
                Where
                    e.assign            = dp.costcode              
                    And dp.isprimary    = 1
                    And e.emptype       in ('R','F','S','C')
                    And e.status        = 1                    
                    And e.assign        = p_costcode
                    And Exists (select 1 from time_mast tm
                        where tm.yymm = p_yymm
                        And tm.empno = e.empno
                        And tm.assign = p_costcode
                        And nvl(tm.locked, 0) = 0);
        End If;
        
        if p_statusstring = 'Approve' Then
            If length(Trim(p_costcode)) > 0 then            
                Open c For
                    Select
                        listagg (distinct e.email,'; ' on overflow truncate with count)    recepient_mail 
                    From                        
                        emplmast           e, 
                        costmast           c,
                        time_mast          tm
                    Where
                        tm.assign = c.costcode
                        And c.hod = e.empno 
                        And tm.assign           = Trim(p_costcode)
                        And tm.yymm             = Trim(p_yymm)
                        And nvl(tm.approved, 0) = 0
                        And nvl(tm.locked, 0)   = 1;
            Else
                Open c For
                    Select
                        listagg (distinct e.email,'; ' on overflow truncate with count)    recepient_mail 
                    From                        
                        emplmast           e, 
                        costmast           c,
                        time_mast          tm
                    Where
                        tm.assign = c.costcode
                        And c.hod = e.empno                        
                        And tm.yymm             = Trim(p_yymm)
                        And nvl(tm.approved, 0) = 0
                        And nvl(tm.locked, 0)   = 1;
            End If;
        End If;
        
        If p_statusstring = 'Post' Then
             If length(Trim(p_costcode)) > 0 then
                Open c For
                    Select
                        listagg (distinct e.email,'; ' on overflow truncate with count)    recepient_mail 
                    From                        
                        emplmast           e, 
                        costmast           c,
                        time_mast          tm
                    Where
                        tm.assign = c.costcode
                        And c.hod = e.empno 
                        And tm.assign           = Trim(p_costcode)
                        And tm.yymm             = Trim(p_yymm)
                        And nvl(tm.posted, 0) = 0    
                        And nvl(tm.approved, 0) = 1
                        And nvl(tm.locked, 0)   = 1;
             Else
                Open c For
                    Select
                        listagg (distinct e.email,'; ' on overflow truncate with count)    recepient_mail 
                    From                        
                        emplmast           e, 
                        costmast           c,
                        time_mast          tm
                    Where
                        tm.assign = c.costcode
                        And c.hod = e.empno 
                        And tm.yymm             = Trim(p_yymm)
                        And nvl(tm.posted, 0) = 0    
                        And nvl(tm.approved, 0) = 1
                        And nvl(tm.locked, 0)   = 1;
             End If;
             
             
             
        End If;
        
        Return c;         
   end fn_get_reminder_mail_list;  
  
  Function fn_odd_timesheet_employee_count(
     p_yymm           Varchar2,
     p_costcode       Varchar2
  ) Return Number as
        v_count          Number := 0;
    begin 
        select 
            count(*)
        Into
            v_count
        From
            time_mast tm
        where tm.yymm = p_yymm   
            And tm.assign = p_costcode
            And Not Exists (select 1 
                            from 
                                emplmast           e,                      
                                deptphase          dp
                            where
                                e.assign            = dp.costcode              
                                And dp.isprimary    = 1
                                And e.emptype       in ('R','F','S','C')
                                And e.status        = 1                                
                                And e.assign        = p_costcode
                                And e.empno = tm.empno);
        return v_count;
  end fn_odd_timesheet_employee_count;  
  
  Function fn_get_outsource_hours(
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_statusstring   varchar2
    ) Return Number as
        --c                    Sys_Refcursor;
        v_count          Number := 0;
    begin 
        
        If p_statusstring = 'Filled' Then            
            select    
                sum(nvl(tomm.hours,0)) 
            Into
                v_count
            from 
                ts_osc_mhrs_master tomm
            where tomm.yymm = p_yymm 
                And tomm.assign = p_costcode
            group by tomm.yymm, 
                     tomm.assign;
        End If;
        
        If p_statusstring = 'Locked' Then            
            select    
                sum(nvl(tomm.hours,0))
            Into
                v_count
            from 
                ts_osc_mhrs_master tomm
            where tomm.yymm = p_yymm 
                And tomm.assign = p_costcode
                And tomm.is_lock = 'OK'
            group by tomm.yymm, 
                     tomm.assign;
        End If;
        
        if p_statusstring = 'Approved' Then           
            select    
                sum(nvl(tomm.hours,0))
            Into
                v_count
            from 
                ts_osc_mhrs_master tomm
            where tomm.yymm = p_yymm 
                And tomm.assign = p_costcode
                And tomm.is_hod_approve = 'OK'
            group by tomm.yymm, 
                     tomm.assign;
        End If;
        
        if p_statusstring = 'Posted' Then
            --Open c For
                select    
                    sum(nvl(tomm.hours,0)) 
                Into
                    v_count
                from 
                    ts_osc_mhrs_master tomm
                where tomm.yymm = p_yymm 
                    And tomm.assign = p_costcode
                    And tomm.is_post = 'OK'
                group by tomm.yymm, 
                         tomm.assign;
        End If;        
        
        return v_count;
  end fn_get_outsource_hours;  
  
  function fn_employee_count_breakup_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor as 
    v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        c                    Sys_Refcursor;
        v_submit            Number;
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        Open c For
            select 
                *
            from
            (            
                select 
                    p_yymm,
                    empno,
                    empname,
                    emptype,
                    parent,
                    assign,
                    timesheet_type,
                    status_name, 
                    Row_Number() Over(Order By timesheet_type, status_name, empno)      row_number,
                    Count(*) Over()                                                     total_row
                from
                (
                    Select                           
                        e.empno,
                        initcap(e.name)                                                         empname,
                        e.emptype,
                        e.parent,
                        e.assign,
                        'Normal'                                                                timesheet_type,
                        pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, e.empno, e.assign)    status_name
                    From                        
                        emplmast           e,                      
                        deptphase          dp
                    Where
                        e.assign            = dp.costcode                        
                        And dp.isprimary    = 1
                        And e.emptype       in ('R','F','S','C')
                        And e.status        = 1                        
                        And e.assign        = p_costcode
                    Union
                    select 
                       em.empno,
                       initcap(em.name)         empname,
                       em.emptype,
                       tm.parent,
                       tm.assign,
                       'Odd'                    timesheet_type,
                       pkg_ts_status_qry.fn_get_timesheet_status(p_yymm, em.empno, tm.assign)    status_name
                    from 
                        time_mast tm,
                        emplmast em
                    where 
                        tm.empno = em.empno
                        And tm.assign = p_costcode
                        And tm.yymm = p_yymm
                        And Not Exists (select empno from                      
                                        emplmast           e,                      
                                        deptphase          dp
                                    Where
                                        e.assign            = dp.costcode              
                                        And dp.isprimary    = 1
                                        And e.emptype       in ('R','F','S','C')
                                        And e.status        = 1                                        
                                        And e.assign        = p_costcode
                                        And e.empno         = tm.empno)
                    Union
                    select    
                        e.empno,
                        initcap(e.name)                                                         empname,
                        e.emptype,
                        e.parent,
                        tomm.assign,
                        'Outsource'                                                             timesheet_type,
                        pkg_ts_status_qry.fn_get_outsource_timesheet_status(p_yymm, e.empno, tomm.assign)   status_name
                    from 
                        ts_osc_mhrs_master tomm,
                        emplmast e
                    where tomm.empno = e.empno
                        And tomm.yymm = p_yymm 
                        And tomm.assign = p_costcode
                )
                where
                    upper(empno)  Like '%' || upper(Trim(p_generic_search)) || '%'
                      Or upper(empname)   Like '%' || upper(Trim(p_generic_search)) || '%'
                order by 
                    timesheet_type,
                    status_name,
                    empno
            )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;
    end fn_employee_count_breakup_list;
     
  
  Procedure sp_employee_count_4_status(
        p_person_id             Varchar2,
        p_meta_id               Varchar2,
        p_costcode              Varchar2,
        p_yymm                  Varchar2,
        p_wrk_hours         Out Number,
        p_process_month     Out Varchar2,
        p_submit_count      Out Number,
        p_odd_count         Out Number,
        p_outsource_count   Out Number,
        p_total_count       Out Number,
        p_filled            Out Number,
        p_filled_nhr        Out Number,
        p_filled_ohr        Out Number,
        p_filled_outhr      Out Number,
        p_filled_thr        Out Number,
        p_locked            Out Number,
        p_locked_nhr        Out Number,
        p_locked_ohr        Out Number,
        p_locked_outhr      Out Number,
        p_locked_thr        Out Number,
        p_approved          Out Number,
        p_approved_nhr      Out Number,
        p_approved_ohr      Out Number,
        p_approved_outhr    Out Number,
        p_approved_thr      Out Number,
        p_posted            Out Number,
        p_posted_nhr        Out Number,
        p_posted_ohr        Out Number,
        p_posted_outhr      Out Number,
        p_posted_thr        Out Number,
        p_message_type      Out Varchar2,
        p_message_text      Out Varchar2
   ) as
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);        
     begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        -- Work hours
        begin
          select
              working_hrs
          into
              p_wrk_hours
          from
              wrkhours
          where
              yymm = p_yymm;
         exception
           when no_data_found then
              p_wrk_hours := 0;
        end; 

        -- Process month
        Select
            pros_month
        Into
            p_process_month
        From
            tsconfig;

        -- Eligible employee count
        Select
            nvl(count(*),0)
        Into
            p_submit_count
        From
            emplmast           e,
            deptphase          dp
        Where
            e.assign            = dp.costcode
            And dp.isprimary    = 1
            And e.emptype       in ('R','F','S','C')
            And e.status        = 1
            And e.assign        = p_costcode;

        -- Odd timesheet employee count
        select
            nvl(count(*),0)
        Into
            p_odd_count
        from
            time_mast tm
        where
            assign = p_costcode
            And yymm = p_yymm
            And Not Exists (select empno from
                                emplmast           e,
                                deptphase          dp
                            Where
                                e.assign            = dp.costcode
                                And dp.isprimary    = 1
                                And e.emptype       in ('R','F','S','C')
                                And e.status        = 1
                                And e.assign        = p_costcode
                                And e.empno         = tm.empno);

        -- Outsource employee count
        select
            nvl(count(*),0)
        Into
            p_outsource_count
        from
            ts_osc_mhrs_master tomm
        where tomm.yymm = p_yymm
            And tomm.assign = p_costcode;

        -- Filled
        select
            nvl(sum(cnt),0),
            nvl(sum(hrs),0),
            nvl(sum(ot_hrs),0),
            nvl(sum(os_hrs),0),
            nvl(sum(tot_hrs),0)
        Into
            p_filled,
            p_filled_nhr,
            p_filled_ohr,
            p_filled_outhr,
            p_filled_thr
        from
            (select
                nvl(count(*),0) cnt,
                nvl(sum(tot_nhr),0) hrs,
                nvl(sum(tot_ohr),0) ot_hrs,
                nvl(max(pkg_ts_status_qry.fn_get_outsource_hours(p_yymm, p_costcode, 'Filled')),0) os_hrs,
                nvl(sum(tot_nhr),0) + nvl(sum(tot_ohr),0) + nvl(max(pkg_ts_status_qry.fn_get_outsource_hours(p_yymm, p_costcode, 'Filled')),0) tot_hrs
            from
                time_mast tm
            where
                tm.assign = p_costcode
                And tm.yymm = p_yymm
            Union all
                select
                    nvl(count(*),0) cnt,
                    0 hrs,
                    0 ot_hrs,
                    0 os_hrs,
                    0 tot_hrs
                from
                    ts_osc_mhrs_master tomm
                where
                    tomm.assign         = p_costcode
                    And tomm.yymm       = p_yymm);
        /*select
            nvl(count(*),0),
            nvl(sum(tot_nhr),0),
            nvl(sum(tot_ohr),0),
            nvl(max(pkg_ts_status_qry.fn_get_outsource_hours(p_yymm, p_costcode, 'Filled')),0),
            nvl(sum(tot_nhr),0) + nvl(sum(tot_ohr),0) + nvl(max(pkg_ts_status_qry.fn_get_outsource_hours(p_yymm, p_costcode, 'Filled')),0)
        Into
            p_filled,
            p_filled_nhr,
            p_filled_ohr,
            p_filled_outhr,
            p_filled_thr
        from
            time_mast tm
        where
            tm.assign = p_costcode
            And tm.yymm = p_yymm;*/

        -- Total employee count

        p_total_count := p_submit_count + p_odd_count;

        -- Locked
        select
            nvl(sum(cnt),0),
            nvl(sum(hrs),0),
            nvl(sum(ot_hrs),0),
            nvl(sum(os_hrs),0),
            nvl(sum(tot_hrs),0)
        Into
            p_locked,
            p_locked_nhr,
            p_locked_ohr,
            p_locked_outhr,
            p_locked_thr
        from
            (select
                tm.yymm,
                tm.assign,
                nvl(count(*),0)       cnt,
                nvl(sum(tot_nhr),0)   hrs,
                nvl(sum(tot_ohr),0)   ot_hrs,
                nvl(max(pkg_ts_status_qry.fn_get_outsource_hours(p_yymm, p_costcode, 'Locked')),0)   os_hrs,
                nvl(sum(tot_nhr + tot_ohr) + nvl(max(pkg_ts_status_qry.fn_get_outsource_hours(p_yymm, p_costcode, 'Locked')),0),0)  tot_hrs
            from
                time_mast tm
            where
                tm.assign       = p_costcode
                And tm.yymm     = p_yymm
                And tm.locked   = 1
            Group by
                tm.yymm,
                tm.assign
            Union all
            select
                tomm.yymm,
                tomm.assign,
                nvl(count(*),0)       cnt,
                0     hrs,
                null  ot_hrs,
                null  os_hrs,
                0     tot_hrs
            from
                ts_osc_mhrs_master tomm
            where
                tomm.assign         = p_costcode
                And tomm.yymm       = p_yymm
                And tomm.is_lock    = 'OK'
            Group by
                tomm.yymm,
                tomm.assign);

        -- Approved

        select
            nvl(sum(cnt),0),
            nvl(sum(hrs),0),
            nvl(sum(ot_hrs),0),
            nvl(sum(os_hrs),0),
            nvl(sum(tot_hrs),0)
        Into
            p_approved,
            p_approved_nhr,
            p_approved_ohr,
            p_approved_outhr,
            p_approved_thr
        from
            (select
                tm.yymm,
                tm.assign,
                nvl(count(*),0)       cnt,
                nvl(sum(tot_nhr),0)   hrs,
                nvl(sum(tot_ohr),0)   ot_hrs,
                nvl(max(pkg_ts_status_qry.fn_get_outsource_hours(p_yymm, p_costcode, 'Locked')),0)   os_hrs,
                nvl(sum(tot_nhr + tot_ohr) + nvl(max(pkg_ts_status_qry.fn_get_outsource_hours(p_yymm, p_costcode, 'Locked')),0),0)  tot_hrs
            from
                time_mast tm
            where
                tm.assign       = p_costcode
                And tm.yymm     = p_yymm
                And tm.locked   = 1
                And tm.approved = 1
            Group by
                tm.yymm,
                tm.assign
            Union all
            select
                tomm.yymm,
                tomm.assign,
                nvl(count(*),0)       cnt,
                0                     hrs,
                null                  ot_hrs,
                null                  os_hrs,
                0                     tot_hrs
            from
                ts_osc_mhrs_master tomm
            where
                tomm.assign         = p_costcode
                And tomm.yymm       = p_yymm
                And tomm.is_lock    = 'OK'
                And tomm.is_hod_approve = 'OK'
            Group by
                tomm.yymm,
                tomm.assign);

        -- Posted

        select
            nvl(sum(cnt),0),
            nvl(sum(hrs),0),
            nvl(sum(ot_hrs),0),
            nvl(sum(os_hrs),0),
            nvl(sum(tot_hrs),0)
        Into
            p_posted,
            p_posted_nhr,
            p_posted_ohr,
            p_posted_outhr,
            p_posted_thr
        from
            (select
                tm.yymm,
                tm.assign,
                nvl(count(*),0)       cnt,
                nvl(sum(tot_nhr),0)   hrs,
                nvl(sum(tot_ohr),0)   ot_hrs,
                nvl(max(pkg_ts_status_qry.fn_get_outsource_hours(p_yymm, p_costcode, 'Locked')),0)   os_hrs,
                nvl(sum(tot_nhr + tot_ohr) + nvl(max(pkg_ts_status_qry.fn_get_outsource_hours(p_yymm, p_costcode, 'Locked')),0),0)  tot_hrs
            from
                time_mast tm
            where
                tm.assign       = p_costcode
                And tm.yymm     = p_yymm
                And tm.locked   = 1
                And tm.approved = 1
                And tm.posted = 1
            Group by
                tm.yymm,
                tm.assign
            Union all
            select
                tomm.yymm,
                tomm.assign,
                nvl(count(*),0)       cnt,
                0                     hrs,
                null                  ot_hrs,
                null                  os_hrs,
                0                     tot_hrs
            from
                ts_osc_mhrs_master tomm
            where
                tomm.assign         = p_costcode
                And tomm.yymm       = p_yymm
                And tomm.is_lock    = 'OK'
                And tomm.is_hod_approve = 'OK'
                And tomm.is_post = 'OK'
            Group by
                tomm.yymm,
                tomm.assign);

        p_message_type := ok;
        p_message_text := 'Successfully fetched';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
  end sp_employee_count_4_status;
  
  function fn_monthly_normal_hours(
        p_yymm      varchar2
  ) return number as
        v_count     number := 0;
    begin
        select 
            working_hrs
        into
            v_count
        from 
            wrkhours 
        where 
            yymm = p_yymm;
        return v_count;
  end fn_monthly_normal_hours; 
  
  Function fn_get_other_cc_normal_hrs(
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_empno          Varchar2
    ) return Number as
        v_hours      Number := 0;
     begin
        select 
            nvl(sum(tm.tot_nhr), 0) 
        Into
            v_hours
        from 
            time_mast tm 
        where 
            tm.yymm = p_yymm
            And tm.empno = p_empno 
            And tm.assign <> p_costcode
        group by 
            tm.empno;
            
        return v_hours;
  end fn_get_other_cc_normal_hrs;
  
  Function fn_get_other_cc_ot_hrs(
        p_yymm           Varchar2,
        p_costcode       Varchar2,
        p_empno          Varchar2
    ) return Number as
        v_hours      Number := 0;
     begin
        select 
            nvl(sum(tm.tot_ohr), 0) 
        Into
            v_hours
        from 
            time_mast tm 
        where 
            tm.yymm = p_yymm
            And tm.empno = p_empno 
            And tm.assign <> p_costcode
        group by 
            tm.empno;
            
        return v_hours;
  end fn_get_other_cc_ot_hrs;
  
  Function fn_get_project_name(
        p_projno5           Varchar2
   ) Return Varchar2 as
        v_name      Varchar2(100) := '';
     begin
        Select 
            distinct name
        Into
            v_name
        from
            projmast
        where
            proj_no = p_projno5
            And rownum = 1;
        
        return v_name;
   end fn_get_project_name;

end pkg_ts_status_qry;

/
Grant Execute On "TIMECURR"."PKG_TS_STATUS_QRY" To "TCMPL_APP_CONFIG";