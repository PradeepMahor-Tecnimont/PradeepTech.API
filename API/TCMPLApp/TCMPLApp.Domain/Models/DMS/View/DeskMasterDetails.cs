using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskMasterDetails : DBProcMessageOutput
    {
        public string POffice { get; set; }

        public string PFloor { get; set; }

        public string PSeatNo { get; set; }

        public string PWing { get; set; }

        public decimal? PIsDeleted { get; set; }

        public string PCabin { get; set; }

        public string PRemarks { get; set; }

        public string PDeskidOld { get; set; }

        public string PWorkAreaCode { get; set; }

        public string PWorkAreaCategories { get; set; }

        public string PWorkAreaDesc { get; set; }

        public string PBay { get; set; }
        public decimal? PIsBlocked { get; set; }
    }
}