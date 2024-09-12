create or replace package body tcmpl_afc.pkg_bg_common as

   function fn_bg_get_new_ref_num(
        p_projnum        varchar2
  ) return varchar2 as
        v_refnum_new     varchar2(11);
        v_new_counter    varchar2(3);
  begin
    if p_projnum is not null then
        select           
            substr('00'|| to_char(nvl(max(substr(refnum,8,3)),0) + 1), -3)
        into 
            v_new_counter 
        from 
            bg_main_master 
        where 
            trim(projnum) = trim(p_projnum);
        
        v_refnum_new := 'BG' || trim(p_projnum) || v_new_counter;
    else
        v_refnum_new := '';
    end if;
    
    return v_refnum_new;
    
    exception
       when others then
           return '';
  end fn_bg_get_new_ref_num;
  
  function fn_bg_get_new_amendment_num(
        p_refnum            varchar2
  ) return varchar2 as
        v_amendment_new     varchar2(3);
  begin
      select 
        case when max(amendmentnum) is null then '001'
            else substr('00'||to_char(max(amendmentnum) + 1), -3)
        end into v_amendment_new
      from 
        bg_main_amendments        
      where 
        refnum = p_refnum;
      return v_amendment_new;
    exception
       when others then
           return '000';
  end fn_bg_get_new_amendment_num;

  function fn_bg_get_last_amendment_num(
        p_refnum            varchar2
  ) return varchar2 as
        v_amendment_last    varchar2(3);
  begin
      select 
        nvl(max(amendmentnum),'000') into v_amendment_last
      from 
        bg_main_amendments        
      where 
        refnum = p_refnum;
      return v_amendment_last;
      
    exception
       when others then
           return '000';
  end fn_bg_get_last_amendment_num;
  
  function fn_bg_get_bank_name(
        p_bankid        varchar2
  ) return varchar2 as
    v_bank_name         varchar2(100);       
  begin
    select
        bankname into v_bank_name
    from 
        bg_bank_mast 
    where
        bankid = p_bankid;
    return v_bank_name;
    
    exception
       when others then
           return '';
  end fn_bg_get_bank_name;
  
  function fn_bg_get_company_name(
        p_compid        varchar2
  ) return varchar2 as
        v_company_name         varchar2(75);       
  begin
    select
        compdesc into v_company_name
    from 
        bg_company_mast 
    where
        compid = p_compid;
    return v_company_name;
    
    exception
       when others then
           return '';
  end fn_bg_get_company_name;
  
  function fn_bg_get_currency_name(
        p_currid        varchar2
  ) return varchar2 as
        v_currency_name         varchar2(50);
  begin
    select
        currdesc into v_currency_name
    from 
        bg_currency_mast 
    where
        currid = p_currid;
    return v_currency_name;
    
    exception
       when others then
           return '';      
  end fn_bg_get_currency_name;
  
  function fn_bg_get_guarantee_type(
        p_guaranteetypeid        varchar2
  ) return varchar2 as
        v_guarantee_type         varchar2(50);
  begin
    select
        guaranteetype into v_guarantee_type
    from 
        bg_guarantee_type_mast 
    where
        guaranteetypeid = p_guaranteetypeid;
    return v_guarantee_type;
    
  exception
       when others then
           return '';      
  end fn_bg_get_guarantee_type;
  
  function fn_bg_get_issued_by_name(
        p_issuedbyid        varchar2
  ) return varchar2 as
        v_issued_by_name         varchar2(100);
  begin
    select
        issuedby into v_issued_by_name
    from 
        bg_issued_by_mast 
    where
        issuedbyid = p_issuedbyid;
    return v_issued_by_name;
    
  exception
       when others then
           return ''; 
  end fn_bg_get_issued_by_name;
  
  function fn_bg_get_issued_to_name(
        p_issuedtoid        varchar2
  ) return varchar2 as
        v_issued_to_name         varchar2(100);
      begin
        select
            issuedto into v_issued_to_name
        from 
            bg_issued_to_mast 
        where
            issuedtoid = p_issuedtoid;
        return v_issued_to_name;
        
      exception
           when others then
               return '';
  end fn_bg_get_issued_to_name;
  
  function fn_bg_get_project_name(
        p_projnum           varchar2
  ) return varchar2 as
        v_project_name         varchar2(100);
      begin
        select
            distinct name into v_project_name
        from 
            vu_projmast 
        where
            substr(projno,1,5) = substr(p_projnum,1,5);
        return v_project_name;
        
      exception
           when others then
               return '';  
  end fn_bg_get_project_name;
  
  function fn_bg_get_vendor_name(
        p_vendorid        varchar2
  ) return varchar2 as
        v_vendor_name         varchar2(75);
      begin
        select
            vendorname into v_vendor_name
        from 
            bg_vendor_mast 
        where
            vendorid = p_vendorid;
        return v_vendor_name;
        
      exception
           when others then
               return '';  
  end fn_bg_get_vendor_name;
  
  function fn_bg_get_vendor_type(
        p_vendortypeid        varchar2
  ) return varchar2 as 
       v_vendor_type         varchar2(75);
      begin
        select
            vendortype into v_vendor_type
        from 
            bg_vendor_type_mast 
        where
            vendortypeid = p_vendortypeid;
        return v_vendor_type;
        
      exception
           when others then
               return '';
  end fn_bg_get_vendor_type;
  
  function fn_bg_get_acceptable(
        p_acceptableid        varchar2
  ) return varchar2 as
        v_acceptable     varchar2(75);
      begin
        select
            accetablename into v_acceptable
        from 
            bg_acceptable_mast 
        where
            acceptableid = p_acceptableid;
        return v_acceptable;
        
      exception
           when others then
               return '';
  end fn_bg_get_acceptable;
  
  function fn_bg_get_empname(
        p_empno             varchar2
  ) return varchar2 as
        v_name  vu_emplmast.name%Type;
    begin
        Select
            name
        Into v_name
        From
            vu_emplmast
        Where
            empno = p_empno;

        Return v_name;
    Exception
        When Others Then
            Return Null;
  end fn_bg_get_empname;
  
  function fn_bg_get_email(
        p_empno             varchar2
  ) return varchar2 as
        v_email  vu_emplmast.email%Type;
    begin
        Select
            email
        Into v_email
        From
            vu_emplmast
        Where
            empno = p_empno;

        Return v_email;
    Exception
        When Others Then
            Return Null;
  end fn_bg_get_email;
  
  function fn_bg_recipient_list(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,
        p_row_number         Number,
        p_page_length        Number,        
        p_projno             varchar2,
        p_compid             varchar2
  ) return sys_refcursor as
        c                  Sys_Refcursor;        
    begin
        Open c for
            select 
                grpname, 
                empno, 
                name, 
                email,
                Row_Number() Over (Order By grpname Desc, empno Desc)   row_number,
                Count(*) Over ()                                        total_row
            from          
                (select    
                    distinct
                    'PM' grpname, 
                    prjmngr empno, 
                    initcap(pkg_bg_common.fn_bg_get_empname(prjmngr)) name, 
                    pkg_bg_common.fn_bg_get_email(prjmngr) email 
                from 
                    vu_projmast
                where 
                    proj_no = p_projno
                UNION
                select 
                    'AFC Payble' grpname, 
                    empno, 
                    initcap(pkg_bg_common.fn_bg_get_empname(empno)) name, 
                    pkg_bg_common.fn_bg_get_email(empno) email 
                from 
                    bg_payable_mast
                where 
                    compid = p_compid and 
                    isvisible = 1 and 
                    isdeleted = 0
                UNION
                select 
                    'PPC' grpname, 
                    empno, 
                    initcap(pkg_bg_common.fn_bg_get_empname(empno)) name, 
                    pkg_bg_common.fn_bg_get_email(empno) email 
                from 
                    bg_proj_contl_mast
                where 
                    compid = p_compid and 
                    isvisible = 1 and 
                    isdeleted = 0
                UNION
                select 
                    'projdir' grpname, 
                    empno, 
                    initcap(pkg_bg_common.fn_bg_get_empname(empno)) name, 
                    pkg_bg_common.fn_bg_get_email(empno) email 
                from 
                    bg_proj_dir_mast
                where 
                    compid = p_compid and
                    isvisible = 1 and 
                    isdeleted = 0)
            order by grpname, empno;
        Return c;
  end fn_bg_recipient_list;
  
  function fn_bg_get_bank_occur_count(
        p_bankid        varchar2
  ) return number as
        v_count Number := 0;
    begin
        select 
            count(bankid) 
        Into
            v_count
        from 
            bg_main_master 
        where 
            bankid = p_bankid;
        return v_count;
  end fn_bg_get_bank_occur_count;
  
  
end pkg_bg_common;