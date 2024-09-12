using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaUserMapDataTableExcel
    {
        [Display(Name = "Employee no")]
        public string EmpNo { get; set; }

        [Display(Name = "Employee")]
        public string EmpName { get; set; }

        public string TagName { get; set; }

        [Display(Name = "Base location")]
        public string OfficeLocation { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Parent")]
        public string DeptCode { get; set; }

        [Display(Name = "Department")]
        public string DeptName { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "From date")]
        public DateTime? FromDate { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }
    }
}