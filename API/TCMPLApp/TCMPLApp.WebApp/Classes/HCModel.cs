using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Areas.RapReporting;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Classes
{
    //Http Client Model
    public class HCModel
    {
        [Display(Name = "Year month")]
        public string Yymm { get; set; }

        public string Assign { get; set; }
        public string Empno { get; set; }

        [Display(Name = "Cost code")]
        public string CostCode { get; set; }

        [Display(Name = "Project")]
        public string Projno { get; set; }

        [Display(Name = "Cost center")]
        public string CostCenter { get; set; }

        [Display(Name = "Year month")]
        public string Yyyymm { get; set; }

        [Display(Name = "Report for")]
        public string RepFor { get; set; }

        [Required]
        [Display(Name = "Year mode")]
        public string YearMode { get; set; }

        public string Keyid { get; set; }
        public string User { get; set; }

        [Required]
        [Display(Name = "Year")]
        public string Yyyy { get; set; }

        public string Status { get; set; }

        [Display(Name = "Report id")]
        public string Reportid { get; set; }

        public string Runmode { get; set; }
        public string Category { get; set; }

        [Display(Name = "Report type")]
        public string ReportType { get; set; }

        [Display(Name = "Simulation")]
        public string Simul { get; set; }

        public string Name { get; set; }

        public int? top { get; set; }
        public int? skip { get; set; }
        public string count { get; set; }
        public string orderby { get; set; }
        public string Sim { get; set; }

        [Display(Name = "Process id")]
        public string Processid { get; set; }

        [Display(Name = "Process desc")]
        public string Processdesc { get; set; }
        public string CostcodeGroupId { get; set; }
        public string CostcodeGroupName { get; set; }

        public string EmployeeTypeList { get; set; }

        public string ReportMode { get; set; }

        public string Htmlcontent { get; set; }
        public string Fname { get; set; }

        public string MailTo { get; set; }
        public string MailCc { get; set; }
        public string MailBcc { get; set; }
        public string MailSubject { get; set; }
        public string MailBody1 { get; set; }
        public string MailBody2 { get; set; }
        public string MailType { get; set; }
        public string MailFrom { get; set; }        

        public List<IFormFile> Files { get; set; }

    }
}