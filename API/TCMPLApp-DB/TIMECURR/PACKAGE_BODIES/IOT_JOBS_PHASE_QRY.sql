Create Or Replace Package Body timecurr.iot_jobs_phase_qry As

    Function fn_job_phases_list(
        p_person_id Varchar2,
        p_meta_id   Varchar2,
        p_projno    Varchar2
    ) Return Sys_Refcursor As

        c                    Sys_Refcursor;
        v_empno              Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init(e_employee_not_found, -20001);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

        Open c For
            Select
                pp.projno,
                pp.phase_select                                         phase,
                ps.description,
                pp.tmagrp,
                iot_jobs_general.get_tmagrp_desc(pp.tmagrp)             tmagrpdesc,
                nvl(pp.block_booking, 0)                                block_booking,
                nvl(pp.block_ot, 0)                                     block_ot,
                fn_phase_exists_in_database(pp.projno, pp.phase_select) isexists,
                Row_Number() Over (Order By
                        pp.phase_select)                                row_number,
                Count(*) Over ()                                        total_row
            From
                job_proj_phase pp,
                job_phases     ps
            Where
                pp.phase_select     = ps.phase
                And Trim(pp.projno) = Trim(p_projno)
            Order By
                phase;
        Return c;
    End fn_job_phases_list;

    Function fn_phase_exists_in_database(
        p_projno Varchar2,
        p_phase  Varchar2
    ) Return Number As
        v_exists Number := 0;
    Begin
        -- time_daily
        Select
            Count(projno)
        Into
            v_exists
        From
            time_daily
        Where
            projno = Trim(p_projno) || Trim(p_phase);
        If v_exists > 0 Then
            Return v_exists;
        End If;
        
        -- time_ot        
        Select
            Count(projno)
        Into
            v_exists
        From
            time_ot
        Where
            projno = Trim(p_projno) || Trim(p_phase);
        If v_exists > 0 Then
            Return v_exists;
        End If;
        
        -- timetran            
        Select
            Count(projno)
        Into
            v_exists
        From
            timetran
        Where
            projno = Trim(p_projno) || Trim(p_phase);
        If v_exists > 0 Then
            Return v_exists;
        End If;   
        
        -- budgmast            
        Select
            Count(projno)
        Into
            v_exists
        From
            budgmast
        Where
            projno = Trim(p_projno) || Trim(p_phase);
        If v_exists > 0 Then
            Return v_exists;
        End If;
        
        -- budgtran                
        Select
            Count(projno)
        Into
            v_exists
        From
            budgtran
        Where
            projno = Trim(p_projno) || Trim(p_phase);
        If v_exists > 0 Then
            Return v_exists;
        End If;
        
        -- prjcmast                
        Select
            Count(projno)
        Into
            v_exists
        From
            prjcmast
        Where
            projno = Trim(p_projno) || Trim(p_phase);
        If v_exists > 0 Then
            Return v_exists;
        End If;
        
        -- job_budgtran                
        Select
            Count(projno)
        Into
            v_exists
        From
            job_budgtran
        Where
            projno = Trim(p_projno) || Trim(p_phase);
        If v_exists > 0 Then
            Return v_exists;
        End If;
        
        -- jobbudget                
        Select
            Count(projno)
        Into
            v_exists
        From
            jobbudget
        Where
            projno = Trim(p_projno) || Trim(p_phase);
        If v_exists > 0 Then
            Return v_exists;
        End If;

        Return v_exists;
    End fn_phase_exists_in_database;

End iot_jobs_phase_qry;
/
Grant Execute On "TIMECURR"."IOT_JOBS_PHASE_QRY" To "TCMPL_APP_CONFIG";