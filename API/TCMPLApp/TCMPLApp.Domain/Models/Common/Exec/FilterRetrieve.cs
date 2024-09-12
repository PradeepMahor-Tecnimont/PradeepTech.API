using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models
{
    public class FilterRetrieve
    {
        public string CommandText { get => "PKG_FILTER.GET_FILTER"; }
        public string PPersonId { get; set; }
        public string PMetaId { get; set; }
        public string PModuleName { get; set; }
        public string PMvcActionName { get; set; }
        public string OutPFilterJson { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}
