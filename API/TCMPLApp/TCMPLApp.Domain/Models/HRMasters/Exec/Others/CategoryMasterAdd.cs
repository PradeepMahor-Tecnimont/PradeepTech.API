using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CategoryMasterAdd
    {
        public string CommandText { get => HRMastersProcedure.CategoryMasterAdd; }
        public string PCategoryid { get; set; }
        public string PCategorydesc { get; set; }        
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }
    }
}
