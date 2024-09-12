using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.BG
{
    public class BGAmendmentStatusDetail : DBProcMessageOutput
    {       
        [Display(Name = "Status")]
        public string PStatusTypeId { get; set; }

        [Display(Name = "Status")]
        public string PStatusTypeDesc { get; set; }

        [Display(Name = "Nominative")]
        public string PModifiedBy { get; set; }

        [Display(Name = "Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PModifiedDate { get; set; }
    }
}