using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CostCenterMasterHoDUpdate
    {
        public string CommandText { get => HRMastersProcedure.CostCenterMasterHoDUpdate; }
        public string ParamCostcodeid { get; set; }
        public string ParamDyHod { get; set; }
        public Int32 ParamChangedNemps { get; set; }
        public string OutParamSuccess { get; set; }
        public string OutParamMessage { get; set; }
    }

}
