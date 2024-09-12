using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class InvItemAddOnDetails : DBProcMessageOutput
    {
        [Display(Name = "Date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? PTransDate { get; set; }

        [Display(Name = "Empno")]
        public string PEmpno { get; set; }

        [Display(Name = "Name")]
        public string PEmpName { get; set; }

        [Display(Name = "Parent")]
        public string PParent { get; set; }

        [Display(Name = "Name")]
        public string PParentName { get; set; }

        [Display(Name = "Assign")]
        public string PAssign { get; set; }

        [Display(Name = "Name")]
        public string PAssignName { get; set; }

        [Display(Name = "Type")]
        public string PTransTypeId { get; set; }

        [Display(Name = "Type")]
        public string PTransTypeDesc { get; set; }

        [Display(Name = "Remarks")]
        public string PRemarks { get; set; }
        
        public string PGatePassRefNo { get; set; }
    }
}