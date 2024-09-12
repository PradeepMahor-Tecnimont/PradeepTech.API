Create Or Replace Package Body "IOT_DMS_QRY" As
   
   /* DESK MASETR */
   
   Function deskmaster_list_count
      Return Number as     
        v_count   number;
      Begin
        Select 
            count(*) into v_count 
        From 
            dm_deskmaster 
        Where 
            deskid not like 'H%';        
        return nvl(v_count, 0);    
    End deskmaster_list_count;
   
   Function deskmaster_list( 
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
      c        Sys_Refcursor;     
     Begin
       Open c For
        select 
            *
        from 
            dm_deskmaster
        where 
            deskid not like 'H%'
        order by 
            deskid;
       Return c;     
   End deskmaster_list;
   
   Function deskmaster_detail(
      p_deskid      Varchar2,
      
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor as
     c        Sys_Refcursor;     
     Begin
       Open c For
        select 
            *
        from 
            dm_deskmaster
        where 
            deskid not like 'H%'
        order by 
            deskid;
       Return c;
    End deskmaster_detail;
    
    Function bay_list
        Return Sys_Refcursor As
        c     Sys_Refcursor;       
      Begin        
        Open c For
            Select
                bay_key_id As data_value_field,
                bay_desc As data_text_field
            From
                dm_desk_bays           
            Order By
                bay_desc;
        Return c;
    End bay_list;
    
    Function workarea_list
        Return Sys_Refcursor As
        c     Sys_Refcursor;       
      Begin        
        Open c For
            Select
                area_key_id As data_value_field,
                area_desc As data_text_field
            From
                dm_desk_areas           
            Order By
                area_desc;
        Return c;
    End workarea_list;
    
End IOT_DMS_QRY;


/

  GRANT EXECUTE ON "DMS"."IOT_DMS_QRY" TO "TCMPL_APP_CONFIG";