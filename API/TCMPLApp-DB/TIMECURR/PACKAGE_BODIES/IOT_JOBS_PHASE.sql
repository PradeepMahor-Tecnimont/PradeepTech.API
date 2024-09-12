create or replace package body "TIMECURR"."IOT_JOBS_PHASE" as

  procedure sp_add_phase (
        p_person_id     varchar2,
        p_meta_id       varchar2,
        p_projno        varchar2,
        p_phase         varchar2,
        p_tmagrp        varchar2,
        p_blockbooking  number,
        p_blockot       number,
        p_message_type Out      Varchar2,
        p_message_text Out      Varchar2
    ) as  
        v_exists    number := 0;
        v_empno     varchar2(5);
      begin      
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
      
        select count(*) into v_exists from job_proj_phase where projno = p_projno and phase_select = p_phase;
        
        if v_exists = 0 then
            insert into job_proj_phase (
                projno, phase, tmagrp, phase_select, block_booking, block_ot                             
            )
            values(
                p_projno, '00', p_tmagrp, p_phase, p_blockbooking, p_blockot
            );    
            p_message_type := c_ok;
            p_message_text := 'Phase added successfully';
        else
            p_message_type := c_not_ok;
            p_message_text := 'Phase already exists';         
        end if;
        Commit;
      exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
  end sp_add_phase;

  procedure sp_update_phase(
        p_person_id     varchar2,
        p_meta_id       varchar2,
        p_projno        Varchar2,
        p_phase         Varchar2,
        p_tmagrp        Varchar2,
        p_blockbooking  Number,
        p_blockot       Number,      
        p_message_type Out      Varchar2,
        p_message_text Out      Varchar2
    ) as
        v_empno     varchar2(5);
      begin      
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        update job_proj_phase
            set tmagrp = p_tmagrp,              
            block_booking = p_blockbooking, 
            block_ot = p_blockot            
        where projno = p_projno 
            and phase_select = p_phase;
        
       p_message_type := c_ok;
       p_message_text := 'Phase updated successfully';
    
        Commit;
      exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
  end sp_update_phase;

  procedure sp_delete_phase (
        p_person_id     varchar2,
        p_meta_id       varchar2,
        p_projno        Varchar2,
        p_phase         Varchar2,
        p_message_type Out      Varchar2,
        p_message_text Out      Varchar2
    ) as
        v_empno     varchar2(5);
    begin      
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERROR' Then
            p_message_type := c_not_ok;
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        delete from job_proj_phase
        where Trim(projno) = Trim(p_projno) 
            and Trim(phase_select) = Trim(p_phase);
        
        p_message_type := c_ok;
        p_message_text := 'Phase deleted successfully';
    
        Commit;
      exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
  end sp_delete_phase;
  
  procedure sp_phase_detail (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_projno        Varchar2,
        p_phase         Varchar2,
        p_description  Out      Varchar2,
        p_tmagrp       Out      Varchar2,
        p_blockbooking Out      Number,
        p_blockot      Out      Number, 
        p_message_type Out      Varchar2,
        p_message_text Out      Varchar2
    ) as
    begin
        Select            
            ps.description,
            pp.tmagrp,
            nvl(pp.block_booking, 0),
            nvl(pp.block_ot, 0)
        Into            
            p_description,
            p_tmagrp,
            p_blockbooking,
            p_blockot
        From
            job_proj_phase pp,
            job_phases     ps
        Where
            pp.phase_select     = ps.phase
            And Trim(pp.projno) = Trim(p_projno)
            And Trim(pp.phase_select) = Trim(p_phase);
        p_message_type := c_ok;
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := c_not_ok;
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
  end sp_phase_detail;
end IOT_JOBS_PHASE;

/
Grant Execute On "TIMECURR"."IOT_JOBS" To "TCMPL_APP_CONFIG";