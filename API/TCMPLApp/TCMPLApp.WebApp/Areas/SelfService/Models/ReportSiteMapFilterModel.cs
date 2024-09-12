using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.ReportSiteMap;

namespace TCMPLApp.WebApp.Models
{
    public class ReportSiteMapFilterModel : ReportSiteMapFilter
    {
        public DateTime? StartDate { get; set; }
    }
}
