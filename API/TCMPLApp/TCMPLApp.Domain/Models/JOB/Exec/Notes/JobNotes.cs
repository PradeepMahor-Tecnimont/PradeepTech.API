using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobNotes : DBProcMessageOutput
    {
        [Display(Name = "Job No")]        
        public string PProjno { get; set; }

        [Display(Name = "Description")]
        [MaxLength(255)]
        public string PDescription { get; set; }

        [Display(Name = "Notes")]
        [MaxLength(455)]
        public string PNotes { get; set; }
    }
}
