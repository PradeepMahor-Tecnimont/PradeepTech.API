using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class EmployeePolicyTrainingViewModel
    {
        public bool? Security { get; set; }

        public bool? Sharepoint16 { get; set; }

        public bool? Onedrive365 { get; set; }

        public bool? Teams { get; set; }

        public bool? Planner { get; set; }

        public string UrlSecurity { get => "https://tecnimont.sharepoint.com/sites/elearning/SecurityAwareness/SitePages/HomePage.aspx"; }

        public string UrlSharepoint16 { get => "https://tecnimont.sharepoint.com/sites/elearning/thO365/SharePoint2016-EN/SitePages/Course.aspx"; }

        public string UrlOnedrive365 { get => "https://tecnimont.sharepoint.com/sites/elearning/thO365/OneDrive365-EN/SitePages/Course.aspx"; }

        public string UrlTeams { get => "https://tecnimont.sharepoint.com/sites/elearning/thO365/Teams-EN/SitePages/Course.aspx"; }

        public string UrlPlanner { get => "https://tecnimont.sharepoint.com/sites/elearning/thO365/Planner-EN/SitePages/Course.aspx"; }

        public bool IsTrainingComplete { get; set; }
        public string Message { get; set; }
    }
}
