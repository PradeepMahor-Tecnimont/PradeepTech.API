using System;
using System.ComponentModel.DataAnnotations;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public class CostCenterMasterMainCreate
    {
        public string CommandText { get => HRMastersProcedure.CostCenterMasterMainCreate; }
        public string ParamCostcode { get; set; }
        public string ParamName { get; set; }
        public string ParamAbbr { get; set; }
        public string ParamHod { get; set; }
        public Int32 ParamNoofemps { get; set; }
        public string ParamCostgroupid { get; set; }
        public string ParamGroupid { get; set; }
        public string ParamCostTypeId { get; set; }
        public string ParamSecretary { get; set; }
        public DateTime? ParamSdate { get; set; }
        public DateTime? ParamEdate { get; set; }
        public string ParamSapcc { get; set; }
        public string ParamParentCostcodeid { get; set; }
        public string ParamEnggNonengg { get; set; }

        public string OutParamSuccess { get; set; }
        public string OutParamMessage { get; set; }
    }

}
