Create Or Replace Package Body timecurr.pkg_rap_osc_report As

    Function fn_before_period_total_hrs (
        p_start_yymm In Varchar2,
        p_hrs_type   In Varchar2,
        p_projno     In Varchar2,
        p_costcode   In Varchar2,
        p_ponum      In Varchar2
    ) Return Number As
        v_total_hrs Number;
    Begin
        v_total_hrs := 0;

        If p_hrs_type = 'A' Then            
                
            Select
                nvl(Sum(t.hours),0)
            Into 
                v_total_hrs
            From
                rap_osc_detail          rod,
                rap_osc_master          rom,
                emplmast                e,
                rap_gtt_osc_timetran    t
            Where                
                t.empno                 = e.empno
                And e.emptype = 'O'
                And rom.oscm_vendor     = e.subcontract
                And rod.oscm_id         = rom.oscm_id
                And t.projno            = rom.projno5                
                And t.costcode          = rod.costcode                
                And rom.projno5         = trim(p_projno)
                And rom.po_number       = trim(p_ponum)
                And rod.costcode        = trim(p_costcode)
                And t.yymm < to_number(p_start_yymm);
        End If;

        If p_hrs_type = 'C' Then
                            
            Select
                nvl(Sum(t.hours),0)                
            Into 
                v_total_hrs
            From
                rap_osc_detail          rod,
                rap_osc_master          rom,
                emplmast                e,
                rap_gtt_osc_timetran    t
            Where
                t.empno                 = e.empno 
                And e.emptype = 'O'
                And rom.oscm_vendor     = e.subcontract                
                And rod.oscm_id         = rom.oscm_id
                And t.projno            = trim(rom.projno5)
                And t.costcode          = rod.costcode               
                And rom.projno5         = trim(p_projno)
                And rom.po_number       = trim(p_ponum)
                And rod.costcode        = trim(p_costcode)
                And t.yymm < to_number(p_start_yymm);
        End If;

        If p_hrs_type = 'O' Then
            Select
                nvl(Sum(orig_est_hrs),0)                
            Into 
                v_total_hrs
            From
                rap_osc_hours  roh,
                rap_osc_detail rod,
                rap_osc_master rom
            Where
                roh.oscd_id = rod.oscd_id
                And rod.oscm_id     = rom.oscm_id
                And rom.projno5     = p_projno
                And rod.costcode    = p_costcode
                And rom.po_number   = p_ponum
                And roh.yyyymm < p_start_yymm;
        End If;

        Return v_total_hrs;
        
      exception
        when no_data_found then
            Return 0;
            
    End fn_before_period_total_hrs;

    Function fn_after_period_total_hrs (
        p_end_yymm In Varchar2,
        p_hrs_type In Varchar2,
        p_projno   In Varchar2,
        p_costcode In Varchar2,
        p_ponum    In Varchar2
    ) Return Number As
        v_total_hrs Number;
    Begin
        v_total_hrs := 0;
        
        If p_hrs_type = 'C' Then
            Select
                nvl(Sum(cur_est_hrs),0)                
              Into v_total_hrs
              From
                rap_osc_hours  roh,
                rap_osc_detail rod,
                rap_osc_master rom
             Where
                   roh.oscd_id          = rod.oscd_id
                   And rod.oscm_id      = rom.oscm_id
                   And rom.projno5      = p_projno
                   And rod.costcode     = p_costcode
                   And rom.po_number    = p_ponum
                   And roh.yyyymm > p_end_yymm;
        End If;

        If p_hrs_type = 'O' Then
            Select
                nvl(Sum(orig_est_hrs),0)                
              Into v_total_hrs
              From
                rap_osc_hours  roh,
                rap_osc_detail rod,
                rap_osc_master rom
             Where
                   roh.oscd_id = rod.oscd_id
                   And rod.oscm_id      = rom.oscm_id
                   And rom.projno5      = p_projno
                   And rod.costcode     = p_costcode
                   And rom.po_number    = p_ponum
                   And roh.yyyymm > p_end_yymm;
        End If;

        Return v_total_hrs;
     exception
        when no_data_found then
            Return 0;
    End fn_after_period_total_hrs;

    Function fn_before_period_amount (
        p_start_yymm In Varchar2,
        p_yymm       In Varchar2,
        p_hrs_type   In Varchar2,
        p_projno     In Varchar2,
        p_costcode   In Varchar2,
        p_ponum      In Varchar2
    ) Return Number As
        v_before_amount             Number;
        v_orgi_hrs                  Number;
        v_actual_hrs                Number;
        v_curr_hrs                  Number;
        v_grant_total_orig_est_hrs  Number;
        v_grant_total_curr_est_hrs  Number;                
        v_orig_po_amount            Number;
        v_current_po_amount         Number;
    Begin
        v_before_amount             := 0;
        v_orgi_hrs                  := 0;
        v_actual_hrs                := 0;
        v_curr_hrs                  := 0;
        v_grant_total_orig_est_hrs  := 0;
        v_grant_total_curr_est_hrs  := 0;
        v_orig_po_amount            := 0;
        v_current_po_amount         := 0;
        
        If p_hrs_type = 'O' Then
            Select
                nvl(Sum(orig_est_hrs),0)                
            Into 
                v_orgi_hrs
            From
                rap_osc_hours  roh,
                rap_osc_detail rod,
                rap_osc_master rom
            Where
                roh.oscd_id         = rod.oscd_id And
                rod.oscm_id         = rom.oscm_id And
                rom.projno5         = p_projno And
                rod.costcode        = p_costcode And
                rom.po_number       = p_ponum And
                roh.yyyymm < p_start_yymm;
        End If;

        If p_hrs_type = 'A' or p_hrs_type = 'C' Then
                        
            Select
                nvl(Sum(t.hours),0)                
            Into 
                v_actual_hrs
            From
                rap_osc_detail          rod,
                rap_osc_master          rom,
                emplmast                e,
                rap_gtt_osc_timetran    t
            Where
                t.empno                 = e.empno 
                And e.emptype = 'O'
                And rom.oscm_vendor     = e.subcontract                
                And rod.oscm_id         = rom.oscm_id
                And t.projno            = trim(rom.projno5)
                And t.costcode          = rod.costcode               
                And rom.projno5         = trim(p_projno)
                And rom.po_number       = trim(p_ponum)
                And rod.costcode        = trim(p_costcode)
                And t.yymm < to_number(p_start_yymm);
            
        End If;
              
        -- Grant total original estimated hours
        Select
            nvl(Sum(orig_est_hrs),0)           
        Into
            v_grant_total_orig_est_hrs
        From
            rap_osc_hours  roh,
            rap_osc_detail rod,
            rap_osc_master rom
        Where
            roh.oscd_id         = rod.oscd_id  
            And rod.oscm_id     = rom.oscm_id
            And rom.projno5     = p_projno             
            And rom.po_number   = p_ponum;        
        
        -- Grant total for current estimated hrs
        select 
            nvl(actual_hours + esti_hours, 0) hours 
        Into 
            v_grant_total_curr_est_hrs 
        from
        (select 
            nvl(Sum(hours),0) as actual_hours
        from 
            rap_gtt_osc_timetran    t, 
            emplmast                e,
            rap_osc_detail          rod, 
            rap_osc_master          rom
        where 
            t.empno                 = e.empno
            And e.emptype = 'O'
            And rom.oscm_vendor     = e.subcontract
            And rod.oscm_id         = rom.oscm_id
            And t.projno            = rom.projno5                
            And e.assign            = rod.costcode                
            And rom.projno5         = trim(p_projno)
            And rom.po_number       = trim(p_ponum)
            And t.yymm <= to_number(p_yymm)
        ) a,
        (select 
            nvl(sum(cur_est_hrs),0) as esti_hours
        from 
            rap_osc_hours roh, 
            rap_osc_detail rod, 
            rap_osc_master rom
        where 
            roh.oscd_id         = rod.oscd_id
            And rod.oscm_id     = rom.oscm_id 
            And rom.projno5     = p_projno 
            And rom.po_number   = p_ponum 
            And roh.yyyymm > p_yymm
        ) b;
        
        -- PO amount
        Select
            nvl(rom.po_amt,0),
            nvl(rom.cur_po_amt,0)
        Into 
            v_orig_po_amount,
            v_current_po_amount
        From
            rap_osc_master rom
        Where
            trim(rom.po_number)     = trim(p_ponum);
                
        -- Monthly po amount
        If p_hrs_type = 'O' Then
            If v_grant_total_orig_est_hrs <> 0 Then
                v_before_amount := round((v_current_po_amount / v_grant_total_orig_est_hrs) * v_orgi_hrs, 2);
            Else
                v_before_amount := 0;
            End If;
        End If;

        If p_hrs_type = 'A' Then
            If v_grant_total_curr_est_hrs <> 0 Then            
                If v_grant_total_curr_est_hrs > v_grant_total_orig_est_hrs Then
                    v_before_amount := round((v_current_po_amount / v_grant_total_curr_est_hrs) * v_actual_hrs, 2);
                Else
                    If v_grant_total_orig_est_hrs <> 0 Then
                        v_before_amount := round((v_current_po_amount / v_grant_total_orig_est_hrs) * v_actual_hrs, 2);
                    Else
                        v_before_amount := 0;
                    End if;                    
                End If;
            Else
                v_before_amount := 0;
            End If;            
        End If;

        If p_hrs_type = 'C' Then
            If v_grant_total_curr_est_hrs <> 0 Then            
                If v_grant_total_curr_est_hrs > v_grant_total_orig_est_hrs Then
                    v_before_amount := round((v_current_po_amount / v_grant_total_curr_est_hrs) * v_actual_hrs, 2);
                Else
                    If v_grant_total_orig_est_hrs <> 0 Then
                        v_before_amount := round((v_current_po_amount / v_grant_total_orig_est_hrs) * v_actual_hrs, 2);
                    Else
                        v_before_amount := 0;
                    End if;
                End If;
            Else
                v_before_amount := 0;
            End If;            
        End If;
        
        /*dbms_output.put_line('v_actual_hrs=' || v_actual_hrs);
        dbms_output.put_line('v_curr_hrs=' || v_curr_hrs);
        dbms_output.put_line('v_grant_total_orig_est_hrs=' || v_grant_total_orig_est_hrs);
        dbms_output.put_line('v_grant_total_curr_est_hrs=' || v_grant_total_curr_est_hrs);
        dbms_output.put_line('v_orig_po_amount='|| v_orig_po_amount);
        dbms_output.put_line('v_current_po_amount='|| v_current_po_amount);
        dbms_output.put_line('v_before_amount='|| v_before_amount);*/
        
        Return v_before_amount;
        
    End fn_before_period_amount;

    Function fn_after_period_amount (
        p_end_yymm In Varchar2,
        p_yymm     In Varchar2,
        p_hrs_type In Varchar2,
        p_projno   In Varchar2,
        p_costcode In Varchar2,
        p_ponum    In Varchar2
    ) Return Number As
        v_before_amount      Number;
        v_orgi_hrs           Number;
        v_actual_hrs         Number;
        v_curr_hrs           Number;
        v_total_orig_est_hrs Number;
        v_total_curr_est_hrs Number;
        v_orig_po_amount     Number;
        v_current_po_amount  Number;
    Begin
        v_before_amount      := 0;
        v_orgi_hrs           := 0;
        v_actual_hrs         := 0;
        v_curr_hrs           := 0;
        v_total_orig_est_hrs := 0;
        v_total_curr_est_hrs := 0;
        v_orig_po_amount     := 0;
        v_current_po_amount  := 0;
        
        If p_hrs_type = 'O' or p_hrs_type = 'A' Then
            Select
                nvl(sum(orig_est_hrs),0)               
            Into 
                v_orgi_hrs
            From
                rap_osc_hours  roh,
                rap_osc_detail rod,
                rap_osc_master rom
            Where
                roh.oscd_id         = rod.oscd_id
                And rod.oscm_id     = rom.oscm_id
                And rom.projno5     = p_projno
                And rod.costcode    = p_costcode
                And rom.po_number   = p_ponum
                And roh.yyyymm > p_end_yymm;
        End If;

        If p_hrs_type = 'C' Then
            Select
                nvl(sum(cur_est_hrs),0)                
            Into 
                v_curr_hrs
            From
                rap_osc_hours  roh,
                rap_osc_detail rod,
                rap_osc_master rom
            Where
                roh.oscd_id = rod.oscd_id
                And rod.oscm_id     = rom.oscm_id
                And rom.projno5     = p_projno
                And rod.costcode    = p_costcode
                And rom.po_number   = p_ponum
                And roh.yyyymm > p_end_yymm;
        End If;

        -- Total original estimated hrs
        Select
            nvl(Sum(orig_est_hrs),0)           
        Into
            v_total_orig_est_hrs
        From
            rap_osc_hours  roh,
            rap_osc_detail rod,
            rap_osc_master rom
        Where
            roh.oscd_id             = rod.oscd_id  
            And rod.oscm_id         = rom.oscm_id
            And rom.projno5         = p_projno              
            And rom.po_number       = p_ponum;     
        
       
        -- Total current estimated hrs
        select 
            nvl(actual_hours + esti_hours, 0) hours 
        Into 
            v_total_curr_est_hrs 
        from
        (select 
            nvl(Sum(hours),0) as actual_hours
        from 
            rap_gtt_osc_timetran    t, 
            emplmast                e,
            rap_osc_detail          rod, 
            rap_osc_master          rom
        where 
            t.empno                 = e.empno
            And e.emptype = 'O'
            And rom.oscm_vendor     = e.subcontract
            And rod.oscm_id         = rom.oscm_id
            And t.projno            = rom.projno5                
            And e.assign            = rod.costcode                
            And rom.projno5         = trim(p_projno)
            And rom.po_number       = trim(p_ponum)
            And rod.costcode        = trim(p_costcode)
            And t.yymm <= to_number(p_yymm)
        ) a,
        (select 
            nvl(sum(cur_est_hrs),0) as esti_hours
        from 
            rap_osc_hours roh, 
            rap_osc_detail rod, 
            rap_osc_master rom
        where 
            roh.oscd_id             = rod.oscd_id
            And rod.oscm_id         = rom.oscm_id 
            And rom.projno5         = p_projno
            And rom.po_number       = p_ponum 
            And roh.yyyymm > p_yymm
        ) b;
        
        
      -- PO amount
        Select
            nvl(rom.po_amt,0),
            nvl(rom.cur_po_amt,0)
        Into 
            v_orig_po_amount,
            v_current_po_amount
        From
            rap_osc_master rom
        Where
            rom.po_number = trim(p_ponum);      
      
      -- Monthly po amount
        If p_hrs_type = 'O' Then
            If v_total_orig_est_hrs <> 0 Then
                v_before_amount := round((v_orig_po_amount / v_total_orig_est_hrs) * v_orgi_hrs,2);
            Else
                v_before_amount := 0;
            End If;
        End If;

        If p_hrs_type = 'A' Then            
            v_before_amount := 0;
        End If;

        If p_hrs_type = 'C' Then
            If v_total_curr_est_hrs <> 0 Then
                v_before_amount := round((v_current_po_amount / v_total_curr_est_hrs) * v_curr_hrs,2);
            Else
                v_before_amount := 0;
            End If;
        End If;

         Return v_before_amount;

    exception
        when no_data_found then
            Return 0;
    End fn_after_period_amount;

    Function fn_cal_monthly_po_amount (
        p_hrs_type   In Varchar2,
        p_ponum      In Varchar2,
        p_yymm       In Varchar2,
        p_calc_hours In Number
    ) Return Number As
        v_total_orig_est_hrs Number;
        v_total_curr_est_hrs Number;
        v_orig_po_amount     Number;
        v_current_po_amount  Number;
        v_monthly_po_amount  Number;
    Begin
        v_total_orig_est_hrs := 0;
        v_orig_po_amount     := 0;
        v_monthly_po_amount  := 0;

      -- Total original estimated hrs
        Select
            nvl(sum(orig_est_hrs),0)            
        Into 
          v_total_orig_est_hrs
        From
            rap_osc_hours  roh,
            rap_osc_detail rod,
            rap_osc_master rom
         Where
                roh.oscd_id = rod.oscd_id
               And rod.oscm_id   = rom.oscm_id
               And rom.po_number = p_ponum;

      -- Total current estimated hrs
        select
            nvl(sum(hours),0) hours
         Into v_total_curr_est_hrs
         from
        (select nvl(sum(hours),0) as hours
        from rap_gtt_osc_timetran  t, emplmast e, rap_osc_detail rod, rap_osc_master rom
        where t.empno = e.empno 
            And e.emptype               = 'O' 
            And rom.oscm_vendor         = e.subcontract 
            And rod.oscm_id             = rom.oscm_id 
            And t.projno    = rom.projno5 
            And e.assign                = rod.costcode
            And t.projno in (select distinct projno5 from rap_osc_master) 
            And t.yymm < p_yymm
            --e.subcontract = rom.oscm_vendor and             
            And rom.po_number = p_ponum
        union
        select nvl(sum(cur_est_hrs),0) as hours
            from rap_osc_hours roh, rap_osc_detail rod, rap_osc_master rom
            where roh.oscd_id = rod.oscd_id and rod.oscm_id = rom.oscm_id
                and roh.yyyymm >= p_yymm and rom.po_number = p_ponum) ;

      -- Original PO amount
        Select
            nvl(
                rom.po_amt,
                0
            )
          Into v_orig_po_amount
          From
            rap_osc_master rom
         Where
            rom.po_number = p_ponum;

      -- Current PO amount
        Select
            nvl(
                rom.cur_po_amt,
                0
            )
          Into v_current_po_amount
          From
            rap_osc_master rom
         Where
            rom.po_number = p_ponum;

      -- Monthly po amount
        If p_hrs_type = 'O' Or p_hrs_type = 'A' Then
            If v_total_orig_est_hrs <> 0 Then
                v_monthly_po_amount := round((v_orig_po_amount / v_total_orig_est_hrs) * p_calc_hours,2);
            Else
                v_monthly_po_amount := 0;
            End If;
        End If;

        If p_hrs_type = 'C' Then
            If v_total_curr_est_hrs <> 0 Then
                If v_total_curr_est_hrs > v_total_orig_est_hrs Then
                    v_monthly_po_amount := round((v_current_po_amount / v_total_curr_est_hrs) * p_calc_hours,2);
                Else
                    If v_total_orig_est_hrs <> 0 Then                    
                        v_monthly_po_amount := round((v_current_po_amount / v_total_orig_est_hrs) * p_calc_hours,2);
                    Else
                        v_monthly_po_amount := 0;
                    End If;
                End If;
            Else
                v_monthly_po_amount := 0;
            End If;
        End If;
      
        Return v_monthly_po_amount;

      exception
        when no_data_found then
             Return 0;

    End fn_cal_monthly_po_amount;
    
    Function fn_monthly_po_amount (
        p_hrs_type   In Varchar2,
        p_projno     In Varchar2,
        p_ponum      In Varchar2,
        p_costcode   In Varchar2,
        p_yymm       In Varchar2,
        p_calc_hours In Number
    ) Return Number As        
        v_grant_total_orig_est_hrs  Number;        
        v_grant_total_curr_est_hrs  Number;
        v_orig_po_amount            Number;
        v_current_po_amount         Number;
        v_monthly_po_amount         Number;
    Begin        
        v_grant_total_orig_est_hrs  := 0;        
        v_grant_total_curr_est_hrs  := 0;
        v_orig_po_amount            := 0;
        v_current_po_amount         := 0;
        v_monthly_po_amount         := 0;

        -- Grant total original estimated hours
        Select
            nvl(sum(orig_est_hrs),0)            
        Into
            v_grant_total_orig_est_hrs
        From
            rap_osc_hours  roh,
            rap_osc_detail rod,
            rap_osc_master rom
        Where
            roh.oscd_id             = rod.oscd_id
            And rod.oscm_id         = rom.oscm_id 
            And rom.projno5         = p_projno 
            And rod.costcode        = p_costcode
            And rom.po_number       = p_ponum;
        
        -- Grant total for current estimated hrs
        select 
            nvl(actual_hours + esti_hours,0) hours 
        Into 
            v_grant_total_curr_est_hrs 
        from
        (select 
            nvl(Sum(hours),0) as actual_hours
        from 
            rap_gtt_osc_timetran    t, 
            emplmast                e,
            rap_osc_detail          rod, 
            rap_osc_master          rom
        where 
            t.empno                 = e.empno
            And e.emptype = 'O'
            And rom.oscm_vendor     = e.subcontract
            And rod.oscm_id         = rom.oscm_id
            And t.projno            = rom.projno5                
            And e.assign            = rod.costcode                
            And rom.projno5         = trim(p_projno)
            And rom.po_number       = trim(p_ponum)
            And rod.costcode        = trim(p_costcode)
            And t.yymm <= to_number(p_yymm)
        ) a,
        (select 
            nvl(sum(cur_est_hrs),0) as esti_hours
        from 
            rap_osc_hours roh, 
            rap_osc_detail rod, 
            rap_osc_master rom
        where 
            roh.oscd_id             = rod.oscd_id 
            And rod.oscm_id         = rom.oscm_id
            And rom.projno5         = p_projno 
            And rom.po_number       = p_ponum 
            And roh.yyyymm > p_yymm
        ) b;   
        
        -- PO amount
        Select
            nvl(rom.po_amt,0),
            nvl(rom.cur_po_amt,0)
        Into 
            v_orig_po_amount,
            v_current_po_amount
        From
            rap_osc_master rom
        Where
            rom.po_number = p_ponum;
        
        -- Monthly po amount
        If p_hrs_type = 'O' Then
            If v_grant_total_orig_est_hrs <> 0 Then
                v_monthly_po_amount := round((v_current_po_amount / v_grant_total_orig_est_hrs) * p_calc_hours, 2);
            Else
                v_monthly_po_amount := 0;
            End If;
        End If;

        If p_hrs_type = 'A' Then
           If v_grant_total_curr_est_hrs <> 0 Then            
                If v_grant_total_curr_est_hrs > v_grant_total_orig_est_hrs Then
                    v_monthly_po_amount := round((v_current_po_amount / v_grant_total_curr_est_hrs) * p_calc_hours, 2);
                Else
                    If v_grant_total_orig_est_hrs <> 0 Then
                        v_monthly_po_amount := round((v_current_po_amount / v_grant_total_orig_est_hrs) * p_calc_hours, 2);
                    Else
                        v_monthly_po_amount := 0;
                    End if;
                End If;
            Else
                v_monthly_po_amount := 0;
            End If;            
        End If;

        If p_hrs_type = 'C' Then
            If v_grant_total_curr_est_hrs <> 0 Then            
                If v_grant_total_curr_est_hrs > v_grant_total_orig_est_hrs Then
                    v_monthly_po_amount := round((v_current_po_amount / v_grant_total_curr_est_hrs) * p_calc_hours, 2);
                Else
                    If v_grant_total_orig_est_hrs <> 0 Then
                        v_monthly_po_amount := round((v_current_po_amount / v_grant_total_orig_est_hrs) * p_calc_hours, 2);
                    Else
                        v_monthly_po_amount := 0;
                    End if;                    
                End If;
            Else
                v_monthly_po_amount := 0;
            End If;            
        End If;
        
        Return v_monthly_po_amount;

      exception
        when no_data_found then
             Return 0;

    End fn_monthly_po_amount;  
    
    Function fn_monthly_ses_amount (
        p_actual_hours In Number,
        p_projno       In Varchar2,
        p_ponum        In Varchar2,
        p_yyyymm       In Varchar2,
        p_costcode     In Varchar2
    ) Return Number As
        v_total_ses_amount          Number;
        v_ses_amount_in_month       Number;
        v_total_actual_hrs          Number;
        v_total_actual_hrs_costcode Number;
        v_monthly_ses_amount        Number;
    Begin
        v_total_ses_amount              := 0;
        v_ses_amount_in_month           := 0;
        v_total_actual_hrs              := 0;
        v_total_actual_hrs_costcode     := 0;
        v_monthly_ses_amount            := 0;
        
        Select 
            nvl(sum(ses_amount),0) 
        Into
            v_ses_amount_in_month
        From 
            rap_osc_ses ros, 
            rap_osc_master rom
        Where 
            ros.oscm_id             = rom.oscm_id
            And rom.projno5         = p_projno
            And rom.po_number       = trim(p_ponum)
            And to_char(trunc(ros.ses_date), 'yyyymm') = p_yyyymm;
        
        -- Total actual hours till yymm
        
        Select
            nvl(Sum(t.hours),0)
        Into 
            v_total_actual_hrs
        From
            rap_osc_detail          rod,
            rap_osc_master          rom,
            emplmast                e,
            rap_gtt_osc_timetran    t
        Where                
            t.empno                 = e.empno
            And e.emptype = 'O'
            And rom.oscm_vendor     = e.subcontract
            And rod.oscm_id         = rom.oscm_id
            And t.projno            = rom.projno5                
            And t.costcode          = rod.costcode                
            And rom.projno5         = trim(p_projno)
            And rom.po_number       = trim(p_ponum)            
            And t.yymm <= to_number(p_yyyymm);
        
        -- Total hours hours till yymm for costcode
        
        Select
            nvl(Sum(t.hours),0)
        Into 
            v_total_actual_hrs_costcode
        From
            rap_osc_detail          rod,
            rap_osc_master          rom,
            emplmast                e,
            rap_gtt_osc_timetran    t
        Where                
            t.empno                 = e.empno
            And e.emptype = 'O'
            And rom.oscm_vendor     = e.subcontract
            And rod.oscm_id         = rom.oscm_id
            And t.projno            = rom.projno5                
            And t.costcode          = rod.costcode                
            And rom.projno5         = trim(p_projno)
            And rom.po_number       = trim(p_ponum)
            And rod.costcode        = trim(p_costcode)
            And t.yymm <= to_number(p_yyyymm);
            
        -- Monthly ses amount
        If v_total_actual_hrs <> 0 Then
            If v_ses_amount_in_month > 0 Then
                v_monthly_ses_amount := round((v_total_actual_hrs_costcode / v_total_actual_hrs) * v_ses_amount_in_month, 2);
            Else
                v_monthly_ses_amount := 0;
            End If;
        Else
             v_monthly_ses_amount := 0;
        End If;
        
        Return v_monthly_ses_amount;
    exception
        when no_data_found then
            Return 0;
    End fn_monthly_ses_amount;

    Function fn_before_period_ses (
        p_start_yymm In Varchar2,
        p_projno     In Varchar2,
        p_ponumber   In Varchar2,
        p_costcode   In Varchar2
    ) Return Number As
        v_total_ses_amount          Number;
        v_total_actual_hrs          Number;
        v_total_actual_hrs_costcode Number;
        v_before_ses_amt            Number;
    Begin
        v_total_ses_amount  := 0;
        v_total_actual_hrs_costcode := 0;
        v_total_actual_hrs  := 0;
        v_before_ses_amt := 0;

        -- Total ses amount
        Select
            nvl(Sum(ses_amount),0)
        Into 
            v_total_ses_amount
        From
            rap_osc_ses     ros,
            rap_osc_master  rom
        Where
        ros.oscm_id             = rom.oscm_id
        And to_char(ses_date,'yyyymm') < p_start_yymm
        And rom.projno5         = p_projno
        And rom.po_number       = p_ponumber;

        -- Total actual hrs
           
        Select
            nvl(Sum(t.hours),0)
        Into 
            v_total_actual_hrs
        From
            rap_osc_detail          rod,
            rap_osc_master          rom,
            emplmast                e,
            rap_gtt_osc_timetran    t
        Where                
            t.empno                 = e.empno
            And e.emptype = 'O'
            And rom.oscm_vendor     = e.subcontract
            And rod.oscm_id         = rom.oscm_id
            And t.projno            = rom.projno5                
            And t.costcode          = rod.costcode                
            And rom.projno5         = trim(p_projno)
            And rom.po_number       = trim(p_ponumber)            
            And t.yymm < to_number(p_start_yymm);
                    
        -- Total actual hrs for costcode
        Select
            nvl(Sum(t.hours),0)
        Into 
            v_total_actual_hrs_costcode
        From
            rap_osc_detail          rod,
            rap_osc_master          rom,
            emplmast                e,
            rap_gtt_osc_timetran    t
        Where                
            t.empno                 = e.empno
            And e.emptype = 'O'
            And rom.oscm_vendor     = e.subcontract
            And rod.oscm_id         = rom.oscm_id
            And t.projno            = rom.projno5                
            And t.costcode          = rod.costcode                
            And rom.projno5         = trim(p_projno)
            And rom.po_number       = trim(p_ponumber)
            And rod.costcode        = trim(p_costcode)
            And t.yymm < to_number(p_start_yymm);
        
        -- Before period ses amount
        If v_total_actual_hrs <> 0 Then            
            v_before_ses_amt := round((v_total_ses_amount / v_total_actual_hrs) * v_total_actual_hrs_costcode, 2);                                
        Else
            v_before_ses_amt := v_total_ses_amount;
        End If;

        Return v_before_ses_amt;

      exception
            when no_data_found then
                Return 0;
    End fn_before_period_ses;

    Function fn_after_period_ses (
        p_end_yymm In Varchar2,
        p_projno   In Varchar2,
        p_ponumber In Varchar2,
        p_costcode In Varchar2
    ) Return Number As
        v_total_ses_amount          Number;
        v_total_actual_hrs          Number;
        v_total_actual_hrs_costcode Number;
        v_after_ses_amt             Number;
    Begin
        v_total_ses_amount := 0;
        v_total_actual_hrs := 0;
        v_total_actual_hrs_costcode := 0;
        v_after_ses_amt := 0;

        -- Total ses amount
        Select
            nvl(Sum(ses_amount),0)            
        Into 
            v_total_ses_amount
        From
            rap_osc_ses    ros,
            rap_osc_master rom
        Where
            ros.oscm_id             = rom.oscm_id
            And to_char(ses_date,'yyyymm') > p_end_yymm
            And rom.projno5         = trim(p_projno)
            And rom.po_number       = trim(p_ponumber);

        -- Total hours hours till yymm for costcode
        
        Select
            nvl(Sum(t.hours),0)
        Into 
            v_total_actual_hrs_costcode
        From
            rap_osc_detail          rod,
            rap_osc_master          rom,
            emplmast                e,
            rap_gtt_osc_timetran    t
        Where                
            t.empno                 = e.empno
            And e.emptype = 'O'
            And rom.oscm_vendor     = e.subcontract
            And rod.oscm_id         = rom.oscm_id
            And t.projno            = rom.projno5                
            And t.costcode          = rod.costcode                
            And rom.projno5         = trim(p_projno)
            And rom.po_number       = trim(p_ponumber)
            And rod.costcode        = trim(p_costcode);

        -- Total actual hrs
        
        Select
            nvl(Sum(t.hours),0)
        Into 
            v_total_actual_hrs
        From
            rap_osc_detail          rod,
            rap_osc_master          rom,
            emplmast                e,
            rap_gtt_osc_timetran    t
        Where                
            t.empno                 = e.empno
            And e.emptype = 'O'
            And rom.oscm_vendor     = e.subcontract
            And rod.oscm_id         = rom.oscm_id
            And t.projno            = rom.projno5                
            --And t.costcode          = rod.costcode             --- ??              
            And rom.projno5         = trim(p_projno)
            And rom.po_number       = trim(p_ponumber)            
            And t.yymm < to_number(p_end_yymm);
            
        -- after period ses amount
        If v_total_actual_hrs <> 0 Then            
            v_after_ses_amt := round((v_total_actual_hrs_costcode / v_total_actual_hrs) * v_total_ses_amount, 2);
        Else
            v_after_ses_amt := 0;
        End If;

        Return v_after_ses_amt;

      exception
        when no_data_found then
            Return 0;
    End fn_after_period_ses;

    Function fn_vendor_name (
        p_projno   In Varchar2,
        p_ponumber In Varchar2
    ) Return Varchar2 As
        v_vendor_name Varchar2(45);
    Begin
        v_vendor_name := '';
        Select
            scm.description
          Into v_vendor_name
          From
            rap_osc_master  rom,
            subcontractmast scm
         Where
                rom.oscm_vendor = scm.subcontract
               And rom.projno5   = p_projno
               And rom.po_number = p_ponumber;

        Return v_vendor_name;
    End fn_vendor_name;

    Function fn_oscm_type (
        p_projno   In Varchar2,
        p_ponumber In Varchar2
    ) Return Varchar2 As
        v_oscm_type Varchar2(5);
    Begin
        v_oscm_type := '';
        Select
            rom.oscm_type
          Into v_oscm_type
          From
            rap_osc_master rom
         Where
                rom.projno5 = p_projno
               And rom.po_number = p_ponumber;
        Return v_oscm_type;
    End fn_oscm_type;

    function fn_scope_of_work_name(
        p_projno   In Varchar2,
        p_ponumber In Varchar2
    ) return varchar2 as
        v_scope_of_work_name Varchar2(50);
      begin
        v_scope_of_work_name := '';
        select distinct roswm.scope_work_desc into v_scope_of_work_name from  rap_osc_scope_work_mst roswm, rap_osc_master rom
        where roswm.oscsw_id = rom.oscsw_id and trim(rom.projno5) = trim(p_projno)
               And trim(rom.po_number) = trim(p_ponumber);
        return v_scope_of_work_name;
      exception
        when no_data_found then
            return '';
    end fn_scope_of_work_name;

    Function fn_po_amount (
        p_projno   In Varchar2,
        p_ponumber In Varchar2
    ) Return Number As
        v_po_amount Number;
    Begin
        v_po_amount := 0;
        Select
            rom.po_amt
          Into v_po_amount
          From
            rap_osc_master rom
         Where
                rom.projno5 = p_projno
               And rom.po_number = p_ponumber;

      Return v_po_amount;
      exception
        when no_data_found then
            Return 0;
    End fn_po_amount;

    Function fn_cur_po_amount (
        p_projno   In Varchar2,
        p_ponumber In Varchar2
    ) Return Number As
        v_cur_po_amount Number;
    Begin
        v_cur_po_amount := 0;
        Select
            rom.cur_po_amt
          Into v_cur_po_amount
          From
            rap_osc_master rom
         Where
                rom.projno5 = p_projno
               And rom.po_number = p_ponumber;

        Return v_cur_po_amount;
    End fn_cur_po_amount;

    function fn_proj_name(
         p_projno            In Varchar2
    ) return varchar2 as
        v_proj_name     varchar2(100);
      begin
        v_proj_name := '';
        select distinct name into v_proj_name from projmast where proj_no = p_projno ;
        return v_proj_name;
    end fn_proj_name;

    Procedure sp_osc_monthly_report (
        p_yearmode In Varchar2,
        p_yyyy     In Varchar2,
        p_yymm     In Varchar2,
        p_costcode In Varchar2,
        p_cols     Out Sys_Refcursor,
        p_results  Out Sys_Refcursor
    ) As
        v_start_month      Varchar2(6);
        v_end_month        Varchar2(6);
        v_start_month_prev Varchar2(6);
        v_end_month_next   Varchar2(6);
        v_costcode         Varchar2(4);
        noofmonths         Number;
        pivot_clause       Varchar2(4000);
        p_batch_key_id     Varchar2(8);
        p_insert_query     Varchar2(10000);
        p_success          Varchar2(2);
        p_message          Varchar2(4000);
    Begin
        noofmonths := 12;
        If p_costcode Is Null Then
            v_costcode := '%';
        Else
            v_costcode := p_costcode;
        End If;

        If p_yearmode = 'J' Then
            Select
                to_char(
                    trunc(
                        add_months(
                            To_Date('01-04-' || substr(
                                p_yyyy,
                                1,
                                4
                            ),
                                    'dd-mm-yyyy'),
                            - 3
                        ),
                        'yyyy'
                    ),
                    'yyyymm'
                ),
                to_char(
                    add_months(
                        trunc(
                            add_months(
                                To_Date('01-04-' || substr(
                                    p_yyyy,
                                    1,
                                    4
                                ),
                                        'dd-mm-yyyy'),
                                - 3
                            ),
                            'yyyy'
                        ),
                        12
                    ) - 1,
                    'yyyymm'
                )
              Into
                v_start_month,
                v_end_month
              From
                dual;
        Else
            Select
                to_char(
                    add_months(
                        trunc(
                            add_months(
                                To_Date('01-04-' || substr(
                                    p_yyyy,
                                    1,
                                    4
                                ),
                                        'dd-mm-yyyy'),
                                - 3
                            ),
                            'yyyy'
                        ),
                        3
                    ),
                    'yyyymm'
                ),
                to_char(
                    add_months(
                        trunc(
                            add_months(
                                To_Date('01-04-' || substr(
                                    p_yyyy,
                                    1,
                                    4
                                ),
                                        'dd-mm-yyyy'),
                                - 3
                            ),
                            'yyyy'
                        ),
                        15
                    ) - 1,
                    'yyyymm'
                )
              Into
                v_start_month,
                v_end_month
              From
                dual;
        End If;

        Select
            to_char(
                add_months(
                    To_Date(v_start_month,
                            'yyyymm'),
                    - 1
                ),
                'yyyymm'
            )
          Into v_start_month_prev
          From
            dual;
        Select
            to_char(
                add_months(
                    To_Date(v_end_month,
                            'yyyymm'),
                    1
                ),
                'yyyymm'
            )
          Into v_end_month_next
          From
            dual;

        Select
            Listagg(yymm || ' as "' || heading || '"',
                    ', ') Within Group(
             Order By
                yymm
            )
          Into pivot_clause
          From
            (
                Select
                    yymm,
                    heading
                  From
                    Table ( rap_reports.rpt_month_cols(
                        v_start_month,
                        12
                    ) )
            );

    
    -- populate 
    Insert Into rap_gtt_osc_timetran(
        projno, yyyymm, yymm, costcode, empno, hours, othours
    )
    Select
        substr(projno, 1, 5), yymm, yymm, costcode, empno, hours, othours
    From
        timetran_combine
    Where
        substr(projno, 1, 5) In (
            Select
                projno5
            From
                rap_osc_master    
        );

        
    -- months column --------------------------------------------------------
      
       Open p_cols For
            'select ''Till '' || :v_start_month_prev AS "TM", a.*, :v_end_month_next || '' onwards'' AS "PM" from
                (select * from (
                    (Select                
                        to_char(add_months(pdate, n-1), ''yyyymm'') yymm                
                    From
                        (    
                            Select
                                To_Date(:v_start_month, ''yyyymm'') pdate, Rownum n
                            From
                                (
                                    Select
                                        1 just_a_column
                                    From
                                        dual
                                    Connect By level <= :noofmonths
                                )
                        )
                   )
            ) pivot (max(yymm) for yymm in (' || pivot_clause || '))) a'
       Using v_start_month_prev, v_end_month_next, v_start_month, noofmonths;     
            

    -- Data --------------------------------------------------------
        Open p_results For
        'select p.*, pkg_rap_osc_report.fn_vendor_name(p.projno, p.po_number) vendor,
            pkg_rap_osc_report.fn_proj_name(p.projno) projname,
            pkg_rap_osc_report.fn_oscm_type(p.projno, p.po_number) oscm_type,
            pkg_rap_osc_report.fn_scope_of_work_name(p.projno, p.po_number) scope_of_work,
            pkg_rap_osc_report.fn_po_amount(p.projno, p.po_number) po_amt,
            pkg_rap_osc_report.fn_cur_po_amount(p.projno, p.po_number) cur_po_amt from
            (select ''A] Estimated Hours'' AS "DESCRIPTION",
                pkg_rap_osc_report.fn_before_period_total_hrs(:v_start_month, ''O'', projno, costcode, po_number) till_month,
                t1.*,
                pkg_rap_osc_report.fn_after_period_total_hrs(:v_end_month, ''O'', projno, costcode, po_number) post_month from
                (select * from (
                    with t_yymm as (
                        select distinct col_t.yymm, rom.projno5 projno, rom.po_number, rod.costcode
                        from table(rap_reports.rpt_month_cols(:v_start_month, 12)) col_t, rap_osc_detail rod, rap_osc_master rom
                        where rod.oscm_id = rom.oscm_id
                    ),
                    t_data as (
                        select rom.projno5 projno, rod.costcode, rom.po_number, roh.yyyymm yymm, nvl(sum(orig_est_hrs),0) as hours
                        from rap_osc_hours roh, rap_osc_detail rod, rap_osc_master rom
                        where roh.oscd_id = rod.oscd_id and rod.oscm_id = rom.oscm_id
                            and roh.yyyymm >= :v_start_month and roh.yyyymm <= :v_end_month
                        group by rom.projno5, rod.costcode, rom.po_number, roh.yyyymm order by rom.projno5, rod.costcode, rom.po_number, roh.yyyymm
                    )
                    select a.projno, a.costcode, a.po_number, a.yymm, b.hours from t_yymm a, t_data b
                    where a.yymm = b.yymm(+) and a.projno = b.projno(+) and a.po_number = b.po_number(+) and a.costcode = b.costcode(+)
                    order by a.projno, a.costcode, a.po_number, a.yymm
                    ) pivot (sum(hours) for yymm in (' || pivot_clause || '))
                ) t1
             UNION
             select ''B] Estimated Monthly PO AMT'' AS "DESCRIPTION",
                pkg_rap_osc_report.fn_before_period_amount(:v_start_month, :p_yymm, ''O'', projno, costcode, po_number) till_month,
                t2.*,
                pkg_rap_osc_report.fn_after_period_amount(:v_end_month, :p_yymm, ''O'', projno, costcode, po_number) post_month from
                (select * from (
                    with t_yymm as (
                        select distinct col_t.yymm, rom.projno5 projno, rom.po_number, rod.costcode
                        from table(rap_reports.rpt_month_cols(:v_start_month, 12)) col_t, rap_osc_detail rod, rap_osc_master rom
                        where rod.oscm_id = rom.oscm_id
                    ),
                    t_data as (
                        select rom.projno5 projno, rod.costcode, rom.po_number, roh.yyyymm yymm,
                            pkg_rap_osc_report.fn_monthly_po_amount(''O'', rom.projno5, rom.po_number, rod.costcode, :p_yymm, nvl(sum(orig_est_hrs),0)) as esti_amt
                        from rap_osc_hours roh, rap_osc_detail rod, rap_osc_master rom
                        where roh.oscd_id = rod.oscd_id and rod.oscm_id = rom.oscm_id
                            and roh.yyyymm >= :v_start_month and roh.yyyymm <= :v_end_month
                            group by rom.projno5, rod.costcode, rom.po_number, roh.yyyymm order by rom.projno5, rod.costcode, rom.po_number, roh.yyyymm
                    )
                    select a.projno, a.costcode, a.po_number, a.yymm, b.esti_amt from t_yymm a, t_data b
                    where a.yymm = b.yymm(+) and a.projno = b.projno(+) and a.po_number = b.po_number(+) and a.costcode = b.costcode(+)
                    order by a.projno, a.costcode, a.po_number, a.yymm
                    ) pivot (sum(esti_amt) for yymm in (' || pivot_clause || '))
                ) t2
             UNION
             select ''C] Actual Hours'' AS "DESCRIPTION",
                    pkg_rap_osc_report.fn_before_period_total_hrs(:v_start_month, ''A'', projno, costcode, po_number) till_month,
                    t3.*,
                    pkg_rap_osc_report.fn_after_period_total_hrs(:v_end_month, ''A'', projno, costcode, po_number) post_month from
                (select * from (
                    with t_yymm as (
                        select distinct col_t.yymm, rom.projno5 projno, rom.po_number, rod.costcode
                        from table(rap_reports.rpt_month_cols(:v_start_month, 12)) col_t, rap_osc_detail rod, rap_osc_master rom
                        where rod.oscm_id = rom.oscm_id
                    ),
                    t_data as (
                         select t.projno, e.assign, rom.po_number, t.yyyymm yymm, nvl(sum(hours),0) as hours
                            from rap_gtt_osc_timetran t, emplmast e, rap_osc_detail rod, rap_osc_master rom
                            where t.empno = e.empno and e.emptype = ''O'' and rom.oscm_vendor = e.subcontract and
                              rod.oscm_id = rom.oscm_id and t.projno = rom.projno5 and e.assign = rod.costcode and
                              t.projno in (select distinct projno5 from rap_osc_master) and
                              t.yymm >= to_number(:v_start_month) and t.yymm <= to_number(:v_end_month)
                        group by rod.oscm_id, t.projno, e.assign, rom.po_number, t.yyyymm order by t.yyyymm
                    )
                    select a.projno, a.costcode, a.po_number, a.yymm, b.hours from t_yymm a, t_data b
                    where a.yymm = b.yymm(+) and a.projno = b.projno(+) and a.po_number = b.po_number(+) and a.costcode = b.assign(+)
                    order by a.projno, a.costcode, a.po_number, a.yymm
                    ) pivot (sum(hours) for yymm in (' || pivot_clause || '))
                ) t3
             UNION
             select ''D] Actual Monthly PO Amount'' AS "DESCRIPTION",
                    pkg_rap_osc_report.fn_before_period_amount(:v_start_month, :p_yymm, ''A'', projno, costcode, po_number) till_month,
                    t4.*,
                    pkg_rap_osc_report.fn_after_period_amount(:v_end_month, :p_yymm, ''A'', projno, costcode, po_number) post_month from
                (select * from (
                    with t_yymm as (
                        select distinct col_t.yymm, rom.projno5 projno, rom.po_number, rod.costcode
                        from table(rap_reports.rpt_month_cols(:v_start_month, 12)) col_t, rap_osc_detail rod, rap_osc_master rom
                        where rod.oscm_id = rom.oscm_id
                    ),
                    t_data as (
                         select t.projno, e.assign, rom.po_number, t.yyyymm yymm,
                            pkg_rap_osc_report.fn_monthly_po_amount(''A'', t.projno, rom.po_number, e.assign, :p_yymm, nvl(sum(hours),0)) as esti_amt
                            from rap_gtt_osc_timetran t, emplmast e, rap_osc_detail rod, rap_osc_master rom
                            where t.empno = e.empno and e.emptype = ''O'' and rom.oscm_vendor = e.subcontract and
                              rod.oscm_id = rom.oscm_id and t.projno = rom.projno5 and e.assign = rod.costcode and
                              t.projno in (select distinct projno5 from rap_osc_master) and
                              t.yymm >= to_number(:v_start_month) and t.yymm <= to_number(:v_end_month)
                        group by rod.oscm_id, t.projno, e.assign, rom.po_number, t.yyyymm order by t.yyyymm
                    )
                    select a.projno, a.costcode, a.po_number, a.yymm, b.esti_amt from t_yymm a, t_data b
                    where a.yymm = b.yymm(+) and a.projno = b.projno(+) and a.po_number = b.po_number(+) and a.costcode = b.assign(+)
                    order by a.projno, a.costcode, a.po_number, a.yymm
                    ) pivot (sum(esti_amt) for yymm in (' || pivot_clause || '))
                ) t4
             UNION
             select ''E] Current Estimated Hours'' AS "DESCRIPTION",
                    pkg_rap_osc_report.fn_before_period_total_hrs(:v_start_month, ''C'', projno, costcode, po_number) till_month,
                    t5.*,
                    pkg_rap_osc_report.fn_after_period_total_hrs(:v_end_month, ''C'', projno, costcode, po_number) post_month from
                (select * from (
                    with t_yymm as (
                        select distinct col_t.yymm, rom.projno5 projno, rom.po_number, rod.costcode
                        from table(rap_reports.rpt_month_cols(:v_start_month, 12)) col_t, rap_osc_detail rod, rap_osc_master rom
                        where rod.oscm_id = rom.oscm_id
                    ),
                    t_data as (
                        select projno, costcode, po_number, yymm, hours from
                        (select t.projno, e.assign costcode, rom.po_number, t.yyyymm yymm, nvl(sum(hours),0) as hours
                        from rap_gtt_osc_timetran t, emplmast e, rap_osc_detail rod, rap_osc_master rom
                        where t.empno = e.empno and e.emptype = ''O'' and rom.oscm_vendor = e.subcontract and
                            rod.oscm_id = rom.oscm_id and t.projno = rom.projno5 and e.assign = rod.costcode and
                            t.projno in (select distinct projno5 from rap_osc_master) and
                            t.yymm >= to_number(:v_start_month) and t.yymm <= to_number(:p_yymm)
                        group by rod.oscm_id, t.projno, e.assign, rom.po_number, t.yyyymm
                        union
                        select rom.projno5 projno, rod.costcode, rom.po_number, roh.yyyymm yymm, nvl(sum(cur_est_hrs),0) as hours
                            from rap_osc_hours roh, rap_osc_detail rod, rap_osc_master rom
                            where roh.oscd_id = rod.oscd_id and rod.oscm_id = rom.oscm_id
                                and roh.yyyymm > :p_yymm and roh.yyyymm <= :v_end_month
                             group by rod.oscm_id, rom.projno5, rod.costcode, rom.po_number, roh.yyyymm
                        ) order by projno, costcode, po_number, yymm
                    )
                    select a.projno, a.costcode, a.po_number, a.yymm, b.hours from t_yymm a, t_data b
                    where a.yymm = b.yymm(+) and a.projno = b.projno(+) and a.po_number = b.po_number(+) and a.costcode = b.costcode(+)
                    order by a.projno, a.costcode, a.po_number, a.yymm
                    ) pivot (sum(hours) for yymm in (' || pivot_clause || '))
                ) t5
            UNION
              select ''F] Current Estimated PO Amount'' AS "DESCRIPTION",
                    pkg_rap_osc_report.fn_before_period_amount(:v_start_month, :p_yymm, ''C'', projno, costcode, po_number) till_month,
                    t6.*,
                    pkg_rap_osc_report.fn_after_period_amount(:v_end_month, :p_yymm, ''C'', projno, costcode, po_number) post_month from
                (select * from (
                    with t_yymm as (
                        select distinct col_t.yymm, rom.projno5 projno, rom.po_number, rod.costcode
                        from table(rap_reports.rpt_month_cols(:v_start_month, 12)) col_t, rap_osc_detail rod, rap_osc_master rom
                        where rod.oscm_id = rom.oscm_id
                    ),
                    t_data as (
                        select projno, costcode, po_number, yymm, curr_amt from
                        (select t.projno, e.assign costcode, rom.po_number, t.yyyymm yymm,
                        pkg_rap_osc_report.fn_monthly_po_amount(''C'', t.projno, rom.po_number, e.assign, :p_yymm, nvl(sum(hours),0)) as curr_amt
                        from rap_gtt_osc_timetran t, emplmast e, rap_osc_detail rod, rap_osc_master rom
                        where t.empno = e.empno and e.emptype = ''O'' and rom.oscm_vendor = e.subcontract and
                            rod.oscm_id = rom.oscm_id and t.projno = rom.projno5 and e.assign = rod.costcode and
                            t.projno in (select distinct projno5 from rap_osc_master) and
                            t.yymm >= to_number(:v_start_month) and t.yymm <= to_number(:p_yymm)
                        group by rod.oscm_id, t.projno, e.assign, rom.po_number, t.yyyymm
                        union
                        select rom.projno5 projno, rod.costcode, rom.po_number, roh.yyyymm yymm,
                            pkg_rap_osc_report.fn_monthly_po_amount(''C'', rom.projno5, rom.po_number, rod.costcode, :p_yymm, nvl(sum(cur_est_hrs),0)) as curr_amt
                            from rap_osc_hours roh, rap_osc_detail rod, rap_osc_master rom
                            where roh.oscd_id = rod.oscd_id and rod.oscm_id = rom.oscm_id
                                and roh.yyyymm > :p_yymm and roh.yyyymm <= :v_end_month
                             group by rod.oscm_id, rom.projno5, rod.costcode, rom.po_number, roh.yyyymm
                        ) order by projno, costcode, po_number, yymm
                    )
                    select a.projno, a.costcode, a.po_number, a.yymm, b.curr_amt from t_yymm a, t_data b
                    where a.yymm = b.yymm(+) and a.projno = b.projno(+) and a.po_number = b.po_number(+) and a.costcode = b.costcode(+)
                    order by a.projno, a.costcode, a.po_number, a.yymm
                    ) pivot (sum(curr_amt) for yymm in (' || pivot_clause || '))
                ) t6
             UNION
               select ''G] Actual Monthly SES entry'' AS "DESCRIPTION",
                    pkg_rap_osc_report.fn_before_period_ses(:v_start_month, projno, po_number, costcode) till_month,
                    t7.* ,
                    pkg_rap_osc_report.fn_after_period_ses(:v_end_month, projno, po_number, costcode) post_month
                    from
               (select * from (
                    with t_yymm as (
                        select distinct col_t.yymm, rom.projno5 projno, rom.po_number, rod.costcode
                        from table(rap_reports.rpt_month_cols(:v_start_month, 12)) col_t, rap_osc_detail rod, rap_osc_master rom
                        where rod.oscm_id = rom.oscm_id
                    ),
                    t_data as (
                        select projno, costcode, po_number, yymm, nvl(sum(hours),0) as hours,
                            pkg_rap_osc_report.fn_monthly_ses_amount(nvl(sum(hours),0), projno, po_number, yymm, costcode) as ses_amt from
                          (select t.projno projno, e.assign costcode, rom.po_number, t.yyyymm yymm, nvl(hours,0) as hours                            
                            from rap_gtt_osc_timetran t, emplmast e, rap_osc_detail rod, rap_osc_master rom
                            where t.empno = e.empno and e.emptype = ''O'' and rom.oscm_vendor = e.subcontract and
                              rod.oscm_id = rom.oscm_id and t.projno = rom.projno5 and e.assign = rod.costcode and
                              t.projno in (select distinct projno5 from rap_osc_master) and
                              t.yymm >= to_number(:v_start_month) and t.yymm <= to_number(:v_end_month)
                        UNION
                          select distinct rom.projno5 projno, rod.costcode, rom.po_number, col_t.yymm, 0 as hours
                          from table(rap_reports.rpt_month_cols(:v_start_month, 12)) col_t, rap_osc_detail rod, rap_osc_master rom
                          where rod.oscm_id = rom.oscm_id)
                        group by projno, costcode, po_number, yymm
                    )
                    select a.projno, a.costcode, a.po_number, a.yymm, b.ses_amt from t_yymm a, t_data b
                    where a.yymm = b.yymm(+) and a.projno = b.projno(+) and a.po_number = b.po_number(+) and a.costcode = b.costcode(+)
                    order by a.projno, a.costcode, a.po_number, a.yymm
                    ) pivot (sum(ses_amt) for yymm in (' || pivot_clause || '))
                where projno is not null order by projno, costcode, po_number) t7
                ) p
        where p.projno is not null and p.po_number is not null
        order by p.projno, p.po_number, p.costcode, p.description'
        Using v_start_month, v_end_month, v_start_month, v_start_month, v_end_month,                                --- [for t1]
            v_start_month, p_yymm, v_end_month, p_yymm, v_start_month, p_yymm, v_start_month, v_end_month,          --- [for t2]
            v_start_month, v_end_month, v_start_month, v_start_month, v_end_month,                                  --- [for t3]
            v_start_month, p_yymm, v_end_month, p_yymm, v_start_month, p_yymm, v_start_month, v_end_month,          --- [for t4]
            v_start_month, v_end_month, v_start_month, v_start_month, p_yymm, p_yymm, v_end_month,                  --- [for t5]
            v_start_month, p_yymm, v_end_month, p_yymm, v_start_month, p_yymm, v_start_month, p_yymm, p_yymm, p_yymm, v_end_month,  --- [for t6]
            v_start_month, v_end_month, v_start_month, v_start_month, v_end_month, v_start_month;                   --- [for t7]
    End sp_osc_monthly_report;

End pkg_rap_osc_report;