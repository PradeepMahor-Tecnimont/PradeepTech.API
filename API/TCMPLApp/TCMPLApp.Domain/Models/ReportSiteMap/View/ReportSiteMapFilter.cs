using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.ReportSiteMap
{
    public class ReportSiteMapFilter
    {        
        public string SiteMapMasterId { get; set; }
        public string LinkId { get; set; }
        public string LinkControllerName { get; set; }
        public string LinkActionName { get; set; }
        public string LinkAreaName { get; set; }
        public string LinkRouteParameters { get; set; }
        public string LinkMappingRouteParameters { get; set; }
        public string FunctionalName { get; set; }
        public string FunctionalDatatype { get; set; }
        public string FunctionalDateParameter { get; set; }
        public string IsRequired { get; set; }
        public string IsDefault { get; set; }
        public string DefaultValue { get; set; }
        public string IsVisible { get; set; }
        public int OrderBy { get; set; }
        public string TargetActionUrl { get; set; }

    }
}
