--------------------------------------------------------
--  DDL for Package Body IOT_SWP_DESK_AREA_MAP_QRY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."IOT_SWP_DESK_AREA_MAP_QRY" As
 
Function fn_desk_area_map_list(
     p_person_id   Varchar2,
      p_meta_id     Varchar2,
      P_area        Varchar2 Default Null,
      p_row_number  Number,
      p_page_length Number
   ) Return Sys_Refcursor
   Is
   c                    Sys_Refcursor;
   v_count              Number;
   v_empno              Varchar2(5);
   v_hod_sec_assign_code              Varchar2(4);
   e_employee_not_found Exception;
   Pragma exception_init(e_employee_not_found, -20001);

Begin

   v_empno := get_empno_from_meta_id(p_meta_id);
   If v_empno = 'ERRRR' Then
      Raise e_employee_not_found;
      Return Null;
   End If;
   
   /*
   Select a.KYE_ID, a.DESKID, a.AREA_KEY_ID ,
      b.AREA_KEY_ID, b.AREA_DESC, b.AREA_CATG_CODE, b.AREA_INFO
   From SWP_DESK_AREA_MAPPING a , DMS.DM_DESK_AREAS b
   where a.AREA_KEY_ID = b.AREA_KEY_ID(+);
   */
 /*
   If v_empno Is Null Or p_assign_code Is Not Null Then
            v_hod_sec_assign_code := iot_swp_common.get_default_costcode_hod_sec(
                                         p_hod_sec_empno => v_empno,
                                         p_assign_code   => p_assign_code
                                     );
     end if;       
	
   Open c For
      Select *
        From (
                Select empprojmap.KYE_ID As keyid,
                       empprojmap.EMPNO As Empno,
                        a.name As Empname,
                       empprojmap.PROJNO As Projno,
                       b.name As Projname,
                       Row_Number() Over (Order By empprojmap.KYE_ID Desc) row_number,
                       Count(*) Over () total_row
                  From SWP_EMP_PROJ_MAPPING empprojmap , 
                        ss_emplmast a , ss_projmast b
                 Where a.empno = empprojmap.empno 
                     and b.projno = empprojmap.PROJNO
                     and  empprojmap.EMPNO In (
                          Select Distinct empno
                            From ss_emplmast
                           Where status = 1
                            And a.assign = nvl(v_hod_sec_assign_code, a.assign)
                       )

             )
       Where row_number Between (nvl(p_row_number, 0) + 1) And (nvl(p_row_number, 0) + p_page_length)
       Order By Empno,PROJNO;
   Return c;
	*/
 RETURN NULL;
 
End fn_desk_area_map_list;


End IOT_SWP_DESK_AREA_MAP_QRY;


/

  GRANT EXECUTE ON "SELFSERVICE"."IOT_SWP_DESK_AREA_MAP_QRY" TO "TCMPL_APP_CONFIG";
