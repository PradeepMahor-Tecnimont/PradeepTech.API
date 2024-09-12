using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaUserMapDetailsViewModel
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

        [Display(Name = "Employee no")]
        public string EmpNo { get; set; }

        [Display(Name = "Employee")]
        public string EmpName { get; set; }

        [Display(Name = "Office code")]
        public string OfficeCode { get; set; }

        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Modified By")]
        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime? ModifiedOn { get; set; }
    }
}