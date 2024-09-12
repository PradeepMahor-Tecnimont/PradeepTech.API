--------------------------------------------------------
--  DDL for Package Body NU_EMP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."NU_EMP" AS
  --procedure assign_shift_4_mnth (param_empno varchar2, param_month varchar2 ) ;
  procedure process_nu_employee AS
      cursor cur_nu_emp is SELECT A.EMPNO,  A.EMP_NAME,  A.META_ID,  A.DOMAIN,  A.ACCOUNT_NAME,
          A.EMAIL_ID,  A.MODIFIED_ON,  B.NAME AS employee_name, B.DOJ FROM ss_fim_data A
          LEFT JOIN SS_EMPLMAST B ON A.EMPNO = B.EMPNO;
      v_count number;
      v_shift varchar2(62);
      v_start_day number;
      v_last_day number;
      v_na_shift varchar2(62);
  BEGIN
      for nu_emp in  cur_nu_emp loop
          select count(empno) into v_count from userids where empno = nu_emp.empno;
          If v_count = 0 Then
              insert into userids (empno, name, office, userid, 
                                  datetime, email, domain  )
                  values (nu_emp.empno, nvl(nu_emp.emp_name, nu_emp.employee_name), '', nu_emp.account_name, 
                                 sysdate, nu_emp.email_id, nu_emp.domain);
              commit;
              null;
          End If;
          /*
          assign_shift_4_mnth(to_char(nu_emp.doj,'yyyymm'), nu_emp.empno);

          If to_number(to_char(sysdate,'dd')) > 26 Then
              assign_shift_4_mnth(to_char(last_day(nu_emp.doj) + 1,'yyyymm'), nu_emp.empno);
          End If;
          */
      end loop;
  END process_nu_employee;

  procedure assign_shift_4_mnth ( param_empno varchar2 ,param_month varchar2 ) is
      v_last_day    number;
      v_shift       varchar2(62);
      v_hoilday     varchar2(2);
      v_doj         date;
      v_start_day   number;
      v_na_shift    varchar(62);
      v_count       number;
      cursor cur_holidays is select SRNO ,HOLIDAY ,YYYYMM ,WEEKDAY  from selfservice.ss_holidays where yyyymm = param_month;
  begin

      v_last_day := to_Number(to_char(last_day(to_date(param_month || '01','yyyymmdd')),'dd'));
      select count(empno) into v_count from selfservice.ss_emplmast where empno = param_empno and status = 1;
      If v_count = 0 then return; end if;

      select count(empno) into v_count from selfservice.SS_MUSTER where empno = param_empno
          and MNTH = param_month;

      If v_count > 0 Then          return;      end if;

      v_shift := rpad('GS',v_last_day * 2,'GS');

      Select doj into v_doj from selfservice.ss_emplmast where 
        empno = param_empno and status = 1;
      --v_last_day := to_number(last_day(to_date(param_month || '01','yyyymmdd')),'dd');

      if param_month = to_char(v_doj, 'yyyymm') then
        v_start_day := to_number(to_char(v_doj, 'dd'));
        v_na_shift := rpad('NA',(v_start_day-1) * 2,'NA');
        v_shift := trim(v_na_shift) || substr(v_shift, ((v_start_day-1) * 2) + 1);
      end if;

      for holiday_row in  cur_holidays loop
          case 
            when holiday_row.weekday in ('SAT' ,'SUN') then v_hoilday := 'OO';
            else v_hoilday := 'HH'; 
          end case;
          v_shift := substr(v_shift,1,(to_number(to_char(holiday_row.holiday,'dd'))-1)*2) || v_hoilday || substr(v_shift, to_number(to_char(holiday_row.holiday,'dd')) * 2 + 1);
      end loop;
      insert into selfservice.ss_muster (empno, mnth,s_mrk) values (trim(param_empno), trim(param_month), trim(v_shift));
      commit;
  exception
      when others then null;
  end assign_shift_4_mnth;

  procedure Assign_Shift_2_nu_emp is
      cursor cur_nu_emp is select empno, doj, emptype from TIMECURR.EMPLMAST_NEW_EMP_LOG where MODIFIED_ON >= sysdate - 15;
      v_date_4_shift date;
  begin
      v_date_4_shift :=  SelfService.NU_EMP.Get_assign_shift_run_date(to_char(add_months(sysdate,1), 'yyyymm'));
      If v_date_4_shift is null then return; end If;
      for nu_emp_row in cur_nu_emp loop
         assign_shift_4_mnth( nu_emp_row.empno, to_char(sysdate, 'yyyymm'));
         If sysdate >= v_date_4_shift Then
            assign_shift_4_mnth( nu_emp_row.empno, to_char(add_months(sysdate,1), 'yyyymm'));
         end if;
      end loop;
  end Assign_Shift_2_nu_emp;

  Procedure Auto_assign_Shift_2_All( param_yyyymm date) as
      v_count Number;
      Cursor cur_emp is Select Empno From ss_emplmast where status = 1;
      v_date_4_shift date;
  Begin
      v_date_4_shift :=  SelfService.NU_EMP.Get_assign_shift_run_date(param_yyyymm);
      If v_date_4_shift is null then return; end If;
      If Not (sysdate >= v_date_4_shift) Then
          Return;
      End If;
      Select count(yyyymm) into v_count from Selfservice.SS_SHIFT_AUTO_ASSIGN_LOG a where a.YYYYMM = param_yyyymm and nvl(a.SHIFT_ASSIGNED,0) = 1;
      If v_count >0 Then
          Return;
      End If;
      For emp_row in cur_emp loop
          assign_shift_4_mnth(emp_row.empno, param_yyyymm);
      end loop;
      Insert into ss_shift_auto_assign_log (yyyymm, modified_on, shift_assigned ) values (param_yyyymm, sysdate, 1);
      commit;
  Exception 
      When others then
          null;
  End Auto_assign_Shift_2_All;



  function Get_assign_shift_run_date(param_yyyymm varchar2) return date is
      TYPE MonthDays IS TABLE OF ss_days_details%ROWTYPE;
      TabMonthdays MonthDays;
  begin
      select D_DATE ,D_DD ,D_MM ,D_YYYY ,D_MON ,D_DAY ,WK_OF_YEAR BULK COLLECT INTO TabMonthDays  from (
          select D_DATE ,D_DD ,D_MM ,D_YYYY ,D_MON ,D_DAY ,WK_OF_YEAR from selfservice.SS_DAYS_DETAILS where d_mm = substr(param_yyyymm,5,2) 
          and d_yyyy = substr(param_yyyymm,1,4) and d_date not in 
            (select holiday from selfservice.ss_holidays where yyyymm = param_yyyymm )
          order by d_date desc ) 
        where rownum < c_5_working_days order by d_date ;
      return TabMonthDays(1).d_date;
      Exception
      When others then
        insert_dates(substr(param_yyyymm,1,4));
        return null;
  end Get_assign_shift_run_date;
END NU_EMP;


/
