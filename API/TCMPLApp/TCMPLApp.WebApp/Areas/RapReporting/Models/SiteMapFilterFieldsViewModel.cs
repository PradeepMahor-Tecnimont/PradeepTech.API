using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.ReportSiteMap;

namespace TCMPLApp.WebApp.Models
{
    public class SiteMapFilterFieldsViewModel
    {
        public string ActionName { get; set; }
        public string ActionDesc { get; set; }
        public string ControllerArea { get; set; }
        public string ControllerName { get; set; }
        public string ControllerMethod { get; set; }
        public string RequestMethodType { get; set; }
        public IEnumerable<SiteMapFilterFormFields> FilterFormFields { get; set; }

    }
}
