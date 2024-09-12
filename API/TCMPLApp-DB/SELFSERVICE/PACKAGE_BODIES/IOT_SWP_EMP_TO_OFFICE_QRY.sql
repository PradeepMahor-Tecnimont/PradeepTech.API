create or replace package body "IOT_SWP_EMP_TO_OFFICE_QRY" as

   function fn_Emp_Coming_To_Office_list(
      p_person_id      varchar2,
      p_meta_id        varchar2,

      p_generic_search varchar2 default null,
      p_start_date     date     default null,
      P_Activefuture   number  default null,
      
      p_row_number     number,
      p_page_length    number
   ) return sys_refcursor as
      P_PLAN_START_DATE    date;
      P_PLAN_END_DATE      date;
      P_CURR_START_DATE    date;
      P_CURR_END_DATE      date;
      P_PLANNING_EXISTS    varchar2(200);
      P_PWS_OPEN           varchar2(200);
      P_SWS_OPEN           varchar2(200);
      P_OWS_OPEN           varchar2(200);
      P_MESSAGE_TYPE       varchar2(200);
      P_MESSAGE_TEXT       varchar2(200);
      v_empno              varchar2(5);
      e_employee_not_found exception;
      pragma exception_init(e_employee_not_found, -20001);
      c                    sys_refcursor;
   begin

      v_empno := get_empno_from_meta_id(p_meta_id);
      if v_empno = 'ERRRR' then
         raise e_employee_not_found;
         return null;
      end if;

      IOT_SWP_COMMON.GET_PLANNING_WEEK_DETAILS(
         P_PERSON_ID       => P_PERSON_ID,
         P_META_ID         => P_META_ID,
         P_PLAN_START_DATE => P_PLAN_START_DATE,
         P_PLAN_END_DATE   => P_PLAN_END_DATE,
         P_CURR_START_DATE => P_CURR_START_DATE,
         P_CURR_END_DATE   => P_CURR_END_DATE,
         P_PLANNING_EXISTS => P_PLANNING_EXISTS,
         P_PWS_OPEN        => P_PWS_OPEN,
         P_SWS_OPEN        => P_SWS_OPEN,
         P_OWS_OPEN        => P_OWS_OPEN,
         P_MESSAGE_TYPE    => P_MESSAGE_TYPE,
         P_MESSAGE_TEXT    => P_MESSAGE_TEXT
      );

      if (P_MESSAGE_TYPE = 'KO') then
         return null;
      end if;

      open c for
           select * from (
           /*
           select Key_id , Empno , Employee_Name ,to_char(P_CURR_START_DATE, 'dd-Mon-yyyy') as Curr_Pws_Date,curr_pws ,Curr_desk ,
                  future_pws , to_char(START_DATE, 'dd-Mon-yyyy') As Future_Pws_Date ,
                  Start_Date For_Order,  Desk_Id , Modified_by , Modified_on_date ,
                  row_number() over (order by Empno desc) As row_number, emp_assign , emp_parent, 
                  count(*) over () As total_row 
           from (
                    select A.Key_Id as Key_id,
                          A.Empno as Empno,
                          get_emp_name(A.Empno) as Employee_Name, 
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,P_CURR_END_DATE)) As curr_pws,
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,A.Start_Date)) As future_pws,
                          iot_swp_common.get_desk_from_dms(A.Empno) As Curr_desk, 
                          b.assign As emp_assign , b.parent As emp_parent, 
                          A.Start_Date  as Start_Date,
                          null as Desk_Id,
                          case
                             when A.MODIFIED_BY = 'Sys' then
                                'System'
                             else
                                A.MODIFIED_BY
                                || ' - '
                                || get_emp_name(A.MODIFIED_BY)
                          end as Modified_by,
                          to_char(A.MODIFIED_ON, 'dd-Mon-yyyy') as Modified_on_date 
                     from Swp_Primary_Workspace A , SS_emplmast b
                    where  A.PRIMARY_WORKSPACE = nvl(P_Activefuture,A.PRIMARY_WORKSPACE)
                        and  A.Start_Date >= nvl(P_PLAN_START_DATE,sysdate) 
                        and  b.empno=a.empno
                        and a.empno not in (select empno from SWP_TEMP_DESK_ALLOCATION )
                  union    
                      select '' as Key_id,
                          A.Empno as Empno,
                          get_emp_name(A.Empno) as Employee_Name, 
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,P_CURR_END_DATE)) As curr_pws,
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,A.Start_Date)) As future_pws,
                          iot_swp_common.get_desk_from_dms(A.Empno) As Curr_desk,           
                          A.Start_Date  as Start_Date, 
                          a.DESKID as Desk_Id,
                          '' as Modified_by,
                          '' as Modified_on_date 
                     from SWP_TEMP_DESK_ALLOCATION A
                    where  A.Start_Date >= nvl(P_PLAN_START_DATE, sysdate)                     
                )*/
                select SWP_temp.Key_id , SWP_temp.Empno , SWP_temp.Employee_Name ,to_char(P_CURR_START_DATE, 'dd-Mon-yyyy') as Curr_Pws_Date,
                  SWP_temp.curr_pws ,SWP_temp.Curr_desk ,SWP_temp.pws_val ,
                  SWP_temp.future_pws , to_char(SWP_temp.START_DATE, 'dd-Mon-yyyy') As Future_Pws_Date ,
                  (select  b.assign from SS_emplmast b where to_char(b.empno) = to_char(SWP_temp.empno))As assign , 
                  (select  b.parent from SS_emplmast b where to_char(b.empno) = to_char(SWP_temp.empno))As parent , 
                  --to_char(b.assign) As assign , 
                  --to_char(b.parent) As parent, 
                  SWP_temp.Start_Date For_Order,  SWP_temp.Desk_Id , SWP_temp.Modified_by , SWP_temp.Modified_on_date ,
                  row_number() over (order by SWP_temp.Empno desc) As row_number, 
                  count(*) over () As total_row 
           from (
                    select A.Key_Id as Key_id,
                          A.Empno as Empno,
                          get_emp_name(A.Empno) as Employee_Name, 
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,P_CURR_END_DATE)) As curr_pws,
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,A.Start_Date)) As future_pws,
                          iot_swp_common.get_desk_from_dms(A.Empno) As Curr_desk,                           
                          A.Start_Date  as Start_Date,
                          A.PRIMARY_WORKSPACE as pws_val,
                          null as Desk_Id,
                          case
                             when A.MODIFIED_BY = 'Sys' then
                                'System'
                             else
                                A.MODIFIED_BY
                                || ' - '
                                || get_emp_name(A.MODIFIED_BY)
                          end as Modified_by,
                          to_char(A.MODIFIED_ON, 'dd-Mon-yyyy') as Modified_on_date 
                     from Swp_Primary_Workspace A 
                    where  A.PRIMARY_WORKSPACE = nvl(P_Activefuture,A.PRIMARY_WORKSPACE)
                        and  A.Start_Date >= nvl(P_PLAN_START_DATE,sysdate)                        
                        and a.empno not in (select empno from SWP_TEMP_DESK_ALLOCATION )
                  union    
                      select '' as Key_id,
                          A.Empno as Empno,
                          get_emp_name(A.Empno) as Employee_Name, 
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,P_CURR_END_DATE)) As curr_pws,
                          iot_swp_common.fn_get_pws_text(iot_swp_common.fn_get_emp_pws(A.Empno,A.Start_Date)) As future_pws,
                          iot_swp_common.get_desk_from_dms(A.Empno) As Curr_desk,           
                          A.Start_Date  as Start_Date,   
                          A.PRIMARY_WORKSPACE as pws_val,
                          a.DESKID as Desk_Id,
                          '' as Modified_by,
                          '' as Modified_on_date 
                     from SWP_TEMP_DESK_ALLOCATION A  
                    where  A.Start_Date >= nvl(P_PLAN_START_DATE, sysdate)
                     and A.PRIMARY_WORKSPACE = nvl(P_Activefuture,A.PRIMARY_WORKSPACE)
                            
                ) SWP_temp 
                where SWP_temp.pws_val  = nvl(P_Activefuture,SWP_temp.pws_val)
         )
          where row_number between (nvl(p_row_number, 0) + 1) and (nvl(p_row_number, 0) + p_page_length)
           order by future_pws ;
           
      return c;

   end;

end IOT_SWP_EMP_TO_OFFICE_QRY;

/

  GRANT EXECUTE ON "SELFSERVICE"."IOT_SWP_EMP_TO_OFFICE_QRY" TO "TCMPL_APP_CONFIG";
