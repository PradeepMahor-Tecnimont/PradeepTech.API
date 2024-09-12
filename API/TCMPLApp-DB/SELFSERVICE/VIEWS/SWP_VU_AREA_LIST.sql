--------------------------------------------------------
--  DDL for View SWP_VU_AREA_LIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "SELFSERVICE"."SWP_VU_AREA_LIST" ("OFFICE", "FLOOR", "WING", "WORK_AREA", "AREA_DESC", "IS_SHARED_AREA", "TOTAL_COUNT", "OCCUPIED_COUNT", "AVAILABLE_COUNT", "row_number", "total_row") AS 
  Select Distinct
          mast.office office,
          mast.floor floor,
          mast.wing wing,
          mast.work_area work_area,
          area.area_desc area_desc,
          area.is_shared_area is_shared_area,
          selfservice.iot_swp_common.get_total_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing) As total,
          selfservice.iot_swp_common.get_occupied_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing) As occupied,
          (selfservice.iot_swp_common.get_total_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing) - selfservice.
          iot_swp_common
          .get_occupied_desk(mast.work_area, Trim(mast.office), mast.floor, mast.wing)) As available,
          0 row_number,
          0 total_row
     From dms.dm_deskmaster mast,
          dms.dm_desk_areas area
    Where area.area_key_id = mast.work_area
;
