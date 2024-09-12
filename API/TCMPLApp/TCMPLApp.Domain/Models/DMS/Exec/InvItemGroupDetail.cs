using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemGroupDetail : DBProcMessageOutput
    {

        [Display(Name = "Modified On")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PModifiedOn { get; set; }

        [Display(Name = "Item Group")]
        public string PItemGroupDesc { get; set; }


    }
}