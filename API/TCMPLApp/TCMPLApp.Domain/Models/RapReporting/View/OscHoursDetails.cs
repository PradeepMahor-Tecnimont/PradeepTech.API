using System;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class OscHoursDetails : DBProcMessageOutput
    {
        [Display(Name = "OSCD id")]
        public string POscdId { get; set; }

        [Display(Name = "Year month")]
        public string PYyyymm { get; set; }

        [Display(Name = "Original est hours")]
        public decimal? POrigEstHrs { get; set; }

        [Display(Name = "Current est hours")]
        public decimal? PCurEstHrs { get; set; }

    }
}