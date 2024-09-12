using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLAPP.WinService.Models
{  
    public class CostcodeGroupCostcodeModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public List<CostcodeData> data { get; set; }
    }

    public class CostcodeData
    {
        public string CostcodeGroupName { get; set; }
        public string Costcode { get; set; }
    }
}
