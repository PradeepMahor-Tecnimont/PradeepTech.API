using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.JOB
{
    public class JobNotesDetail : DBProcMessageOutput
    {        
        [Display(Name = "Description")]
        public string PDescription { get; set; }

        [Display(Name = "Notes")]
        public string PNotes { get; set; }

    }
}
