using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HSE
{
    public class HSESuggestionDataTableList
    {
        public decimal? TotalRow { get; set; }

        public decimal RowNumber { get; set; }

        [Display(Name = "Application number")]
        public string AppNo { get; set; }

        [Display(Name = "Application date")]
        public string AppliedOn { get; set; }

        [Display(Name = "Host name")]
        public string HostName { get; set; }

        [Display(Name = "Guest name(s)")]
        public string GuestName { get; set; }

        [Display(Name = "Guest company name")]
        public string GuestCompany { get; set; }

        [Display(Name = "Meeting date")]
        public string MeetingDate { get; set; }

        [Display(Name = "Meeting time")]
        public string MeetingTime { get; set; }

        [Display(Name = "Meeting Place(Office)")]
        public string MeetingPlace { get; set; }

        [Display(Name = "Remarks")]
        public string Remarks { get; set; }

        public decimal DeleteAllowed { get; set; }
    }
}