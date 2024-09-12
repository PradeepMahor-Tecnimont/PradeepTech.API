using System.Collections.Generic;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class DeskAssignmentNewViewModel
    {
        public string SearchByDeskNoOrEmpNo { get; set; } = string.Empty;

        public IEnumerable<MasterListFields> MasterList { get; set; }
        public decimal? TrueFlag { get; set; }
        public DeskTileViewModel DeskTileViewModel { get; set; }
        public EmployeeTileViewModel Employee1TileViewModel { get; set; }
        public EmployeeTileViewModel Employee2TileViewModel { get; set; }
    }

    public class DeskTileViewModel
    {
        public DeskDetailHeaderFields DeskDetailHeaderFields { get; set; }
        public IEnumerable<AssetsListFields> DeskAssetsList { get; set; }
    }

    public class EmployeeTileViewModel
    {
        public EmployeeDetailHeaderFields EmployeeDetailHeaderFields { get; set; }
        public IEnumerable<AssetsListFields> EmployeeAssetsList { get; set; }
    }

    public class DeskDetailHeaderFields
    {
        public string DeskNo { get; set; } = string.Empty;

        public string Office { get; set; } = string.Empty;

        public string Floor { get; set; } = string.Empty;

        public string Seatno { get; set; } = string.Empty;

        public string Wing { get; set; } = string.Empty;

        public string CabinDesk { get; set; } = string.Empty;

        public string WorkArea { get; set; } = string.Empty;

        public string AreaDesc { get; set; } = string.Empty;

        public string IsBlocked { get; set; } = string.Empty;

        public string IsDeleted { get; set; } = string.Empty;

        public string BlockedReason { get; set; } = string.Empty;
    }

    public class EmployeeDetailHeaderFields
    {
        public string DeskId { get; set; } = string.Empty;
        public string Empno { get; set; } = string.Empty;
        public string EmpName { get; set; } = string.Empty;
        public string Grade { get; set; } = string.Empty;
        public string Parent { get; set; } = string.Empty;
        public string Assign { get; set; } = string.Empty;
        public string UserIn { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
    }
}