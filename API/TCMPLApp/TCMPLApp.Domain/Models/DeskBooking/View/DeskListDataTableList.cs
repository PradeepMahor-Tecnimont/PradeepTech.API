using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class DeskListDataTableList
    {
        public decimal RowNumber { get; set; }
        public decimal? TotalRow { get; set; }

        [Display(Name = "Floor")]
        public string Floor { get; set; }

        [Display(Name = "Wing")]
        public string Wing { get; set; }

        [Display(Name = "Work Area")]
        public string WorkArea { get; set; }
        public string AreaDesc { get; set; }

        [Display(Name = "Desk Id")]
        public string Deskid { get; set; }
    }
}
