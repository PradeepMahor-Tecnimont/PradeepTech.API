using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.Models.rpt
{
    public partial class BeforePostProjModel
    {
        [Key]
        public string Title_YY_PRJ_CC { get; set; } = "Monthly Jobwise Manhours";

        public string Title_YY_PRJ_CC_ACT { get; set; } = "Monthly Jobwise Avtivitywise Manhours";
        public string Title_YY_PRJ_CC_EMP { get; set; } = "Monthly Jobwise Employeewise Manhours";

        public string OnDate { get; set; } = DateTime.Now.ToString("dd-MMM-yyyy");
        public List<YY_PRJ_CC_List> yy_prj_cc_list { get; set; }
        public List<YY_PRJ_CC_ACT_List> yy_prj_cc_act_list { get; set; }
        public List<YY_PRJ_CC_EMP_List> yy_prj_cc_emp_list { get; set; }
    }

    public partial class YY_PRJ_CC_List
    {
        [Key]
        public string Yymm { get; set; }

        public string Assign { get; set; }
        public string ProjNo { get; set; }
        public string CostCodeName { get; set; }
        public string ProjName { get; set; }
        public decimal NHRS { get; set; }

        public decimal OHRS { get; set; }
    }

    public partial class YY_PRJ_CC_ACT_List
    {
        [Key]
        public string Yymm { get; set; }

        public string Assign { get; set; }
        public string ProjNo { get; set; }
        public string Activity { get; set; }
        public string ProjName { get; set; }
        public string ActName { get; set; }
        public decimal NHRS { get; set; }
        public decimal OHRS { get; set; }
        public decimal TotalHRS { get; set; }
    }

    public partial class YY_PRJ_CC_EMP_List
    {
        [Key]
        public string Yymm { get; set; }

        public string Assign { get; set; }
        public string ProjNo { get; set; }
        public string EmpNO { get; set; }
        public string Activity { get; set; }
        public string EmpName { get; set; }
        public string ProjName { get; set; }
        public decimal NHRS { get; set; }
        public decimal OHRS { get; set; }

        public decimal TotalHRS { get; set; }
    }
}