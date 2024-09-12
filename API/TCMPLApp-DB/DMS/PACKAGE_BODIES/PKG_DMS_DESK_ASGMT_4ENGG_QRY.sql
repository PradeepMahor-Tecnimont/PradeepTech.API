--------------------------------------------------------
--  DDL for Package Body PKG_DMS_DESK_ASGMT_4ENGG_QRY
--------------------------------------------------------

Create Or Replace Package Body "DMS"."PKG_DMS_DESK_ASGMT_4ENGG_QRY" As

    Function fn_assets_on_desk(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                b.assetid   As asset_id,
                a.model     description,
                a.assettype As asset_code,
                a.compname  As asset_name
            From
                dm_vu_asset_list                      a, dm_deskallocation b
            Where
                a.barcode    = b.assetid(+)
                And b.deskid = upper(Trim(p_generic_search));

        Return c;
    End fn_assets_on_desk;

    Function fn_desk_asgmt_employee(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2
    ) Return Sys_Refcursor As
        c Sys_Refcursor;
    Begin
        Open c For

            Select
                a.barcode   As asset_id,
                a.model     description,
                a.assettype As asset_code,
                a.compname  As asset_name
            From
                dm_vu_asset_list     a,
                inv_emp_item_mapping b
            Where
                a.barcode   = b.item_id
                And b.empno = upper(Trim(p_generic_search));

        Return c;
    End fn_desk_asgmt_employee;

    Procedure sp_desk_asgmt_master_details(
        p_person_id          Varchar2,
        p_meta_id            Varchar2,

        p_generic_search     Varchar2,

        p_emp1           Out Varchar2,
        p_emp2           Out Varchar2,
        p_deskno         Out Varchar2,
        p_cabin_desk     Out Varchar2,
        p_office         Out Varchar2,
        p_floor          Out Varchar2,
        p_area           Out Varchar2,
        p_is_blocked     Out Varchar2,
        p_blocked_reason Out Varchar2,

        p_message_type   Out Varchar2,
        p_message_text   Out Varchar2
    ) As
        v_empno        Varchar2(5);
        v_count        Number;
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno        := get_empno_from_meta_id(p_meta_id);

        If v_empno = 'ERRRR' Then
            p_message_type := 'KO';
            p_message_text := 'Invalid employee number';
            Return;
        End If;

        Select
            Count(*)
        Into
            v_count
        From
            dm_deskmaster
        Where
            deskid        = upper(Trim(p_generic_search))
            And isblocked = 1;

        If v_count > 0 Then
            p_is_blocked   := ok;
            Select
                deskid || ' : Desk blocked - ' || remarks
            Into
                p_blocked_reason
            From
                dm_deskmaster
            Where
                deskid        = upper(Trim(p_generic_search))
                And isblocked = 1;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';

        End If;

        Select
            Count(*)
        Into
            v_count
        From
            dm_deskmaster
        Where
            deskid        = upper(Trim(p_generic_search))
            And isdeleted = 1;

        If v_count > 0 Then
            p_is_blocked   := ok;
            Select
                deskid || ' : Desk Deleted - ' || remarks
            Into
                p_blocked_reason
            From
                dm_deskmaster
            Where
                deskid        = upper(Trim(p_generic_search))
                And isdeleted = 1;

            p_message_type := 'OK';
            p_message_text := 'Procedure executed successfully.';

        End If;
      
        /*
         Select
              Count(*)
          Into
              v_count
          From
              dm_guestmaster a
          Where
              a.gnum          = upper(Trim(p_generic_search))
              Or a.targetdesk = upper(Trim(p_generic_search))
              And a.gnum      = (
                       Select
                           b.empno
                       From
                           dm_usermaster b
                       Where
                           b.empno = a.gnum
                   );

          If v_count > 0 Then
              p_is_blocked   := ok;
              Select
                  Trim(a.targetdesk),
                  'Desk booked for guest : ' || a.gnum || ' : ' || a.gname || ', From date (' || a.gfromdate || ' - ' || a.
                  gtodate || ' )'
              Into
                  p_deskno,
                  p_blocked_reason
              From
                  dm_guestmaster                  a, dm_deskmaster b
              Where
                  a.targetdesk = upper(Trim(p_generic_search));

              p_message_type := 'OK';
              p_message_text := 'Procedure executed successfully.';

          End If;
        */

        Select
            Count(*)
        Into
            v_count
        From
            desmas_allocation
        Where
            empno1    = upper(Trim(p_generic_search))
            Or empno2 = upper(Trim(p_generic_search))
            Or deskid = upper(Trim(p_generic_search))
            And deskid In (
                Select
                    deskid
                From
                    dm_deskmaster
                Where
                    deskid = upper(Trim(p_generic_search))
            );

        If v_count > 0 Then
            Select
                Trim(deskid),
                Trim(empno1),
                Trim(empno2),
                Trim(office),
                Trim(floor),
                Trim(cabin),
                Trim(wing)
            Into
                p_deskno,
                p_emp1,
                p_emp2,
                p_office,
                p_floor,
                p_cabin_desk,
                p_area
            From
                desmas_allocation
            Where
                empno1    = upper(Trim(p_generic_search))
                Or empno2 = upper(Trim(p_generic_search))
                Or deskid = upper(Trim(p_generic_search));

        Else
            p_deskno := upper(trim(p_generic_search));
        End If;

        p_message_type := 'OK';
        p_message_text := 'Procedure executed successfully.';

    Exception
        When Others Then
            p_message_type := 'KO';
            p_message_text := 'ERR :- ' || sqlcode || ' - ' || sqlerrm;

    End sp_desk_asgmt_master_details;

End pkg_dms_desk_asgmt_4engg_qry;
/
Grant Execute On "DMS"."PKG_DMS_DESK_ASGMT_4ENGG_QRY" To "TCMPL_APP_CONFIG";