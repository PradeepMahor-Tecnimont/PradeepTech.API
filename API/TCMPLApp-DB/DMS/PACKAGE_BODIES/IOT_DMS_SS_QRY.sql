Create Or Replace Package Body "IOT_DMS_SS_QRY" As

    Function is_asset_2_home_confirmed(
        p_empno     varchar2,
        p_deskid    varchar2
      ) Return number as
        v_confirm   number;
      Begin
        select 
            distinct dahr.confirmed into v_confirm
        from 
            dm_asset_home_request dahr
        where 
            dahr.deskid = p_deskid and 
            dahr.empno = p_empno;
        return nvl(v_confirm, 0);    
    End is_asset_2_home_confirmed;
    
    Function is_asset_in_tbl(
        p_assetid Varchar2
      ) Return Number As
        v_retval Number := 0;
        v_count  Number := 0;
      Begin

      Select 
        Count(*) Into v_count
      From 
        dm_asset_home_request a
      Where 
        a.assetid = p_assetid;
    
      If v_count != 0 Then 
        v_retval := 1;       
        Return nvl(v_retval, 0);         
      End If;
    
      /*Select Count(*) Into v_count
      From dm_orphan_asset a
      Where a.assetid = p_assetid;
    
      If v_count != 0 Then 
      v_retval := 2;       
      Return nvl(v_retval, 0);         
      End If;*/
    
      Return nvl(v_retval, 0);
   End is_asset_in_tbl;
   
   function is_request_exists(
      p_deskid      Varchar2,
      p_empno       Varchar2
   ) Return Varchar2
   As
      v_unqid   varchar2(20);
   Begin
    Select distinct unqid into v_unqid
    from
        (Select 
            distinct a.unqid 
        From 
            dm_asset_home_request a
        Where 
            a.deskid = p_deskid and
            a.empno = p_empno
        union all
        Select 
            distinct b.unqid 
        From 
            dm_orphan_asset b
        Where 
            b.deskid = p_deskid and
            b.empno = p_empno);
       return v_unqid;
   End is_request_exists;
   
   Function get_desk_asset_details(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_empno       Varchar2,

      p_row_number  Number,
      p_page_length Number

   ) Return Sys_Refcursor As
      c                    Sys_Refcursor;
      v_empno              Varchar2(5);
      e_employee_not_found Exception;
      Pragma exception_init(e_employee_not_found, -20001);
   Begin
      /*
      v_empno := SelfService.get_empno_from_meta_id(p_meta_id);
           If v_empno = 'ERRRR' Then
               Raise e_employee_not_found;
               Return Null;
           End If;
         
      */

      Open c For
         Select iot_dms_ss_qry.is_request_exists(deskid, empno) unqid,
                          empno,
                          deskid,
                          assetid,
                          asset_type,
                          description,
                          istaking2home,
                          requestconfirm,
                          row_number,                          
                          total_row,
                          sum(istaking2home) Over () As home_count
           From (
                   Select du.empno As empno,
                          du.deskid As deskid,
                          dda.assetid As assetid,
                          da.assettype As asset_type,
                          da.model As description,
                          IOT_DMS_SS_QRY.is_asset_in_tbl(dda.assetid) As istaking2home,
                          iot_dms_ss_qry.is_asset_2_home_confirmed(du.empno, du.deskid) requestconfirm,
                          Row_Number() Over (Order By du.deskid Desc) As row_number,
                          Count(*) Over () As total_row
                     From dm_usermaster du,
                          dm_deskallocation dda,
                          dm_assetcode da,
                          dm_sub_assettype dsa
                    Where du.deskid = dda.deskid
                      And Trim(dda.assetid) = Trim(da.barcode)
                      And da.sub_asset_type = dsa.sub_asset_type
                      And du.empno = p_empno
                    Order by dsa.sort_order asc
                )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
      Return c;
   End get_desk_asset_details;

   /* Get oraphan assets request list */
   function get_orphan_request_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c             Sys_Refcursor; 
   Begin
      Open c for
      select * from    
          (Select unqid,
                 empno,
                 name,
                 deskid,                          
                 Row_Number() Over (Order By unqid Desc) As row_number,
                 Count(*) Over () As total_row
          From (
                   Select 
                        distinct doa.unqid,
                        doa.empno,
                        e.name,
                        doa.deskid
                   From 
                        dm_orphan_asset doa,
                        ss_emplmast e
                   Where 
                        doa.empno = e.empno and
                        doa.confirmed = 0                                  
                   Order By 
                        doa.deskid
                ))
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_orphan_request_list;
   
   /* Get oraphan assets request detail */
   function get_orphan_request_detail(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_unqid       Varchar2,
      
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c                    Sys_Refcursor;      
   Begin
      Open c for
      select * from    
          (
            Select 
                doa.unqid,
                du.empno,
                e.name,
                du.deskid,
                dda.assetid,
                da.assettype As asset_type,
                da.model As description,                          
                Row_Number() Over (Order By du.deskid Desc) As row_number,
                Count(*) Over () As total_row
             From dm_usermaster du,
                dm_deskallocation dda,
                dm_assetcode da,
                dm_orphan_asset doa,
                ss_emplmast e,
                dm_sub_assettype dsa
            Where du.deskid = dda.deskid and
                doa.deskid = dda.deskid and
                trim(dda.assetid) = trim(da.barcode) and
                trim(doa.assetid) = trim(da.barcode) and
                da.sub_asset_type = dsa.sub_asset_type and
                du.empno = doa.empno and
                du.empno = e.empno and
                doa.unqid = p_unqid and
                doa.confirmed = 0
            Order by dsa.sort_order asc
          )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_orphan_request_detail;
   
   
   /* Get 2home assets request detail */
   function get_2home_request_detail(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_unqid       Varchar2,
      
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c             Sys_Refcursor;     
   Begin
        Open c for
          select * from 
           (
            Select 
                dah.unqid,
                du.empno As empno,
                du.deskid As deskid,
                dda.assetid As assetid,
                da.assettype As asset_type,
                da.model As description,                          
                Row_Number() Over (Order By du.deskid Desc) As row_number,
                Count(*) Over () As total_row
            From 
                dm_usermaster du,
                dm_deskallocation dda,
                dm_assetcode da,
                dm_asset_home_request dah,
                dm_sub_assettype dsa
            Where 
                du.deskid = dda.deskid and
                dah.deskid = dda.deskid and
                trim(dda.assetid) = trim(da.barcode) and
                trim(dah.assetid) = trim(da.barcode) and
                da.sub_asset_type = dsa.sub_asset_type and
                du.empno = dah.empno and                
                dah.unqid = p_unqid and
                dah.confirmed = 0
            Order by dsa.sort_order asc
           )
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_2home_request_detail;
    
   /* Get 2home assets request list */
   function get_2home_request_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c             Sys_Refcursor;      
   Begin
        Open c for
          select * from 
           (Select unqid,
                  empno,
                  name,
                  deskid,                          
                  Row_Number() Over (Order By unqid Desc) As row_number,
                  Count(*) Over () As total_row
           From (
                   Select 
                        distinct doa.unqid,
                        doa.empno As empno,
                        e.name,
                        doa.deskid As deskid
                   From 
                        dm_asset_home_request doa,
                        ss_emplmast e
                   Where 
                        doa.empno = e.empno and
                        doa.confirmed = 0                    
                   Order By 
                        doa.deskid
                ))
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_2home_request_list;
   
    /* Get 2home gatepass list */
   function get_2home_gatepass_list(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,

      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c             Sys_Refcursor;      
   Begin
        Open c for
          select * from 
           (Select unqid,
                  empno,
                  name,
                  deskid,                          
                  Row_Number() Over (Order By unqid Desc) As row_number,
                  Count(*) Over () As total_row
           From (
                   Select 
                        distinct doa.unqid,
                        doa.empno As empno,
                        e.name,
                        doa.deskid As deskid
                   From 
                        dm_asset_home_request doa,
                        ss_emplmast e
                   Where 
                        doa.empno = e.empno and
                        doa.confirmed = 1                    
                   Order By 
                        doa.deskid
                ))
          Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_2home_gatepass_list;
   
   /* Get 2home gatepass detail */
   function get_2home_gatepass_detail(
      p_person_id   Varchar2,
      p_meta_id     Varchar2,
      p_unqid       Varchar2,
      
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c             Sys_Refcursor;     
   Begin
        Open c for
          --select * from 
           --(
            Select 
                dah.unqid,
                du.empno As empno,
                du.deskid As deskid,
                dda.assetid As assetid,
                da.assettype As asset_type,
                da.model As description,                          
                Row_Number() Over (Order By du.deskid Desc) As row_number,
                Count(*) Over () As total_row
            From 
                dm_usermaster du,
                dm_deskallocation dda,
                dm_assetcode da,
                dm_asset_home_request dah,
                dm_sub_assettype dsa
            Where 
                du.deskid = dda.deskid and
                dah.deskid = dda.deskid and
                trim(dda.assetid) = trim(da.barcode) and
                trim(dah.assetid) = trim(da.barcode) and
                da.sub_asset_type = dsa.sub_asset_type and
                du.empno = dah.empno and                
                dah.unqid = p_unqid and
                dah.confirmed = 1
            Order by dsa.sort_order asc;
           --)
          --Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        return c;
   end get_2home_gatepass_detail;
End IOT_DMS_SS_QRY;