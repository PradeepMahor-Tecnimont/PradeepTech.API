Create Or Replace Package Body "DMS"."PKG_DMS_REPORTS" As

    v_qrystr Varchar2(8000) := regexp_replace('
With
    emp_assets As (
        Select
            *
        From
            (
                Select
                    a.empno,
                    a.empno empno1,
                    a.item_id,
                    b.assettype,
                    b.model
                From
                    inv_emp_item_mapping a,
                    dm_assetcode         b
                Where
                    a.item_id   = b.barcode
                    And b.assettype In (''NB'', ''DS'')
                    And b.scrap = 0
                Order By a.empno
            )
            Pivot (
            Listagg(item_id, '',''
                On Overflow Truncate) Within
                Group (Order By empno
                ) id,
            Listagg(model, '',''
                On Overflow Truncate) Within
                Group (Order By empno
                ) model
            For assettype In (''NB'' nb, ''DS'' ds))
    ),
    emplist As (
        Select
            e.empno,
            e.name,
            e.parent,
            e.emptype,
            e.grade,
            e.status,
            d.desg,
            selfservice.getshift1(e.empno, sysdate) shift,
            e.email,
            u.userid,
            ea.nb_id,
            ea.nb_model,
            ea.ds_id,
            ea.ds_model
        From
            ss_emplmast e,
            ss_desgmast d,
            ss_userids  u,
            emp_assets  ea
        Where
            e.empno In (
                Select
                    empno
                From
                    dm_usermaster
                Union
                Select
                    empno1
                From
                    emp_assets
            )
            And e.desgcode = d.desgcode
            And e.empno    = u.empno(+)
            And e.empno    = ea.empno1(+)
        Union
        Select
            gnum      empno,
            gname     name,
            gcostcode parent,
            ''G''       emptype,
            ''GM''      grade,
            1         status,
            Null      desg,
            Null      shift,
            Null      email,
            Null      userid,
            Null      nb_id,
            Null      nb_model,
            Null      ds_id,
            Null      ds_model
        From
            dm_guestmaster
        Where
            gnum In (
                Select
                    empno
                From
                    dm_usermaster
            )
    ),

    desk_emp As (
        Select
            *
        From
            (
                Select
                    *
                From
                    (
                        Select
                            deskid         deskid,
                            deskid         deskid1,
                            empno          empno,
                            name           name,
                            parent         parent,
                            emptype        emptype,
                            grade          grade,
                            status         status,
                            desg           desg,
                            shift          shift,
                            email          email,
                            userid         userid,
                            nb_id,
                            nb_model,
                            ds_id,
                            ds_model,
                            ''EMPNO'' || cnt empnum
                        From
                            (
                                Select
                                    um.deskid,
                                    um.empno,
                                    e.name,
                                    e.parent,
                                    e.emptype,
                                    e.grade,
                                    e.status,
                                    e.desg,
                                    e.shift,
                                    e.email,
                                    e.userid,
                                    e.nb_id,
                                    e.nb_model,
                                    e.ds_id,
                                    e.ds_model,
                                    Row_Number()
                                    Over( Partition By um.deskid Order By um.deskid, um.empno) cnt
                                From
                                    dm_usermaster um,
                                    emplist       e
                                Where
                                    um.empno = e.empno(+)
                            )
                        Where
                            cnt <= 2
                    )

                    Pivot (
                    Listagg(empno, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) empno,
                    Listagg(name, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) name,
                    Listagg(parent, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) parent,
                    Listagg(grade, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) grade,
                    Listagg(emptype, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) emptype,
                    Listagg(status, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) status,
                    Listagg(desg, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) desg,
                    Listagg(shift, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) shift,
                    Listagg(email, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) email,
                    Listagg(userid, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) userid,
                    Listagg(nb_id, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) nb_id,
                    Listagg(nb_model, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) nb_model,
                    Listagg(ds_id, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) ds_id,
                    Listagg(ds_model, '',''
                        On Overflow Truncate) Within
                        Group (Order By deskid
                        ) ds_model
                    For empnum In (''EMPNO1'' emp1, ''EMPNO2'' emp2)
                    )
            )
    ),
    desk_asset As(

        Select
            *
        From
            (
                Select
                    deskid                          deskid1,
                    nvl(assettype, ''XX'') || row_num As asset_row_num,
                    deskid,
                    assetid,
                    model,
                    compname,
                    --assettype,
                    nvl(assettype, ''XX'') || row_num As asset_row_num1
                From
                    (

                        Select
                            da.deskid,
                            da.assetid,
                            ac.model,
                            ac.compname,
                            ac.assettype,
                            Row_Number() Over ( Partition By da.deskid, ac.assettype Order By da.deskid,
                                    ac.assettype) row_num
                        From
                            dm_deskallocation da,
                            dm_assetcode      ac
                        Where
                            da.assetid = ac.barcode(+)
                        Order By deskid, assettype
                    )
                Where
                    row_num <= 2
                Order By asset_row_num
            )
            Pivot (
            Listagg(assetid, '',''
                On Overflow Truncate) Within
                Group (Order By deskid, asset_row_num1) assetid,
            Listagg(model, '',''
                On Overflow Truncate) Within
                Group (Order By deskid, asset_row_num1) model,
            Listagg(compname, '',''
                On Overflow Truncate) Within
                Group (Order By deskid, asset_row_num1) compname

            For asset_row_num In (''PC1'' pc1, ''MO1'' mo1, ''MO2'' mo2, ''IP1'' ip_phone, ''DP1'' printer,
            ''XX1'' unknown)
            )
    )

Select
    dm.deskid,
    dm.office,
    dm.floor,
    dm.wing,
    dm.cabin,
    de.emp1_empno                                                     empno1,
    de.emp1_name                                                      name1,
    de.emp1_parent                                                    dept1,
    de.emp1_grade                                                     grade1,
    de.emp1_status                                                    status1,
    de.emp1_desg                                                      desg1,
    de.emp1_shift                                                     shift1,
    de.emp1_email                                                     email1,
    de.emp1_userid                                                    userid1,

    de.emp1_nb_id                                                     nb1,
    de.emp1_nb_model                                                  nb_model1,
    de.emp1_ds_id                                                     ds1,
    de.emp1_ds_model                                                  ds_model1,

    de.emp2_empno                                                     empno2,
    de.emp2_name                                                      name2,
    de.emp2_parent                                                    dept2,
    de.emp2_grade                                                     grade2,
    de.emp2_status                                                    status2,
    de.emp2_desg                                                      desg2,
    de.emp2_shift                                                     shift2,
    de.emp2_email                                                     email2,
    de.emp2_userid                                                    userid2,

    de.emp2_nb_id                                                     nb2,
    de.emp2_nb_model                                                  nb_model2,
    de.emp2_ds_id                                                     ds2,
    de.emp2_ds_model                                                  ds_model2,

    pkg_dms_common.fn_get_pc_name(p_asset_id => da.pc1_assetid)       compname,
    da.pc1_assetid                                                    computer,
    da.pc1_model                                                      pcmodel,
    pkg_dms_common.fn_inv_get_pc_nb_ram(p_asset_id => da.pc1_assetid) pc_ram,
    pkg_dms_common.fn_inv_get_pc_gcard(p_asset_id => da.pc1_assetid)  pc_gcard,
    da.mo1_assetid                                                    monitor1,
    da.mo1_model                                                      monmodel1,
    da.mo2_assetid                                                    monitor2,
    da.mo2_model                                                      monmodel2,
    da.ip_phone_assetid                                               telephone,
    da.ip_phone_model                                                 telmodel,
    da.printer_assetid                                                printer,
    da.printer_model                                                  printmodel
From
    dm_deskmaster dm,
    desk_emp      de,
    desk_asset    da
Where
    dm.deskid Not In (
        Select
            deskid
        From
            dm_desklock
    )
    And dm.deskid = de.deskid1(+)
    And dm.deskid = da.deskid1(+)
Union
Select
    ''HH'' || e.empno   deskid,
    Null              office,
    Null              floor,
    Null              wing,
    Null              cabin,
    e.empno           empno1,
    e.name            name1,
    e.parent          dept1,
    e.grade           grade1,
    to_char(e.status) status1,
    e.desg            desg1,
    e.shift           shift1,
    e.email           email1,
    e.userid          userid1,
    e.nb_id           nb1,
    e.nb_model        nb_model1,

    e.ds_id           ds1,
    e.ds_model        ds_model1,
    Null              empno2,
    Null              name2,
    Null              dept2,
    Null              grade2,
    Null              status2,
    Null              desg2,
    Null              shift2,
    Null              email2,
    Null              userid2,
    Null              nb_id2,
    Null              nb_model2,
    Null              ds_id2,
    Null              ds_model2,

    Null              compname,
    Null              computer,
    Null              pcmodel,
    Null              pc_ram,
    Null              pc_gcard,
    Null              monitor1,
    Null              monmodel1,
    Null              monitor2,
    Null              monmodel2,
    Null              telephone,
    Null              telmodel,
    Null              printer,
    Null              printmodel
From
    emplist e
Where
    empno Not In(
        Select
            empno
        From
            dm_usermaster
    )
    And nb_id Is Not Null
    And ds_id Is Not Null', ' {2,}', ' ');

    Function fn_desk_management_status_list(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,

        p_generic_search  Varchar2 Default Null,

        p_office          Varchar2 Default Null,
        p_floor           Varchar2 Default Null,
        p_wing            Varchar2 Default Null,
        p_cabin           Varchar2 Default Null,
        p_grade           Varchar2 Default Null,
        p_department      Varchar2 Default Null,
        p_pc_model_list   Varchar2 Default Null,
        p_monitor_model   Varchar2 Default Null,
        p_telephone_model Varchar2 Default Null,
        p_printer_model   Varchar2 Default Null,
        p_docstn_model    Varchar2 Default Null,

        p_dual_monitor   Number  Default 0,
        p_vacant_desk     Varchar2,

        p_row_number      Number,
        p_page_length     Number
    ) Return Sys_Refcursor As
        c              Sys_Refcursor;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
         v_find_vacant number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return c;
        End If;

        If p_vacant_desk is null Then 
            v_find_vacant := 5;
        Else
            v_find_vacant := 0;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        deskid,
                        office,
                        floor,
                        wing,
                        cabin,
                        empno1,
                        initcap(name1)                      As name1,
                        userid1,
                        dept1,
                        grade1,
                        desg1,
                        shift1,
                        email1,
                        nb1,
                        nb_hostname1,
                        nb_model1,
                        ds1,
                        ds_model1,
                        empno2                              As empno2,
                        initcap(nvl(name2, ''))             As name2,
                        userid2,
                        dept2,
                        grade2,
                        desg2,
                        shift2,
                        email2,
                        nb2,
                        nb_hostname2,
                        nb_model2,
                        ds2,
                        ds_model2,
                        compname,
                        computer,
                        pcmodel,
                        monitor1,
                        monmodel1,
                        monitor2,
                        monmodel2,
                        telephone,
                        telmodel,
                        printer,
                        printmodel,
                        desk_dck_stn,
                        desk_dck_stn_model,
                        --docstn,
                        --docstnmodel,
                        pc_ram,
                        pc_gcard,
                        Row_Number() Over (Order By deskid) As row_number,
                        Count(*) Over ()                    As total_row
                    From
                        desmas_allocation
                    Where
                        upper(nvl(pcmodel, 'X'))          = upper(nvl(p_pc_model_list, nvl(pcmodel, 'X')))
                        And (
                            upper(nvl(dept1, 'X'))        = upper(nvl(p_department, nvl(dept1, 'X')))
                            Or
                            upper(nvl(dept2, 'X'))        = upper(nvl(p_department, nvl(dept2, 'X')))
                        )
                        And (
                            upper(nvl(monmodel1, 'X'))    = upper(nvl(p_monitor_model, nvl(monmodel1, 'X')))
                            Or
                            upper(nvl(monmodel2, 'X'))    = upper(nvl(p_monitor_model, nvl(monmodel2, 'X')))
                        )
                        And (
                            upper(nvl(grade1, 'X'))       = upper(nvl(p_grade, nvl(grade1, 'X')))
                            Or
                            upper(nvl(grade2, 'X'))       = upper(nvl(p_grade, nvl(grade2, 'X')))
                        )

                        And upper(nvl(telmodel, 'X'))     = upper(nvl(p_telephone_model, nvl(telmodel, 'X')))
                        And upper(nvl(printmodel, 'X'))   = upper(nvl(p_printer_model, nvl(printmodel, 'X')))
                        --And upper(nvl(docstnmodel, 'X'))  = upper(nvl(p_docstn_model,nvl(docstnmodel, 'X')))
                        And upper(nvl(Trim(office), 'X')) = upper((nvl(Trim(p_office), nvl(Trim(office), 'X'))))

                        And upper(Trim(nvl(floor, 'X')))  = upper(nvl(Trim(p_floor), Trim(nvl(floor, 'X'))))
                        And upper(Trim(nvl(wing, 'X')))   = upper(nvl(Trim(p_wing), Trim(nvl(wing, 'X'))))

                        And nvl(length(monitor2),0) >= p_dual_monitor
                        And nvl(length(empno1),0) <= v_find_vacant
                        --And upper(nvl(Trim(cabin)), not_ok) = upper(nvl(nvl(Trim(p_cabin),Trim(cabin))), not_ok)

                        And (
                            upper(deskid) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(empno1) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(name1) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(userid1) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(dept1) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(desg2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(shift1) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(email1) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(empno2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(name2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(userid2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(dept2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(desg2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(shift2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(email2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(compname) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(computer) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(nb1) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(nb_hostname1) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(nb2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(nb_hostname2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(ds1) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(ds2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            -- Or upper(monitor1) Like '%' || upper(Trim(p_generic_search)) || '%'
                            -- Or upper(monitor2) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(telephone) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(printer) Like '%' || upper(Trim(p_generic_search)) || '%'
                            --Or upper(docstn) Like '%' || upper(Trim(p_generic_search)) || '%'
                            Or upper(pc_ram) Like '%' || upper(Trim(p_generic_search)) || '%'
                        )
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
            Order By
                deskid;-- office,floor, wing;

        Return c;
    End fn_desk_management_status_list;

    Function fn_desk_management_status_xls(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,

        p_generic_search  Varchar2 Default Null,

        p_office          Varchar2 Default Null,
        p_floor           Varchar2 Default Null,
        p_wing            Varchar2 Default Null,
        p_cabin           Varchar2 Default Null,
        p_grade           Varchar2 Default Null,
        p_department      Varchar2 Default Null,
        p_pc_model_list   Varchar2 Default Null,
        p_monitor_model   Varchar2 Default Null,
        p_telephone_model Varchar2 Default Null,
        p_printer_model   Varchar2 Default Null,
        p_docstn_model    Varchar2 Default Null,
        p_dual_monitor Number Default 0,
        p_vacant_desk     Varchar2 Default Null

    ) Return Sys_Refcursor As
        c              Sys_Refcursor;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
        v_find_vacant number;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return c;
        End If;

        If p_vacant_desk is null Then 
            v_find_vacant := 5;
        Else
            v_find_vacant := 0;
        End If;

        Open c For
            Select
                deskid,
                office,
                floor,
                wing,
                cabin,
                empno1,
                initcap(name1)          As name1,
                userid1,
                dept1,
                grade1,
                desg1,
                shift1,
                email1,
                nb_hostname1,
                nb1,                
                nb_model1,
                ds1,
                ds_model1,
                empno2                  As empno2,
                initcap(nvl(name2, '')) As name2,
                userid2,
                dept2,
                grade2,
                nb_hostname2,
                nb2,                
                nb_model2,
                desg2,
                shift2,
                email2,
                compname,
                computer,
                pcmodel,
                monitor1,
                monmodel1,
                monitor2,
                monmodel2,
                telephone,
                telmodel,
                printer,
                printmodel,
                --docstn,
                --docstnmodel,
                pc_ram,
                pc_gcard,
                Row_Number() Over (Order By
                        deskid Desc)    As row_number
            From
                desmas_allocation

            Where
                upper(nvl(pcmodel, 'X'))          = upper(nvl(p_pc_model_list, nvl(pcmodel, 'X')))
                And ( upper(nvl(dept1, 'X'))        = upper(nvl(p_department, nvl(dept1, 'X')))
                    Or
                    upper(nvl(dept2, 'X'))        = upper(nvl(p_department, nvl(dept2, 'X')))
                )
                And (
                    upper(nvl(monmodel1, 'X'))    = upper(nvl(p_monitor_model, nvl(monmodel1, 'X')))
                    Or
                    upper(nvl(monmodel2, 'X'))    = upper(nvl(p_monitor_model, nvl(monmodel2, 'X')))
                )
                And (
                    upper(nvl(grade1, 'X'))       = upper(nvl(p_grade, nvl(grade1, 'X')))
                    Or
                    upper(nvl(grade2, 'X'))       = upper(nvl(p_grade, nvl(grade2, 'X')))
                )
                And upper(nvl(telmodel, 'X'))     = upper(nvl(p_telephone_model, nvl(telmodel, 'X')))
                And upper(nvl(printmodel, 'X'))   = upper(nvl(p_printer_model, nvl(printmodel, 'X')))
                --And upper(nvl(docstnmodel, 'X'))  = nvl(upper(p_docstn_model), upper(nvl(docstnmodel, 'X')))

                And upper(Trim(nvl(office, 'X'))) = nvl(upper(Trim(p_office)), upper(Trim(nvl(office, 'X'))))
                And upper(Trim(nvl(floor, 'X')))  = nvl(upper(Trim(p_floor)), upper(Trim(nvl(floor, 'X'))))
                And upper(Trim(nvl(wing, 'X')))   = nvl(upper(Trim(p_wing)), upper(Trim(nvl(wing, 'X'))))
            /*

            upper(nvl(pcmodel, 'X'))          = upper(nvl(p_pc_model_list, nvl(pcmodel, 'X'))
                And (
                    upper(nvl(dept1, 'X'))        = nvl(upper(p_department), upper(nvl(dept1, 'X')))
                    Or
                    upper(nvl(dept2, 'X'))        = nvl(upper(p_department), upper(nvl(dept2, 'X')))
                )
                And (
                    upper(nvl(monmodel1, 'X'))    = nvl(upper(p_monitor_model), upper(nvl(monmodel1, 'X')))
                    Or
                    upper(nvl(monmodel2, 'X'))    = nvl(upper(p_monitor_model), upper(nvl(monmodel2, 'X')))
                )
                And (
                    upper(nvl(grade1, 'X'))       = nvl(upper(p_grade), upper(nvl(grade1, 'X')))
                    Or
                    upper(nvl(grade2, 'X'))       = nvl(upper(p_grade), upper(nvl(grade2, 'X')))
                )
                And upper(nvl(telmodel, 'X'))     = nvl(upper(p_telephone_model), upper(nvl(telmodel, 'X')))
                And upper(nvl(printmodel, 'X'))   = nvl(upper(p_printer_model), upper(nvl(printmodel, 'X')))
                --And upper(nvl(docstnmodel, 'X'))  = nvl(upper(p_docstn_model), upper(nvl(docstnmodel, 'X')))

                And upper(Trim(nvl(office, 'X'))) = nvl(upper(Trim(p_office)), upper(Trim(nvl(office, 'X'))))
                And upper(Trim(nvl(floor, 'X')))  = nvl(upper(Trim(p_floor)), upper(Trim(nvl(floor, 'X'))))
                And upper(Trim(nvl(wing, 'X')))   = nvl(upper(Trim(p_wing)), upper(Trim(nvl(wing, 'X'))))
            */

                And nvl(length(monitor2),0) >= p_dual_monitor                
                And nvl(length(empno1),0) <= v_find_vacant  
                --And nvl(upper(Trim(cabin)), not_ok) = nvl(nvl(upper(Trim(p_cabin)), upper(Trim(cabin))), not_ok)


            Order By
                deskid;-- office,floor, wing;

        Return c;
    End fn_desk_management_status_xls;


    Function fn_desk_management_wl_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,

        p_generic_search Varchar2 Default Null,
        p_from           Date     Default Null,
        p_to             Date     Default Null,

        p_row_number     Number,
        p_page_length    Number
    ) Return Sys_Refcursor As
        c              Sys_Refcursor;
        v_empno        Varchar2(5);
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return c;
        End If;

        Open c For
            Select
                *
            From
                (
                    Select
                        particulars,
                        cnt,
                        Row_Number() Over (Order By particulars) As row_number,
                        Count(*) Over ()                         As total_row
                    From
                        (
                            Select
                                'Asset Movement' particulars, Count(*) cnt
                            From
                                dm_assetmove_tran
                            Where
                                movereqdate >= nvl(p_from, movereqdate)
                                And movereqdate <= nvl(p_to, movereqdate)
                                And assetflag = 1
                                And empflag   = 0 Union
                            Select
                                'Employee Movement' particulars, Count(*) cnt
                            From
                                dm_assetmove_tran
                            Where
                                movereqdate >= nvl(p_from, movereqdate)
                                And movereqdate <= nvl(p_to, movereqdate)
                                And assetflag = 0
                                And empflag   = 1 Union
                            Select
                                'Asset and Employee Movement' particulars, Count(*) cnt
                            From
                                dm_assetmove_tran
                            Where
                                movereqdate >= nvl(p_from, movereqdate)
                                And movereqdate <= nvl(p_to, movereqdate)
                                And assetflag = 1
                                And empflag   = 1 Union
                            Select
                                'Employee Re-joining' particulars, Count(*) cnt
                            From
                                ss_rejoin
                            Where
                                rejoinreqdate >= nvl(p_from, rejoinreqdate)
                                And rejoinreqdate <= nvl(p_to, rejoinreqdate) Union
                            Select
                                'Employee New-joining' particulars, Count(*) cnt
                            From
                                dm_newjoin_trans
                            Where
                                newjoinreqdate >= nvl(p_from, newjoinreqdate)
                                And newjoinreqdate <= nvl(p_to, newjoinreqdate) Union
                            Select
                                'Guest Joining' particulars, Count(*) cnt
                            From
                                dm_guestmaster
                            Where
                                gdate >= nvl(p_from, gdate)
                                And gdate <= nvl(p_to, gdate)
                        )
                    Where
                        upper(particulars) Like '%' || upper(Trim(p_generic_search)) || '%'
                        Or cnt Like '%' || Trim(p_generic_search) || '%'
                )
            Where
                row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length);

        Return c;
    End fn_desk_management_wl_list;

    Function fn_asset_with_itpool_list(
        p_person_id      Varchar2,
        p_meta_id        Varchar2,
        p_asset_category Varchar2 Default Null
    ) Return Sys_Refcursor As
        c              Sys_Refcursor;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number      := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return c;
        End If;

        Open c For

            With
                item_types As(
                    Select
                        item_type_key_id, item_type_code, item_type_desc
                    From
                        inv_item_types
                    Where
                        category_code = 'C1'
                )

            Select
                b.item_type_desc                                                                typename,
                Trim(a.barcode)                                                                 barcode,
                a.serialnum,
                a.model,
                a.compname,
                decode(a.out_of_service, 1, 'Yes', 'No')                                        out_of_service,
                pkg_dms_general.get_last_desk(Trim(a.barcode))                                  last_office,
                pkg_dms_general.get_desk_office(pkg_dms_general.get_last_desk(Trim(a.barcode))) last_deskno
            From
                dm_assetcode a,
                item_types   b
            Where
                scrap_date Is Null
                And b.item_type_key_id = nvl(p_asset_category, b.item_type_key_id)
                And a.assetkey         = b.item_type_key_id
                And Trim(a.barcode) Not In (
                    Select
                        Trim(assetid)
                    From
                        dm_deskallocation
                )
                And Trim(a.barcode)Not In (
                    Select
                        Trim(item_id)
                    From
                        inv_emp_item_mapping
                )
            Order By
                b.item_type_desc,
                a.barcode;

        Return c;
    End fn_asset_with_itpool_list;


    Function fn_check_4_vacant_desk(
        p_deskid        Varchar2        
    ) Return varchar2 as
        v_cnt       Number;
        v_isvacant  varchar2(1);
      begin
        select 
            count(empno)
        into 
            v_cnt
        from 
            dm_usermaster
        where 
            deskid = p_deskid; 

        if v_cnt > 0 then
            v_isvacant := '1';
        else
            v_isvacant := '';
        end if;

        return v_isvacant;
    End fn_check_4_vacant_desk;


    Function fn_office_desk_status (
        p_person_id      Varchar2,
        p_meta_id        Varchar2
    ) Return Sys_Refcursor As

        c              Sys_Refcursor;
        v_empno        Varchar2(5);
        v_user_tcp_ip  Varchar2(5) := 'NA';
        v_message_type Number := 0;
    Begin
        v_empno := get_empno_from_meta_id(p_meta_id);
        If v_empno = 'ERRRR' Then
            Return c;
        End If;
        
        Open c For 
            With emp_desk As (
                                  Select
                                      deskid,
                                      Count(empno) emp_count
                                    From
                                      dm_usermaster
                                   Group By
                                      deskid
                              )
                              Select
                                  d.deskid,
                                  d.office,
                                  d.floor,
                                  d.seatno,
                                  d.wing,
                                  d.assetcode,
                                  to_char(d.isdeleted) as isdeleted,
                                  d.cabin,
                                  d.remarks,
                                  d.deskid_old,                                  
                                  d.bay,
                                  d.work_area,
                                  to_char(d.isblocked) as isblocked,
                                  to_char(nvl(ed.emp_count, 0)) emp_on_desk_count
                                From
                                  dm_deskmaster d,
                                  emp_desk      ed
                    Where
                           d.deskid = ed.deskid (+)
                          And d.deskid Not Like '_MR%'
                          And d.deskid Not Like 'SPD%'
                          And d.deskid Not Like '4TR%'
                          And d.deskid Not Like 'H%'
                          And d.deskid Not In (
                           Select
                               dm_desklock.deskid
                             From
                               dm_desklock
                            Where
                               dm_desklock.blockreason In ( 2, 3, 4 )
                       )
                    Order By
                       office,
                       deskid;
        Return c;
    End fn_office_desk_status;

End pkg_dms_reports;
