create or replace package body selfservice.iot_rsvp as

  procedure sp_create_navratri_rsvp(
        p_person_id        varchar2,
        p_meta_id          varchar2,        
        p_attend           number, 
        p_bus              number,
        p_dinner           number,
        p_message_type out varchar2,
        p_message_text out varchar2
    ) as
        v_empno        Varchar2(5); 
        v_count        number := 0;
        v_message_type Number      := 0;
  begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        select count(*) into v_count from ss_navratri_2023 where empno = v_empno;
        
        if v_count > 0 then
            update ss_navratri_2023 set attend = p_attend, bus = p_bus, dinner = p_dinner, modifiedon = sysdate
                where empno = v_empno;
        else
            Insert Into ss_navratri_2023 (empno, attend, bus, dinner, modifiedon)
            Values (v_empno, p_attend, p_bus, p_dinner, sysdate);
        end if;
        
        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
  end sp_create_navratri_rsvp;

  procedure sp_update_navratri_rsvp(
        p_person_id        varchar2,
        p_meta_id          varchar2,       
        p_attend           number,
        p_bus              number,
        p_dinner           number,
        p_message_type out varchar2,
        p_message_text out varchar2
    ) as
        v_empno        Varchar2(5);        
        v_message_type Number      := 0;
  begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        update ss_navratri_2023  
        set attend = p_attend,
            bus = p_bus, 
            dinner = p_dinner,
            modifiedon = sysdate
        where empno = v_empno;

        Commit;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
  end sp_update_navratri_rsvp;

  procedure sp_detail_navratri_rsvp(
        p_person_id        varchar2,
        p_meta_id          varchar2,        
        p_attend       Out number, 
        p_bus          Out number,
        p_dinner       Out number,
        p_counter      Out varchar2,
        p_message_type out varchar2,
        p_message_text out varchar2
    ) as  
        v_count_attend  number := 0;
        v_count_bus    number := 0;
        v_count_dinner number := 0;
        v_empno        Varchar2(5);        
        v_message_type Number      := 0;
        v_total        number;
        v_yes          number;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        
        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;
        
        select 
            count(*) 
         into 
            v_yes        
        from 
            ss_navratri_2023        
        where 
            attend = 1;

        select 
            count(*)
        into 
            v_total
        from 
            ss_navratri_2023;
            
        if v_total > 0 then
            p_counter := v_yes || ' / ' || v_total;
        else
            p_counter := '-NA-';
        end if;        
        
        
        -- Attend
        select 
            count(*) into v_count_attend 
        from 
            ss_navratri_2023 
        where
            empno = v_empno;
        
        if v_count_attend > 0 then
            Select
                attend,
                bus,
                dinner
            Into
                p_attend,
                p_bus,
                p_dinner
            From
                ss_navratri_2023
            Where
                empno = v_empno;

        else
            p_attend := -1;
            p_bus := -1;
            p_dinner := -1;
        end if;            

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;
  end sp_detail_navratri_rsvp;
  
  function sp_excel_navratri_rsvp(
      p_person_id       varchar2,
      p_meta_id         varchar2
    ) return sys_refcursor as
        c sys_refcursor;
        v_empno         varchar2(5);
        e_employee_not_found    exception;
        Pragma exception_init(e_employee_not_found, -20001);             
    begin       
        v_empno := get_empno_from_meta_id(p_meta_id);
        if v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        end If;      
        open c for
            select 
                a.empno,
                initcap(b.name) name,
                c.abbr, 
                b.sex gender, 
                decode(a.attend,1,'Yes','No') attend,
                decode(a.bus,1,'Yes','No') bus,
                decode(a.dinner,1,'Yes','No') dinner
            from 
                ss_navratri_2023 a, 
                ss_emplmast b,
                ss_costmast c
            where 
                a.empno = b.empno and 
                b.parent = c.costcode
            order by 
                a.attend desc,
                a.empno;
        return c;
    end sp_excel_navratri_rsvp;    
    
end iot_rsvp;