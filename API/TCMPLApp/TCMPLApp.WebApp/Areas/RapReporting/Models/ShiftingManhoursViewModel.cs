using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.WebApp.Models
{
    public class ShiftingManhoursViewModel
    {
        public ShiftingManhoursViewModel()
        {
            this.FilterDataModel = new FilterDataModel();
        }
        public FilterDataModel FilterDataModel { get; set; }

        [Required]
        [Display(Name = "Year Month")]
        public string YearMonth { get; set; }

        [Required]
        [Display(Name = "From Project")]
        public string FromProject { get; set; }

        [Required]
        [Display(Name = "To Project")]
        public string ToProject { get; set; }

    }
}
