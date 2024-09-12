--------------------------------------------------------
--  DDL for Function DELETE_DATEWISE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TIMECURR"."DELETE_DATEWISE" (p_projno varchar2,p_yymm, p_user varchar2) return number as
   v_desc VARCHAR2(100);
    v_count number(1);
    v_cntprojmast number(1);
    v_cntbudgmast number(1);
    v_cntprjcmast number(1);
    
    v_APPROVED_AMFI number(1);
    v_APPDT_AMFI date;
    v_amfi_empno varchar2(5);
    
    v_APPROVED_DIROP number(1);
    v_appdt_dirop date;
    v_dirop_empno varchar2(5);
    
    v_approved_vpdir number(1);
    v_appdt_vpdir date;
    v_dirvp_empno varchar2(5);
    
    v_pm_empno varchar2(5);
    p_desc varchar2(50);
    
begin  
   p_desc := '';
   if p_projno is not null then --and p_projno in (select projno from jobmaster  WHERE PROJNO = P_PROJNO ) then
     -- SELECT COUNT(*) INTO v_Count  FROM JOBMASTER WHERE PROJNO = P_PROJNO;
    --  SELECT APPROVED_AMFI,APPDT_AMFI, amfi_empno, APPROVED_DIROP , appdt_dirop ,dirop_empno , approved_vpdir ,appdt_vpdir ,dirvp_empno into v_APPROVED_AMFI,v_APPDT_AMFI, v_amfi_empno, v_APPROVED_DIROP , v_appdt_dirop ,v_dirop_empno , v_approved_vpdir ,v_appdt_vpdir ,v_dirvp_empno FROM JOBMASTER WHERE PROJNO = P_PROJNO;
      SELECT projno FROM projmast WHERE PROJNO = P_PROJNO;
      begin
 --     if v_count > 0 then
     --    if  nvl(v_APPROVED_AMFI,0) = 0 and nvl(v_APPDT_AMFI,'') = '' and nvl(v_amfi_empno,'') = '' then
           if  p_yymm is not null  then
             --if  nvl(v_APPROVED_DIROP,0)=0  and   nvl(v_appdt_dirop,'') = '' and  nvl(v_dirop_empno,'') = '' then
               if  p_user is not null then then
                  SELECT empno FROM emplmast WHERE EMPNO = P_USER AND STATUS = 1;
                      select count(*) into v_cnt from  DATEWISE_TIMESHEET where PROJNO = chr(39) || p_projno || chr(39)  AND YYMM =   CHR(39) ||P_YYMM || CHR(39); 
                         delete from DATEWISE_TIMESHEET where projno = p_projno AND YYMM = P_YYMM;
                        
                         insert into DATEWISE_history (projno,YYMM,empno,MODIFIED_ON) values (p_projno,P_YYMM,p_user,sysdate);
                         commit;
                          p_desc := 'Successfully deleted DATEWISE FOR PROJECT AND YYMM ' || P_PROJNO || ' YYMM   - ' || P_YYMM;   
                          RETURN 1;
                       else
                          p_desc := 'This is not in opening mode , Records exist in Project Master';   
                          RETURN 8;
                       
                      end if ;
                     
                    --   commit;
                 else
                    p_desc := 'Job Sponsors Approval Done Cannot delete Budget';
                    RETURN 2;
                 end if ;
              else
                 p_desc := 'CMDs Approval Done Cannot delete Budget';
                    RETURN 3;
              end if ;
         else
             p_desc := 'AFC Approval Done Cannot delete Budget';
                RETURN 4;
         end if ;
--       else
--         p_desc := 'Project Number Not Available in Job Master';      
--       end if;
     
       exception   
    
   when no_data_found then
        p_desc := 'exception Data Not Found Project Number Not Available in Job Master';
        return 6;
  --  when others then
  --    p_desc := 'some other exception ';
   --     return 7;
          end;  
   else
      p_desc := 'Project Number should Not be empty';      
         RETURN 5;
    
   end if;   
    --  return p_desc;
--exception   
 --  when no_data_found then
  --      p_desc := 'exception Data Not Found Project Number Not Available in Job Master';
   --     return 6;
  --  when others then
   --   p_desc := 'some other exception ';
   --     return 7;
end;

/
