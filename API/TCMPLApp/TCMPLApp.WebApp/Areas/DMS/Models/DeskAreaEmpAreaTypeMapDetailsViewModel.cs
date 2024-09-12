using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaEmpAreaTypeMapDetailsViewModel
    {
        public string KeyId { get; set; }

        [Display(Name = "Area Category Code")]
        public string AreaCatgCode { get; set; }

        [Display(Name = "Area Category Description")]
        public string AreaCatgDesc { get; set; }

        [Display(Name = "AreaId")]
        public string AreaId { get; set; }

        [Display(Name = "Area description")]
        public string AreaDesc { get; set; }

        [Display(Name = "Area type")]
        public string AreaTypeCode { get; set; }

        [Display(Name = "Area type")]
        public string AreaTypeDesc { get; set; }

        [Display(Name = "Employee no")]
        public string EmpNo { get; set; }

        [Display(Name = "Employee")]
        public string EmpName { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }
    }
}