using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaProjectMapDataTableExcel
    {
        public string AreaDesc { get; set; }

        public string IsRestricted { get; set; }
        public string ProjectNo { get; set; }
        public string ProjectName { get; set; }

        public string ModifiedBy { get; set; }

        [Display(Name = "Modified On")]
        public DateTime ModifiedOn { get; set; }
    }
}