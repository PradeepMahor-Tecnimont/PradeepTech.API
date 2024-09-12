using System;
using System.ComponentModel.DataAnnotations;
using System.Security.AccessControl;

namespace TCMPLApp.Domain.Models.DMS
{
    public class FlexiToDMSDataTableList
    {
        public decimal RowNumber { get; set; }

        public decimal? TotalRow { get; set; }

        public string Keyid { get; set; }

        [Display(Name = "Date")]
        public DateTime CreatedOn { get; set; }

        [Display(Name = "Desk")]
        public String Deskid { get; set; }

        [Display(Name = "Previous area")]
        public String PreviousAreaId { get; set; }        

        [Display(Name = "Area")]
        public String AreaId { get; set; }        

        [Display(Name = "Rollback")]
        public decimal Isvisible { get; set; }        

    }
}