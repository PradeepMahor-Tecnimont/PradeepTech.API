using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DeskBooking
{
    public class BookingSummaryDetails : DBProcMessageOutput
    {
        public string PAreaDesc { get; set; }
        public decimal PDeskCount { get; set; }
        public decimal PDeptEmpnoCount { get; set; }
        public decimal PBookedDesks { get; set; }
    }
}
