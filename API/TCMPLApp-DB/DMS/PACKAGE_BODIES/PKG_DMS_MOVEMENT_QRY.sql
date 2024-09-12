--------------------------------------------------------
--  DDL for Package Body PKG_DMS_MOVEMENT_QRY
--------------------------------------------------------

Create Or Replace Package Body DMS.PKG_DMS_MOVEMENT_QRY As

    Function fn_movement_source_desk (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c            Sys_Refcursor;
        pivot_clause Varchar2(1000);
    Begin
        Select
            Listagg('''' || assettype || '''' || ' as "' || assettype || '"',
                    ', ') Within Group(
             Order By
                orderby
            )
          Into pivot_clause
          From
            dm_movement_assettype;

        Open c For 'select t.*, pkg_dms_general.fn_get_cabin_val(deskid) cabin, pkg_dms_general.fn_get_emp_name(empno) name from
            (select * from (
                    with t_assettype as (
                        select assettype from dm_movement_assettype Order By orderby
                    ),
                    t_data as (
                        select deskid, empno, costcode, assettype,
                            pkg_dms_general.fn_get_asset_count_4_type(deskid, assettype) cnt from
                            (select da.deskid, du.empno, du.costcode,
                                pkg_dms_general.fn_get_assettype(da.assetid) assettype
                            from dm_deskallocation da, dm_usermaster du
                            where trim(da.deskid) = trim(du.deskid)
                            and trim(da.deskid) not in (select trim(deskid) from dm_deskmaster where isblocked = 1)
                         )
                    )
                    select b.deskid, b.empno, b.costcode, a.assettype, b.cnt
                    from t_assettype a, t_data b
                    where a.assettype = b.assettype(+) order by b.deskid, b.empno, b.costcode, a.assettype
                    ) pivot (count(cnt) for assettype in (' || pivot_clause || '))
                where deskid is not null order by deskid) t';
        Return c;
    End fn_movement_source_desk;

    Function fn_movement_target_desk (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c            Sys_Refcursor;
        pivot_clause Varchar2(1000);
    Begin
        Select
            Listagg('''' || assettype || '''' || ' as "' || assettype || '"',
                    ', ') Within Group(
             Order By
                orderby
            )
          Into pivot_clause
          From
            dm_movement_assettype;

        Open c For 'select t.*, pkg_dms_general.fn_get_cabin_val(deskid) cabin, pkg_dms_general.fn_get_emp_name(empno) name from
            (select * from (
                    with t_assettype as (
                        select assettype from dm_movement_assettype Order By orderby
                    ),
                    t_data as (
                        select deskid, empno, costcode, assettype,
                            pkg_dms_general.fn_get_asset_count_4_type(deskid, assettype) cnt from
                            (select da.deskid, du.empno, du.costcode,
                                pkg_dms_general.fn_get_assettype(da.assetid) assettype
                            from dm_deskallocation da, dm_usermaster du
                            where trim(da.deskid) = trim(du.deskid) and
                                  trim(da.deskid) not in (select trim(deskid) from dm_deskmaster where isblocked = 1) )
                    )
                    select b.deskid, b.empno, b.costcode, a.assettype, b.cnt
                    from t_assettype a, t_data b
                    where a.assettype = b.assettype(+) order by b.deskid, b.empno, b.costcode, a.assettype
                    ) pivot (count(cnt) for assettype in (' || pivot_clause || '))
                where deskid is not null order by deskid) t';
        Return c;
    End fn_movement_target_desk;

    Function fn_movement_request_list (
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_generic_search Varchar2 Default Null,
        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c              Sys_Refcursor;
        v_empno        Varchar2(5);
        v_is_secretary Number;
        v_query        Varchar2(4000);
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        Select
            Count(*)
          Into v_is_secretary
          From
            dm_secretary
         Where
            empno = v_empno;

        v_query := 'Select
                    *
                    From
                        (Select
                            movereqnum,
                            trunc(movereqdate) movereqdate,
                            max(it_apprl) it_apprl,
                            max(it_cord_apprl) it_cord_apprl,
                            Row_Number() Over (Order By movereqnum Desc) row_number,
                            Count(*) Over ()                             total_row
                         From
                            dm_assetmove_tran
                         Where
                            (it_cord_apprl is null or it_cord_apprl = 0) ';
        If v_is_secretary > 0 Then
            v_query := v_query
                       || ' And substr(trim(movereqnum),1,5) = '
                       || v_empno;
        End If;

        v_query := v_query
                   || 'Group by
                                    movereqnum,
                                    trunc(movereqdate)
                                Order By
                                    trunc(movereqdate) desc)
                            Where
                                row_number Between (nvl('
                   || p_row_number
                   || ', 0) + 1) And (nvl('
                   || p_row_number
                   || ', 0) + '
                   || p_page_length
                   || ')
                            Order By
                                movereqdate desc';

        Open c For v_query;

        Return c;
    End fn_movement_request_list;


    Function fn_selected_source_desk_list (
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_session_id Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
           Select
              sid,
              desk_id,
              asset_id,
              category,
              assettype,
              name,
              iconname
            From
              (
              Select
                  ds.sid                                    As sid,
                  ds.deskid                                 As desk_id,
                  da.assetid                                As asset_id,
                  'A'                                       As category,
                  pkg_dms_general.fn_get_assettype(
                      da.assetid
                  )                                         As assettype,
                  dc.model                                  As name,
                  pkg_dms_general.fn_get_icon_by_asset(
                      da.assetid
                  )                                         As iconname
                From
                  dm_deskallocation da,
                  dm_sourcedesk ds,
                  dm_assetcode  dc
               Where
                  trim(da.deskid) = trim(ds.deskid)
                  And trim(da.assetid) = trim(dc.barcode)
                  And Trim(ds.sid) = Trim(p_session_id)
                  And Trim(da.assetid) not in (select trim(assetid) from dm_assetadd where Trim(unqid) = Trim(p_session_id))
              Union
              Select Distinct
                  ds.sid                                        As sid,
                  ds.deskid                                     As desk_id,
                  du.empno                                      As asset_id,
                  'E'                                           As category,
                  'EM'                                          As assettype,
                  pkg_dms_general.fn_get_emp_name(
                      du.empno
                  )                                             As name,
                  pkg_dms_general.fn_get_icon_by_asset_type(
                     'EM'
                  )                                             As iconname
                From
                  dm_sourcedesk ds,
                  dm_usermaster du
               Where
                  trim(du.deskid) = trim(ds.deskid)
                  And trim(du.deskid) = trim(ds.deskid)
                  And Trim(ds.sid) = p_session_id
                  And Trim(du.empno) not in (select distinct trim(empno) from dm_assetadd where Trim(unqid) = Trim(p_session_id))
              /*Select Distinct
                  da.unqid                                      As sid,
                  ds.deskid                                     As desk_id,
                  da.empno                                      As asset_id,
                  'E'                                           As category,
                  'EM'                                          As assettype,
                  pkg_dms_general.fn_get_emp_name(
                      da.empno
                  )                                             As name,
                  pkg_dms_general.fn_get_icon_by_asset_type(
                     'EM'
                  )                                             As iconname
                From
                  dm_assetadd   da,
                  dm_sourcedesk ds
               Where
                      Trim(ds.sid) = Trim(da.unqid)
                      And trim(da.deskid) = trim(ds.deskid)
                     And Trim(da.unqid) = p_session_id*/
              )
        Order By
           sid,
           desk_id,
           category,
           assettype,
           asset_id;
        Return c;
    End fn_selected_source_desk_list;

    Function fn_selected_target_desk_list (
        p_person_id  Varchar2,
        p_meta_id    Varchar2,
        p_session_id Varchar2
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
           Select
              sid,
              desk_id,
              asset_id,
              category,
              assettype,
              name,
              iconname
            From
              (
                 Select
                      dt.sid                                    As sid,
                      dt.deskid                                 As desk_id,
                      nvl(da.assetid, '')                       As asset_id,
                      'A'                                       As category,
                      pkg_dms_general.fn_get_assettype(
                          da.assetid
                      )                                         As assettype,
                      dc.model                                  As name,
                      nvl(pkg_dms_general.fn_get_icon_by_asset(
                          da.assetid
                      ), '')                                         As iconname
                    From
                      dm_deskallocation da,
                      dm_targetdesk dt,
                      dm_assetcode  dc
                   Where
                      trim(da.deskid(+)) = trim(dt.deskid)
                      And trim(da.assetid) = trim(dc.barcode(+))
                      And Trim(dt.sid) = p_session_id
                      And Trim(da.assetid) not in (select trim(assetid) from dm_assetadd where Trim(unqid) = Trim(p_session_id))
                      And trim(da.assetid) not in (Select trim(targetdesk) from dm_assetmove_tran where trim(movereqnum) = Trim(p_session_id) And empno <> 'ABCDE')
              Union
              Select Distinct
                  dt.sid                                        As sid,
                  dt.deskid                                     As desk_id,
                  du.empno                                      As asset_id,
                  'E'                                           As category,
                  'EM'                                          As assettype,
                  pkg_dms_general.fn_get_emp_name(
                      du.empno
                  )                                             As name,
                  pkg_dms_general.fn_get_icon_by_asset_type(
                     'EM'
                  )                                             As iconname
                From
                  dm_deskallocation da,
                  dm_targetdesk dt,
                  dm_usermaster du
               Where
                     trim(da.deskid) = trim(dt.deskid)
                     And trim(da.deskid) = trim(du.deskid)
                     And Trim(dt.sid) = p_session_id
                     And Trim(du.empno) not in (select distinct trim(empno) from dm_assetadd where Trim(unqid) = Trim(p_session_id))
              )
        Order By
           sid,
           desk_id,
           category,
           assettype,
           asset_id;

        /*Open c For Select
                                  dt.sid,
                                  Trim(dt.deskid)  deskid,
                                  Trim(da.assetid) assetid
                                From
                                  dm_targetdesk dt,
                                  dm_assetadd   da
                    Where
                           Trim(dt.deskid) = Trim(da.deskid(+))
                          And Trim(dt.sid) = Trim(da.unqid)
                          And Trim(dt.sid) = p_session_id
                    Order By
                       Trim(dt.deskid);


               select ds.sid, trim(ds.deskid) deskid, trim(dd.assetid) assetid
from dm_sourcedesk ds, dm_deskallocation dd, dm_movement_assettype dma
where trim(ds.deskid) = trim(dd.deskid(+)) and
trim(ds.deskid) = trim(dd.deskid) and
pkg_dms_general.fn_get_assettype(dd.assetid) = dma.assettype and
trim(ds.sid) = '800498864'
Order by trim(ds.deskid), dma.orderby, trim(dd.assetid)
               */
        Return c;
    End fn_selected_target_desk_list;

    Function fn_movement_assignment_list(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_session_id        Varchar2
    ) Return Sys_Refcursor as
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        Open c For
            Select
                trim(movereqnum)                       As sid,
                currdesk                               As curr_deskid,
                targetdesk                             As deskid,
                empno                                  As empno,
                pkg_dms_general.fn_get_emp_name(empno) As empname,
                nvl(assetflag,0)                       As is_asset,
                nvl(empflag,0)                         As is_employee
            From
                dm_assetmove_tran
            where
                trim(movereqnum) = p_session_id
                And empno <> 'ABCDE'
            order by
                currdesk;
        Return c;

    end fn_movement_assignment_list;

    Function fn_desk_asset_list (
        p_person_id     Varchar2,
        p_meta_id       Varchar2,
        p_session_id    Varchar2,
        p_deskid        Varchar2,
        p_category      Varchar2,
        p_asset_flag     Number default 0
    ) Return Sys_Refcursor As
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;

       If p_category = 'T' Then
            If p_asset_flag = 1 then
                Open c For
                    Select
                      trim(da.unqid)                            As sid,
                      da.deskid                                 As desk_id,
                      da.assetid                                As asset_id,
                      'A'                                       As category,
                      pkg_dms_general.fn_get_assettype(
                          da.assetid
                      )                                         As assettype,
                      dc.model                                  As name,
                      pkg_dms_general.fn_get_icon_by_asset(
                          da.assetid
                      )                                         As iconname
                   From
                      dm_assetadd   da,
                      dm_assetcode  dc
                   Where
                      Trim(da.assetid) = Trim(dc.barcode)
                      And Trim(da.unqid) = Trim(p_session_id)
                      And Trim(da.deskid) = Trim(p_deskid)
                   Order By
                       assettype,
                       asset_id;
            Else
                Open c For
                    select
                          Trim(p_session_id)                        As sid,
                          da.deskid                                 As desk_id,
                          da.assetid                                As asset_id,
                          'A'                                       As category,
                          pkg_dms_general.fn_get_assettype(
                              da.assetid
                          )                                         As assettype,
                          dc.model                                  As name,
                          pkg_dms_general.fn_get_icon_by_asset(
                              da.assetid
                          )                                         As iconname
                    from
                        dm_deskallocation da, dm_assetcode  dc
                    where
                        Trim(da.assetid) = Trim(dc.barcode)
                        And Trim(da.deskid) = Trim(p_deskid)
                    Order By
                        assettype,
                        asset_id;
            End If;
       Else
        Open c For
            select
                  Trim(p_session_id)                        As sid,
                  da.deskid                                 As desk_id,
                  da.assetid                                As asset_id,
                  'A'                                       As category,
                  pkg_dms_general.fn_get_assettype(
                      da.assetid
                  )                                         As assettype,
                  dc.model                                  As name,
                  pkg_dms_general.fn_get_icon_by_asset(
                      da.assetid
                  )                                         As iconname
            from
                dm_deskallocation da, dm_assetcode  dc
            where
                Trim(da.assetid) = Trim(dc.barcode)
                And Trim(da.deskid) = Trim(p_deskid)
            Order By
                assettype,
                asset_id;
       End If;

       Return c;
    End fn_desk_asset_list;

    Function fn_flexi_to_dms_list(
        p_person_id         Varchar2,
        p_meta_id           Varchar2,
        p_generic_search    Varchar2 Default Null,        
        p_row_number        Number,
        p_page_length       Number
    ) Return Sys_Refcursor as
        c       Sys_Refcursor;
        v_empno Varchar2(5);
        e_employee_not_found Exception;
        Pragma exception_init ( e_employee_not_found, -20001 );
      begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'errrr' Then
            Raise e_employee_not_found;
            Return Null;
        End If;
        
        Open c For
            Select *
              From (                
                select 
                    keyid,
                    created_on,
                    deskid,
                    previous_area_id,
                    area_id,                    
                    isvisible,
                    Row_Number() Over (Order By keyid) row_number,
                    Count(*) Over ()                   total_row
                from 
                    dm_desk_flexi_to_dms 
                where 
                    isvisible = 1 
                order by 
                    deskid        
             )
             Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        
        Return c;
    End fn_flexi_to_dms_list;
    
End pkg_dms_masters_qry;
/
Grant Execute On DMS.PKG_DMS_MOVEMENT_QRY To tcmpl_app_config;