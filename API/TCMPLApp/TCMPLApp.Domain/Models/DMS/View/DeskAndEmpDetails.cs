using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAndEmpDetails : DBProcMessageOutput
    {
        public string PDeskDetailJson { get; set; }
        public string PEmpDetailJson { get; set; }
        public decimal? PTrueFlag { get; set; }
        public IEnumerable<MasterListFields> PMasterList { get; set; }

        public IEnumerable<AssetsListFields> PDeskAssetsList { get; set; }

        public IEnumerable<AssetsListFields> PEmp1AssetsList { get; set; }
        public IEnumerable<AssetsListFields> PEmp2AssetsList { get; set; }
    }

    public class MasterListFields
    {
        public string Empno { get; set; }
        public string Deskid { get; set; }
        public string UserIn { get; set; }
    }

    public class DeskDetailHeaderFields
    {
        public string Deskno { get; set; }

        public string CabinDesk { get; set; }

        public string Emp1 { get; set; }

        public string Emp2 { get; set; }

        public string Office { get; set; }

        public string Floor { get; set; }

        public string Area { get; set; }

        public string IsBlocked { get; set; }

        public string BlockedReason { get; set; }
    }

    public class EmployeeDetailHeaderFields
    {
        public string Desk { get; set; }
        public string Empno { get; set; }
        public string Employee { get; set; }
        public string Grade { get; set; }
        public string Parent { get; set; }
        public string Assign { get; set; }
    }

    public class AssetsListFields
    {
        public string AssetId { get; set; }

        public string AssetName { get; set; }

        public string AssetCode { get; set; }

        public string Description { get; set; }
    }
}