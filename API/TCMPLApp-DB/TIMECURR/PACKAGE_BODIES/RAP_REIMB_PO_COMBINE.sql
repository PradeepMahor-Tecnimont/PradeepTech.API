Create Or Replace Package Body "TIMECURR"."RAP_REIMB_PO_COMBINE" As
    Procedure rpt_reimbpo(p_yymm           In  Varchar2,
                          p_hrs            Out Sys_Refcursor,
                          p_hrs_o          Out Sys_Refcursor,
                          p_hrs_exo        Out Sys_Refcursor,
                          p_hrs_exo_mumbai Out Sys_Refcursor,
                          p_hrs_exo_delhi  Out Sys_Refcursor) As
    Begin
        -- All data --------------------------------------------------------
        Open p_hrs For
            'select projno, tcmno, name, sapcc, ccdesc, purchaseorder, tcm_cc, tcm_phase, tothours, rate, e_ep_type
        from prj_cc_po_rt_hrs where yymm = :p_yymm order by projno, sapcc'
            Using p_yymm;

        -- Subcontract (O) --------------------------------------------------------
        Open p_hrs_o For
            'select projno, tcmno, name, sapcc, ccdesc, purchaseorder, tcm_cc, tcm_phase, tothours, rate, e_ep_type
        from prj_cc_po_rt_hrs_o where yymm = :p_yymm order by projno, sapcc'
            Using p_yymm;

        -- Excluding Subcontract (O) --------------------------------------------------------
        Open p_hrs_exo For
            'select projno, tcmno, name, sapcc, ccdesc, purchaseorder, tcm_cc, tcm_phase, tothours, rate, e_ep_type
        from prj_cc_po_rt_hrs_exo where yymm = :p_yymm order by projno, sapcc'
            Using p_yymm;
      
        -- Excluding Subcontract (O) - Mumbai --------------------------------------------------------
        Open p_hrs_exo_mumbai For
            'select projno, tcmno, name, sapcc, ccdesc, purchaseorder, tcm_cc, tcm_phase, tothours, rate, e_ep_type
        from prj_cc_po_rt_hrs_exo where yymm = :p_yymm 
        and costcode in (Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And cgc.code Is Null )
        order by projno, sapcc'
            Using p_yymm;
      
        -- Excluding Subcontract (O) - Delhi --------------------------------------------------------
        Open p_hrs_exo_delhi For
            'select projno, tcmno, name, sapcc, ccdesc, purchaseorder, tcm_cc, tcm_phase, tothours, rate, e_ep_type
        from prj_cc_po_rt_hrs_exo where yymm = :p_yymm 
        and costcode in (Select cgc.costcode From rap_costcode_group cg, rap_costcode_group_costcodes cgc Where cg.group_id = cgc.group_id And cgc.code = ''D'' )
        order by projno, sapcc'
            Using p_yymm;

    End rpt_reimbpo;

End rap_reimb_po_combine;
/
Grant Execute On "TIMECURR"."RAP_REIMB_PO_COMBINE" To "TCMPL_APP_CONFIG";