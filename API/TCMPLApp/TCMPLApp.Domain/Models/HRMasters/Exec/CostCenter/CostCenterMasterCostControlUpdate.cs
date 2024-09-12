using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CostCenterMasterCostControlUpdate
    {
        public string CommandText { get => HRMastersProcedure.CostCenterMasterCostControlUpdate; }

        public string ParamCostcodeid { get; set; }
        public string ParamTm01id { get; set; }
        public string ParamTmaid { get; set; }
        public string ParamActivity { get; set; }
        public string ParamGroupChart { get; set; }
        public string ParamItalianName { get; set; }
        public string ParamCmid { get; set; }
        public string ParamPhase { get; set; }
        public string OutParamSuccess { get; set; }
        public string OutParamMessage { get; set; }
                
    }

}
