using System;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAreaDepartmentMapDataTableExcel
    {
        public string AreaDesc { get; set; }

        public string IsRestricted { get; set; }
        public string DepartmentCode { get; set; }
        public string DepartmentName { get; set; }

        public string ModifiedBy { get; set; }

        public DateTime ModifiedOn { get; set; }
    }
}