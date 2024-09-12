using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CategoryMasterUpdate
    {
        public string CommandText { get => HRMastersProcedure.CategoryMasterUpdate; }
        public string PCategoryid { get; set; }
        public string PCategorydesc { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
