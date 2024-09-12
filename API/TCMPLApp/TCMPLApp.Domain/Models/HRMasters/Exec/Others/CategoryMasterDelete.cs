using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CategoryMasterDelete
    {
        public string CommandText { get => HRMastersProcedure.CategoryMasterDelete; }
        public string PCategoryid { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
