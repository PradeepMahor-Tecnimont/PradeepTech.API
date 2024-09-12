--------------------------------------------------------
--  DDL for Package Body PKG_DMS_MASTERS_QRY
--------------------------------------------------------

Create Or Replace Package Body dms.pkg_dms_masters_qry As

    Function fn_deskmaster(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_generic_search       Varchar2 Default Null,
        p_office               Varchar2 Default Null,
        p_work_area_categories Varchar2 Default Null,
        p_work_area            Varchar2 Default Null,
        p_bay                  Varchar2 Default Null,
        p_is_blocked           Number   Default Null,
        p_floor                Varchar2 Default Null,
        p_cabin                Varchar2 Default Null,

        p_row_number           Number,
        p_page_length          Number

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin

        Open c For
            Select *
              From (
                       With
                           area As (
                               Select dac.area_catg_code,
                                      dac.description                         area_catg_desc,
                                      da.area_key_id,
                                      da.area_key_id || ' - ' || da.area_desc area_desc,
                                      da.area_info
                                 From dm_desk_areas da,
                                      dm_desk_area_categories dac
                                Where nvl(dac.area_catg_code, ' ') = nvl(da.area_catg_code, ' ')
                           )
                       Select a.deskid                                        As desk_id,
                              a.office                                        As office,
                              a.floor                                         As floor,
                              a.seatno                                        As seat_no,
                              a.wing                                          As wing,
                              a.assetcode                                     As asset_code,
                              a.isdeleted                                     As is_deleted,
                              a.cabin                                         As cabin,
                              a.remarks                                       As remarks,
                              a.deskid_old                                    As deskid_old,
                              b.area_desc                                     As work_area,
                              b.area_catg_desc                                As work_area_catg,
                              a.bay || ' - ' || d.bay_desc                    As bay,
                              a.isblocked                                     As is_blocked,
                              Row_Number() Over (Order By a.office, a.deskid) row_number,
                              Count(*) Over ()                                total_row
                         From dm_deskmaster           a
                          Left Outer Join area                    b
                           On a.work_area = b.area_key_id
                         Left Outer Join dm_desk_bays d
                           On a.bay = d.bay_key_id
                        Where 
                        --b.area_catg_code <> 'A004' And
                        Trim(a.office) = nvl(p_office, Trim(a.office))
                          And a.isblocked = nvl(p_is_blocked, a.isblocked)
                          And a.floor = nvl(p_floor, a.floor)
                          And nvl(a.cabin, ' ') = nvl(p_cabin, nvl(a.cabin, ' '))
                          And (
                              upper(a.floor) Like '%' || upper(Trim(p_generic_search)) || '%'
                           Or upper(a.seatno) Like '%' || upper(Trim(p_generic_search)) || '%'
                              )
                          And nvl(a.work_area, ' ') = nvl(p_work_area, nvl(a.work_area, ' '))
                          And nvl(b.area_catg_code, ' ') = nvl(p_work_area_categories, nvl(b.area_catg_code, ' '))
                   )
             Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);
        Return c;

    End fn_deskmaster;

    Function fn_xl_download_deskmaster(
        p_person_id            Varchar2,
        p_meta_id              Varchar2,

        p_generic_search       Varchar2 Default Null,
        p_office               Varchar2 Default Null,
        p_work_area_categories Varchar2 Default Null,
        p_work_area            Varchar2 Default Null,
        p_bay                  Varchar2 Default Null,
        p_is_blocked           Number Default Null

    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            With
                area As(
                    Select dac.area_catg_code,
                           dac.description                         area_catg_desc,
                           da.area_key_id,
                           da.area_key_id || ' - ' || da.area_desc area_desc,
                           da.area_info
                      From dm_desk_areas da,
                           dm_desk_area_categories dac
                     Where nvl(dac.area_catg_code, ' ') = nvl(da.area_catg_code, ' ')
                )

            Select a.deskid                     As desk_id,
                   a.office                     As office,
                   a.floor                      As floor,
                   a.seatno                     As seat_no,
                   a.wing                       As wing,
                   a.assetcode                  As asset_code,
                   a.isdeleted                  As is_deleted,
                   --a.cabin                      As cabin,
                   ( case a.cabin when 'Y' then 'C' else a.cabin end ) as cabin,
                   a.remarks                    As remarks,
                   a.deskid_old                 As deskid_old,
                   b.area_desc                  As work_area,
                   b.area_catg_desc             As work_area_catg,
                   a.bay || ' - ' || c.bay_desc bay
              From dm_deskmaster           a
              Left Outer Join area                    b
                On a.work_area = b.area_key_id
              Left Outer Join dm_desk_bays c
                On a.bay = c.bay_key_id
             Where 
             --b.area_catg_code <> 'A004' And 
                a.isblocked = nvl(p_is_blocked, a.isblocked)
               And (
                   upper(a.floor) Like '%' || upper(Trim(p_generic_search)) || '%'
                Or upper(a.seatno) Like '%' || upper(Trim(p_generic_search)) || '%'
                   )
               And nvl(a.work_area, ' ') = nvl(p_work_area, nvl(a.work_area, ' '))
               And nvl(b.area_catg_code, ' ') = nvl(p_work_area_categories, nvl(b.area_catg_code, ' '))
             Order By a.office,
                   a.deskid;

        Return c;
    End fn_xl_download_deskmaster;

    Procedure sp_deskmaster_details(
        p_person_id                Varchar2,
        p_meta_id                  Varchar2,

        p_desk_id                  Varchar2,
        p_office               Out Varchar2,
        p_floor                Out Varchar2,
        p_seat_no              Out Varchar2,
        p_wing                 Out Varchar2,
        p_is_deleted           Out Varchar2,
        p_cabin                Out Varchar2,
        p_remarks              Out Varchar2,
        p_deskid_old           Out Varchar2,
        p_work_area_code       Out Varchar2,
        p_work_area_categories Out Varchar2,
        p_work_area_desc       Out Varchar2,
        p_bay                  Out Varchar2,
        p_is_blocked           Out Varchar2,

        p_message_type         Out Varchar2,
        p_message_text         Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        With
            desk_areas As (
                Select b.area_key_id,
                       c.description As work_area_categories,
                       b.area_desc   As work_area_desc
                  From dm_desk_areas b,
                       dm_desk_area_categories c
                 Where c.area_catg_code = b.area_catg_code
            )
        Select a.office               As office,
               a.floor                As floor,
               a.seatno               As seat_no,
               a.wing                 As wing,
               a.isdeleted            As is_deleted,
               a.cabin                As cabin,
               a.remarks              As remarks,
               a.deskid_old           As deskid_old,
               a.work_area            As work_area_code,
               b.work_area_categories As work_area_categories,
               b.work_area_desc       As work_area_desc,
               a.bay                  As bay,
               a.isblocked            As is_blocked
          Into p_office,
               p_floor,
               p_seat_no,
               p_wing,
               p_is_deleted,
               p_cabin,
               p_remarks,
               p_deskid_old,
               p_work_area_code,
               p_work_area_categories,
               p_work_area_desc,
               p_bay,
               p_is_blocked
          From dm_deskmaster a,
               desk_areas b
         Where a.deskid = p_desk_id
           And a.work_area = b.area_key_id(+);

        if p_cabin = 'C' then
                p_cabin :='Y';
            end if;
            
        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_deskmaster_details;

    Function fn_check_bay_exists(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_bay       Varchar2

    ) Return Number As
        n_count Number;
    Begin
        Select Count(bay)
          Into n_count
          From dm_deskmaster
         Where bay = Trim(p_bay);
        Return n_count;
    End;

    Function fn_check_work_area_exists(
        p_person_id Varchar2,
        p_meta_id   Varchar2,

        p_work_area Varchar2

    ) Return Number As
        n_count Number;
    Begin
        Select Count(deskid)
          Into n_count
          From dm_deskmaster
         Where work_area = Trim(p_work_area);
        Return n_count;
    End;

End pkg_dms_masters_qry;
/
Grant Execute On dms.pkg_dms_masters_qry To tcmpl_app_config;