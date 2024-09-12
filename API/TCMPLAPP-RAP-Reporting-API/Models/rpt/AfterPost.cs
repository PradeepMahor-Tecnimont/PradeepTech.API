using System;
using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.Models.rpt
{
    public partial class AfterPost
    {
        [Key]
        public string OnDate { get; set; } = DateTime.Now.ToString("dd-MMM-yyyy");

        public Project project { get; set; }
    }

    public partial class Project
    {
        [Key]
        public string Title_GRADE { get; set; } = "Gradewise Manhuors";

        public string Title_PlanRep1 { get; set; } = "Hours Costcode & Activity  Wise";
        public string Title_Planrep2 { get; set; } = "Projectwise Costcode Activity wise hours for the various Period";
        public string Title_PRJ_ACC_ACT_BUDG { get; set; } = "PRJ_ACC_ACT_BUDG";
        public string Title_ProjCost_combine { get; set; } = "Project Costcode Wise Manhours from begining of project ";
        public string Title_ProjCostOT_combine { get; set; } = "Project Costcode Wise Manhours from begining of project (OT)";
        public string Title_Projhrs_OtBreak { get; set; } = "Project Costcode Employee Manhours with Overtime Breakup";
        public string Title_Projhrs_OtCrossTab { get; set; } = "Projhrs_OtCrossTab";
        public string Title_WorkPosition_Combine { get; set; } = "Work Position Wise from 2011 onward";
    }
}