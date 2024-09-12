using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.DMS
{
    public class MovementsDataTableList
    {
        public decimal RowNumber { get; set; }

        public decimal? TotalRow { get; set; }

        [Display(Name = "Request number")]
        public string Movereqnum { get; set; }

        [Display(Name = "Request date")]
        public DateTime Movereqdate { get; set; }

        [Display(Name = "IT apprl")]
        public decimal ItApprl { get; set; }

        [Display(Name = "Final Status")]
        public decimal ItCordApprl { get; set; }
    }
}