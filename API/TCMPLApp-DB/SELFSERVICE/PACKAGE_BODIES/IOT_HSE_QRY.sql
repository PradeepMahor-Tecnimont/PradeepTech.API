--------------------------------------------------------
--  DDL for Package Body IOT_HSE_QRY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_HSE_QRY" AS

    function fn_naturetype_select_list(
        p_person_id             varchar2,
        p_meta_id               varchar2
    ) return Sys_Refcursor As
        c                       sys_Refcursor;
        v_empno                 varchar2(5);
        e_employee_not_found    exception;
        Pragma exception_init(e_employee_not_found, -20001);
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        if v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        end If;

        open c For
            select 
                natureid data_value_field, 
                naturename data_text_field 
            from 
                hse_naturetype
            order by 
                orderby;                    
        return c;
    end;
    
    function fn_incidenttype_select_list(
        p_person_id             varchar2,
        p_meta_id               varchar2
    ) return Sys_Refcursor As
        c                       sys_Refcursor;
        v_empno                 varchar2(5);
        e_employee_not_found    exception;
        Pragma exception_init(e_employee_not_found, -20001);
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        if v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        end If;

        open c For
            select 
                typeid data_value_field, 
                typename data_text_field 
            from 
                hse_incidenttype
            order by 
                orderby;                    
        return c;
    end;
        
    function fn_incident_list(
      p_person_id       varchar2,
      p_meta_id         varchar2,      
      p_is_active       number default 1,
      p_showall         number default 0,
      p_generic_search  varchar2 default null,
      p_statusstring    varchar2 default null,
      p_row_number      number,
      p_page_length     number
    ) return sys_refcursor as
        c sys_refcursor;
        v_empno         varchar2(5);
        e_employee_not_found    exception;
        Pragma exception_init(e_employee_not_found, -20001);
        v_isdelete      number := 0;        
    begin
      if p_showall = 1 then
         v_empno := '%%';
      else 
         v_empno := get_empno_from_meta_id(p_meta_id);
         if v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        end If;
      end if;
      
      if p_statusstring = 'Deleted' then
        v_isdelete := 1;
      end if;
      
      --dbms_output.put_line(' ---> '||v_empno);
      open c for
         select *
           from (
                select 
                    a.reportid,
                    a.reportdate,
                    nvl(a.empno,'') as empno,
                    nvl(a.empname, '') as name,
                    a.costcode,
                    a.office,
                    a.loc,
                    a.incdate,
                    a.inctime,
                    a.mailsend,
                    a.isactive,
                    iot_hse_qry.fn_get_incident_status(a.reportid) as statusstring,
                    initcap(b.name) as reportedby,
                    row_number() over (order by reportdate desc) row_number,
                    count(*) over () total_row
                from 
                    hse_incidentreport a,
                    ss_emplmast b
				where 
                    substr(trim(a.reportid),4,5) = b.empno and
                    substr(trim(a.reportid),4,5) like '%'|| trim(v_empno) || '%' and
                    --a.isactive = nvl(p_is_active, a.isactive) and
                    --a.isdelete = case when p_showall = 1 then a.isdelete else v_isdelete end and
                    (upper(a.empno) like upper('%' || p_generic_search || '%') or
                        upper(a.empname) like upper('%' || p_generic_search || '%')
                    ) and                    
                    trim(upper(iot_hse_qry.fn_get_incident_status(a.reportid))) = nvl(trim(upper(p_statusstring)), trim(upper(iot_hse_qry.fn_get_incident_status(a.reportid))))
                    
          )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
          order by reportdate desc;
      return c;
    end fn_incident_list;
    
     procedure sp_incident_detail(
        p_person_id         varchar2,
        p_meta_id           varchar2,
        p_reportid          varchar2, 
        p_reportdate        out date,
        p_yyyy              out varchar2,
        p_office            out varchar2,
        p_loc               out varchar2,
        p_costcode          out varchar2,
        p_incdate           out date,
        p_inctime           out varchar2,
        p_inctype           out varchar2,
        p_inctypename       out varchar2,
        p_nature            out varchar2,
        p_naturename        out varchar2,
        p_injuredparts      out varchar2,
        p_empno             out varchar2,
        p_empname           out varchar2,
        p_desg              out varchar2,
        p_age               out varchar2,
        p_sex               out varchar2,
        p_subcontract       out varchar2,
        p_subcontractname   out varchar2,
        p_aid               out varchar2,
        p_description       out varchar2,
        p_causes            out varchar2,
        p_action            out varchar2,
        p_correctiveactions out varchar2,
        p_closer            out varchar2,
        p_closerdate        out date,
        p_attchmentlink     out varchar2,
        p_mailsend          out number,
        p_isactive          out number,
        p_isdelete          out number,
        p_message_type      out varchar2,
        p_message_text      out varchar2
    ) as
            v_empno        varchar2(5);
            v_user_tcp_ip  varchar2(5) := 'NA';
            v_message_type number      := 0;
        begin
            v_empno        := get_empno_from_meta_id(p_meta_id);
            
            if v_empno = 'ERRRR' then
                p_message_type := 'KO';
                p_message_text := 'Invalid employee number';
                return;
            end if;
            
            select
                a.reportdate,
                a.yyyy,
                a.office,
                a.loc,
                a.costcode,
                a.incdate,
                a.inctime,
                a.inctype,
                b.typename,
                a.nature,
                c.naturename,
                iot_hse_qry.fn_get_injured_parts(a.reportid),
                a.empno,
                a.empname,
                a.desg,
                a.age,
                a.sex,
                a.subcontract,
                a.subcontractname,
                a.aid,
                a.description,
                a.causes,
                a.action,
                a.correctiveactions,
                a.closer,
                a.closerdate,
                a.attchmentlink,
                a.mailsend,
                a.isactive,
                a.isdelete
            Into
                p_reportdate,
                p_yyyy,
                p_office,
                p_loc,
                p_costcode,
                p_incdate,
                p_inctime,
                p_inctype,
                p_inctypename,
                p_nature,
                p_naturename,
                p_injuredparts,
                p_empno,
                p_empname,
                p_desg,
                p_age,
                p_sex,
                p_subcontract,
                p_subcontractname,
                p_aid,
                p_description,
                p_causes,
                p_action,
                p_correctiveactions,
                p_closer,
                p_closerdate,
                p_attchmentlink,
                p_mailsend,
                p_isactive,
                p_isdelete
            from 
                hse_incidentreport a, 
                hse_incidenttype b,
                hse_naturetype c
            where 
                a.inctype = b.typeid and
                a.nature = c.natureid and
                trim(a.reportid) = trim(p_reportid);
                        
            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';

       exception
          when others then
             p_message_type := 'KO';
             p_message_text := 'ERR :- '
                               || sqlcode
                               || ' - '
                               || sqlerrm;
    end sp_incident_detail;
    
    function fn_get_injured_parts(
        p_reportid          varchar2
    ) return varchar2 as
        v_injured_parts     varchar2(500);
        i                   number := 0;
        cursor c1 is 
            select        
                b_head, b_neck, b_forearm, b_legs, b_face, b_shoulder,
                b_elbow, b_knee, b_mouth, b_chest, b_wrist, b_ankle, b_ear, 
                b_abdomen, b_hip, b_foot, b_eye, b_back, b_thigh, b_other 
            from 
                hse_incidentreport
            where 
                reportid = p_reportid;        
    begin
        for rec in c1
        loop
            exit when c1%notfound;
            -- dbms_output.put_line(' ---> '||rec.b_head);
            i := i + 1;
            if rec.b_abdomen = 1 then v_injured_parts := v_injured_parts||'Abdomen,'; end if; 
            if rec.b_ankle = 1 then v_injured_parts := v_injured_parts||'Ankle,'; end if; 
            if rec.b_back = 1 then v_injured_parts := v_injured_parts||'Back,'; end if;
            if rec.b_chest = 1 then v_injured_parts := v_injured_parts||'Chest,'; end if;
            if rec.b_ear = 1 then v_injured_parts := v_injured_parts||'Ear,'; end if;               
            if rec.b_elbow = 1 then v_injured_parts := v_injured_parts||'Elbow,'; end if;
            if rec.b_eye = 1 then v_injured_parts := v_injured_parts||'Eye,'; end if; 
            if rec.b_face = 1 then v_injured_parts := v_injured_parts||'Face,'; end if; 
            if rec.b_foot = 1 then v_injured_parts := v_injured_parts||'Foot,'; end if;
            if rec.b_forearm = 1 then v_injured_parts := v_injured_parts||'Forearm,'; end if; 
            if rec.b_head = 1 then v_injured_parts := v_injured_parts||'Head,'; end if;
            if rec.b_hip = 1 then v_injured_parts := v_injured_parts||'Hip,'; end if; 
            if rec.b_knee = 1 then v_injured_parts := v_injured_parts||'Knee,'; end if;
            if rec.b_legs = 1 then v_injured_parts := v_injured_parts||'Legs,'; end if;
            if rec.b_mouth = 1 then v_injured_parts := v_injured_parts||'Mouth,'; end if; 
            if rec.b_neck = 1 then v_injured_parts := v_injured_parts||'Neck,'; end if;             
            if rec.b_shoulder = 1 then v_injured_parts := v_injured_parts||'Shoulder,'; end if;               
            if rec.b_thigh = 1 then v_injured_parts := v_injured_parts||'Thigh,'; end if; 
            if rec.b_wrist = 1 then v_injured_parts := v_injured_parts||'Wrist,'; end if;
            if rec.b_other = 1 then v_injured_parts := v_injured_parts||'Other,'; end if; 
        end loop;        
        v_injured_parts := substr(v_injured_parts,1,length(v_injured_parts)-1);        
        return v_injured_parts;
      exception when others then       
        return null;
    end fn_get_injured_parts;
    
    function fn_email_list(
        p_person_id     varchar2,
        p_meta_id       varchar2,        
        p_reportid      varchar2
    ) return sys_refcursor as
        c sys_refcursor;
        v_empno        varchar2(5);
        e_employee_not_found    exception;
        Pragma exception_init(e_employee_not_found, -20001);
    begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        if v_empno = 'ERRRR' Then
            Raise e_employee_not_found;
            Return Null;
        end If;

        open c For
            select 
                role, 
                email 
            from 
                hse_email_address 
            where 
                isactive = 1
            union 
            select 
                'Head of Department' role, 
                b.email 
            from 
                ss_emplmast a,            
                ss_emplmast b
            where 
                b.empno = a.emp_hod and 
                a.empno = substr(trim(p_reportid),4,5);                   
        return c;
    end fn_email_list;    
    
    function fn_get_incident_status(             
        p_reportid      varchar2
    ) return varchar2 as        
        v_isactive      number := 0;
        v_isdelete      number := 0;
        v_status        varchar2(500) := '';
      begin        
        select 
            isactive, isdelete 
        Into 
            v_isactive, v_isdelete 
        from hse_incidentreport
        where trim(reportid) = trim(p_reportid);
        
        if v_isdelete = 0 and v_isactive = 0 then
            v_status := 'Closed';
        end if;
        if v_isdelete = 0 and v_isactive = 1 then
            v_status := 'In Process';
        end if;
        if v_isdelete = 1 then
            v_status := 'Deleted';
        end if;
        
        return v_status;        
    end  fn_get_incident_status;
    
    Function get_hse_suggestion(
        p_empno       Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        sysdate,
                        Row_Number() Over (Order By sysdate ) row_number,
                        Count(*) Over () total_row
                    From
                        (
                             select sysdate from dual
                        )
                 --   Where
                 --       start_date >= add_months(sysdate, - 24)
                 --   Order By app_date_4_sort Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End;    

    Function get_hse_suggestion_desk(
        p_empno       Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For
            Select
                *
            From
                (
                    Select
                        sysdate,
                        Row_Number() Over (Order By sysdate ) row_number,
                        Count(*) Over ()                                  total_row
                    From
                        (
                             select sysdate from dual
                        )
                 --   Where
                 --       start_date >= add_months(sysdate, - 24)
                 --   Order By app_date_4_sort Desc
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End;

    Function fn_hse_suggestion(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
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
        c       := get_hse_suggestion(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
  END fn_hse_suggestion;

    Function fn_hse_suggestion_desk(
        p_person_id   Varchar2,
        p_meta_id     Varchar2,
        p_start_date  Date,
        p_end_date    Date,
        p_row_number  Number,
        p_page_length Number
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
        c       := get_hse_suggestion_desk(v_empno, p_start_date, p_end_date, p_row_number, p_page_length);
        Return c;
  END fn_hse_suggestion_desk;

END IOT_HSE_QRY;


/
