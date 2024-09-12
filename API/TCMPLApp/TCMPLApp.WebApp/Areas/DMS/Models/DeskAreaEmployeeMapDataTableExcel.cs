using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaEmployeeMapDataTableExcel
    {
        [Display(Name = "Key Id")]
        public string KeyId { get; set; }

        [Display(Name = "Desk Id")]
        public string DeskId { get; set; }

        [Display(Name = "Area Category Code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area Category Desc")]
        public string AreaCatgDesc { get; set; }

        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Employee no")]
        public string EmpNo { get; set; }

        [Display(Name = "Employee")]
        public string EmpName { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime ModifiedOn { get; set; }
    }
}