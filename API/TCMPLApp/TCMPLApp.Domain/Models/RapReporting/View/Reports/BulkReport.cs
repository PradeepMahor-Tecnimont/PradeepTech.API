using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.RapReporting
{
    public class BulkReport
    {
        [Display(Name = "Report")]
        public string Reportid { get; set; }

        [Display(Name = "Active year")]
        public string Yyyy { get; set; }

        [Display(Name = "Processing month")]
        public string Yymm { get; set; }

        [Display(Name = "Year mode")]
        public string Yearmode { get; set; }

        [Display(Name = "Report generated")]
        public DateTime? SDate { get; set; }

        [Display(Name = "File name")]
        public string Filename { get; set; }

        public string Status { get; set; }

        public short iscomplete { get; set; }
    }
}
