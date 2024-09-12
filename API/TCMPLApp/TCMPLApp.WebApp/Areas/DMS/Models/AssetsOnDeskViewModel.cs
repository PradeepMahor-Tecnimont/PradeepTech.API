using System.Collections.Generic;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.WebApp.Models
{
    public class AssetsOnDeskViewModel
    {
        public string Empno { get; set; }

        public string DeskNo { get; set; }
        public string CabinDesk { get; set; }

        public string Office { get; set; }

        public string Floor { get; set; }
        public string Area { get; set; }

        public IEnumerable<AssetsOnDeskDataTableList> assetsOnDeskDataTableList { get; set; }
    }
}