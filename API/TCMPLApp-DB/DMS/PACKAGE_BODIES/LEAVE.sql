--------------------------------------------------------
--  DDL for Package Body LEAVE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "LEAVE" 
AS
    /*PROCEDURE validate_cl_nu(
        param_empno VARCHAR2,
        param_bdate DATE,
        param_edate DATE,
        param_half_day_on NUMBER,
        param_leave_period out number,
        param_msg_type OUT NUMBER,
        param_msg OUT VARCHAR2);*/
    function Get_Date_4_continuous_Leave(param_empno varchar2,param_date date, param_leave_type varchar2, param_forward_reverse VARCHAR2) return date;
    function check_co_with_adjacent_leave(param_empno varchar2, param_date date, param_forward_reverse varchar2) return number ;
    
    function validate_spc_co_spc(param_empno varchar2, param_bdate date, param_edate date, param_half_day_on number) return number;
    function get_continuous_cl_sum (
        param_empno VARCHAR2,
        param_date DATE,
        param_reverse_forward varchar2
        ) 
    return number ;
    function get_continuous_sl_sum (
        param_empno VARCHAR2,
        param_date DATE,
        param_reverse_forward varchar2
        ) return number;
        
    --function validate_co_spc_co(param_empno varchar2, param_bdate date, param_edate date) return number ;
    function validate_co_spc_co(param_empno varchar2, param_bdate date, param_edate date, param_half_day_on number ) return number;
    function validate_cl_sl_co(
          param_empno VARCHAR2,
          param_bdate DATE,
          param_edate DATE,
          param_half_day_on NUMBER,
          param_leave_type varchar2) return number ;

    function get_continuous_leave_sum (
        param_empno VARCHAR2,
        param_date DATE,
        param_leave_type varchar2,
        param_reverse_forward varchar2) 
    return number ;
    function check_pl_combination(param_empno in varchar2, param_leave_type varchar2, param_bdate date, param_edate date, param_app_no varchar2 default ' ' ) return number;
    /*
  function calc_leave_period ( 
        param_bdate date, 
        param_edate date,
        param_leave_type varchar2,
        param_half_day_on number
        ) return number ;
    
    /*function validate_cl_sl_co
    (
      param_empno VARCHAR2,
      param_bdate DATE,
      param_edate DATE,
      param_half_day_on NUMBER,
      param_leave_type varchar2
    ) return number ;
*/
    PROCEDURE validate_pl(
          param_empno VARCHAR2,
          param_bdate DATE,
          param_edate DATE,
          param_half_day_on NUMBER DEFAULT half_day_on_none,
          param_app_no      VARCHAR2 DEFAULT ' ',
          param_leave_period out number,
          param_msg_type OUT NUMBER,
          param_msg OUT VARCHAR2)
    AS
          v_leave_period number;
          v_minimum_days number;
          v_failure_number number := 0;
          v_pl_combined number;
          v_co_spc_co number;
          v_spc_co_spc number;
    BEGIN
    
    
          param_msg_type              := ss.success;
          
          --Cannot avail leave on holiday.
          IF CheckHoliday(param_bdate) > 0 OR CheckHoliday(param_edate) > 0 THEN
              v_failure_number          := v_failure_number + 1;
              param_msg_type            := ss.failure;
              param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Cannot avail leave on holiday. ';
          END IF;
    
          --PL cannot be less then 4 days.
          v_minimum_days  := 4;

          v_leave_period := calc_leave_period(param_bdate,param_edate,'PL',param_half_day_on);

          param_leave_period := v_leave_period;          
          If v_leave_period < v_minimum_days Then
              v_failure_number          := v_failure_number + 1;
              param_msg_type            := ss.failure;
              param_msg                 := param_msg || To_Char(v_failure_Number) || ' - PL cannot be less then 4 days. ';
          End If;
          
    
          --Check PL Combined with other Leave
          v_pl_combined := check_pl_combination (param_empno,'PL',param_bdate, param_edate,param_app_no);
          if v_pl_combined = leave_combined_with_none then
              return;
          end if;
          If v_pl_combined = leave_combined_with_csp Then
              v_failure_number          := v_failure_number + 1;
              param_msg_type            := ss.failure;
              param_msg                 := param_msg || To_Char(v_failure_Number) || ' - PL and CL/PL/SL cannot be availed together. ';
          elsif v_pl_combined = leave_combined_over_lap then
              v_failure_number := v_failure_number + 1;
              param_msg_type            := ss.failure;
              param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Leave has already been availed on same day. ';
          End If;

          v_co_spc_co := validate_co_spc_co(param_empno, param_bdate, param_edate, param_half_day_on);
          If v_co_spc_co = ss.failure Then
              v_failure_number          := v_failure_number + 1;
              param_msg_type            := ss.failure;
              param_msg                 := param_msg || To_Char(v_failure_Number) || ' - PL cannot be availed with trailing and preceding CO - CO-PL-CO. ';
          end If;
          
          
          v_spc_co_spc := validate_spc_co_spc(param_empno, param_bdate, param_edate, param_half_day_on);
          if v_spc_co_spc = ss.failure then
              v_failure_number          := v_failure_number + 1;
              param_msg_type            := ss.failure;
              param_msg                 := param_msg || To_Char(v_failure_Number) || ' - PL cannot be availed when trailing and preceding to CO. "CL-SL-PL  -CO-  CL-SL-PL"';
          end if;


    END validate_pl;

   

    function check_pl_combination(
          param_empno in varchar2, 
          param_leave_type varchar2,
          param_bdate date, 
          param_edate date,
          param_app_no varchar2 default ' ' ) return number
    is
          v_count number;
          v_next_work_date date;
          v_prev_work_date date;
    begin
          --Check Overlap
          Select count(*) Into v_count From ss_leave_app_ledg
            Where empno = param_empno  And
            (param_bdate Between bdate And edate Or param_edate Between bdate And edate)
            and app_no <> nvl(param_app_no,' ');
          if v_count > 0 Then
             return leave_combined_over_lap;
          End If;
          --Check Overlap
          
          --Check CL/SL/PL Combination
          v_prev_work_date := getlastworkingday(param_bdate,'-');
          v_next_work_date := getlastworkingday(param_edate,'+');
          
          
          Select count(*) Into v_count From ss_leave_app_ledg
            Where empno = param_empno  And
            (trunc(v_prev_work_date) Between bdate And edate Or trunc(v_next_work_date) Between bdate And edate ) 
            and leavetype not in ('CO') 
            and app_no <> nvl(param_app_no,' ');
          if v_count > 0 Then
              return leave_combined_with_csp;
          End If;
          --Check CL/SL/PL Combination
          
    
          --Check CO Combination
          declare  
              v_prev_co_count number;
              v_next_co_count number;
          begin
              Select count(*) Into v_prev_co_count From ss_leave_app_ledg
                Where empno = param_empno  And
                (trunc(v_prev_work_date) Between bdate And edate ) 
                and leavetype = 'CO' and app_no <> nvl(param_app_no,' ');
              
              Select count(*) Into v_next_co_count From ss_leave_app_ledg
                Where empno = param_empno  And
                (trunc(v_next_work_date) Between bdate And edate ) 
                and leavetype = 'CO' and app_no <> nvl(param_app_no,' '); 
              
              if v_prev_co_count > 0 Or v_next_co_count > 0 Then
                  return leave_combined_with_co;
              else
                  return leave_combined_with_none;
              end if;
          end;
          --Check CO Combination
    end check_pl_combination;


    

    procedure validate_sl(
        param_empno             VARCHAR2,
        param_bdate             DATE,
        param_edate             DATE,
        param_half_day_on       NUMBER,
        param_leave_period  OUT NUMBER,
        param_msg_type      OUT NUMBER,
        param_msg           OUT VARCHAR2) 
    as

        v_minimum_days number;
        v_failure_number number := 0;
        v_sl_combined number;
        v_co_spc_co number ;
        v_cumu_sl number;
        v_max_days number := 3;
        v_leave_period number;
        v_bdate date;
        v_edate date;
        v_spc_co_spc number;
        v_co_combined number;
    begin
    
        param_msg_type              := ss.success;
        
      --Cannot avail leave on holiday.
        IF CheckHoliday(param_bdate) > 0 OR CheckHoliday(param_edate) > 0 THEN
            v_failure_number := v_failure_number + 1;
            param_msg_type            := ss.failure;
            param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Cannot avail leave on holiday. ';
        END IF;
        
        param_leave_period := calc_leave_period(param_bdate,param_edate,'SL',param_half_day_on);
        v_leave_period := param_leave_period;
        v_sl_combined := validate_cl_sl_co(param_empno , param_bdate , param_edate ,param_half_day_on , 'SL');
  
        If v_sl_combined = leave_combined_with_csp Then
            v_failure_number := v_failure_number + 1;
            param_msg_type            := ss.failure;
            param_msg                 := param_msg || To_Char(v_failure_Number) || ' - SL and CL/PL/SL cannot be availed together. ';
        elsif v_sl_combined = leave_combined_over_lap then
            v_failure_number := v_failure_number + 1;
            param_msg_type            := ss.failure;
            param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Leave has already been availed on same day. ';
        End If;

        if param_half_day_on in (hd_bdate_presnt_part_2 ,half_day_on_none) then
            v_cumu_sl := get_continuous_sl_sum( param_empno, param_edate,  c_forward);
        end if;
        if param_half_day_on in (hd_edate_presnt_part_1 ,half_day_on_none) then
            v_cumu_sl := nvl(v_cumu_sl,0) + get_continuous_sl_sum( param_empno, param_bdate,  c_reverse);
        end if;
        
        v_cumu_sl := nvl(v_cumu_sl,0);
        v_cumu_sl := v_cumu_sl / 8;
        
        If v_cumu_sl <> 0 and v_cumu_sl + v_leave_period > v_max_days then
            v_failure_number          := v_failure_number + 1;
            param_msg_type            := ss.failure;
            param_msg                 := param_msg || To_Char(v_failure_Number) || ' - SL cannot be availed for more than 3 days in succession. ';
        end if;
        
      v_bdate := null;      
      v_edate := null;
      If param_half_day_on in (hd_edate_presnt_part_1, half_day_on_none ) then
          v_bdate := get_date_4_continuous_leave(param_empno, param_bdate, leave_type_sl,c_reverse);
      end if;

      If param_half_day_on in (hd_bdate_presnt_part_2, half_day_on_none ) then
          v_edate := get_date_4_continuous_leave(param_empno, param_edate, leave_type_sl,c_forward);
      end if;


      v_co_spc_co := validate_co_spc_co(param_empno, nvl(v_bdate,param_bdate), nvl(v_edate,param_edate), param_half_day_on);
      If v_co_spc_co = ss.failure Then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - SL cannot be availed with trailing and preceding CO - CO-SL-CO. ';
      end If;
      
      
      v_spc_co_spc := validate_spc_co_spc(param_empno, nvl(v_bdate,param_bdate), nvl(v_edate,param_edate), param_half_day_on);
      if v_spc_co_spc = ss.failure then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - SL cannot be availed when trailing and preceding to CO. "CL-SL-PL  -CO-  CL-SL-PL"';
      end if;
        
    end validate_sl;
      

    PROCEDURE validate_lv( 
        param_empno VARCHAR2,
        param_bdate DATE,
        param_edate DATE,
        param_half_day_on NUMBER,
        param_leave_period out number,
        param_msg_type OUT NUMBER,
        param_msg OUT VARCHAR2) 
    as
        v_failure_number number := 0;
        v_leave_period number;
        v_count Number;
    begin
          param_msg_type              := ss.success;

          select count(EmpNO) Into v_Count from ss_emplmast where empno = param_empno and
            status = 1 and (emptype = 'C' or EXPATRIATE = 1);
          If v_count = 0 Then
              v_failure_number := v_failure_number + 1;
              param_msg_type            := ss.failure;
              param_msg                 := param_msg || To_Char(v_failure_Number) || ' - You Cannot avail leave type "LV". ';
          end if;
          
          --Cannot avail leave on holiday.
          IF CheckHoliday(param_bdate) > 0 OR CheckHoliday(param_edate) > 0 THEN
              v_failure_number := v_failure_number + 1;
              param_msg_type            := ss.failure;
              param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Cannot avail leave on holiday. ';
          END IF;
    
          
          param_leave_period := calc_leave_period(param_bdate,param_edate,'LV',param_half_day_on);

          Select count(*) Into v_count From ss_leave_app_ledg Where empno = param_empno  And
            (param_bdate Between bdate And edate Or param_edate Between bdate And edate);
          if v_count > 0 Then
              v_failure_number := v_failure_number + 1;
              param_msg_type            := ss.failure;
              param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Leave has already been availed on same day. ';
          End If;
          
          
    end;
 
    PROCEDURE validate_co(
        param_empno VARCHAR2,
        param_bdate DATE,
        param_edate DATE,
        param_half_day_on NUMBER,
        param_leave_period out number,
        param_msg_type OUT NUMBER,
        param_msg OUT VARCHAR2) 
    as
        v_leave_period number;
        v_max_days number := 3;
        v_failure_number number := 0;
        v_co_combined_forward number;
        v_co_combined_reverse number;
        v_cumu_co number;
        v_co_combined number;
    begin
    
        param_msg_type              := ss.success;
        
        --Cannot avail leave on holiday.
        IF CheckHoliday(param_bdate) > 0 OR CheckHoliday(param_edate) > 0 THEN
            v_failure_number := v_failure_number + 1;
            param_msg_type            := ss.failure;
            param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Cannot avail leave on holiday. ';
        END IF;
  
        --CO cannot be less then 3 days.
        v_leave_period := calc_leave_period(param_bdate,param_edate,'CO',param_half_day_on);
        param_leave_period := v_leave_period;
        If v_leave_period > v_max_days Then
            param_msg_type            := ss.failure;
            param_msg_type            := ss.failure;
            param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CO cannot be more then 3 days. ';
        End If;
        --CO cannot be less then 3 days.
        
        if param_half_day_on in (hd_bdate_presnt_part_2 ,half_day_on_none) then
            v_cumu_co := get_continuous_leave_sum( param_empno, param_edate, leave_type_co, c_forward);
        end if;
        if param_half_day_on in (hd_edate_presnt_part_1 ,half_day_on_none) then
            v_cumu_co := nvl(v_cumu_co,0) + get_continuous_leave_sum( param_empno, param_bdate, leave_type_co, c_reverse);
        end if;

        v_cumu_co := v_cumu_co / 8;
        
        If v_cumu_co + v_leave_period > v_max_days then
            v_failure_number          := v_failure_number + 1;
            param_msg_type            := ss.failure;
            param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CO cannot be availed for more than 3 days continuously. ';
        end if;

        v_co_combined := validate_cl_sl_co(param_empno , param_bdate , param_edate ,param_half_day_on , 'CO');
  
        if v_co_combined = leave_combined_over_lap then
            v_failure_number          := v_failure_number + 1;
            param_msg_type            := ss.failure;
            param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Leave has already been availed on same day. ';
        End If;



        if param_half_day_on in (hd_bdate_presnt_part_2 ,half_day_on_none) then
            v_co_combined_forward := check_co_with_adjacent_leave( param_empno, param_edate, c_forward);
            if v_co_combined_forward = ss.failure then
                v_failure_number := v_failure_number + 1;
                param_msg_type            := ss.failure;
                param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CO + CL/SL/PL + CL/SL/PL/CO cannot be availed together. ';
                return;
            end if;
        end if;
        if param_half_day_on in (hd_edate_presnt_part_1 ,half_day_on_none) then
            v_co_combined_reverse := check_co_with_adjacent_leave( param_empno, param_bdate, c_reverse);
            if v_co_combined_reverse = ss.failure then
                v_failure_number := v_failure_number + 1;
                param_msg_type            := ss.failure;
                param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CL/SL/PL/CO + CL/SL/PL + CO cannot be availed together. ';
            elsif leave_with_adjacent = v_co_combined_reverse and leave_with_adjacent = v_co_combined_forward then
                v_failure_number := v_failure_number + 1;
                param_msg_type            := ss.failure;
                param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CL/SL/PL + CO + CL/SL/PL cannot be availed together. ';
            end if;
        end if;
        
    end validate_co;

    PROCEDURE validate_cl_old(
        param_empno VARCHAR2,
        param_bdate DATE,
        param_edate DATE,
        param_half_day_on NUMBER,
        param_leave_period out number,
        param_msg_type OUT NUMBER,
        param_msg OUT VARCHAR2)
    as
        v_leave_period number;
        v_max_days number;
        v_failure_number number := 0;
        v_cl_combined number;
    begin
    
      param_msg_type              := ss.success;
      
      --Cannot avail leave on holiday.
      IF CheckHoliday(param_bdate) > 0 OR CheckHoliday(param_edate) > 0 THEN
          v_failure_number := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Cannot avail leave on holiday. ';
      END IF;

      --CL cannot be more then 3 days.
      If param_half_day_on = half_day_on_none Then
          v_max_days  := 3;
      else
          v_max_days  := 3;
      end if;
      
      v_leave_period := calc_leave_period(param_bdate,param_edate,'CL',param_half_day_on);
      param_leave_period := v_leave_period;
      
      If v_leave_period > v_max_days Then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CL cannot be more then 3 days. ';
      End If;
      --CL cannot be less then 3 days.
      v_cl_combined := validate_cl_sl_co(param_empno , param_bdate , param_edate ,param_half_day_on , 'CL');

      If v_cl_combined = leave_combined_with_csp Then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CL and CL/PL/SL cannot be availed together. ';
      elsif v_cl_combined = leave_combined_over_lap then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Leave has already been availed on same day. ';
      elsif v_cl_combined = leave_combined_with_co then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CL and CO cannot be availed together. ';
      End If;
    end validate_cl_old;

    procedure check_co_co_combination (
          param_empno varchar2,
          param_bdate date,
          param_edate date,
          param_success out number
    ) as
        cursor prev_leave is select * from ss_leave_app_ledg where empno = param_empno
          and bdate < param_bdate order by edate desc;
        cursor next_leave is select * from ss_leave_app_ledg where empno = param_empno
          and bdate > param_edate order by bdate asc;
        v_count number;
        v_prev_work_date date;
        v_next_work_date date;
    begin
        v_count := 0;
        for cur_row in  prev_leave loop
            v_count := v_count + 1;
            If v_count = 1 Then
                v_prev_work_date := getlastworkingday(param_bdate,'-');
                If not(trunc(v_prev_work_date) between cur_row.bdate and cur_row.edate) Or cur_row.leavetype = 'CO' then
                  --No Error
                  param_success := ss.success;
                  exit;
                else
                  v_prev_work_date := getlastworkingday(cur_row.bdate,'-');
                end if;
            End if;
            If v_count = 2 Then
              If trunc(v_prev_work_date) between cur_row.bdate and cur_row.edate and cur_row.leavetype = 'CO' then
                  --Error
                  param_success := ss.failure;
                  return;
              else
                  --No Error
                  param_success := ss.success;
                  null;
              end If;
              exit ;
            end If;
        end loop;
        if param_success = ss.failure then return; End If; 
        v_count := 0;
        for cur_row in next_leave loop
            v_count := v_count +1;
            If v_count = 1 Then
                v_next_work_date := getlastworkingday(param_edate,'+');
                If not(trunc(v_next_work_date) between cur_row.bdate and cur_row.edate) Or cur_row.leavetype = 'CO' then
                    param_success := ss.success;
                    exit;
                else
                    v_next_work_date  := getlastworkingday(cur_row.edate,'+');
                end if;
            End if;
            If v_count = 2 Then
                If trunc(v_next_work_date) between cur_row.bdate and cur_row.edate and cur_row.leavetype = 'CO' then
                    --Error
                    param_success := ss.failure;
                    return;
                else
                    param_success := ss.success;
                    null;
                end If;
                exit;
            end If;
        end loop;
    end;
  
    
  procedure   validate_leave(
        param_empno         VARCHAR2,
        param_leave_type    varchar2,
        param_bdate         DATE,
        param_edate         DATE,
        param_half_day_on   NUMBER,
        param_app_no        varchar2 default '',
        param_leave_period  out number,
        param_last_reporting out varchar2 ,
        param_resuming      out varchar2,
        param_msg_type      OUT NUMBER,
        param_msg           OUT VARCHAR2) 
  as
    v_last_reporting varchar2(100);
    v_resuming varchar2(100);
  begin
        If param_bdate > param_edate Then
              param_msg_type := ss.failure;
              param_msg := 'Invalid date range. Cannot proceed.';
              return;
        end if;
        begin
            go_come_msg(param_bdate, param_edate, param_half_day_on, v_last_reporting, v_resuming );
            param_last_reporting := v_last_reporting;
            param_resuming := v_resuming;
        exception
          when others then null;
        end;
        case 
          when param_leave_type = leave_type_cl then 
            --if param_empno in ('02320','02079') then
              validate_cl( param_empno ,param_bdate , param_edate , param_half_day_on ,param_leave_period , param_msg_type ,param_msg ) ;
            /*else
              validate_cl( param_empno ,param_bdate , param_edate , param_half_day_on ,param_leave_period , param_msg_type ,param_msg ) ;
            end if;*/
          when param_leave_type = leave_type_pl then 
              validate_pl( param_empno ,param_bdate , param_edate , param_half_day_on , param_app_no ,param_leave_period , param_msg_type ,param_msg ) ;
          when param_leave_type = leave_type_sl then 
              validate_sl( param_empno ,param_bdate , param_edate , param_half_day_on ,param_leave_period , param_msg_type ,param_msg ) ;
          when param_leave_type = leave_type_co then 
              validate_co( param_empno ,param_bdate , param_edate , param_half_day_on ,param_leave_period , param_msg_type ,param_msg ) ;
          when param_leave_type = leave_type_lv then
              validate_lv( param_empno ,param_bdate , param_edate , param_half_day_on ,param_leave_period , param_msg_type ,param_msg ) ;
          when param_leave_type = leave_type_ex then 
              --validate_ex( param_empno ,param_bdate , param_edate , param_half_day_on ,param_leave_period , param_msg_type ,param_msg ) ;
              param_msg_type := ss.failure;
              param_msg := 'Cannot avail "' || param_leave_type || '" Leave. Cannot proceed.';
          else 
              param_msg_type := ss.failure;
              param_msg := '"' || param_leave_type || '" Leave Type not defined. Cannot proceed.';
        end case;
  exception
    when others then
      param_leave_period := 0;
      param_msg_type := ss.failure;
      param_msg := sqlCode || ' - ' || sqlerrm;
  end;

  procedure go_come_msg(
        param_bdate date,
        param_edate date,
        param_half_day_on number ,
        param_last_reporting out varchar2 ,
        param_resuming out varchar2
        ) 
  as
        v_prev_work_date date;
        v_next_work_date date;
  begin
        v_prev_work_date := getlastworkingday(param_bdate,'-');
        v_next_work_date := getlastworkingday(param_edate,'+');
        CASE
        WHEN param_half_day_on = hd_bdate_presnt_part_2 THEN
            param_last_reporting := To_Char(param_bdate,DayDateFormat ) || in_first_half;
            param_resuming := To_Char(v_next_work_date,DayDateFormat ) ;
        WHEN param_half_day_on = hd_edate_presnt_part_1 THEN
            param_last_reporting := To_Char(v_prev_work_date,DayDateFormat ) ;
            param_resuming := To_Char(param_edate,DayDateFormat ) || in_second_half;
        else
            param_last_reporting := To_Char(v_prev_work_date,DayDateFormat ) ;
            param_resuming := To_Char(v_next_work_date,DayDateFormat ) ;
        END CASE ;
  end;
  
  function calc_leave_period ( 
        param_bdate date, 
        param_edate date,
        param_leave_type varchar2,
        param_half_day_on number
        ) return number 
  as
      v_ret_val number := 0;
  begin
  
        If param_leave_type = leave_type_sl Then
            v_ret_val := param_edate - param_bdate + 1;
            If nvl(param_half_day_on,half_day_on_none) <> half_day_on_none Then
                v_ret_val := v_ret_val - .5;
            End If;
            return v_ret_val;
        End If;
        
        v_ret_val := (param_edate - param_bdate + 1) - holidaysbetween(param_bdate,param_edate);
        If nvl(param_half_day_on,half_day_on_none) <> half_day_on_none Then
            v_ret_val := v_ret_val - .5;
        End If;
        
        return v_ret_val;
  end;
  
  function get_app_no(param_empno varchar2) return varchar2
  as
      my_exception exception;
      pragma exception_init(my_exception,-20001);
      v_max_app_no number;
      v_ret_val varchar2(60);
  begin
        select count(*) into v_max_app_no from ss_leaveApp where empno = param_empno and app_date >= trunc(sysdate,'YEAR');
        If v_max_app_no > 0 then
            Select max(to_number(substr(app_no,instr(app_no,'/',-1)+1))) into v_max_app_no
            from SS_LeaveApp where empno = trim(param_empno) and app_date >= trunc(sysdate,'YEAR')
            order by to_number(substr(app_no,instr(app_no,'/',-1)+1));
        End If;
        v_ret_val := param_empno || '/' || to_char(sysdate,'yyyymmdd') || '/' || (v_max_app_no + 1);
        return v_ret_val;
  exception
        when others then
          raise_application_error(-20001,'GET_APP_NO - ' || sqlcode || ' - ' || sqlerrm);
  end;
  
  procedure add_leave_app(
        param_empno varchar2,
        param_app_no varchar2 default ' ',
        param_leave_type varchar2,
        param_bdate date,
        param_edate date,
        param_half_day_on number,
        param_projno varchar2,
        param_careTaker varchar2,
        param_Reason varchar2,
        param_Cert number,
        param_contact_add varchar2,
        param_contact_std varchar2,
        param_contact_Phn varchar2,
        param_office varchar2,
        param_dataEntryBy varchar2,
        param_lead_empno varchar2,
        param_discrepancy varchar2,
        param_tcp_ip varchar2,
        param_nu_app_no out varchar2,
        param_msg_type OUT NUMBER,
        param_msg OUT VARCHAR2
        ) 
  as
        v_app_no varchar2(60);
        v_last_reporting varchar2(150);
        v_resuming_on varchar2(150);
        v_l_rep_dt date;
        v_resume_dt date;
        v_hd_date date;
        v_hd_presnt_part number;
        v_lead_apprl number;
        v_mngr_email varchar2(100);
        v_leave_period number;
        v_email_success number;
        v_email_message varchar2(100);
  begin
        validate_leave 
          (  
              param_empno ,
              param_leave_type ,
              param_bdate ,
              param_edate ,
              param_half_day_on ,
              param_app_no ,
              v_leave_period ,
              v_last_reporting,
              v_resuming_on,
              param_msg_type ,
              param_msg 
          ) ;
        --v_leave_period := calc_leave_period( param_bdate, param_edate, param_leave_type, param_half_day_on);

        if param_msg_type = ss.failure then
            return;
        end if;
        if nvl(param_half_day_on, half_day_on_none) = hd_bdate_presnt_part_2 then
            v_hd_date := param_bdate;
            v_hd_presnt_part := 2;
        elsif nvl(param_half_day_on, half_day_on_none) = hd_edate_presnt_part_1 then
            v_hd_date := param_edate;
            v_hd_presnt_part := 1;
        end if;
        If param_lead_empno = 'None' Then
          v_lead_apprl := ss.apprl_none;
        Else
            v_lead_apprl := ss.pending;
        End If;
        v_app_no := get_app_no(param_empno);
        param_nu_app_no := v_app_no;
        --go_come_msg( param_bdate, param_edate, param_half_day_on, v_last_reporting, v_resuming_on);
        
        v_last_reporting := replace( v_last_reporting , in_first_half);
        v_last_reporting := replace( v_last_reporting , in_second_half);
        
        v_resuming_on := replace( v_resuming_on, in_first_half);
        v_resuming_on := replace( v_resuming_on, in_second_half);
        
        v_l_rep_dt := to_date(v_last_reporting, DayDateFormat );
        v_resume_dt := to_date(v_resuming_on, DayDateFormat);
        v_leave_period := v_leave_period * 8;
        
        
        insert into ss_leaveapp (
                                    EMPNO,  APP_NO,  APP_DATE,  PROJNO,  CARETAKER,  LEAVETYPE, BDATE,  
                                    EDATE,  MCERT,  WORK_LDATE,  RESM_DATE,  CONTACT_PHN,  CONTACT_STD,
                                    DATAENTRYBY,  OFFICE,  HOD_APPRL,  DISCREPANCY,  USER_TCP_IP,  HD_DATE,  
                                    HD_PART, LEAD_APPRL,  LEAD_APPRL_EMPNO,  HRD_APPRL, leaveperiod, reason
                                  ) 
                                  values
                                  (
                                    param_empno, v_app_no, sysdate, param_projno, param_careTaker, param_leave_type, param_bdate,
                                    param_edate, param_cert, v_l_rep_dt, v_resume_dt,param_contact_phn, param_contact_std,
                                    param_dataentryBy, param_office, ss.pending,param_discrepancy, param_tcp_ip,v_hd_date, 
                                    v_hd_presnt_part, v_lead_apprl, param_lead_Empno,ss.pending, v_leave_period, param_reason
                                  );
                                    
        commit;
        param_msg := 'Application successfully Saved. ' || v_app_no;
        param_msg_type := ss.success;
        
        ss_mail.send_msg_new_leave_app(v_app_no,v_email_success, v_email_message);
        
        if v_email_success = ss.failure then
            param_msg_type := ss.warning;
            param_msg := param_msg || ' Email could not be sent. - ';
        else
            param_msg := param_msg || ' Email sent to HoD / Lead.';
        end if;
        
  exception
      when others then
          param_msg_type := ss.failure;
          param_msg := nvl(param_msg, ' ') || sqlcode || ' - ' || sqlerrm;
  end;
  
  procedure save_pl_revision(
        param_empno varchar2,
        param_app_no varchar2,
        param_bdate date,
        param_edate date,
        param_half_day_on number,
        param_dataEntryBy varchar2,
        param_lead_empno varchar2,
        param_discrepancy varchar2,
        param_tcp_ip varchar2,
        param_nu_app_no out varchar2,
        param_msg_type OUT NUMBER,
        param_msg OUT VARCHAR2
  )
  as
        v_CONTACT_ADD               VARCHAR2(60);
        v_CONTACT_PHN               VARCHAR2(30);
        v_CONTACT_STD               VARCHAR2(30);
        v_PROJNO                    VARCHAR2(60);
        v_CARETAKER                 VARCHAR2(60);
        v_MCERT                     NUMBER(1);
        v_OFFICE                    VARCHAR2(30);
        v_count                     NUMBER;
  begin
        select count(*) into v_Count From ss_pl_revision_mast where trim(old_app_no) = trim(param_app_no)
          or trim(new_app_no)  = trim(param_app_no);
        If v_count > 0 Then
            param_msg_type := ss.failure;
            param_msg := 'PL application "' || trim(param_app_no) || '" has already been revised.';
            Return;
        End If;
        begin
            Select PROJNO,  CARETAKER,  MCERT,  contact_add, CONTACT_PHN,  CONTACT_STD, OFFICE
              into v_projno, v_caretaker, v_mcert, v_contact_add, v_contact_phn, v_contact_std, v_office
              from ss_leaveapp where trim(app_no) = trim(param_app_no);
        exception
            when others then
              param_msg_type := ss.failure;
              param_msg := nvl(param_msg, ' ') || sqlcode || ' - ' || sqlerrm || '. "' || param_app_no || '" Application not found.';
              return;
        end;
        
        add_leave_app(
                param_empno         => param_empno,
                param_app_no        => param_app_no,
                param_leave_type    => 'PL',
                param_bdate         => param_bdate,
                param_edate         => param_edate,
                param_half_day_on   => param_half_day_on,
                param_projno        => v_projno,
                param_careTaker     => v_caretaker,
                param_Reason        => param_app_no || ' P L   R e v i s e d',
                param_Cert          => v_mcert,
                param_contact_add   => v_contact_add,
                param_contact_std   => v_contact_std,
                param_contact_Phn   => v_contact_phn,
                param_office        => v_office,
                param_dataEntryBy   => param_dataentryby,
                param_lead_empno    => param_lead_empno,
                param_discrepancy   => param_discrepancy,
                param_tcp_ip        => param_tcp_ip,
                param_nu_app_no     => param_nu_app_no,
                param_msg_type      => param_msg_type,
                param_msg           => param_msg
                );
          If param_msg_type = ss.failure then
              rollback;
              return;
          end if;
          insert into ss_pl_revision_mast(old_app_no , new_app_no ) values (trim(param_app_no), trim(param_nu_app_no));
          commit;
          param_msg_type := ss.success;
  exception
      when others then
        param_msg_type := ss.failure;
        param_msg := nvl(param_msg, ' ') || sqlcode || ' - ' || sqlerrm;
  end;
  
 
  procedure get_leave_details(
        param_o_app_no        In  varchar2,
        param_o_empno	        out	varchar2,
        param_o_emp_name	    out	varchar2,
        param_o_app_date	    out	varchar2,
        param_o_office        out varchar2,
        param_o_edate	        out	varchar2,
        param_o_bdate	        out	varchar2,
        param_o_hd_date	      out	varchar2,
        param_o_hd_part	      out	number,
        param_o_leave_period	out	number,
        param_o_leave_type	  out	varchar2,
        param_o_rep_to	      out	varchar2,
        param_o_projno	      out	varchar2,
        param_o_care_taker	  out	varchar2,
        param_o_reason	      out	varchar2,
        param_o_mcert	        out	number,
        param_o_work_ldate	  out	varchar2,
        param_o_resm_date	    out	varchar2,
        param_o_last_reporting  out varchar2,
        param_o_resuming        out varchar2,
        param_o_contact_add	  out	varchar2,
        param_o_contact_phn	  out	varchar2,
        param_o_std	          out	varchar2,
        param_o_discrepancy	  out	varchar2,
        param_o_lead_empno	  out	varchar2,
        param_o_lead_name	    out	varchar2,
        param_o_msg_type      OUT NUMBER,
        param_o_msg           OUT VARCHAR2
  ) as
        v_empno varchar2(5);
        v_name varchar2(60);
        v_last_reporting varchar2(100);
        v_resuming varchar2(100);
  begin

      SELECT 
        EMPNO,  get_emp_name(empno),
        To_char(APP_DATE, 'dd-Mon-yyyy'), to_char( EDATE,'dd-Mon-yyyy'),  to_char(BDATE, 'dd-Mon-yyyy'),  
        to_char(hd_date, 'dd-Mon-yyyy'), nvl(hd_part,0), LEAVEPERIOD,  LEAVETYPE, 
        REP_TO,  PROJNO,  CARETAKER,  REASON,  MCERT,  
        to_char(WORK_LDATE, 'dd-Mon-yyyy'),  to_char(RESM_DATE,'dd-Mon-yyyy'),  CONTACT_ADD,  CONTACT_PHN,
        CONTACT_STD,  DISCREPANCY, lead_apprl_empno, get_emp_name(LEAD_APPRL_EMPNO) LeadName,
        office
      into
        param_o_empno, param_o_emp_name,
        param_o_app_date, param_o_edate, param_o_bdate, 
        param_o_hd_date, param_o_hd_part, param_o_leave_period, param_o_leave_type, 
        param_o_rep_to, param_o_projno, param_o_care_taker, param_o_reason, param_o_mcert,
        param_o_work_ldate, param_o_resm_date, param_o_contact_add, param_o_contact_phn,
        param_o_std, param_o_discrepancy, param_o_lead_empno, param_o_lead_name,
        param_o_office
      FROM ss_leaveapp WHERE APP_NO in ( param_o_app_no);
        begin
            go_come_msg(param_o_bdate, param_o_edate, param_o_hd_date, v_last_reporting, v_resuming );
            param_o_last_reporting := v_last_reporting;
            param_o_resuming := v_resuming;
        exception
          when others then null;
        end;

      param_o_msg_type := ss.success;
      param_o_msg_type := 'SUCCESS';


  exception 
    when others then
      param_o_msg_type := ss.failure;
      param_o_msg := sqlcode || ' - ' || sqlerrm;
  end get_leave_details;
   
     
    procedure post_leave_apprl(param_list_appno varchar2, param_msg_type out number, param_msg out varchar2) as
    
        cursor app_recs is 
            SELECT TRIM( SUBSTR (txt , INSTR (txt, ',', 1, level ) + 1 , INSTR (txt, ',', 1, level+1)
                - INSTR (txt, ',', 1, level) -1 ) ) AS app_no
                FROM ( SELECT ','||param_list_appno||',' AS txt FROM dual )
                  CONNECT BY level <= LENGTH(txt)-LENGTH(REPLACE(txt,',',''))-1;
    
        v_cur_app varchar2(60);
        v_old_app varchar2(60); 
        v_count number;
    begin
        for cur_app in app_recs loop
        
            v_cur_app := replace(cur_app.app_no,chr(39));
            
            Select count(*) into v_count from ss_pl_revision_mast where trim(new_app_no) = trim(v_cur_app);
            If v_count > 0 Then
              select old_app_no into v_old_app from ss_pl_revision_mast 
                where trim(new_app_no) = trim(v_cur_app);
                
              insert into ss_pl_revision_app 
                  (APP_NO, EMPNO, APP_DATE, REP_TO, PROJNO, CARETAKER,
                    LEAVEPERIOD, LEAVETYPE, BDATE, EDATE, REASON, MCERT, WORK_LDATE,
                    RESM_DATE, CONTACT_ADD, CONTACT_PHN, CONTACT_STD, LAST_HRS,
                    LAST_MN, RESM_HRS, RESM_MN, DATAENTRYBY, OFFICE, HOD_APPRL,
                    HOD_APPRL_DT, HOD_CODE, HRD_APPRL, HRD_APPRL_DT, HRD_CODE,
                    DISCREPANCY, USER_TCP_IP, HOD_TCP_IP, HRD_TCP_IP, HODREASON,
                    HRDREASON, HD_DATE, HD_PART, LEAD_APPRL, LEAD_APPRL_DT,
                    LEAD_CODE, LEAD_TCP_IP, LEAD_APPRL_EMPNO, LEAD_REASON)
                  SELECT APP_NO, EMPNO, APP_DATE, REP_TO, PROJNO, CARETAKER,
                    LEAVEPERIOD, LEAVETYPE, BDATE, EDATE, REASON, MCERT, WORK_LDATE,
                    RESM_DATE, CONTACT_ADD, CONTACT_PHN, CONTACT_STD, LAST_HRS,
                    LAST_MN, RESM_HRS, RESM_MN, DATAENTRYBY, OFFICE, HOD_APPRL,
                    HOD_APPRL_DT, HOD_CODE, HRD_APPRL, HRD_APPRL_DT, HRD_CODE,
                    DISCREPANCY, USER_TCP_IP, HOD_TCP_IP, HRD_TCP_IP, HODREASON,
                    HRDREASON, HD_DATE, HD_PART, LEAD_APPRL, LEAD_APPRL_DT,
                    LEAD_CODE, LEAD_TCP_IP, LEAD_APPRL_EMPNO, LEAD_REASON
                  FROM ss_leaveapp where 
                    trim(app_no) = trim(v_old_app);
  
                delete from ss_leaveapp where 
                  trim(app_no) = trim(v_old_app);
                  
                delete from ss_leaveledg where 
                  trim(app_no) = trim(v_old_app);
            end If;
            Insert into SS_LeaveLedg value 
              (Select App_No, App_Date, LeaveType, Reason, EmpNo, LeavePeriod * -1 , 'D', 1, BDate, EDate, 'LA', 
                HD_Date, HD_Part From SS_LeaveApp Where trim(App_No) = trim(v_cur_app));
            v_cur_app := null;              
        end loop;
        param_msg_type := ss.success;
  
  /*      
        for cur_app in app_recs loop
            v_cur_app := trim(replace(cur_app.app_no,chr(39)));
            Select v_old_app_no from ss_pl_revision_mast
              where trim(new_app_no) = trim(v_cur_app);
        end loop;
  */
    exception
        when others then 
          param_msg_type := ss.failure;
    end;
    
    function is_pl_revision(param_app_no varchar2) return number is
        v_count number;
    begin
        select count(*) into v_count from ss_pl_revision_mast 
          where trim(new_app_no) = trim(param_app_no);
        If v_count = 0 then
          return 0;
        else
          return 1;
        end if;
    end;
  
    PROCEDURE validate_cl(
        param_empno VARCHAR2,
        param_bdate DATE,
        param_edate DATE,
        param_half_day_on NUMBER,
        param_leave_period out number,
        param_msg_type OUT NUMBER,
        param_msg OUT VARCHAR2)
    as
        v_leave_period number;
        v_max_days number;
        v_failure_number number := 0;
        v_cl_combined number;
        v_cumu_cl number;
        v_co_spc_co number;
        v_spc_co_spc number;
        v_bdate date;
        v_edate date;
    begin
    
      param_msg_type              := ss.success;
      v_cumu_cl := 0;
      --Cannot avail leave on holiday.
      IF CheckHoliday(param_bdate) > 0 OR CheckHoliday(param_edate) > 0 THEN
          v_failure_number := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Cannot avail leave on holiday. ';
      END IF;

      --CL cannot be more then 3 days.
      If param_half_day_on = half_day_on_none Then
          v_max_days  := 3;
      else
          v_max_days  := 3;
      end if;
      
      v_leave_period := calc_leave_period(param_bdate,param_edate,'CL',param_half_day_on);
      param_leave_period := v_leave_period;
      
      If v_leave_period > v_max_days Then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CL cannot be more then 3 days. ';
      End If;
      --CL cannot be less then 3 days.
      
      v_cl_combined := validate_cl_sl_co(param_empno , param_bdate , param_edate ,param_half_day_on , 'CL');

      If v_cl_combined = leave_combined_with_csp Then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CL and CL/PL/SL cannot be availed together. ';
      elsif v_cl_combined = leave_combined_over_lap then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - Leave has already been availed on same day. ';
      End If;
      
        if param_half_day_on in (hd_bdate_presnt_part_2 ,half_day_on_none) then
            v_cumu_cl := get_continuous_cl_sum( param_empno, param_edate,  c_forward);
        end if;
        if param_half_day_on in (hd_edate_presnt_part_1 ,half_day_on_none) then
            v_cumu_cl := nvl(v_cumu_cl,0) + get_continuous_cl_sum( param_empno, param_bdate,  c_reverse);
        end if;
      
      v_cumu_cl := v_cumu_cl / 8;
      
      If v_cumu_cl + v_leave_period > v_max_days then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CL cannot be availed for more than 3 days continuously. ';
      end if;
      
      v_bdate := null;      
      v_edate := null;
      If param_half_day_on in (hd_edate_presnt_part_1, half_day_on_none ) then
          v_bdate := get_date_4_continuous_leave(param_empno, param_bdate, leave_type_cl,c_reverse);
      end if;

      If param_half_day_on in (hd_bdate_presnt_part_2, half_day_on_none ) then
          v_edate := get_date_4_continuous_leave(param_empno, param_edate, leave_type_cl,c_forward);
      end if;


      v_co_spc_co := validate_co_spc_co(param_empno, nvl(v_bdate,param_bdate), nvl(v_edate,param_edate), param_half_day_on);
      If v_co_spc_co = ss.failure Then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CL cannot be availed with trailing and preceding CO - CO-CL-CO. ';
      end If;
      
      
      v_spc_co_spc := validate_spc_co_spc(param_empno, nvl(v_bdate,param_bdate), nvl(v_edate,param_edate), param_half_day_on);
      
      if v_spc_co_spc = ss.failure then
          v_failure_number          := v_failure_number + 1;
          param_msg_type            := ss.failure;
          param_msg                 := param_msg || To_Char(v_failure_Number) || ' - CL cannot be availed when trailing and preceding to CO. "CL-SL-PL  -CO-  CL-SL-PL"';
      end if;
      
      
    end validate_cl;
  
  
  
    function get_continuous_leave_sum (
        param_empno VARCHAR2,
        param_date DATE,
        param_leave_type varchar2,
        param_reverse_forward varchar2
        ) 
    return number is
        v_app_no        varchar2(60);
        v_cumu_leave       number;
        v_lw_date       date;
        v_leave_period  number;
        v_leave_bdate   date;
        v_leave_edate   date;
    begin
        v_cumu_leave := 0;
          v_lw_date := getlastworkingday(param_date,param_reverse_forward);
          loop
              begin
                  Select app_no Into v_app_no From ss_leave_app_ledg
                    Where empno = param_empno  And
                    (v_lw_date Between bdate And edate and leavetype = param_leave_type);
                  select leaveperiod, bdate, edate into v_leave_period , v_leave_bdate,v_leave_edate
                    from ss_leaveapp where trim(app_no) = trim(v_app_no) ;
                  v_cumu_leave := v_cumu_leave + v_leave_period;
                  if param_reverse_forward = c_forward then
                      v_lw_date := getlastworkingday(v_leave_edate,c_forward);
                  else
                      v_lw_date := getlastworkingday(v_leave_bdate,c_reverse);
                  end if;
              exception
                  when others then exit;
              end;
          end loop;
          return v_cumu_leave;
    end;
    
    function get_continuous_sl_sum (
        param_empno VARCHAR2,
        param_date DATE,
        param_reverse_forward varchar2
        ) 
    return number is
        v_app_no        varchar2(60);
        v_cumu_leave       number;
        v_lw_date       date;
        v_leave_period  number;
        v_leave_bdate   date;
        v_leave_edate   date;
        v_prev_lw_dt    date;
        v_date_diff     number := 0;
    begin
          v_cumu_leave := 0;
          v_prev_lw_dt := param_date;
          v_lw_date := getlastworkingday(param_date,param_reverse_forward);
          
          
          loop
              begin
                  Select app_no Into v_app_no From ss_leave_app_ledg
                    Where empno = param_empno  And
                    (v_lw_date Between bdate And edate and leavetype = leave_type_sl);
                  select leaveperiod, bdate, edate into v_leave_period , v_leave_bdate,v_leave_edate
                    from ss_leaveapp where trim(app_no) = trim(v_app_no) ;
                  v_cumu_leave := v_cumu_leave + v_leave_period;

                  -- S T A R T
                  -- ADD UP holidays between Continuous SL
                  if param_reverse_forward = c_forward then
                  
                      v_date_diff := trunc(v_lw_date,'DDD') - trunc(v_prev_lw_dt,'DDD');
                      v_prev_lw_dt := v_lw_date;
                      v_lw_date := getlastworkingday(v_leave_edate,c_forward);
                  
                  else
                  
                      v_date_diff := trunc(v_prev_lw_dt,'DDD') - trunc(v_lw_date,'DDD');
                      v_prev_lw_dt := v_lw_date;
                      v_lw_date := getlastworkingday(v_leave_bdate,c_reverse);
                      
                  end if;
                  
                  if v_date_diff > 1 then
                      v_cumu_leave := v_cumu_leave + (v_date_diff * 8);
                  end if;
                  v_date_diff := 0;
                  -- ADD UP holidays between Continuous SL
                  -- E N D
              exception
                  when others then exit;
              end;
          end loop;
          return v_cumu_leave;
    end;
    
    
      
    function validate_cl_sl_co(
          param_empno VARCHAR2,
          param_bdate DATE,
          param_edate DATE,
          param_half_day_on NUMBER,
          param_leave_type varchar2) return number 
    is 
          v_count number;
          v_prev_work_date date;
          v_next_work_date date;
          v_results number;
    begin
      
      --Check Overlap
          Select count(*) Into v_count From ss_leave_app_ledg
            Where empno = param_empno  And
            (param_bdate Between bdate And edate Or param_edate Between bdate And edate);
          if v_count > 0 Then
              return leave_combined_over_lap;
          End If;
      --Check Overlap     

      --Check CL/SL/PL Combination
        v_prev_work_date := getlastworkingday(param_bdate,'-');
        v_next_work_date := getlastworkingday(param_edate,'+');
        
        if param_leave_type in  ('PL' ) then
            Select count(*) Into v_count From ss_leave_app_ledg
              Where empno = param_empno  And
              (trunc(v_prev_work_date) Between bdate And edate Or trunc(v_next_work_date) Between bdate And edate ) 
              and leavetype not in ('CO') ; -- Combination with CO is allowed
            if v_count > 0 Then
                return leave_combined_with_csp;
            end if;
        elsif param_leave_type in  ('SL') then
            Select count(*) Into v_count From ss_leave_app_ledg
              Where empno = param_empno  And
              (trunc(v_prev_work_date) Between bdate And edate Or trunc(v_next_work_date) Between bdate And edate ) 
              and leavetype not in ('CO','SL') ; -- Combination with CO is allowed
            if v_count > 0 Then
                return leave_combined_with_csp;
            end if;
        elsif param_leave_type = 'CL' Then
            Select count(*) Into v_count From ss_leave_app_ledg
              Where empno = param_empno  And
              (trunc(v_prev_work_date) Between bdate And edate Or trunc(v_next_work_date) Between bdate And edate ) 
              and leavetype not in ('CO', 'CL') ; -- Combination with CO is allowed
            if v_count > 0 Then
                return leave_combined_with_csp;
            end if;
        elsif param_leave_type = 'CO' then
          /*
            Select count(*) Into v_count From ss_leave_app_ledg
              Where empno = param_empno  
              and (trunc(v_prev_work_date) Between bdate And edate 
                    Or trunc(v_next_work_date) Between bdate And edate 
                  );
            if v_count <> 0 Then
                --Check   C O   C O   combination
                check_co_co_combination(param_empno,param_bdate,param_edate,v_results);
                if v_results = ss.failure Then
                    return leave_combined_with_co;
                End If;
            End if;
            */
            null;
        end if;
        return leave_combined_with_none;
      --Check CL/SL/PL Combination
    end validate_cl_sl_co;
      
    
    
    function validate_co_spc_co(param_empno varchar2, param_bdate date, param_edate date, param_half_day_on number ) return number is 
        v_prev_date date;
        v_next_date date;
        v_count number;
    begin
        v_prev_date := getlastworkingday( param_bdate, c_reverse);
        v_next_date := getlastworkingday( param_edate, c_forward);
        
        if param_half_day_on in (hd_bdate_presnt_part_2, half_day_on_none) then
            begin
                select count(*) into v_count from ss_leave_app_ledg where empno = param_empno 
                  and leavetype = leave_type_co and v_next_date between bdate and edate;
                if v_count = 0 then return ss.success; end if;
            end;
        end if;
        
        
        if param_half_day_on in (hd_edate_presnt_part_1, half_day_on_none) then
            begin
                select count(*) into v_count from ss_leave_app_ledg where empno = param_empno
                  and leavetype = leave_type_co and v_prev_date between bdate and edate;
                if v_count = 0 then return ss.success; else return ss.failure; end if;
            end;
        end if;
    end;
    
    
    
    function validate_spc_co_spc(param_empno varchar2, param_bdate date, param_edate date, param_half_day_on number) return number is
        v_lw_date date;
        v_bdate date := param_bdate;
        v_edate date := param_edate;
        v_count number;
        v_leavetype varchar2(2);
        
    begin
        if param_half_day_on in (hd_bdate_presnt_part_2, half_day_on_none) then
            begin
                loop
                    v_edate := GetLastWorkingDay(v_edate, c_forward);
                    select leavetype, edate into v_leavetype , v_edate from ss_leave_app_ledg 
                      where empno = param_empno and v_edate between bdate and edate;
                    if v_leavetype <> leave_type_co then
                        return ss.failure;
                    end if;
                end loop;
            exception
                when others then
                  if param_half_day_on = hd_bdate_presnt_part_2 then return ss.success; else null; end if;
            end;
        end if;
        if param_half_day_on in (hd_edate_presnt_part_1, half_day_on_none) then
            begin
                loop
                    v_bdate := GetLastWorkingDay(v_bdate, c_reverse);
                    select leavetype, bdate into v_leavetype , v_bdate from ss_leave_app_ledg where empno = param_empno
                      and v_bdate between bdate and edate;
                    if v_leavetype <> leave_type_co then
                        return ss.failure;
                    end if;
                end loop;
            exception
                when others then
                  return ss.success;
            end;
        end if;
        
    exception
        when others then return ss.success;
    end;
    
    
    
    
    function Get_Date_4_continuous_Leave(param_empno varchar2,param_date date, param_leave_type varchar2, param_forward_reverse VARCHAR2) return date is
        v_ret_date  date;
        v_date      date;
        v_bdate     date;
        v_edate     date;
    begin
        v_ret_date := param_date;
        v_date := param_date;
        loop
            v_date := getLastWorkingDay(v_date,param_forward_reverse);
            Select bdate, edate into v_bdate, v_edate from ss_leave_app_ledg where empno = param_empno
              and v_date between bdate and edate and leavetype = param_leave_type;
            if param_forward_reverse = c_forward then
                v_date := v_edate;
            else
                v_date := v_bdate;
            end if;
            v_ret_date := v_date;
        end loop;
        
    exception 
        when others then return v_ret_date;
    end Get_Date_4_continuous_Leave;
    
    
   
    
    
    function check_co_with_adjacent_leave(param_empno varchar2, param_date date, param_forward_reverse varchar2) return number is
        v_lw_date date;
        v_leavetype varchar2(2) := 'CO';
        v_ret_val number := ss.success;
        v_date date;
    begin
        v_date := param_date;
        Loop
            if v_leavetype in ('CL','SL','CO') then
                v_date := get_date_4_continuous_leave(param_empno, v_date, v_leavetype, param_forward_reverse);
            end if;
            v_lw_date := getLastWorkingDay(v_date,param_forward_reverse);
            select 
              case param_forward_reverse when c_reverse then bdate else edate end, leavetype 
              into v_date , v_leavetype 
            from ss_leave_app_ledg where empno = param_empno
              and v_lw_date between bdate and edate;
              
            if v_ret_val = leave_with_adjacent then
                return ss.failure;
            else
                v_ret_val := leave_with_adjacent;
            end if;
        end loop;
    exception
        when others then return v_ret_val;
    end ;
    

    
    function get_continuous_cl_sum (
        param_empno VARCHAR2,
        param_date DATE,
        param_reverse_forward varchar2
        ) 
    return number is
        v_app_no        varchar2(60);
        v_cumu_leave       number;
        v_lw_date       date;
        v_leave_period  number;
        v_leave_bdate   date;
        v_leave_edate   date;
        v_prev_lw_dt    date;
        v_date_diff     number := 0;
    begin
          v_cumu_leave := 0;
          v_prev_lw_dt := param_date;
          v_lw_date := getlastworkingday(param_date,param_reverse_forward);
          
          
          loop
              begin
                  Select app_no Into v_app_no From ss_leave_app_ledg
                    Where empno = param_empno  And
                    (v_lw_date Between bdate And edate and leavetype = leave_type_cl);
                  select leaveperiod, bdate, edate into v_leave_period , v_leave_bdate,v_leave_edate
                    from ss_leaveapp where trim(app_no) = trim(v_app_no) ;
                    
                    
                  v_cumu_leave := v_cumu_leave + v_leave_period;

                  if param_reverse_forward = c_forward then
                  
                      v_prev_lw_dt := v_lw_date;
                      v_lw_date := getlastworkingday(v_leave_edate,c_forward);
                  
                  else
                  
                      v_prev_lw_dt := v_lw_date;
                      v_lw_date := getlastworkingday(v_leave_bdate,c_reverse);
                      
                  end if;
                  
              exception
                  when others then exit;
              end;
          end loop;
          return v_cumu_leave;
    end;
 

    
    
END leave;

/
