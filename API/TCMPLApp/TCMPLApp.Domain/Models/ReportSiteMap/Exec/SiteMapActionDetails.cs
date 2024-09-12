using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.ReportSiteMap
{
    public class SiteMapActionDetails :   DBProcMessageOutput
    {
        public string PActionName { get; set; }
        public string PActionDescription { get; set; }
        public string PControllerArea { get; set; }
        public string PControllerName { get; set; }
        public string PControllerMethod { get; set; }
        public string PRequestMethodType { get; set; }
        public IEnumerable<SiteMapFilterFormFields> PFilterFormFields { get; set; }

    }

    public class SiteMapFilterFormFields
    {
        public string FieldId { get; set;}

        public string ControllerMethodParamName { get; set;}

        public string FunctionalDescription { get; set;}
        public string IsRequired { get; set;}
    }
}
