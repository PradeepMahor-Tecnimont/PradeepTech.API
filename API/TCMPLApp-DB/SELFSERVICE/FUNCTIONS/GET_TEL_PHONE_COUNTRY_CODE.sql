--------------------------------------------------------
--  DDL for Function GET_TEL_PHONE_COUNTRY_CODE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SELFSERVICE"."GET_TEL_PHONE_COUNTRY_CODE" 
(
  param_phone_no in varchar2 
) return varchar2 as 
    
    v_country_name varchar2(100);
begin

    select country_name into v_country_name from (
      select country_name, length(trim(country_code))  
        from ss_isd_code_mast where trim(Country_Code) in (
        select country_code  from (
          select substr(param_phone_no,3,level) country_code , level as row_num
            from dual
            connect by level <= 5) ) order by 2 desc ) where rownum = 1;
      return v_country_name;
exception
  when others then  
      return 'ERR';
end get_tel_phone_country_code;


/
