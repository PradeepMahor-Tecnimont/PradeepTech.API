using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class OSCMhrsUpdateViewModel
    {
        [Required]
        public string OscmId { get; set; }

        [Required]
        public string OscdId { get; set; }

        [Display(Name = "Period")]
        public string Yymm { get; set; }

        [Display(Name = "Period")]
        public string YymmWords { get; set; }

        [Display(Name = "Parent")]
        public string Parent { get; set; }

        public string ParentName { get; set; }
        
        [Display(Name = "Parent")]
        public string ParentWithName { get; set; }

        [Display(Name = "Assign")]
        
        public string Assign { get; set; }

        public string AssignName { get; set; }

        [Display(Name = "Assign")]
        public string AssignWithName { get; set; }

        [Display(Name = "OSC No")]
        public string Empno { get; set; }

        public string EmpName { get; set; }

        [Display(Name = "OSC No")]
        public string EmpnoWithName { get; set; }

        [Required]
        [Display(Name = "Project")]
        public string Projno { get; set; }

        [Required]
        [Display(Name = "WP code")]
        public string Wpcode { get; set; }

        [Required]
        [Display(Name = "Activity")]
        public string Activity { get; set; }

        [Required]
        [Display(Name = "Hours")]
        [Range(-999999.5, 999999.5, ErrorMessage = "Hours must be between -999999.5 and 999999.5 inclusive")]
        public decimal? Hours { get; set; }
    }
}
