using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaDepartmentMapDetailsViewModel
    {
        [Display(Name = "Area Category Code")]
        public string AreaCatgCode { get; set; }

        public string KeyId { get; set; }

        [Display(Name = "Area Category Description")]
        public string AreaCatgDesc { get; set; }

        [Display(Name = "Area")]
        public string AreaId { get; set; }

        [Display(Name = "Area Description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Costcode")]
        public string CostCode { get; set; }

        [Display(Name = "Costcode Name")]
        public string CostCodeName { get; set; }

        [Display(Name = "Department Code")]
        public string DeptCode { get; set; }

        [Display(Name = "Department Name")]
        public string DeptName { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }
    }
}