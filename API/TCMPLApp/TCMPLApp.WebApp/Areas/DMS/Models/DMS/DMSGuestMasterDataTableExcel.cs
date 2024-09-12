using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class DMSGuestMasterDataTableExcel
    {
        [Display(Name = "Guest EmpNo")]
        public string GuestEmpno { get; set; }

        [Display(Name = "Guest name")]
        public string GuestName { get; set; }

        [Display(Name = "Cost code")]
        public string Costcode { get; set; }

        [Display(Name = "Project no")]
        public string Projno7 { get; set; }

        [Display(Name = "Project name")]
        public string ProjName { get; set; }

        [Display(Name = "From date")]
        [DataType(DataType.DateTime)]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? FromDate { get; set; }

        [Display(Name = "To date")]
        [DataType(DataType.DateTime)]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? ToDate { get; set; }

        [Display(Name = "Target desk")]
        public string TargetDesk { get; set; }

        [Display(Name = "Entry date")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? EntryDate { get; set; }

        [Display(Name = "Modified on")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime? ModifiedOn { get; set; }

        [Display(Name = "Modified by")]
        public string ModifiedBy { get; set; }
    }
}