create or replace package body "TIMECURR"."PKG_TS_STATUS" as

  Procedure sp_check_processing_month(
        p_person_id        Varchar2 Default Null,
        p_meta_id          Varchar2 Default Null,

        p_yymm             Varchar2,

        p_message_type Out Varchar2,
        p_message_text Out Varchar2
    ) As
        v_empno      Varchar2(5);
        v_pros_month tsconfig.pros_month%Type;
    Begin
        If p_meta_id Is Not Null Then
            v_empno := get_empno_from_meta_id(p_meta_id);

            If v_empno = 'ERRRR' Then
                p_message_type := not_ok;
                p_message_text := 'Invalid employee number';
                Return;
            End If;
        End If;

        Select
            pros_month
        Into
            v_pros_month
        From
            tsconfig;

        If To_Number(v_pros_month) != To_Number(p_yymm) Then
            p_message_type := not_ok;
            p_message_text := 'Invalid month for processing !!!.';
            Return;
        End If;

        p_message_type := ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_check_processing_month;
    
  procedure sp_timesheet_status_update(
        p_person_id      varchar2,
        p_meta_id        varchar2,        
        p_empno          varchar2,
        p_yymm           varchar2,
        p_costcode       varchar2,        
        p_update_type    varchar2, 
        p_emp_type       varchar2,
        p_message_type out varchar2,
        p_message_text out varchar2
    ) as
        v_empno              Varchar2(5);
        v_rec_empno          Varchar2(5);
        v_oscm_id            Varchar2(10);
        v_ts_freeze         Number(1) := 0;
        e_employee_not_found Exception;        
        Pragma exception_init(e_employee_not_found, -20001);
        row_locked           Exception;
        Pragma exception_init( row_locked, -54 );        
     begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;        
        
        select 
            status
        into
            v_ts_freeze
        from 
            tsconfig
        Where
            Trim(schemaname) = 'TIMECURR'
            And Trim(username) = 'TIMECURR';
        
        sp_check_processing_month(
            p_yymm         => p_yymm,
            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;                
        
        if p_emp_type = 'O' then
            select
                empno
            into
                v_rec_empno
            from
                ts_osc_mhrs_master
            where
                yymm = p_yymm
                and empno = p_empno
                and assign = p_costcode
            For Update Nowait;
        else
            select
                empno
            into
                v_rec_empno
            from
                time_mast
            where
                yymm = p_yymm
                and empno = p_empno
                and assign = p_costcode
            For Update Nowait;
        end if;
        
         if v_ts_freeze = 1 then
            if p_update_type = 'LOCK' then
                if p_emp_type = 'O' then
                    select 
                        oscm_id
                    into
                        v_oscm_id
                    from
                        ts_osc_mhrs_master
                    where
                        yymm = p_yymm                    
                        and empno = p_empno
                        and assign = p_costcode;
                    
                    pkg_ts_osc_mhrs.sp_lock_osc_mhrs(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,        
                        p_oscm_id      => v_oscm_id,        
                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );                
                else
                    update
                        time_mast
                    Set
                        locked = 1
                    where
                        yymm = p_yymm
                        and nvl(locked, 0) = 0
                        and nvl(approved, 0) = 0
                        and nvl(posted, 0) = 0
                        and empno = p_empno
                        and assign = p_costcode;
                end if;
                
                p_message_type := ok;
                p_message_text := 'Successfully updated';            
                return;
            end if;
            
            if p_update_type = 'UNLOCK' then            
                if p_emp_type = 'O' then
                    select 
                        oscm_id
                    into
                        v_oscm_id
                    from
                        ts_osc_mhrs_master
                    where
                        yymm = p_yymm                    
                        and empno = p_empno
                        and assign = p_costcode;
                    
                    pkg_ts_osc_mhrs.sp_unlock_osc_mhrs(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,        
                        p_oscm_id      => v_oscm_id,        
                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                else
                    update
                        time_mast
                    Set
                        locked = 0
                    where
                        yymm = p_yymm
                        and nvl(locked, 0) = 1
                        and nvl(approved, 0) = 0
                        and nvl(posted, 0) = 0
                        and empno = p_empno
                        and assign = p_costcode;
                end if;
                
                p_message_type := ok;
                p_message_text := 'Successfully updated';            
                return;
            end if;
       
            if p_update_type = 'APPROVE' then
                if p_emp_type = 'O' then
                    select 
                        oscm_id
                    into
                        v_oscm_id
                    from
                        ts_osc_mhrs_master
                    where
                        yymm = p_yymm                    
                        and empno = p_empno
                        and assign = p_costcode;
                    
                    pkg_ts_osc_mhrs.sp_hod_approve_osc_mhrs(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,        
                        p_oscm_id      => v_oscm_id,        
                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                else
                    update
                        time_mast
                    Set
                        approved = 1
                    where
                        yymm = p_yymm
                        and nvl(locked, 0) = 1
                        and nvl(approved, 0) = 0
                        and nvl(posted, 0) = 0
                        and empno = p_empno
                        and assign = p_costcode;
                end if; 
            end if;
        
            if p_update_type = 'UNAPPROVE' then
                if p_emp_type = 'O' then
                    select 
                        oscm_id
                    into
                        v_oscm_id
                    from
                        ts_osc_mhrs_master
                    where
                        yymm = p_yymm                    
                        and empno = p_empno
                        and assign = p_costcode;
                    
                    pkg_ts_osc_mhrs.sp_hod_disapprove_osc_mhrs(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,        
                        p_oscm_id      => v_oscm_id,        
                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                else
                    update
                        time_mast
                    Set
                        approved = 0
                    where
                        yymm = p_yymm                
                        and nvl(locked, 0) = 1
                        and nvl(approved, 0) = 1                        
                        and nvl(posted, 0) = 0
                        and empno = p_empno
                        and assign = p_costcode;
                end if;                
            end if;

            if p_update_type = 'POST' then            
                if p_emp_type = 'O' then
                    select 
                        oscm_id
                    into
                        v_oscm_id
                    from
                        ts_osc_mhrs_master
                    where
                        yymm = p_yymm                    
                        and empno = p_empno
                        and assign = p_costcode;
                    
                    pkg_ts_osc_mhrs.sp_post_osc_mhrs(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,        
                        p_oscm_id      => v_oscm_id,        
                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                else
                    delete from 
                        timetran 
                    where 
                        yymm = p_yymm 
                        and empno = p_empno 
                        and costcode = p_costcode;
                                
                    insert into timetran(   
                        yymm,
                        empno,
                        costcode,
                        projno,
                        wpcode,
                        activity,
                        grp,
                        company,
                        hours,othours
                    ) 
                     select 
                         yymm,
                         empno,
                         assign,
                         projno,
                         wpcode,
                         activity,
                         grp,
                         company,
                         sum(nhrs),
                         sum(ohrs) 
                     from 
                        postingdata 
                     where 
                        yymm = p_yymm 
                        and empno = p_empno 
                        and assign = p_costcode 
                    group by 
                        yymm,
                        empno,
                        assign,
                        projno,
                        wpcode,
                        activity,
                        grp,
                        company
                    Order by
                        yymm,
                        empno;  
                                  
                    update
                        time_mast
                    Set
                        posted = 1
                    where
                        yymm = p_yymm
                        and nvl(locked, 0) = 1
                        and nvl(approved, 0) = 1                       
                        and nvl(posted, 0) = 0
                        and empno = p_empno
                        and assign = p_costcode;
                end if;            
            end if;
        
            if p_update_type = 'UNPOST' then   
                if p_emp_type = 'O' then
                    select 
                        oscm_id
                    into
                        v_oscm_id
                    from
                        ts_osc_mhrs_master
                    where
                        yymm = p_yymm                    
                        and empno = p_empno
                        and assign = p_costcode;
                    
                    pkg_ts_osc_mhrs.sp_unpost_osc_mhrs(
                        p_person_id    => p_person_id,
                        p_meta_id      => p_meta_id,        
                        p_oscm_id      => v_oscm_id,        
                        p_message_type => p_message_type,
                        p_message_text => p_message_text
                    );
                else
                    delete from 
                        timetran 
                    where 
                        yymm = p_yymm 
                        and empno = p_empno 
                        and costcode = p_costcode;
                        
                    update
                        time_mast
                    Set
                        posted = 0
                    where
                        yymm = p_yymm
                        and nvl(locked, 0) = 1
                        and nvl(approved, 0) = 1
                        and nvl(posted, 0) = 1
                        and empno = p_empno
                        and assign = p_costcode; 
                end if;
            end if;
            
            p_message_type := ok;
            p_message_text := 'Successfully updated';
        else
            p_message_type := not_ok;
            p_message_text := 'Timesheet freezed for processing';
        end if;        
    Exception
        When row_locked Then
            p_message_type := not_ok;
            p_message_text := 'Timesheet in-use';
            Return;        
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
  end sp_timesheet_status_update;
  
  procedure sp_timesheet_bulk_action_update(
        p_person_id      varchar2,
        p_meta_id        varchar2,
        p_yymm           varchar2, 
        p_costcode      varchar2,
        p_statusstring   varchar2, 
        p_action_name    varchar2, 
        p_message_type out varchar2,
        p_message_text out varchar2
    ) as
        v_empno                     Varchar2(5);
        e_employee_not_found        Exception;
        Pragma exception_init(e_employee_not_found, -20001);
        row_locked                   Exception;
        Pragma exception_init( row_locked, -54 );
        v_message_type              Varchar2(10) := ok;
        v_message_text              Varchar2(50) := 'Successfully updated';
        v_locked_message_type       Varchar2(10) := not_ok;
        v_locked_message_text       Varchar2(50) := 'Record locked';
        v_record_locked_count       Number := 0;
        cursor cur_time_mast_all is
          select
            tm.empno,
            e.emptype,
            tm.locked,
            tm.approved,
            tm.posted
          from  
            time_mast tm,
            emplmast e
          where
            tm.yymm = p_yymm
            And tm.empno = e.empno
            and tm.assign = p_costcode
          Union         
          select 
            tomm.empno,
            ee.emptype,
            Case tomm.is_lock
                When 'OK' Then 1
                else 0
            End                             locked,
            Case tomm.is_hod_approve
                When 'OK' Then 1
                else 0
            End                             approved,
            Case tomm.is_post
                When 'OK' Then 1
                else 0
            End                             posted
         from
            ts_osc_mhrs_master tomm,
            emplmast ee
         where
            tomm.yymm = p_yymm
            and tomm.empno = ee.empno
            and tomm.assign = p_costcode;     
     begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            p_message_type := not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;        
        
        sp_check_processing_month(
            p_yymm         => p_yymm,

            p_message_type => p_message_type,
            p_message_text => p_message_text
        );
        
        If p_message_type = not_ok Then
            p_message_type := p_message_type;
            p_message_text := p_message_text;
            Return;
        End If;        
        
        for r_cur_time_mast in cur_time_mast_all 
        loop
            begin
                -- Locking / unlocking
                if p_statusstring = 'Locked' then
                    if p_action_name = 'LockAll' then
                        pkg_ts_status.sp_timesheet_status_update
                        (
                            p_person_id,
                            p_meta_id,        
                            r_cur_time_mast.empno,
                            p_yymm,
                            p_costcode,
                            'LOCK', 
                            r_cur_time_mast.emptype,
                            v_locked_message_type,
                            v_locked_message_text
                        );
                    End if;                    
                    if p_action_name = 'UnlockAll' then
                        pkg_ts_status.sp_timesheet_status_update
                        (
                            p_person_id,
                            p_meta_id,        
                            r_cur_time_mast.empno,
                            p_yymm,
                            p_costcode,
                            'UNLOCK',
                            r_cur_time_mast.emptype,
                            v_locked_message_type,
                            v_locked_message_text
                        );
                    end if;
                end if;
            
                -- Approved / Unapproved
                if p_statusstring = 'Approved' then
                    if p_action_name = 'ApproveAll' then
                        pkg_ts_status.sp_timesheet_status_update
                        (
                            p_person_id,
                            p_meta_id,        
                            r_cur_time_mast.empno,
                            p_yymm,
                            p_costcode,
                            'APPROVE', 
                            r_cur_time_mast.emptype,
                            v_locked_message_type,
                            v_locked_message_text
                        );
                    end if;                    
                    if p_action_name = 'UnapproveAll' then
                        pkg_ts_status.sp_timesheet_status_update
                        (
                            p_person_id,
                            p_meta_id,        
                            r_cur_time_mast.empno,
                            p_yymm,
                            p_costcode,
                            'UNAPPROVE', 
                            r_cur_time_mast.emptype,
                            v_locked_message_type,
                            v_locked_message_text
                        );
                    end if;                               
                end if;
                
                -- Posted / Unposted
                if p_statusstring = 'Posted' then
                    if p_action_name = 'PostAll' then
                        pkg_ts_status.sp_timesheet_status_update
                        (
                            p_person_id,
                            p_meta_id,        
                            r_cur_time_mast.empno,
                            p_yymm,
                            p_costcode,
                            'POST', 
                            r_cur_time_mast.emptype,
                            v_locked_message_type,
                            v_locked_message_text
                        );
                    end if;
                    
                    if p_action_name = 'UnpostAll' then
                        pkg_ts_status.sp_timesheet_status_update
                        (
                            p_person_id,
                            p_meta_id,        
                            r_cur_time_mast.empno,
                            p_yymm,
                            p_costcode,
                            'UNPOST', 
                            r_cur_time_mast.emptype,
                            v_locked_message_type,
                            v_locked_message_text
                        );
                    end if;                              
                end if;
                
                if v_locked_message_text = 'Timesheet in-use' then
                    v_record_locked_count := v_record_locked_count + 1; 
                end if;
            exception
                When row_locked Then
                    v_record_locked_count := v_record_locked_count + 1;                      
                When Others Then
                    v_message_type := not_ok;
                    v_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm; 
            end;      
        end loop;
        
        if v_record_locked_count > 0 then        
            p_message_type := not_ok;
            p_message_text := v_record_locked_count || ' timesheet(s) are in-use';
        else
            p_message_type := v_message_type;
            p_message_text := v_message_text;
        end if;        
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
        
   end sp_timesheet_bulk_action_update; 
   
  procedure sp_timesheet_wrk_hour_count(
        p_person_id      varchar2,
        p_meta_id        varchar2,
        p_yymm           varchar2,
        p_wrk_hours    out Number,
        p_message_type out varchar2,
        p_message_text out varchar2
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
        
        select 
            working_hrs
        into
            p_wrk_hours
        from 
            wrkhours 
        where 
            yymm = p_yymm;    
        
        p_message_type := ok;
        p_message_text := 'Successfully done';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
   end sp_timesheet_wrk_hour_count;
   
  procedure sp_timesheet_freeze_status(
        p_person_id      varchar2,
        p_meta_id        varchar2,       
        p_status       out Number,
        p_message_type out varchar2,
        p_message_text out varchar2
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
        
        select 
            status
        into
            p_status
        from 
            tsconfig
        Where
            Trim(schemaname) = 'TIMECURR'
            And Trim(username) = 'TIMECURR';   
        
        p_message_type := ok;
        p_message_text := 'Successfully done';
    Exception
        When Others Then
            p_message_type := not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
   end sp_timesheet_freeze_status;

end pkg_ts_status;

/
Grant Execute On "TIMECURR"."PKG_TS_STATUS" To "TCMPL_APP_CONFIG";