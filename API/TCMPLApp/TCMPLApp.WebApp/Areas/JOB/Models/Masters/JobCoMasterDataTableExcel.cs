using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class JobCoMasterDataTableExcel
    {
        [Display(Name = "Company code")]
        public string Code { get; set; }

        [Display(Name = "Description")]
        public string Description { get; set; }
    }
}