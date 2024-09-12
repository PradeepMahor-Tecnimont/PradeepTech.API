using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace TCMPLAPP.WinService.Models
{      
    public class CostcodeModel
    {
        public string Status { get; set; }
        public string MessageCode { get; set; }
        public string Message { get; set; }
        public List<Dept> data { get; set; }
    }

    public class Dept
    {
        public string costcode { get; set; }
    }
}
