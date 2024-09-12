using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Areas.HRMasters.Models
{
    public class EmployeeMasterMiscEditViewModel
    {
        public string Empno { get; set; }
        
        [Display(Name = "Department code")]
        public string DeptCode { get; set; }

        [Display(Name = "Employee of week")]
        public string Eow { get; set; }

        [Display(Name = "Eow Date")]
        public DateTime? EowDate { get; set; }

        [Display(Name = "Eow week")]
        public Int32? EowWeek { get; set; }

        [Display(Name = "ESI cover")]
        public Int32? EsiCover { get; set; }
        
        [Display(Name = "IP address")]
        public string Ipadd { get; set; }
        
        [Display(Name = "Job category desc")]
        public string Jobcategoorydesc { get; set; }

        [Display(Name = "Job category")]
        public string Jobcategory { get; set; }

        [Display(Name = "Job discipline")]
        public string Jobdiscipline { get; set; }

        [Display(Name = "Job discipline desc")]
        public string Jobdisciplinedesc { get; set; }

        [Display(Name = "Job group")]
        public string Jobgroup { get; set; }

        [Display(Name = "Job group desc")]
        public string Jobgroupdesc { get; set; }

        [Display(Name = "Job subcategory")]
        public string Jobsubcategory { get; set; }

        [Display(Name = "Job subcategory desc")]
        public string Jobsubcategorydesc { get; set; }

        [Display(Name = "Job subdiscipline")]
        public string Jobsubdiscipline { get; set; }

        [Display(Name = "Job subdiscipline desc")]
        public string Jobsubdisciplinedesc { get; set; }

        [Display(Name = "Job title code")]
        public string JobtitleCode { get; set; }

        [Display(Name = "Last day")]
        public DateTime? Lastday { get; set; }

        [Display(Name = "Location")]
        public string LocId { get; set; }

        [Display(Name = "No TCM upd")]
        public Int32? NoTcmUpd { get; set; }

        [Display(Name = "Old company")]
        public string Oldco { get; set; }

        [Display(Name = "Deputation")]
        public Int32? Ondeputation { get; set; }

        [Display(Name = "PF number")]
        public string Pfslno { get; set; }

        [Display(Name = "Project number")]
        public string Projno { get; set; }

        [Display(Name = "Password")]
        public string Pwd { get; set; }

        [Display(Name = "Reporting")]
        public Int32? Reporting { get; set; }

        [Display(Name = "Report to")]
        public string Reporto { get; set; }

        [Display(Name = "Secretary")]
        public Int32? Secretary { get; set; }

        [Display(Name = "Trans in")]
        public DateTime? TransIn { get; set; }

        [Display(Name = "Trans out")]
        public DateTime? TransOut { get; set; }

        [Display(Name = "User domain")]
        public string UserDomain { get; set; }

        [Display(Name = "Userid")]
        public Int32? Userid { get; set; }

        [Display(Name = "Web itdecl")]
        public Int32? WebItdecl { get; set; }

        [Display(Name = "Winid required")]
        public Int32? WinidReqd { get; set; }        
    }
}
