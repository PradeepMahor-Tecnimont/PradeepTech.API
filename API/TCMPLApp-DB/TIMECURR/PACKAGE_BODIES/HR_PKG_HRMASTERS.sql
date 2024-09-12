--------------------------------------------------------
--  DDL for Package Body HR_PKG_HRMASTERS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "TIMECURR"."HR_PKG_HRMASTERS" As

  /* Designation  */
    Procedure add_designation (
        p_desgcode Char,
        p_desg     Varchar2,
        p_desg_new     Varchar2,
        p_ord      Char,
        p_subcode  Varchar2,
        p_success  Out Varchar2,
        p_message  Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(desgcode)
        Into v_exists
        From
            desgmast
        Where
            desgcode = p_desgcode;

        If v_exists = 0 Then
            Insert Into desgmast (
                desgcode,
                desg,
                desg_new,
                ord,
                subcode
            ) Values (
                p_desgcode,
                p_desg,
                p_desg_new,
                p_ord,
                p_subcode
            );

            p_success := 'OK';
            p_message := 'Designation added successfully';
        Else
            p_success := 'KO';
            p_message := 'Designation "'
                         || p_desgcode
                         || '" already exists';
        End If;

        Commit;
    End add_designation;

    Procedure update_designation (
        p_desgcode Char,
        p_desg     Varchar2,
        p_desg_new Varchar2,
        p_ord      Char,
        p_subcode  Varchar2,
        p_success  Out Varchar2,
        p_message  Out Varchar2
    ) As
    Begin
        Update desgmast
        Set
            desg = p_desg,
            ord = p_ord,
            subcode = p_subcode,
            desg_new = p_desg_new
        Where
            desgcode = p_desgcode;

        p_success := 'OK';
        p_message := 'Designation updated successfully';
        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_designation;

    Procedure delete_designation (
        p_desgcode Char,
        p_success  Out Varchar2,
        p_message  Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(desgcode)
        Into v_exists
        From
            hr_emplmast_main
        Where
            desgcode = p_desgcode;

        If v_exists = 0 Then
            Delete From desgmast
            Where
                desgcode = p_desgcode;

            p_success := 'OK';
            p_message := 'Designation deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete designation';
        End If;

        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_designation;

  /* Bankcode  */
    Procedure add_bankcode (
        p_bankcode     Char,
        p_bankcodedesc Varchar2,
        p_success      Out Varchar2,
        p_message      Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(bankcode)
        Into v_exists
        From
            hr_bankcode_master
        Where
            bankcode = p_bankcode;

        If v_exists = 0 Then
            Insert Into hr_bankcode_master (
                bankcode,
                bankcodedesc
            ) Values (
                p_bankcode,
                p_bankcodedesc
            );

            p_success := 'OK';
            p_message := 'Bankcode added successfully';
        Else
            p_success := 'KO';
            p_message := 'Bankcode "'
                         || p_bankcode
                         || '" already exists';
        End If;

        Commit;
    End add_bankcode;

    Procedure update_bankcode (
        p_bankcode     Char,
        p_bankcodedesc Varchar2,
        p_success      Out Varchar2,
        p_message      Out Varchar2
    ) As
    Begin
        Update hr_bankcode_master
        Set
            bankcodedesc = p_bankcodedesc
        Where
            Trim(bankcode) = Trim(p_bankcode);

        p_success := 'OK';
        p_message := 'Bankcode updated successfully';
        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_bankcode;

    Procedure delete_bankcode (
        p_bankcode Char,
        p_success  Out Varchar2,
        p_message  Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(bankcode)
        Into v_exists
        From
            hr_emplmast_organization
        Where
            bankcode = p_bankcode;

        If v_exists = 0 Then
            Delete From hr_bankcode_master
            Where
                Trim(bankcode) = Trim(p_bankcode);

            p_success := 'OK';
            p_message := 'Bankcode deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete bankcode';
        End If;

        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_bankcode;
  
  /* Category  */
    Procedure add_category (
        p_categoryid   Varchar2,
        p_categorydesc Varchar2,
        p_success      Out Varchar2,
        p_message      Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(categoryid)
        Into v_exists
        From
            hr_category_master
        Where
            categoryid = p_categoryid;

        If v_exists = 0 Then
            Insert Into hr_category_master (
                categoryid,
                categorydesc
            ) Values (
                p_categoryid,
                p_categorydesc
            );

            p_success := 'OK';
            p_message := 'Category added successfully';
        Else
            p_success := 'KO';
            p_message := 'Category "'
                         || p_categoryid
                         || '" already exists';
        End If;

        Commit;
    End add_category;

    Procedure update_category (
        p_categoryid   Varchar2,
        p_categorydesc Varchar2,
        p_success      Out Varchar2,
        p_message      Out Varchar2
    ) As
    Begin
        Update hr_category_master
        Set
            categorydesc = p_categorydesc
        Where
            categoryid = p_categoryid;

        p_success := 'OK';
        p_message := 'Category updated successfully';
        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_category;

    Procedure delete_category (
        p_categoryid Varchar2,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(category)
        Into v_exists
        From
            hr_emplmast_main
        Where
            category = p_categoryid;

        If v_exists = 0 Then
            Delete From hr_category_master
            Where
                categoryid = p_categoryid;

            p_success := 'OK';
            p_message := 'Category deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete category';
        End If;

        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_category;
  
  /* Employee type  */
    Procedure add_emptype (
        p_emptype    Char,
        p_empdesc    Varchar2,
        p_empremarks Varchar2,
        p_tm         Number,
        p_printlogo  Number,
        p_sortorder  Varchar2,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(emptype)
        Into v_exists
        From
            emptypemast
        Where
            emptype = p_emptype;

        If v_exists = 0 Then
            Insert Into emptypemast (
                emptype,
                empdesc,
                empremarks,
                tm,
                printlogo,
                sortorder
            ) Values (
                p_emptype,
                p_empdesc,
                p_empremarks,
                p_tm,
                p_printlogo,
                p_sortorder
            );

            p_success := 'OK';
            p_message := 'Employee type added successfully';
        Else
            p_success := 'KO';
            p_message := 'Employee type "'
                         || p_emptype
                         || '" already exists';
        End If;

        Commit;
    End add_emptype;

    Procedure update_emptype (
        p_emptype    Char,
        p_empdesc    Varchar2,
        p_empremarks Varchar2,
        p_tm         Number,
        p_printlogo  Number,
        p_sortorder  Varchar2,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
    Begin
        Update emptypemast
        Set
            empdesc = p_empdesc,
            empremarks = p_empremarks,
            tm = p_tm,
            printlogo = p_printlogo,
            sortorder = p_sortorder
        Where
            emptype = p_emptype;

        p_success := 'OK';
        p_message := 'Employee type updated successfully';
        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_emptype;

    Procedure delete_emptype (
        p_emptype Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(emptype)
        Into v_exists
        From
            hr_emplmast_main
        Where
            emptype = p_emptype;

        If v_exists = 0 Then
            Delete From emptypemast
            Where
                emptype = p_emptype;

            p_success := 'OK';
            p_message := 'Employee type deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete employee type';
        End If;

        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_emptype;
  
  /* Grade  */
    Procedure add_grade (
        p_grade_id   Varchar2,
        p_grade_desc Varchar2,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(grade_id)
        Into v_exists
        From
            hr_grade_master
        Where
            grade_id = p_grade_id;

        If v_exists = 0 Then
            Insert Into hr_grade_master (
                grade_id,
                grade_desc
            ) Values (
                p_grade_id,
                p_grade_desc
            );

            p_success := 'OK';
            p_message := 'Grade added successfully';
        Else
            p_success := 'KO';
            p_message := 'Grade "'
                         || p_grade_id
                         || '" already exists';
        End If;

        Commit;
    End add_grade;

    Procedure update_grade (
        p_grade_id   Varchar2,
        p_grade_desc Varchar2,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
    Begin
        Update hr_grade_master
        Set
            grade_desc = p_grade_desc
        Where
            grade_id = p_grade_id;

        p_success := 'OK';
        p_message := 'Grade updated successfully';
        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_grade;

    Procedure delete_grade (
        p_grade_id Varchar2,
        p_success  Out Varchar2,
        p_message  Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(grade)
        Into v_exists
        From
            hr_emplmast_main
        Where
            grade = p_grade_id;

        If v_exists = 0 Then
            Delete From hr_grade_master
            Where
                grade_id = p_grade_id;

            p_success := 'OK';
            p_message := 'Grade deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete Grade';
        End If;

        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_grade;
  
  /* Location  */
    Procedure add_location (
        p_locationid Char,
        p_location   Varchar2,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(locationid)
        Into v_exists
        From
            hr_location_master
        Where
            locationid = p_locationid;

        If v_exists = 0 Then
            Insert Into hr_location_master (
                locationid,
                location
            ) Values (
                p_locationid,
                p_location
            );

            p_success := 'OK';
            p_message := 'Location added successfully';
        Else
            p_success := 'KO';
            p_message := 'Location "'
                         || p_locationid
                         || '" already exists';
        End If;

        Commit;
    End add_location;

    Procedure update_location (
        p_locationid Char,
        p_location   Varchar2,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
    Begin
        Update hr_location_master
        Set
            location = p_location
        Where
            locationid = p_locationid;

        p_success := 'OK';
        p_message := 'Location updated successfully';
        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_location;

    Procedure delete_location (
        p_locationid Char,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(location)
        Into v_exists
        From
            hr_emplmast_organization
        Where
            location = p_locationid;

        If v_exists = 0 Then
            Delete From hr_location_master
            Where
                locationid = p_locationid;

            p_success := 'OK';
            p_message := 'Location deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete Location';
        End If;

        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_location;
  
  
  /* Office  */
    Procedure add_office (
        p_office  Char,
        p_name    Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(office)
        Into v_exists
        From
            offimast
        Where
            office = p_office;

        If v_exists = 0 Then
            Insert Into offimast (
                office,
                name
            ) Values (
                p_office,
                p_name
            );

            p_success := 'OK';
            p_message := 'Office added successfully';
        Else
            p_success := 'KO';
            p_message := 'Office "'
                         || p_office
                         || '" already exists';
        End If;

        Commit;
    End add_office;

    Procedure update_office (
        p_office  Char,
        p_name    Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
    Begin
        Update offimast
        Set
            name = p_name
        Where
            office = p_office;

        p_success := 'OK';
        p_message := 'Office updated successfully';
        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_office;

    Procedure delete_office (
        p_office  Char,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(office)
        Into v_exists
        From
            hr_emplmast_main
        Where
            office = p_office;

        If v_exists = 0 Then
            Delete From offimast
            Where
                office = p_office;

            p_success := 'OK';
            p_message := 'Office deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete Office';
        End If;

        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_office;
  
  /* Subcontract  */
    Procedure add_subcontract (
        p_subcontract Char,
        p_description Varchar2,
        p_success     Out Varchar2,
        p_message     Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(subcontract)
        Into v_exists
        From
            subcontractmast
        Where
            subcontract = p_subcontract;

        If v_exists = 0 Then
            Insert Into subcontractmast (
                subcontract,
                description
            ) Values (
                p_subcontract,
                p_description
            );

            p_success := 'OK';
            p_message := 'Subcontract agency added successfully';
        Else
            p_success := 'KO';
            p_message := 'Subcontract agency "'
                         || p_subcontract
                         || '" already exists';
        End If;

        Commit;
    End add_subcontract;

    Procedure update_subcontract (
        p_subcontract Char,
        p_description Varchar2,
        p_success     Out Varchar2,
        p_message     Out Varchar2
    ) As
    Begin
        Update subcontractmast
        Set
            description = p_description
        Where
            subcontract = p_subcontract;

        p_success := 'OK';
        p_message := 'Subcontract agency updated successfully';
        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_subcontract;

    Procedure delete_subcontract (
        p_subcontract Char,
        p_success     Out Varchar2,
        p_message     Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(subcontract)
        Into v_exists
        From
            hr_emplmast_organization
        Where
            subcontract = p_subcontract;

        If v_exists = 0 Then
            Delete From subcontractmast
            Where
                subcontract = p_subcontract;

            p_success := 'OK';
            p_message := 'Subcontract agency deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete Subcontract agency';
        End If;

        Commit;
    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_subcontract;
  
  
  /* Place  */
    Procedure add_place (
        p_place_id   Varchar2,
        p_place_desc Varchar2,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(place_id)
        Into v_exists
        From
            hr_place_master
        Where
            upper(place_desc) = upper(Trim(p_place_desc));

        If v_exists = 0 Then
            Insert Into hr_place_master (
                place_id,
                place_desc
            ) Values (
                dbms_random.string('X', 3),
                Trim(p_place_desc)
            );

            Commit;
            p_success := 'OK';
            p_message := 'Place added successfully';
        Else
            p_success := 'KO';
            p_message := 'Place "'
                         || p_place_desc
                         || '" already exists';
        End If;

    End add_place;

    Procedure update_place (
        p_place_id   Varchar2,
        p_place_desc Varchar2,
        p_success    Out Varchar2,
        p_message    Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(place_id)
        Into v_exists
        From
            hr_place_master
        Where
                upper(place_desc) = upper(Trim(p_place_desc))
            And place_id != p_place_id;

        If v_exists = 0 Then
            Update hr_place_master
            Set
                place_desc = Trim(p_place_desc)
            Where
                place_id = p_place_id;

            Commit;
            p_success := 'OK';
            p_message := 'Place updated successfully';
        Else
            p_success := 'KO';
            p_message := 'Place "'
                         || p_place_desc
                         || '" already exists';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_place;

    Procedure delete_place (
        p_place_id Varchar2,
        p_success  Out Varchar2,
        p_message  Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(place)
        Into v_exists
        From
            hr_emplmast_organization
        Where
            place = p_place_id;

        If v_exists = 0 Then
            Delete From hr_place_master
            Where
                place_id = p_place_id;

            Commit;
            p_success := 'OK';
            p_message := 'Place deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete Place';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_place;
    
    /* Qualification  */
    Procedure add_qualification (
        p_qualification_id   Varchar2,
        p_qualification      Varchar2,
        p_qualification_desc Varchar2,
        p_success            Out Varchar2,
        p_message            Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(qualification_id)
        Into v_exists
        From
            hr_qualification_master
        Where
            qualification = Trim(p_qualification);

        If v_exists = 0 Then
            Insert Into hr_qualification_master (
                qualification_id,
                qualification,
                qualification_desc
            ) Values (
                dbms_random.string('X', 3),
                Trim(p_qualification),
                Trim(p_qualification_desc)
            );

            Commit;
            p_success := 'OK';
            p_message := 'Qualification added successfully';
        Else
            p_success := 'KO';
            p_message := 'Qualification "'
                         || p_qualification
                         || '" already exists';
        End If;

    End add_qualification;

    Procedure update_qualification (
        p_qualification_id   Varchar2,
        p_qualification      Varchar2,
        p_qualification_desc Varchar2,
        p_success            Out Varchar2,
        p_message            Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(qualification_id)
        Into v_exists
        From
            hr_qualification_master
        Where
                qualification = Trim(p_qualification)
            And qualification_id != p_qualification_id;

        If v_exists = 0 Then
            Update hr_qualification_master
            Set
                qualification = Trim(p_qualification),
                qualification_desc = Trim(p_qualification_desc)
            Where
                qualification_id = p_qualification_id;

            Commit;
            p_success := 'OK';
            p_message := 'Qualification updated successfully';
        Else
            p_success := 'KO';
            p_message := 'Qualification "'
                         || p_qualification
                         || '" already exists';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_qualification;

    Procedure delete_qualification (
        p_qualification_id Varchar2,
        p_success          Out Varchar2,
        p_message          Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(qualification_id)
        Into v_exists
        From
            hr_emplmast_organization_qual
        Where
            qualification_id = p_qualification_id;

        If v_exists = 0 Then
            Delete From hr_qualification_master
            Where
                qualification_id = p_qualification_id;

            Commit;
            p_success := 'OK';
            p_message := 'Qualification deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete Qualification';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_qualification;
    
    
     /* Graduation  */
    Procedure add_graduation (
        p_graduation_id   Varchar2,
        p_graduation_desc Varchar2,
        p_success         Out Varchar2,
        p_message         Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(graduation_id)
        Into v_exists
        From
            hr_graduation_master
        Where
            upper(graduation_desc) = upper(Trim(p_graduation_desc));

        If v_exists = 0 Then
            Insert Into hr_graduation_master (
                graduation_id,
                graduation_desc
            ) Values (
                dbms_random.string('X', 2),
                Trim(p_graduation_desc)
            );

            Commit;
            p_success := 'OK';
            p_message := 'Graduation added successfully';
        Else
            p_success := 'KO';
            p_message := 'Graduation "'
                         || p_graduation_desc
                         || '" already exists';
        End If;

    End add_graduation;

    Procedure update_graduation (
        p_graduation_id   Varchar2,
        p_graduation_desc Varchar2,
        p_success         Out Varchar2,
        p_message         Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(graduation_id)
        Into v_exists
        From
            hr_graduation_master
        Where
                upper(graduation_desc) = upper(Trim(p_graduation_desc))
            And graduation_id != p_graduation_id;

        If v_exists = 0 Then
            Update hr_graduation_master
            Set
                graduation_desc = Trim(p_graduation_desc)
            Where
                graduation_id = p_graduation_id;

            Commit;
            p_success := 'OK';
            p_message := 'Graduation updated successfully';
        Else
            p_success := 'KO';
            p_message := 'Graduation "'
                         || p_graduation_desc
                         || '" already exists';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_graduation;

    Procedure delete_graduation (
        p_graduation_id Varchar2,
        p_success       Out Varchar2,
        p_message       Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(graduation)
        Into v_exists
        From
            hr_emplmast_organization
        Where
            graduation = p_graduation_id;

        If v_exists = 0 Then
            Delete From hr_graduation_master
            Where
                graduation_id = p_graduation_id;

            Commit;
            p_success := 'OK';
            p_message := 'Graduation deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Can not delete Graduation';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_graduation;
    
    /* Job group */
    Procedure add_jobgroup (
        p_grp_cd        Varchar2,
        p_grp_name      Varchar2,
        p_grp_milan     Varchar2,
        p_success  Out Varchar2,
        p_message  Out Varchar2
    ) As
        v_grp_cd_exists   Number := 0;
        v_grp_name_exists Number := 0;
    Begin
        Select
            Count(job_group_code)
        Into 
            v_grp_cd_exists
        From
            hr_jobgroup_master
        Where
            upper(Trim(job_group_code)) = upper(Trim(p_grp_cd));

        Select
            Count(job_group)
        Into 
            v_grp_name_exists
        From
            hr_jobgroup_master
        Where
            upper(Trim(job_group)) = upper(Trim(p_grp_name));

        If
            v_grp_cd_exists = 0 And v_grp_name_exists = 0
        Then
            Insert Into hr_jobgroup_master (
                job_group_code,
                job_group,
                milan_job_group
            ) Values (
                upper(Trim(p_grp_cd)),
                upper(Trim(p_grp_name)),
                upper(Trim(p_grp_milan))
            );

            Commit;
            p_success := 'OK';
            p_message := 'Job group added successfully';
        Else
            p_success := 'KO';
            p_message := 'Job group "'
                         || p_grp_cd
                         || '" already exists';
        End If;

    End add_jobgroup;

    Procedure update_jobgroup (
        p_grp_cd        Varchar2,
        p_grp_name      Varchar2,
        p_grp_milan     Varchar2,
        p_success  Out Varchar2,
        p_message  Out Varchar2
    ) As
        v_grp_name_exists Number := 0;
    Begin
        Select
            Count(job_group)
        Into 
            v_grp_name_exists
        From
            hr_jobgroup_master
        Where
            upper(Trim(job_group)) = upper(Trim(p_grp_name))
            And upper(Trim(job_group_code)) <> upper(Trim(p_grp_cd));

        If v_grp_name_exists = 0 Then
            Update hr_jobgroup_master
            Set
                job_group = upper(Trim(p_grp_name)),
                milan_job_group = upper(Trim(p_grp_milan))
            Where
                upper(Trim(job_group_code)) = upper(Trim(p_grp_cd));

            Commit;
            p_success := 'OK';
            p_message := 'Job group updated successfully';
        Else
            p_success := 'KO';
            p_message := 'Job group "'
                         || p_grp_name
                         || '" already exists';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_jobgroup;

    Procedure delete_jobgroup (
        p_grp_cd  Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(job_group_code)
        Into 
            v_exists
        From
            hr_jobgroup_master
        Where
            upper(Trim(job_group_code)) = upper(Trim(p_grp_cd));

        If v_exists = 1 Then
            Delete From hr_jobgroup_master
            Where
                 upper(Trim(job_group_code)) = upper(Trim(p_grp_cd));

            Commit;
            p_success := 'OK';
            p_message := 'Job group deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Cannot delete Job group !!!';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_jobgroup;
    
    
    /* Job discipline */
    Procedure add_job_discipline (       
        p_dis_cd        Varchar2,
        p_dis_name      Varchar2,
        p_success  Out  Varchar2,
        p_message  Out  Varchar2
    ) As
        v_dis_cd_exists     Number := 0;
        v_dis_name_exists   Number := 0;
    Begin        
        Select
            Count(jobdiscipline_code)
        Into 
            v_dis_cd_exists
        From
            hr_jobdiscipline_master
        Where
            upper(Trim(jobdiscipline_code)) = upper(Trim(p_dis_cd));
        
        Select
            Count(jobdiscipline)
        Into 
            v_dis_name_exists
        From
            hr_jobdiscipline_master
        Where
            upper(Trim(jobdiscipline)) = upper(Trim(p_dis_name));
          
        If
            v_dis_cd_exists = 0 and v_dis_name_exists = 0
        Then
            Insert Into hr_jobdiscipline_master (
                jobdiscipline_code,
                jobdiscipline
            ) Values (
                upper(Trim(p_dis_cd)),
                upper(Trim(p_dis_name))
            );

            Commit;
            p_success := 'OK';
            p_message := 'Job discipline added successfully';
        Else
            p_success := 'KO';
            p_message := 'Job discipline "'
                         || p_dis_cd
                         || '" already exists."';
        End If;

    End add_job_discipline;

    Procedure update_job_discipline (        
        p_dis_cd        Varchar2,
        p_dis_name      Varchar2,
        p_success  Out  Varchar2,
        p_message  Out  Varchar2
    ) As
        v_dis_name_exists Number := 0;
    Begin
        Select
            Count(jobdiscipline)
        Into 
            v_dis_name_exists
        From
             hr_jobdiscipline_master
        Where
            upper(Trim(jobdiscipline)) = upper(Trim(p_dis_name))
            and upper(Trim(jobdiscipline_code)) <> upper(Trim(p_dis_cd));

        If v_dis_name_exists = 0 Then
            Update hr_jobdiscipline_master
            Set
                jobdiscipline = upper(Trim(p_dis_name))
            Where
                upper(Trim(jobdiscipline_code)) = upper(Trim(p_dis_cd));

            Commit;
            p_success := 'OK';
            p_message := 'Job discipline updated successfully';
        Else
            p_success := 'KO';
            p_message := 'Job discipline "'
                         || p_dis_name
                         || '" already exists "';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_job_discipline;

    Procedure delete_job_discipline (        
        p_dis_cd  Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_exists    Number := 0;
    Begin
        Select
            Count(jobdiscipline_code)
        Into 
            v_exists
        From
            hr_jobdiscipline_master
        Where
            upper(Trim(jobdiscipline_code)) = upper(Trim(p_dis_cd));

        If v_exists = 1 Then
            Delete From hr_jobdiscipline_master
            Where
                upper(Trim(jobdiscipline_code)) = upper(Trim(p_dis_cd));

            Commit;
            p_success := 'OK';
            p_message := 'Job discipline deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Cannot delete Job discipline !!!';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_job_discipline;
    
    
    /* Job title */
    Procedure add_job_title (        
        p_tit_cd      Varchar2,
        p_title         Varchar2,
        p_success Out   Varchar2,
        p_message Out   Varchar2
    ) As
        v_tit_cd_exists     Number := 0;
        v_tit_name_exists   Number := 0;
    Begin
        Select
            Count(jobtitle_code)
        Into 
            v_tit_cd_exists
        From
            hr_jobtitle_master
        Where
            upper(Trim(jobtitle_code)) = upper(Trim(p_tit_cd));
        
        Select
            Count(jobtitle)
        Into 
            v_tit_name_exists
        From
            hr_jobtitle_master
        Where
            upper(Trim(jobtitle)) = upper(Trim(p_title));
            
        If 
            v_tit_cd_exists = 0 and v_tit_name_exists = 0        
        Then
            Insert Into hr_jobtitle_master  (
                jobtitle_code,                
                jobtitle
            ) Values (
                upper(Trim(p_tit_cd)),
                upper(Trim(p_title))
            );

            Commit;
            p_success := 'OK';
            p_message := 'Job title added successfully';
        Else
            p_success := 'KO';
            p_message := 'Job title "'
                         || p_title
                         || '" already exists "';
        End If;

    End add_job_title;

    Procedure update_job_title (        
        p_tit_cd        Varchar2,
        p_title         Varchar2,
        p_success Out   Varchar2,
        p_message Out   Varchar2
    ) As
        v_tit_name_exists     Number := 0;
    Begin
        Select
            Count(jobtitle)
        Into 
            v_tit_name_exists
        From
             hr_jobtitle_master
        Where
            upper(Trim(jobtitle)) = upper(Trim(p_title))
            And upper(Trim(jobtitle_code)) <> upper(Trim(p_tit_cd));

        If v_tit_name_exists = 0 Then
            Update hr_jobtitle_master
            Set
                jobtitle = upper(Trim(p_title))
            Where
                upper(Trim(jobtitle_code)) = upper(Trim(p_tit_cd));

            Commit;
            p_success := 'OK';
            p_message := 'Job title updated successfully';
        Else
            p_success := 'KO';
            p_message := 'Job title "'
                         || p_title
                         || '" already exists."';

        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End update_job_title;

    Procedure delete_job_title (        
        p_tit_cd      Varchar2,
        p_success Out Varchar2,
        p_message Out Varchar2
    ) As
        v_exists Number := 0;
    Begin
        Select
            Count(jobtitle_code)
        Into 
            v_exists
        From
            hr_jobtitle_master
        Where
            upper(Trim(jobtitle_code)) = upper(Trim(p_tit_cd));

        If v_exists = 1 Then
            Delete From hr_jobtitle_master
            Where
                upper(Trim(jobtitle_code)) = upper(Trim(p_tit_cd));

            Commit;
            p_success := 'OK';
            p_message := 'Job title deleted successfully';
        Else
            p_success := 'KO';
            p_message := 'Cannot delete Job title !!!';
        End If;

    Exception
        When Others Then
            p_success := 'KO';
            p_message := 'Err - '
                         || sqlcode
                         || ' - '
                         || sqlerrm;
    End delete_job_title;

End hr_pkg_hrmasters;

/
