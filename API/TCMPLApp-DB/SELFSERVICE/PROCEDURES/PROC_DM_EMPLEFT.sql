--------------------------------------------------------
--  DDL for Procedure PROC_DM_EMPLEFT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SELFSERVICE"."PROC_DM_EMPLEFT" 
  ( p_reqby in varchar2,
    p_empno in varchar2,
    p_dol in date,    
    p_msg_type out number,
    p_msg out varchar2
  ) as 
  
  cursor cur_sec is select email from ss_emplmast where empno in (select empno from dm_secretary 
    where costcode = (select assign from ss_emplmast where empno = p_empno));
  cursor cur_idcord is select email from dm_emailid
    where name = 'ITCORD' and active = 1;
  vTransUID char(11);
  vDoL Date;
  vSecMail varchar2(50);
  vHoDMail varchar2(50);
  vITCordMail varchar2(200);
  vFromUser varchar2(50);
  vToUser varchar2(50);
  vCCUser varchar2(200);
  vMailSubject varchar2(1000);
  vMailBody varchar2(2000);
begin
  vTransUID := desk.GetDMUid(1);
  vDoL := to_date(p_dol,'dd-mm-yyyy');
  /*-- Sender Email --*/
  select email into vFromUser from ss_emplmast where empno = p_reqby;
  --vFromUser := 'u.bhavsar@ticb.com';
  vToUser := 'helpdeskIT@ticb.com';
  /*-- HoD Email --*/
  select email into vHoDMail from ss_emplmast where empno in (select hod from ss_costmast 
  where costcode = (select assign from ss_emplmast where empno = p_empno));
  /*-- Secreatry Email --*/
  vSecMail := '';
  for c1 in cur_sec loop            
      if c1.email is not Null then
        if length(vSecMail) > 0 then
          vSecMail := vSecMail || ';' || c1.email;
        else
          vSecMail := c1.email;
        end if;        
      end if;
  end loop;  
  /*-- ITCord Email --*/
  vITCordMail := '';  
  for c2 in cur_idcord loop          
      if c2.email is not Null then
        if length(vITCordMail) > 0 then
          vITCordMail := vITCordMail || ';' || c2.email;
        else
          vITCordMail := c2.email;
        end if;        
      end if;
  end loop;
  vCCUser := '';
  if length(vHoDMail) > 0 then
    if length(vCCUser) > 0 then
      vCCUser := vCCUser || ';' || vHoDMail;
    else
      vCCUser := vHoDMail;
    end if;
  end if;  
  if length(vSecMail) > 0 then
    if length(vCCUser) > 0 then
      vCCUser := vCCUser || ';' || vSecMail;
    else
      vCCUser := vSecMail;
    end if;
  end if;
  if length(vITCordMail) > 0 then
    if length(vCCUser) > 0 then
      vCCUser := vCCUser || ';' || vITCordMail;
    else
      vCCUser := vITCordMail;
    end if;
  end if;
  vMailSubject := ' Employee No. ' || p_empno || '  is leaving on ' || vDoL ;                  
  vMailBody := ' Employee No. ' || p_empno || '  is leaving on ' || vDoL ||
               chr(13) || chr(10)  || chr(13) || chr(10) || 
               'Note : This is a system generated message.'
               || chr(13) || chr(10) || chr(13) || chr(10)
               || 'Please do not reply to this message';

  insert into dm_emp_left(reqnum,reqdate,reqby,empno,dol)
    values(vTransUID,sysdate,p_reqby,p_empno,to_date(vDoL,'dd-mm-yy'));
  commit;
  vMailBody := vMailBody || ' ' || vCCUser;  
  --desk_mail.send_mail('u.bhavsar@ticb.com',vFromUser,'',vMailSubject,vMailBody);
  desk_mail.send_mail(vToUser,vFromUser,vCCUser,vMailSubject,vMailBody);
  p_msg_type := 1;
  p_msg := 'Sucessfully Updated';
exception
  when others then
    p_msg_type := -1;
    p_msg := 'Error - ' || sqlcode || sqlerrm;
end proc_dm_empleft;


/
