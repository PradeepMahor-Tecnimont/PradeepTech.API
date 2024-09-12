using System;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CostCenterMasterDeactivate
    {
        public string CommandText { get => HRMastersProcedure.DeactivateCostCenter; }   
        public string ParamCostcodeid { get; set; }        
        public string OutParamSuccess { get; set; }
        public string OutParamMessage { get; set; }
    }
}
