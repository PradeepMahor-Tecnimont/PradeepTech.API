--------------------------------------------------------
--  DDL for Procedure GET_OT_DATA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "GET_OT_DATA" as 
    v_start_date date := '1-MAR-2013';
    v_end_date date := '28-FEB-2014';
    cursor cur_emp is select empno, name, parent,
        greatest(doj, v_start_date) as doj,
        least(nvl(dol,v_end_date),v_end_date) dol from ss_emplmast 
      where 
        nvl(dol,v_end_date) >= v_start_date 
        and doj <= v_end_date and emptype ='R'
        and parent not in ('0225','0221','0217')
        order by empno ;
        -- 0217, 0221, 0225
    /*
      cursor cur_days(P_Date date, p_empno varchar2) is 
      select d_date, get_holiday(d_date) holiday, getshift1(p_empno,d_date) from ss_days_details 
        where d_date between P_date and '31-MAR-2014'
        and PUNCHCOUNT(p_empno,d_date) > 1
        order by d_date;
    */
begin
    for emp_row in cur_emp loop
        begin
            
            insert into SS_OT_DETAILS_4_YEAR_ALL_rest (empno,d_date,ot_hrs,holiday) 
            (
            select
              emp_row.empno,
              d_date,
              case get_holiday(d_date)
                when 0 then
                  N_DeltaHrs(emp_row.empno,d_date,getshift1(emp_row.empno,d_date),
                      PenaltyLeave1( LateCome1(emp_row.empno,D_Date), EarlyGo1(emp_row.empno,D_Date), IsLastWorkDay1(emp_row.empno,D_Date) , SUM(IsLComeEGoApp(emp_row.empno,D_Date)) Over (Partition BY Wk_Of_Year Order by D_Date Range BETWEEN unbounded preceding AND CURRENT row) , N_SUM_SLAPP_COUNT(emp_row.empno,D_Date), IsLComeEGoApp(emp_row.empno,D_Date) , IsSLeaveApp(emp_row.empno,D_Date) ) 
                      )
                  else
                    N_WorkedHrs(emp_row.empno,D_Date, GetShift1(emp_row.empno,D_Date))
                  end as OT,
                get_holiday(d_date) as holiday
              
              from ss_days_details where d_date between emp_row.doj and emp_row.dol
              );
              commit;
              delete from SS_OT_DETAILS_4_YEAR_ALL_rest where ot_hrs < 60;
              commit;
        end;
    end loop;
end get_ot_data;

/
