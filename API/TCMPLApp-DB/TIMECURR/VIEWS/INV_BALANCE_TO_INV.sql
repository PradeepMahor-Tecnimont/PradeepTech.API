--------------------------------------------------------
--  DDL for View INV_BALANCE_TO_INV
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TIMECURR"."INV_BALANCE_TO_INV" ("PROJNO", "COSTCODE", "BUDGET", "BOOKED", "BILLED") AS 
  SELECT projno,
    costcode,
    SUM(budget) AS budget,
    SUM(booked) AS booked,
    SUM(billed) AS billed
  FROM
    (SELECT projno,
      costcode,
      0             AS budget,
      SUM(ticb_hrs) AS booked,
      0             AS billed
    FROM inv_timetran_tcm
    WHERE yymm >= '201904'
    AND yymm   <='202003'
    GROUP BY projno,
      costcode
    UNION ALL
    SELECT projno,
      costcode,
      0                            AS budget,
      0                            AS booked,
      SUM(NVL(invoiced_Current,0)) AS billed
    FROM inv_invoice_master
    WHERE NVL(additional,0) = 0
    GROUP BY projno,
      costcode
    UNION ALL
    SELECT projno,
      costcode,
      SUM(NVL(budgetted_hours,0)) AS budget,
      0                           AS booked,
      0                           AS billed
    FROM inv_loa_details
    WHERE NVL(loa_closed,0)=0
    GROUP BY projno,
      costcode
    )
  GROUP BY projno,
    costcode
;
