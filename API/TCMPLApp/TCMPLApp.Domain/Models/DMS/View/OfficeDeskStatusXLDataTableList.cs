using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.DMS
{
    public class OfficeDeskStatusXLDataTableList
    {
        public string Deskid { get; set; }
        public string Office { get; set; }
        public string Floor { get; set; }
        public string Seatno { get; set; }
        public string Wing { get; set; }
        public string Assetcode { get; set; }
        public string Isdeleted { get; set; }
        public string Cabin { get; set; }
        public string Remarks { get; set; }
        public string DeskidOld { get; set; }
        public string Bay { get; set; }

        public string WorkArea { get; set; }

        //public string Isblocked { get; set; }
        public int EmpOnDeskCount { get; set; }
    }
}