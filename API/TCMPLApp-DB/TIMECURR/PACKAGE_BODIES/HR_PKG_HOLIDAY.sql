--------------------------------------------------------
--  DDL for Package Body HR_PKG_HOLIDAY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."HR_PKG_HOLIDAY" as
  
  procedure polupate_weekend_holidays (
        p_yyyy          Varchar2,
        p_success       Out             Varchar2,
        p_message       Out             Varchar2
    ) as
    v_startdate date;
    v_exists    number := 0;   
    v_srno      number;
  begin
    for r_holidays in (
        with dts as (
            select 
                to_date(p_yyyy || '-01-01', 'yyyy-mm-dd') + rownum - 1 holiday,   
                to_char(to_date(p_yyyy || '-01-01', 'yyyy-mm-dd') + rownum - 1, 'DY') weekday,
                to_char((to_date(p_yyyy || '-01-01', 'yyyy-mm-dd') + rownum - 1), 'yyyymm') yyyymm
                from dual
              connect by level <= 366
        ) 
        select 
            * 
        from 
            dts
        where 
            to_char(holiday, 'fmday') = 'sunday' or 
            to_char(holiday, 'fmday') = 'saturday'
      )
    loop
       select count(holiday) into v_exists from holidays where holiday = r_holidays.holiday;
       if v_exists = 0 then
            select max(srno) + 1 into v_srno from holidays;
            insert into holidays (
                srno, holiday, yyyymm, weekday           
            )
            values(
                v_srno, r_holidays.holiday, r_holidays.yyyymm, r_holidays.weekday
            ); 
       end if;       
    end loop;
    p_success   := 'OK';
    p_message   := 'Weekend holiday pupulated successfully';
    Commit;
   exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
  end polupate_weekend_holidays;
  
  procedure add_holiday (
        p_holiday       date,               
        p_description   varchar2,      
        p_success       out             varchar2,
        p_message       out             varchar2
    ) as  
    v_exists    number := 0;
    v_disabled  number := 0;
    v_srno      number;
  begin
    select max(srno) + 1 into v_srno from holidays;
    select count(yyyymm) into v_exists from holidays where holiday = p_holiday;
    if v_exists = 0 then
        insert into holidays (
            srno, holiday, yyyymm, weekday, description             
        )
        values(
            v_srno, p_holiday, to_char(to_date(p_holiday), 'yyyymm'), 
            to_char(to_date(p_holiday), 'Dy'), p_description
        );    
        p_success   := 'OK';
        p_message   := 'Holiday added successfully';
    else
        p_success   := 'KO';
        p_message   := 'Holiday already exists';         
    end if;
    Commit;
  exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
  end add_holiday;

  procedure update_holiday(
        p_srno          number,
        p_holiday       date,                
        p_description   varchar2,      
        p_success       out             varchar2,
        p_message       out             varchar2
    ) as
  begin
    update holidays
        set holiday = p_holiday,
            yyyymm = to_char(to_date(p_holiday), 'yyyymm'), 
            weekday = to_char(to_date(p_holiday), 'Dy'),
            description = p_description
    where srno = p_srno;
    p_success   := 'OK';
    p_message   := 'Holiday updated successfully';

    Commit;
  exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
  end update_holiday;

  procedure delete_holiday (
        p_srno          number,
        p_success       out             varchar2,
        p_message       out             varchar2
    ) as
  begin
    delete from holidays where srno = p_srno;
    p_success   := 'OK';
    p_message   := 'Holiday deleted successfully';

    Commit;
  exception
        When Others Then
            p_success   := 'KO';
            p_message   := 'Err - ' || Sqlcode || ' - ' || Sqlerrm;
  end delete_holiday;

end hr_pkg_holiday;

/
