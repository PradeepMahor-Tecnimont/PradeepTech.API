create or replace package body iot_hse as
    
    procedure sp_add_incident (
        p_person_id         varchar2,
        p_meta_id           varchar2,        
        p_office            varchar2,
        p_loc               varchar2,
        p_costcode          varchar2,
        p_incdate           date,
        p_inctime           varchar2,
        p_inctype           varchar2,
        p_nature            varchar2,
        p_b_head            number,
        p_b_neck            number,
        p_b_forearm         number,
        p_b_legs            number,
        p_b_face            number,
        p_b_shoulder        number,
        p_b_elbow           number,
        p_b_knee            number,
        p_b_mouth           number,
        p_b_chest           number,
        p_b_wrist           number,
        p_b_ankle           number,
        p_b_ear             number,
        p_b_abdomen         number,
        p_b_hip             number,
        p_b_foot            number,
        p_b_eye             number,
        p_b_back            number,
        p_b_thigh           number,
        p_b_other           number,
        p_empno             varchar2,
        p_empname           varchar2,
        p_desg              varchar2,
        p_age               varchar2,
        p_sex               varchar2,
        p_subcontract       varchar2,
        p_subcontractname   varchar2 default '',
        p_aid               varchar2,
        p_description       varchar2,
        p_causes            varchar2,
        p_action            varchar2,
        p_message_type      out         varchar2,
        p_message_text      out         varchar2
    ) as
        v_reportid          varchar2(16); 
        v_empno             varchar2(5);
        v_new_counter       varchar2(2);
        v_new_id            varchar2(16);
        v_str_temp          varchar2(3);
        v_yyyy              varchar2(7);
    begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        
        if v_empno = 'ERRRR' then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            return;
        end if;
        
        select 
            nvl(max(to_number(substr(trim(reportid),length(reportid)-1,2))) + 1,0) into v_new_id
        from 
            hse_incidentReport
        where 
            substr(trim(reportid),4,5) = v_empno ;
        
        v_str_temp := '0' || v_new_id;
        select 'IPR'||v_empno||to_char(sysdate,'ddmmyy')||substr(v_str_temp,length(v_str_temp) -1,2) into v_new_id from dual;
        
        select extract (year from add_months (sysdate, -3)) || '-'
            || substr(extract (year from add_months (sysdate, 9)), length(extract (year from add_months (sysdate, 9))) -1, 2)
        into
            v_yyyy
        from dual;

        insert into hse_incidentreport
            (
                reportid, reportdate, yyyy, office, loc, costcode, incdate, inctime, inctype, nature,
                b_head, b_neck, b_forearm, b_legs, b_face, b_shoulder, b_elbow, b_knee, b_mouth,
                b_chest, b_wrist, b_ankle, b_ear, b_abdomen, b_hip, b_foot, b_eye, b_back,
                b_thigh, b_other, empno, empname, desg, age, sex, subcontract, subcontractname,
                aid, description, causes, action
            )
            values
            (
                v_new_id, sysdate, v_yyyy, p_office, p_loc, p_costcode, p_incdate, p_inctime, p_inctype, p_nature, 
                p_b_head, p_b_neck, p_b_forearm, p_b_legs, p_b_face, p_b_shoulder, p_b_elbow, p_b_knee, p_b_mouth, 
                p_b_chest, p_b_wrist, p_b_ankle, p_b_ear, p_b_abdomen, p_b_hip, p_b_foot, p_b_eye, p_b_back, 
                p_b_thigh, p_b_other, p_empno, p_empname, p_desg, p_age, p_sex, p_subcontract, trim(p_subcontractname), 
                p_aid, p_description, p_causes, p_action
            );
            
        commit;
        
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

       exception
          when others then
             p_message_type := 'KO';
             p_message_text := 'ERR :- '
                               || sqlcode
                               || ' - '
                               || sqlerrm;
    end sp_add_incident;
    
    procedure sp_delete_incident (
        p_person_id         varchar2,
        p_meta_id           varchar2,        
        p_reportid            varchar2,        
        p_message_type      out         varchar2,
        p_message_text      out         varchar2
    ) as 
        v_empno             varchar2(5);
    begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        
        if v_empno = 'ERRRR' then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            return;
        end if;
        
        update hse_incidentreport
        set isdelete = 1,
        isactive = 0
        where reportid = p_reportid;
	
        commit;
        
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

       exception
          when others then
             p_message_type := 'KO';
             p_message_text := 'ERR :- '
                               || sqlcode
                               || ' - '
                               || sqlerrm;
    end sp_delete_incident;
    
    procedure sp_close_incident (
        p_person_id             varchar2,
        p_meta_id               varchar2,        
        p_reportid              varchar2,
        p_correctiveactions     varchar2,
        p_closer                varchar2,
        p_closerdate            Date,
        p_attchmentlink         varchar2,  
        p_message_type      out         varchar2,
        p_message_text      out         varchar2
    ) as 
        v_empno             varchar2(5);
     begin
        v_empno        := get_empno_from_meta_id(p_meta_id);
        
        if v_empno = 'ERRRR' then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            return;
        end if;
        
        update hse_incidentreport
        set isactive = 0,
            correctiveactions = trim(p_correctiveactions),
            closer = trim(p_closer),
            closerdate = trim(p_closerdate),
            attchmentlink = trim(p_attchmentlink),
            closedby = v_empno,
            closedon = sysdate
        where reportid = p_reportid;
	
        commit;
        
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

       exception
          when others then
             p_message_type := 'KO';
             p_message_text := 'ERR :- '
                               || sqlcode
                               || ' - '
                               || sqlerrm;
    end sp_close_incident;
    
    procedure sp_mail_send (
        p_person_id         varchar2,
        p_meta_id           varchar2,        
        p_reportid          varchar2,        
        p_recipients        varchar2,
        p_message_type      out         varchar2,
        p_message_text      out         varchar2
    ) as        
        v_subject         Varchar2(1000);
        v_msg_body        Varchar2(4000);
        v_success         Varchar2(1000);
        v_message         Varchar2(500);
        cursor c1 is 
            select        
                a.reportdate, a.yyyy, a.office, a.loc, a.costcode, a.incdate,
                a.inctime, a.inctype, b.typename, a.nature, c.naturename,
                iot_hse_qry.fn_get_injured_parts(a.reportid) injured_parts,
                a.empno, a.empname, a.desg, a.age, a.subcontract,
                case when a.sex = 'F' then 'Female' else 'Male' end sex, 
                a.subcontractname, a.aid, a.description, a.causes, a.action,
                a.mailsend, a.isactive  
            from                 
                hse_incidentreport a, 
                hse_incidenttype b,
                hse_naturetype c
            where 
                a.inctype = b.typeid and
                a.nature = c.natureid and
                trim(a.reportid) = trim(p_reportid);
      begin        
        for rec in c1
        loop
            exit when c1%notfound;            
            v_msg_body := '<p>Dear Sir</p>,
                        <p>Please find herewith the details of Incident Preliminary Report.</p>
                        <table style="border-collapse: collapse;width:75%; max-width:500px;" border="1">
                        <tbody>
                        <tr><td>01. Head Office Location</td>                           <td>: '|| rec.office ||' </td></tr> 
                        <tr><td>02. Department of Injured person</td>                   <td>: '|| rec.costcode ||' </td></tr> 
                        <tr><td>03. Location where incident occurred</td>               <td>: '|| rec.loc ||' </td></tr> 
                        <tr><td>04. Date and Time of incident</td>                      <td>: '|| rec.incdate ||' at ' || rec.inctime || ' hrs </td></tr> 
                        <tr><td>05. Type of accident/incident</td>                      <td>: '|| rec.typename ||' </td></tr>
                        <tr><td>06. Nature of injury</td>                               <td>: '|| rec.naturename ||' </td></tr>
                        <tr><td>07. Body part injured</td>                              <td>: '|| rec.injured_parts ||' </td></tr>
                        <tr><td>08. Details of injured person<br/> 
                                    (For incidents causing injury to person / persons)</td>          <td>Employee No. -  '|| rec.empno   || ' <br/> 
                                                                                                         Name -          '|| rec.empname || ' <br/>  
                                                                                                         Designation -   '|| rec.desg    || ' <br/>
                                                                                                         Age -           '|| rec.age     || ' <br/>
                                                                                                         Sex -           '|| rec.sex     || ' <br/> </td></tr>
                        <tr><td>09. Name of Sub-contractor</td>                         <td>: '|| rec.subcontractname   || '</td></tr>    
                        <tr><td>10. Referred Medical Aid</td>                           <td>: '|| rec.aid   || '</td></tr>
                        <tr><td>11. Brief Description of the accident / incident</td>   <td>: '|| rec.description   || '</td></tr>
                        <tr><td>12. Probable Causes</td>                                <td>: '|| rec.causes   || '</td></tr>
                        <tr><td>13. Immediate Action</td>                               <td>: '|| rec.action   || '</td></tr>
                        </tbody>
                        </table>';
        end loop; 
        --dbms_output.put_line(' ---> '||v_msg_body); 
        v_subject     := 'HSE : Incident Preliminary Report';        
        tcmpl_app_config.pkg_app_mail_queue.sp_add_to_queue(
                p_person_id    => Null,
                p_meta_id      => Null,
                p_mail_to      => p_recipients,
                p_mail_cc      => Null,
                p_mail_bcc     => Null,
                p_mail_subject => v_subject,
                p_mail_body1   => v_msg_body,
                p_mail_body2   => Null,
                p_mail_type    => 'HTML',
                p_mail_from    => 'SWP',
                p_message_type => v_success,
                p_message_text => v_message
            );
            
        update hse_incidentreport
            set mailsend = 1
            where reportid = p_reportid;
        
        insert into hse_mailsend(reportid, recipients, mailtime)
        values(p_reportid, p_recipients, sysdate);
        
        commit;
        
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

       exception
          when others then
             p_message_type := 'KO';
             p_message_text := 'ERR :- '
                               || sqlcode
                               || ' - '
                               || sqlerrm;
    end sp_mail_send;
end iot_hse;