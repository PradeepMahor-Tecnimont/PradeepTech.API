using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DMS
{
    public class DeskAreaDetails : DBProcMessageOutput
    {
        public string PAreaDesc { get; set; }

        public string PAreaCatgCode { get; set; }

        public string PAreaCatgDesc { get; set; }

        public string PAreaInfo { get; set; }
        public string PAreaTypeVal { get; set; }
        public string PAreaTypeText { get; set; }
        public decimal? PIsRestrictedVal { get; set; }
        public string PIsRestrictedText { get; set; }

        public decimal? PIsActiveVal { get; set; }
        public string PIsActiveText { get; set; }
        public string PTagId { get; set; }
        public string PTagName { get; set; }
    }
}