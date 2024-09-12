using System;
using System.ComponentModel.DataAnnotations;

namespace TCMPLApp.Domain.Models.HRMasters.View
{
    public class CostCenterDetail
    {
        public string CostCodeId { get; set; }
        public string CostCode { get; set; }        
        public string CostName { get; set; }
        public string HoD { get; set; }
        public string HoDName { get; set; }

    }
}
