using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobErpPhasesFileDetails : DBProcMessageOutput
    {
        [Display(Name = "Clint file name")]
        public string PClintFileName { get; set; }

        [Display(Name = "Server file name")]
        public string PServerFileName { get; set; }

        [Display(Name = " Modified by")]
        public string PModifiedBy { get; set; }

        [Display(Name = "Modified on")]
        public string PModifiedOn { get; set; }
    }
}