create or replace Package Body "DMS"."PKG_DMS_GENERAL" As

    /*get_cabin_val*/
    Function fn_get_cabin_val (
        p_deskid        Varchar2
    ) Return Varchar2 as
        v_cabin     Varchar2(1);
    Begin
        Select
            cabin
          Into v_cabin
          From
            dm_deskmaster
         Where
            Trim(deskid) = Trim(p_deskid);
        Return v_cabin;    
    End fn_get_cabin_val;
    
    /*get_emp_name*/
    Function fn_get_emp_name (
        p_empno        Varchar2
    ) Return Varchar2 as
        v_name     Varchar2(100);
    Begin
        Select
            initcap(name)
          Into v_name
          From
            ss_emplmast
         Where
            Trim(empno) = Trim(p_empno);
        Return v_name;    
    End fn_get_emp_name;
    
    
    /*get_assettype*/
    Function fn_get_assettype (
        p_assetid Varchar2
    ) Return Varchar2 As
        v_assettype Varchar2(2);
    Begin
        Select
            assettype
          Into v_assettype
          From
            dm_assetcode
         Where
            Trim(barcode) = Trim(p_assetid);
        Return v_assettype;
    End fn_get_assettype;
    
    /*get_asset_count_4_type*/
    Function fn_get_asset_count_4_type (
        p_deskid    Varchar2,
        p_assettype Varchar2
    ) Return Varchar2 As
        v_asset_count Number;
    Begin
        v_asset_count := 0;
        Select
            Count(assetid)
          Into v_asset_count
          From
            dm_deskallocation da,
            dm_assetcode      ac
         Where
               Trim(da.assetid) = Trim(ac.barcode)
               And ac.assettype = p_assettype
               And da.deskid    = p_deskid;
        Return v_asset_count;
    End fn_get_asset_count_4_type;
    
    /*get icon by asset type*/
    Function fn_get_icon_by_asset_type (
        p_assettype Varchar2
    ) Return Varchar2 As
        v_icon_name     Varchar2(20);
    Begin
        if p_assettype = 'EM' then
            v_icon_name := 'fas fa-user';
        else
          Select
            iconname
         Into 
            v_icon_name
          From
            dm_assettype da
         Where
            trim(da.asset_type) = trim(p_assettype);    
        End if;
        
        Return v_icon_name;
    End fn_get_icon_by_asset_type;
    
    /*get icon by asset id*/
    Function fn_get_icon_by_asset (
        p_assetid   Varchar2
    ) Return Varchar2 As
        v_assettype     Varchar2(2);
        v_icon_name     Varchar2(20);
    Begin        
        v_assettype := fn_get_assettype(trim(p_assetid));
        v_icon_name := fn_get_icon_by_asset_type(v_assettype);
        
        Return v_icon_name;
    End fn_get_icon_by_asset;
    
    /*get employee assign costcode*/
    Function fn_get_assign_costcode (
        p_empno     Varchar2
    ) Return Varchar2 as
        v_assign     Varchar2(4);
    Begin        
        Select
            assign
        Into 
            v_assign
        From
            ss_emplmast
        Where
            upper(empno) = upper(p_empno);
        Return v_assign;
    
    End fn_get_assign_costcode;
    
    Function get_desk_employee (
        p_deskid     Varchar2
    ) Return Varchar2 as
        v_employee     Varchar2(60);
    Begin        
        Select Distinct              
          nvl(du.empno,'NA') || ' - ' || 
          nvl(initcap(e.name),'NA') || ' [ ' || 
          nvl(du.costcode,'NA') || ' ]' AS Employee 
        Into
          v_employee
        From
          dm_deskallocation da,
          dm_usermaster     du,
          ss_emplmast        e
        Where
              Trim(da.deskid) = Trim(du.deskid)
              And upper(du.empno) = upper(e.empno)
              And Trim(da.deskid) = Trim(p_deskid)
              And rownum = 1;
        Return v_employee;    
    End get_desk_employee;
    
    Function get_desk_employee (
        p_deskid     Varchar2
    ) Return Varchar2 as
        v_employee     Varchar2(60);
    Begin        
        Select Distinct              
          nvl(du.empno,'NA') || ' - ' || 
          nvl(initcap(e.name),'NA') || ' [ ' || 
          nvl(du.costcode,'NA') || ' ]' AS Employee 
        Into
          v_employee
        From
          dm_deskallocation da,
          dm_usermaster     du,
          ss_emplmast        e
        Where
              Trim(da.deskid) = Trim(du.deskid)
              And upper(du.empno) = upper(e.empno)
              And Trim(da.deskid) = Trim(p_deskid)
              And rownum = 1;
        Return v_employee;    
    End get_desk_employee;
    
    Function get_last_desk (
        p_assetid     Varchar2
    ) Return Varchar2 as
        v_deskno     Varchar2(7);
      Begin
        select deskid into v_deskno from (
            select deskid, historydate, rownum rownumber from (
                select deskid, historydate from dm_assetmove_tran_history
                where assetid = p_assetid
                    and desk_flag = 'T'
                order by historydate desc) 
            ) where rownumber = 1;
        
        return v_deskno;
    end get_last_desk;
    
    Function get_desk_office (
        p_deskid     Varchar2
    ) Return Varchar2 as
        v_office    Varchar2(4);
      Begin
        Select 
            trim(Office) 
        into 
            v_office 
        from 
            dm_deskmaster
        where 
            deskid = p_deskid;
  
        return v_office;
    
    end get_desk_office;

End pkg_dms_general;

/
Grant Execute On "DMS"."PKG_DMS_GENERAL" To "TCMPL_APP_CONFIG";