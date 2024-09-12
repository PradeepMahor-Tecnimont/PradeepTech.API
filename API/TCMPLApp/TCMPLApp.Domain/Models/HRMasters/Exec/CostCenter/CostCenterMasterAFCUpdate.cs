using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CostCenterMasterAFCUpdate
    {
        public string CommandText { get => HRMastersProcedure.CostCenterMasterAFCUpdate; }
        public string ParamCostcodeid { get; set; }
        public string ParamTcmcostcodeid { get; set; }
        public string ParamTcmActPhId { get; set; }
        public string ParamTcmPasPhId { get; set; }
        public string ParamPo { get; set; }
        public string OutParamSuccess { get; set; }
        public string OutParamMessage { get; set; }
    }

}
