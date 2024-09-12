Create Or Replace Package Body "DMS"."PKG_DMS_NEWJOIN_QRY" As

    Function fn_dm_newjoin_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_start_date     Date     Default Null,
        p_end_date       Date     Default Null,

        p_row_number     Number,
        p_page_length    Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                *
            From
                (
                    Select
                        a.empno,
                        a.name emp_Name,                        
                        a.parent || ' : ' || (
                            Select
                                name
                            From
                                ss_costmast a
                            Where
                                a.costcode = a.parent
                        ) As Dept,
                        a.parent as parent,
                        a.doj Joining_Date,                       
                        Row_Number() Over (Order By a.doj desc) row_number,
                        Count(*) Over ()                    total_row
                    From
                        ss_emplmast    a
                    Where                        
                        a.newemp = 1
                        And a.doj < (sysdate - 1)
                        and (a.doj between nvl(p_start_date,sysdate) and nvl(p_end_date,sysdate))
                        and
                        (
                            upper(a.empno) Like '%' || upper(Trim(p_generic_search)) || '%' Or
                            upper(a.name) Like '%' || upper(Trim(p_generic_search)) || '%' 
                        )
                        
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;

    End;

    Function fn_xl_dm_dm_newjoin(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_start_date     Date     Default Null,
        p_end_date       Date Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                        a.empno,
                        a.name emp_Name,
                        a.emptype,
                        a.email,                      
                        a.assign || ' : ' || (
                            Select
                                name
                            From
                                ss_costmast b
                            Where
                                b.costcode = a.assign
                        ) As assign,                    
                        a.parent || ' : ' || (
                            Select
                                name
                            From
                                ss_costmast b
                            Where
                                b.costcode = a.parent
                        ) As Dept,
                        a.doj Joining_Date                       
                    From
                        ss_emplmast    a
                    Where                        
                        a.doj < (sysdate - 1)
                        and (a.doj between nvl(p_start_date,sysdate) and nvl(p_end_date,sysdate))                        
                    order by  a.doj desc;
        Return c;

    End;

End pkg_dms_newjoin_qry;
/
Grant Execute On "DMS"."PKG_DMS_NEWJOIN_QRY" To "TCMPL_APP_CONFIG";